import Foundation
import Combine

class LocalMockAdapter: BackendAdapter {
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var currentSession: GameSession?
    @Published var availableTables: [GameTable] = []
    @Published var leaderboard: [LeaderboardEntry] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var mockTables: [GameTable] = []
    private var mockLeaderboard: [LeaderboardEntry] = []
    
    init() {
        setupMockData()
    }
    
    func connect() async throws {
        connectionStatus = .connecting
        
        // Simuler un délai de connexion
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 seconde
        
        connectionStatus = .connected
    }
    
    func disconnect() {
        connectionStatus = .disconnected
        currentSession = nil
    }
    
    func sendMessage(_ message: GameMessage) async throws {
        guard connectionStatus == .connected else {
            throw BackendError.connectionFailed
        }
        
        // Simuler le traitement du message
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconde
        
        // Traiter le message selon son type
        switch message.type {
        case .join:
            // Simuler l'ajout d'un joueur
            break
        case .leave:
            // Simuler le départ d'un joueur
            break
        case .bet:
            // Simuler un pari
            break
        case .action:
            // Simuler une action de jeu
            break
        case .chat:
            // Simuler un message de chat
            break
        case .ready:
            // Simuler un joueur prêt
            break
        }
    }
    
    func joinTable(_ tableId: String, buyIn: Int) async throws -> GameSession {
        guard connectionStatus == .connected else {
            throw BackendError.connectionFailed
        }
        
        guard let table = mockTables.first(where: { $0.id == tableId }) else {
            throw BackendError.tableNotFound
        }
        
        guard !table.isFull else {
            throw BackendError.gameInProgress
        }
        
        // Simuler un délai de connexion à la table
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconde
        
        // Créer une session de jeu simulée
        let session = createMockSession(for: table, buyIn: buyIn)
        currentSession = session
        
        return session
    }
    
    func leaveTable(_ tableId: String) async throws {
        guard connectionStatus == .connected else {
            throw BackendError.connectionFailed
        }
        
        // Simuler un délai de déconnexion
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconde
        
        currentSession = nil
    }
    
    func placeBet(_ amount: Int, position: String) async throws {
        guard connectionStatus == .connected else {
            throw BackendError.connectionFailed
        }
        
        guard currentSession != nil else {
            throw BackendError.gameInProgress
        }
        
        // Vérifier les fonds
        guard WalletStore.shared.canAfford(amount) else {
            throw BackendError.insufficientFunds
        }
        
        // Simuler le pari
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconde
        
        // Déduire les jetons
        _ = WalletStore.shared.bet(amount)
    }
    
    func getLeaderboard() async throws -> [LeaderboardEntry] {
        guard connectionStatus == .connected else {
            throw BackendError.connectionFailed
        }
        
        // Simuler un délai de récupération
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconde
        
        return mockLeaderboard
    }
    
    func getTableList() async throws -> [GameTable] {
        guard connectionStatus == .connected else {
            throw BackendError.connectionFailed
        }
        
        // Simuler un délai de récupération
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconde
        
        return mockTables
    }
    
    func authenticate(userId: String, token: String) async throws -> Bool {
        guard connectionStatus == .connected else {
            throw BackendError.connectionFailed
        }
        
        // Simuler un délai d'authentification
        try await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconde
        
        // Simuler une authentification réussie
        return true
    }
    
    // MARK: - Private Methods
    
    private func setupMockData() {
        // Créer des tables simulées
        mockTables = [
            GameTable(
                id: "blackjack_1",
                name: "Blackjack VIP",
                gameType: .blackjack,
                buyIn: 50_000,
                maxPlayers: 7,
                currentPlayers: 3,
                isActive: true,
                createdAt: Date()
            ),
            GameTable(
                id: "blackjack_2",
                name: "Blackjack Standard",
                gameType: .blackjack,
                buyIn: 10_000,
                maxPlayers: 7,
                currentPlayers: 5,
                isActive: true,
                createdAt: Date()
            ),
            GameTable(
                id: "roulette_1",
                name: "Roulette Européenne",
                gameType: .roulette,
                buyIn: 25_000,
                maxPlayers: 10,
                currentPlayers: 7,
                isActive: true,
                createdAt: Date()
            ),
            GameTable(
                id: "poker_1",
                name: "Poker Texas Hold'em",
                gameType: .poker,
                buyIn: 100_000,
                maxPlayers: 6,
                currentPlayers: 4,
                isActive: true,
                createdAt: Date()
            ),
            GameTable(
                id: "baccarat_1",
                name: "Baccarat Premium",
                gameType: .baccarat,
                buyIn: 75_000,
                maxPlayers: 8,
                currentPlayers: 2,
                isActive: true,
                createdAt: Date()
            )
        ]
        
        // Créer un classement simulé
        mockLeaderboard = [
            LeaderboardEntry(id: "1", username: "ProPlayer1", avatarId: 1, rank: 1, score: 15000, wins: 45, gamesPlayed: 60),
            LeaderboardEntry(id: "2", username: "LuckyWinner", avatarId: 2, rank: 2, score: 12800, wins: 38, gamesPlayed: 55),
            LeaderboardEntry(id: "3", username: "CardMaster", avatarId: 3, rank: 3, score: 11200, wins: 42, gamesPlayed: 70),
            LeaderboardEntry(id: "4", username: "CasinoKing", avatarId: 4, rank: 4, score: 9800, wins: 35, gamesPlayed: 50),
            LeaderboardEntry(id: "5", username: "AcePlayer", avatarId: 5, rank: 5, score: 8900, wins: 28, gamesPlayed: 45)
        ]
        
        availableTables = mockTables
        leaderboard = mockLeaderboard
    }
    
    private func createMockSession(for table: GameTable, buyIn: Int) -> GameSession {
        let players = [
            GameSession.Player(
                id: AuthStore.shared.currentUser?.id ?? "local",
                username: AuthStore.shared.currentUser?.username ?? "Joueur",
                avatarId: AuthStore.shared.currentUser?.avatarId ?? 1,
                seat: 0,
                chips: buyIn,
                isReady: true,
                isDealer: false
            ),
            GameSession.Player(
                id: "bot_1",
                username: "Bot_Alpha",
                avatarId: Int.random(in: 1...10),
                seat: 1,
                chips: buyIn,
                isReady: true,
                isDealer: false
            ),
            GameSession.Player(
                id: "bot_2",
                username: "Bot_Beta",
                avatarId: Int.random(in: 1...10),
                seat: 2,
                chips: buyIn,
                isReady: true,
                isDealer: false
            )
        ]
        
        let gameState = GameSession.GameState(
            phase: .waiting,
            currentPlayer: nil,
            pot: 0,
            communityCards: [],
            playerCards: [:]
        )
        
        return GameSession(
            sessionId: UUID().uuidString,
            tableId: table.id,
            players: players,
            gameState: gameState,
            buyIn: buyIn,
            createdAt: Date()
        )
    }
}
