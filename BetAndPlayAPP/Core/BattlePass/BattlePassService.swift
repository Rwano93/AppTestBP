import Foundation
import Combine

class BattlePassService: ObservableObject {
    static let shared = BattlePassService()
    
    @Published var currentTier: Int = 1
    @Published var currentXP: Int = 0
    @Published var maxTier: Int = 50
    @Published var isPremium: Bool = false
    @Published var claimedTiers: Set<Int> = []
    @Published var seasonEndDate: Date
    
    private let userDefaults = UserDefaults.standard
    private let tierKey = "battlepass_tier"
    private let xpKey = "battlepass_xp"
    private let premiumKey = "battlepass_premium"
    private let claimedKey = "battlepass_claimed"
    private let seasonEndKey = "battlepass_season_end"
    
    private init() {
        // Initialiser la date de fin de saison (1 mois)
        let calendar = Calendar.current
        seasonEndDate = calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        
        loadData()
    }
    
    func addXP(_ amount: Int) {
        currentXP += amount
        
        // Vérifier si on monte de niveau
        while currentXP >= xpRequiredForTier(currentTier + 1) && currentTier < maxTier {
            currentTier += 1
        }
        
        saveData()
    }
    
    func claimTier(_ tier: Int) {
        guard tier <= currentTier && !claimedTiers.contains(tier) else { return }
        
        let reward = getRewardForTier(tier)
        claimedTiers.insert(tier)
        
        // Appliquer la récompense
        WalletStore.shared.addBattlePassReward(reward.amount, currency: reward.currency)
        
        saveData()
    }
    
    func canClaimTier(_ tier: Int) -> Bool {
        return tier <= currentTier && !claimedTiers.contains(tier)
    }
    
    func getRewardForTier(_ tier: Int) -> BattlePassReward {
        // Récompenses gratuites
        if tier % 5 == 0 {
            return BattlePassReward(amount: 50_000, currency: .chips, type: .chips)
        } else if tier % 10 == 0 {
            return BattlePassReward(amount: 100, currency: .gems, type: .gems)
        } else {
            return BattlePassReward(amount: 10_000, currency: .chips, type: .chips)
        }
    }
    
    func getPremiumRewardForTier(_ tier: Int) -> BattlePassReward? {
        guard isPremium else { return nil }
        
        // Récompenses premium
        if tier % 3 == 0 {
            return BattlePassReward(amount: 100_000, currency: .chips, type: .chips)
        } else if tier % 7 == 0 {
            return BattlePassReward(amount: 200, currency: .gems, type: .gems)
        } else {
            return BattlePassReward(amount: 25_000, currency: .chips, type: .chips)
        }
    }
    
    func xpRequiredForTier(_ tier: Int) -> Int {
        // Formule : 1000 XP par niveau
        return (tier - 1) * 1000
    }
    
    func xpProgressForCurrentTier() -> Double {
        let xpForCurrentTier = xpRequiredForTier(currentTier)
        let xpForNextTier = xpRequiredForTier(currentTier + 1)
        let currentTierXP = currentXP - xpForCurrentTier
        let xpNeeded = xpForNextTier - xpForCurrentTier
        
        return Double(currentTierXP) / Double(xpNeeded)
    }
    
    func getTimeRemaining() -> TimeInterval {
        return seasonEndDate.timeIntervalSince(Date())
    }
    
    func formatTimeRemaining() -> String {
        let timeRemaining = getTimeRemaining()
        let days = Int(timeRemaining) / (24 * 60 * 60)
        let hours = (Int(timeRemaining) % (24 * 60 * 60)) / (60 * 60)
        
        return "\(days)j \(hours)h"
    }
    
    func checkBattlePass() {
        // Vérifier si la saison est terminée
        if Date() > seasonEndDate {
            resetSeason()
        }
    }
    
    private func resetSeason() {
        currentTier = 1
        currentXP = 0
        claimedTiers.removeAll()
        
        // Nouvelle saison
        let calendar = Calendar.current
        seasonEndDate = calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        
        saveData()
    }
    
    // MARK: - Persistance
    
    private func saveData() {
        userDefaults.set(currentTier, forKey: tierKey)
        userDefaults.set(currentXP, forKey: xpKey)
        userDefaults.set(isPremium, forKey: premiumKey)
        userDefaults.set(Array(claimedTiers), forKey: claimedKey)
        userDefaults.set(seasonEndDate, forKey: seasonEndKey)
    }
    
    private func loadData() {
        currentTier = userDefaults.integer(forKey: tierKey)
        if currentTier == 0 { currentTier = 1 }
        
        currentXP = userDefaults.integer(forKey: xpKey)
        isPremium = userDefaults.bool(forKey: premiumKey)
        
        if let claimedArray = userDefaults.array(forKey: claimedKey) as? [Int] {
            claimedTiers = Set(claimedArray)
        }
        
        if let savedSeasonEnd = userDefaults.object(forKey: seasonEndKey) as? Date {
            seasonEndDate = savedSeasonEnd
        }
    }
}

struct BattlePassReward {
    let amount: Int
    let currency: Currency
    let type: RewardType
    
    enum RewardType {
        case chips
        case gems
        case cosmetic
    }
}

struct BattlePassTier {
    let tier: Int
    let isUnlocked: Bool
    let isClaimed: Bool
    let freeReward: BattlePassReward
    let premiumReward: BattlePassReward?
    
    var progress: Double {
        return isUnlocked ? 1.0 : 0.0
    }
}
