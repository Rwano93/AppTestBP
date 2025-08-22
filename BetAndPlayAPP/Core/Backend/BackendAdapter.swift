import Foundation
import Combine

protocol BackendAdapter: ObservableObject {
    func connect() async throws
    func disconnect()
    func sendMessage(_ message: GameMessage) async throws
    func joinTable(_ tableId: String, buyIn: Int) async throws -> GameSession
    func leaveTable(_ tableId: String) async throws
    func placeBet(_ amount: Int, position: String) async throws
    func getLeaderboard() async throws -> [LeaderboardEntry]
    func getTableList() async throws -> [GameTable]
    func authenticate(userId: String, token: String) async throws -> Bool
}

enum BackendError: Error, LocalizedError {
    case connectionFailed
    case authenticationFailed
    case invalidMessage
    case tableNotFound
    case insufficientFunds
    case gameInProgress
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .connectionFailed:
            return "Échec de la connexion au serveur"
        case .authenticationFailed:
            return "Échec de l'authentification"
        case .invalidMessage:
            return "Message invalide"
        case .tableNotFound:
            return "Table introuvable"
        case .insufficientFunds:
            return "Fonds insuffisants"
        case .gameInProgress:
            return "Partie en cours"
        case .networkError(let message):
            return "Erreur réseau: \(message)"
        }
    }
}

struct GameMessage: Codable {
    let type: MessageType
    let data: [String: Any]
    let timestamp: Date
    
    enum MessageType: String, Codable {
        case join = "join"
        case leave = "leave"
        case bet = "bet"
        case action = "action"
        case chat = "chat"
        case ready = "ready"
    }
    
    enum CodingKeys: String, CodingKey {
        case type, timestamp
    }
    
    init(type: MessageType, data: [String: Any] = [:]) {
        self.type = type
        self.data = data
        self.timestamp = Date()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(MessageType.self, forKey: .type)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        data = [:]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

struct GameSession: Codable {
    let sessionId: String
    let tableId: String
    let players: [Player]
    let gameState: GameState
    let buyIn: Int
    let createdAt: Date
    
    struct Player: Codable {
        let id: String
        let username: String
        let avatarId: Int
        let seat: Int
        let chips: Int
        let isReady: Bool
        let isDealer: Bool
    }
    
    struct GameState: Codable {
        let phase: GamePhase
        let currentPlayer: String?
        let pot: Int
        let communityCards: [String]
        let playerCards: [String: [String]]
        
        enum GamePhase: String, Codable {
            case waiting = "waiting"
            case dealing = "dealing"
            case betting = "betting"
            case playing = "playing"
            case showdown = "showdown"
            case finished = "finished"
        }
    }
}

struct LeaderboardEntry: Codable, Identifiable {
    let id: String
    let username: String
    let avatarId: Int
    let rank: Int
    let score: Int
    let wins: Int
    let gamesPlayed: Int
    
    var winRate: Double {
        guard gamesPlayed > 0 else { return 0 }
        return Double(wins) / Double(gamesPlayed) * 100
    }
}

struct GameTable: Codable, Identifiable {
    let id: String
    let name: String
    let gameType: GameType
    let buyIn: Int
    let maxPlayers: Int
    let currentPlayers: Int
    let isActive: Bool
    let createdAt: Date
    
    var isFull: Bool {
        return currentPlayers >= maxPlayers
    }
    
    var availableSeats: Int {
        return maxPlayers - currentPlayers
    }
}

// MARK: - Extensions

extension BackendAdapter {
    func isConnected() -> Bool {
        // Implémentation par défaut
        return false
    }
    
    func getConnectionStatus() -> ConnectionStatus {
        // Implémentation par défaut
        return .disconnected
    }
}

enum ConnectionStatus: Equatable {
    case disconnected
    case connecting
    case connected
    case reconnecting
    case error(Error)
    
    static func == (lhs: ConnectionStatus, rhs: ConnectionStatus) -> Bool {
        switch (lhs, rhs) {
        case (.disconnected, .disconnected),
             (.connecting, .connecting),
             (.connected, .connected),
             (.reconnecting, .reconnecting):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
