import Foundation

enum Route: Hashable {
    case splash
    case auth
    case hub
    case profile
    case friends
    case shop
    case pass
    case daily
    case blackjack
    case roulette
    case baccarat
    case poker
    case settings
    
    // Routes avec paramètres
    case gameTable(game: GameType, buyIn: Int)
    case referral(code: String)
    
    var title: String {
        switch self {
        case .splash: return "Chargement"
        case .auth: return "Connexion"
        case .hub: return "CasinoX"
        case .profile: return "Profil"
        case .friends: return "Amis"
        case .shop: return "Boutique"
        case .pass: return "Battle Pass"
        case .daily: return "Récompense Quotidienne"
        case .blackjack: return "Blackjack"
        case .roulette: return "Roulette"
        case .baccarat: return "Baccarat"
        case .poker: return "Poker"
        case .settings: return "Paramètres"
        case .gameTable(let game, _): return game.displayName
        case .referral: return "Parrainage"
        }
    }
}

enum GameType: String, CaseIterable, Codable {
    case blackjack = "blackjack"
    case roulette = "roulette"
    case baccarat = "baccarat"
    case poker = "poker"
    
    var displayName: String {
        switch self {
        case .blackjack: return "Blackjack"
        case .roulette: return "Roulette"
        case .baccarat: return "Baccarat"
        case .poker: return "Poker"
        }
    }
    
    var icon: String {
        switch self {
        case .blackjack: return "suit.club.fill"
        case .roulette: return "circle.circle.fill"
        case .baccarat: return "diamond.fill"
        case .poker: return "suit.spade.fill"
        }
    }
    
    var color: String {
        switch self {
        case .blackjack: return "0F6A5B"
        case .roulette: return "CF3030"
        case .baccarat: return "0B5589"
        case .poker: return "4C2E1A"
        }
    }
}
