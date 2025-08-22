import Foundation
import SwiftUI

// MARK: - Configuration de l'application

struct AppConfiguration {
    // Configuration générale
    static let appName = "CasinoX"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    
    // Configuration de l'orientation
    static let supportedOrientations: UIInterfaceOrientationMask = [.landscapeLeft, .landscapeRight]
    
    // Configuration des couleurs
    static let primaryColor = AppColors.primary
    static let accentColor = AppColors.accent
    static let backgroundColor = AppColors.background
    
    // Configuration du wallet
    static let initialChips = 3_000_000
    static let initialGems = 100
    
    // Configuration des récompenses
    static let dailyRewardCooldown: TimeInterval = 24 * 60 * 60 // 24 heures
    static let battlePassSeasonDuration: TimeInterval = 30 * 24 * 60 * 60 // 30 jours
    
    // Configuration des jeux
    static let blackjackDecks = 6
    static let rouletteNumbers = 37 // 0-36
    static let pokerMaxPlayers = 6
    
    // Configuration des achats
    static let storeKitProductIDs = [
        "chips_2m",
        "chips_10m", 
        "chips_30m",
        "chips_120m",
        "chips_350m",
        "gems_2000",
        "gems_5000",
        "gems_12000",
        "battlepass_premium"
    ]
    
    // Configuration des sons
    static let soundEffects = [
        "chip",
        "deal", 
        "shuffle",
        "roulette_spin",
        "win",
        "lose",
        "click"
    ]
    
    // Configuration de l'accessibilité
    static let supportsDynamicType = true
    static let supportsVoiceOver = true
    static let minimumContrastRatio: Double = 4.5 // AA standard
    
    // Configuration de la performance
    static let targetFrameRate: Int = 60
    static let enablePostProcessing = true
    static let enableMotionBlur = true
    static let enableBloom = true
    
    // Configuration du réseau
    static let websocketReconnectDelay: TimeInterval = 5.0
    static let heartbeatInterval: TimeInterval = 30.0
    static let requestTimeout: TimeInterval = 10.0
    
    // Configuration de la sécurité
    static let enableReceiptValidation = true
    static let enableRNGLogging = true
    static let enableGameHistory = true
    
    // Configuration de l'internationalisation
    static let defaultLocale = "fr"
    static let supportedLocales = ["fr", "en"]
    
    // Configuration des notifications
    static let enablePushNotifications = true
    static let enableLocalNotifications = true
    
    // Configuration du debug
    static let enableDebugLogging = true
    static let enablePerformanceMonitoring = true
    static let enableCrashReporting = true
}

// MARK: - Extensions utilitaires

extension AppConfiguration {
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    static var deviceType: DeviceType {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        } else {
            return .iPhone
        }
    }
    
    enum DeviceType {
        case iPhone
        case iPad
    }
}

// MARK: - Configuration des jeux

struct GameConfiguration {
    struct Blackjack {
        static let decks = 6
        static let dealerStandsOnSoft17 = true
        static let blackjackPays = 3.0 / 2.0
        static let insurancePays = 2.0
        static let maxSplits = 3
        static let canDoubleAfterSplit = true
        static let canSurrender = true
    }
    
    struct Roulette {
        static let numbers = 37 // 0-36
        static let isEuropean = true
        static let hasLaPartage = true
        static let hasEnPrison = true
        static let historySize = 10
    }
    
    struct Baccarat {
        static let commission = 0.05 // 5%
        static let tiePays = 8.0
        static let playerPays = 1.0
        static let bankerPays = 0.95 // 1.0 - commission
    }
    
    struct Poker {
        static let maxPlayers = 6
        static let smallBlind = 10
        static let bigBlind = 20
        static let minBuyIn = 1000
        static let maxBuyIn = 100000
        static let timeBank = 30.0
        static let actionTime = 15.0
    }
}

// MARK: - Configuration des récompenses

struct RewardConfiguration {
    struct DailyReward {
        static let baseAmount = 100_000
        static let streakMultiplier = 1.5
        static let maxStreak = 7
        static let cooldown: TimeInterval = 24 * 60 * 60
    }
    
    struct BattlePass {
        static let maxTier = 50
        static let xpPerTier = 1000
        static let seasonDuration: TimeInterval = 30 * 24 * 60 * 60
        static let premiumPrice = 9.99
    }
    
    struct Referral {
        static let bonusAmount = 500_000
        static let maxReferrals = 10
        static let bonusPerReferral = 100_000
    }
}

// MARK: - Configuration des achats

struct StoreConfiguration {
    static let products: [String: StoreProduct] = [
        "chips_2m": StoreProduct(id: "chips_2m", name: "Pack Jetons", amount: 2_000_000, price: 2.99, type: .chips),
        "chips_10m": StoreProduct(id: "chips_10m", name: "Pack Jetons", amount: 10_000_000, price: 9.99, type: .chips),
        "chips_30m": StoreProduct(id: "chips_30m", name: "Pack Jetons", amount: 30_000_000, price: 24.99, type: .chips),
        "chips_120m": StoreProduct(id: "chips_120m", name: "Pack Jetons", amount: 120_000_000, price: 89.99, type: .chips),
        "chips_350m": StoreProduct(id: "chips_350m", name: "Pack Jetons", amount: 350_000_000, price: 199.99, type: .chips),
        "gems_2000": StoreProduct(id: "gems_2000", name: "Pack Gemmes", amount: 2000, price: 4.99, type: .gems),
        "gems_5000": StoreProduct(id: "gems_5000", name: "Pack Gemmes", amount: 5000, price: 9.99, type: .gems),
        "gems_12000": StoreProduct(id: "gems_12000", name: "Pack Gemmes", amount: 12000, price: 19.99, type: .gems),
        "battlepass_premium": StoreProduct(id: "battlepass_premium", name: "Battle Pass Premium", amount: 0, price: 9.99, type: .battlepass)
    ]
}

struct StoreProduct {
    let id: String
    let name: String
    let amount: Int
    let price: Double
    let type: ProductType
    
    enum ProductType {
        case chips
        case gems
        case battlepass
    }
}
