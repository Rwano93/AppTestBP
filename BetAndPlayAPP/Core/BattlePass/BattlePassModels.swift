import Foundation

struct BattlePassSeason {
    let id: String
    let name: String
    let startDate: Date
    let endDate: Date
    let theme: String
    let maxTier: Int
    
    var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }
    
    var progress: Double {
        let totalDuration = endDate.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        return min(max(elapsed / totalDuration, 0), 1)
    }
}

struct BattlePassMission {
    let id: String
    let title: String
    let description: String
    let xpReward: Int
    let progress: Int
    let maxProgress: Int
    let isCompleted: Bool
    
    var progressPercentage: Double {
        return Double(progress) / Double(maxProgress)
    }
}

enum MissionType: String, CaseIterable {
    case playGames = "play_games"
    case winGames = "win_games"
    case earnChips = "earn_chips"
    case playBlackjack = "play_blackjack"
    case playRoulette = "play_roulette"
    case playBaccarat = "play_baccarat"
    case playPoker = "play_poker"
    case dailyLogin = "daily_login"
    case inviteFriends = "invite_friends"
    case spendChips = "spend_chips"
    
    var displayName: String {
        switch self {
        case .playGames: return "Jouer des parties"
        case .winGames: return "Gagner des parties"
        case .earnChips: return "Gagner des jetons"
        case .playBlackjack: return "Jouer au Blackjack"
        case .playRoulette: return "Jouer à la Roulette"
        case .playBaccarat: return "Jouer au Baccarat"
        case .playPoker: return "Jouer au Poker"
        case .dailyLogin: return "Connexion quotidienne"
        case .inviteFriends: return "Inviter des amis"
        case .spendChips: return "Dépenser des jetons"
        }
    }
    
    var icon: String {
        switch self {
        case .playGames: return "gamecontroller.fill"
        case .winGames: return "trophy.fill"
        case .earnChips: return "plus.circle.fill"
        case .playBlackjack: return "suit.club.fill"
        case .playRoulette: return "circle.circle.fill"
        case .playBaccarat: return "diamond.fill"
        case .playPoker: return "suit.spade.fill"
        case .dailyLogin: return "calendar"
        case .inviteFriends: return "person.2.fill"
        case .spendChips: return "minus.circle.fill"
        }
    }
}

struct BattlePassProgress {
    let currentTier: Int
    let currentXP: Int
    let xpForNextTier: Int
    let totalXP: Int
    let maxTier: Int
    
    var progressToNextTier: Double {
        let xpForCurrentTier = (currentTier - 1) * 1000
        let currentTierXP = currentXP - xpForCurrentTier
        let xpNeeded = xpForNextTier - xpForCurrentTier
        return Double(currentTierXP) / Double(xpNeeded)
    }
    
    var overallProgress: Double {
        return Double(currentTier) / Double(maxTier)
    }
    
    var xpRemaining: Int {
        return xpForNextTier - currentXP
    }
}
