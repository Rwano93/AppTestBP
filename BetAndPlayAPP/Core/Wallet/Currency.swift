import Foundation

enum Currency: String, CaseIterable, Codable {
    case chips = "chips"
    case gems = "gems"
    
    var displayName: String {
        switch self {
        case .chips: return "Jetons"
        case .gems: return "Gemmes"
        }
    }
    
    var symbol: String {
        switch self {
        case .chips: return "₿"
        case .gems: return "💎"
        }
    }
    
    var color: String {
        switch self {
        case .chips: return "D7B55A"
        case .gems: return "21B1FF"
        }
    }
}

enum TransactionType: String, CaseIterable, Codable {
    case bet = "bet"
    case win = "win"
    case loss = "loss"
    case purchase = "purchase"
    case dailyReward = "daily_reward"
    case battlePass = "battle_pass"
    case referral = "referral"
    case bonus = "bonus"
    
    var displayName: String {
        switch self {
        case .bet: return "Mise"
        case .win: return "Gain"
        case .loss: return "Perte"
        case .purchase: return "Achat"
        case .dailyReward: return "Récompense Quotidienne"
        case .battlePass: return "Battle Pass"
        case .referral: return "Parrainage"
        case .bonus: return "Bonus"
        }
    }
    
    var isPositive: Bool {
        switch self {
        case .win, .dailyReward, .battlePass, .referral, .bonus:
            return true
        case .bet, .loss, .purchase:
            return false
        }
    }
}

struct Transaction: Identifiable, Codable {
    let id = UUID()
    let type: TransactionType
    let currency: Currency
    let amount: Int
    let timestamp: Date
    let description: String
    let gameType: GameType?
    
    init(type: TransactionType, currency: Currency, amount: Int, description: String, gameType: GameType? = nil) {
        self.type = type
        self.currency = currency
        self.amount = amount
        self.timestamp = Date()
        self.description = description
        self.gameType = gameType
    }
}

struct WalletBalance: Codable {
    var chips: Int
    var gems: Int
    
    init(chips: Int = 0, gems: Int = 0) {
        self.chips = chips
        self.gems = gems
    }
    
    subscript(currency: Currency) -> Int {
        get {
            switch currency {
            case .chips: return chips
            case .gems: return gems
            }
        }
        set {
            switch currency {
            case .chips: chips = newValue
            case .gems: gems = newValue
            }
        }
    }
}
