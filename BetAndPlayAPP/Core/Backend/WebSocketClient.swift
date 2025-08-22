import Foundation
import Network
import Combine

class WebSocketClient: ObservableObject {
    @Published var isConnected = false
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var lastMessage: String?
    @Published var errorMessage: String?
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession
    private var messageQueue: [String] = []
    private var reconnectTimer: Timer?
    private var heartbeatTimer: Timer?
    
    private let serverURL: URL
    private let reconnectInterval: TimeInterval = 5.0
    private let heartbeatInterval: TimeInterval = 30.0
    
    init(serverURL: URL) {
        self.serverURL = serverURL
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 300
        self.urlSession = URLSession(configuration: configuration)
    }
    
    func connect() {
        guard !isConnected else { return }
        
        connectionStatus = .connecting
        errorMessage = nil
        
        webSocketTask = urlSession.webSocketTask(with: serverURL)
        webSocketTask?.resume()
        
        // Démarrer la réception des messages
        receiveMessage()
        
        // Démarrer le heartbeat
        startHeartbeat()
        
        isConnected = true
        connectionStatus = .connected
    }
    
    func disconnect() {
        webSocketTask?.cancel()
        webSocketTask = nil
        
        stopHeartbeat()
        stopReconnectTimer()
        
        isConnected = false
        connectionStatus = .disconnected
    }
    
    func send(_ message: String) {
        guard isConnected else {
            // Mettre en file d'attente si déconnecté
            messageQueue.append(message)
            return
        }
        
        let webSocketMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(webSocketMessage) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Erreur d'envoi: \(error.localizedDescription)"
                    self?.handleConnectionError()
                }
            }
        }
    }
    
    func send(_ data: Data) {
        guard isConnected else {
            // Mettre en file d'attente si déconnecté
            if let message = String(data: data, encoding: .utf8) {
                messageQueue.append(message)
            }
            return
        }
        
        let webSocketMessage = URLSessionWebSocketTask.Message.data(data)
        webSocketTask?.send(webSocketMessage) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Erreur d'envoi: \(error.localizedDescription)"
                    self?.handleConnectionError()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self?.handleMessage(message)
                    // Continuer à recevoir des messages
                    self?.receiveMessage()
                case .failure(let error):
                    self?.errorMessage = "Erreur de réception: \(error.localizedDescription)"
                    self?.handleConnectionError()
                }
            }
        }
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            lastMessage = text
            processMessage(text)
        case .data(let data):
            if let text = String(data: data, encoding: .utf8) {
                lastMessage = text
                processMessage(text)
            }
        @unknown default:
            break
        }
    }
    
    private func processMessage(_ message: String) {
        // Traiter les messages selon leur type
        guard let data = message.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let type = json["type"] as? String else {
            return
        }
        
        switch type {
        case "game_update":
            handleGameUpdate(json)
        case "player_joined":
            handlePlayerJoined(json)
        case "player_left":
            handlePlayerLeft(json)
        case "bet_placed":
            handleBetPlaced(json)
        case "game_result":
            handleGameResult(json)
        case "chat_message":
            handleChatMessage(json)
        case "pong":
            // Réponse au heartbeat
            break
        default:
            print("Message non reconnu: \(type)")
        }
    }
    
    private func handleGameUpdate(_ data: [String: Any]) {
        // Traiter les mises à jour de jeu
        NotificationCenter.default.post(
            name: .gameStateUpdated,
            object: nil,
            userInfo: data
        )
    }
    
    private func handlePlayerJoined(_ data: [String: Any]) {
        // Traiter l'arrivée d'un joueur
        NotificationCenter.default.post(
            name: .playerJoined,
            object: nil,
            userInfo: data
        )
    }
    
    private func handlePlayerLeft(_ data: [String: Any]) {
        // Traiter le départ d'un joueur
        NotificationCenter.default.post(
            name: .playerLeft,
            object: nil,
            userInfo: data
        )
    }
    
    private func handleBetPlaced(_ data: [String: Any]) {
        // Traiter un pari placé
        NotificationCenter.default.post(
            name: .betPlaced,
            object: nil,
            userInfo: data
        )
    }
    
    private func handleGameResult(_ data: [String: Any]) {
        // Traiter le résultat d'une partie
        NotificationCenter.default.post(
            name: .gameResult,
            object: nil,
            userInfo: data
        )
    }
    
    private func handleChatMessage(_ data: [String: Any]) {
        // Traiter un message de chat
        NotificationCenter.default.post(
            name: .chatMessage,
            object: nil,
            userInfo: data
        )
    }
    
    private func handleConnectionError() {
        isConnected = false
        connectionStatus = .error(BackendError.connectionFailed)
        
        // Tenter de se reconnecter
        startReconnectTimer()
    }
    
    private func startReconnectTimer() {
        stopReconnectTimer()
        
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: reconnectInterval, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.connectionStatus = .reconnecting
                self?.connect()
            }
        }
    }
    
    private func stopReconnectTimer() {
        reconnectTimer?.invalidate()
        reconnectTimer = nil
    }
    
    private func startHeartbeat() {
        stopHeartbeat()
        
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: heartbeatInterval, repeats: true) { [weak self] _ in
            self?.sendHeartbeat()
        }
    }
    
    private func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    private func sendHeartbeat() {
        let heartbeat: [String: Any] = ["type": "ping", "timestamp": Date().timeIntervalSince1970]
        if let data = try? JSONSerialization.data(withJSONObject: heartbeat) {
            send(data)
        }
    }
    
    private func sendQueuedMessages() {
        while !messageQueue.isEmpty {
            let message = messageQueue.removeFirst()
            send(message)
        }
    }
}

// MARK: - Notifications

extension Notification.Name {
    static let gameStateUpdated = Notification.Name("gameStateUpdated")
    static let playerJoined = Notification.Name("playerJoined")
    static let playerLeft = Notification.Name("playerLeft")
    static let betPlaced = Notification.Name("betPlaced")
    static let gameResult = Notification.Name("gameResult")
    static let chatMessage = Notification.Name("chatMessage")
}

// MARK: - Message Types

struct WebSocketMessage: Codable {
    let type: String
    let data: [String: Any]
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case type, timestamp
    }
    
    init(type: String, data: [String: Any] = [:]) {
        self.type = type
        self.data = data
        self.timestamp = Date()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        data = [:]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
