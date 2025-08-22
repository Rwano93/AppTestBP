import Foundation
import Combine

class DailyRewardService: ObservableObject {
    static let shared = DailyRewardService()
    
    @Published var currentStreak: Int = 0
    @Published var lastClaimDate: Date?
    @Published var claimedRewards: Set<Int> = []
    
    private let userDefaults = UserDefaults.standard
    private let lastClaimKey = "DailyRewardLastClaim"
    private let claimedRewardsKey = "DailyRewardClaimed"
    private let streakKey = "DailyRewardStreak"
    
    init() {
        loadData()
        checkDailyReset()
    }
    
    var canClaimToday: Bool {
        guard let lastClaim = lastClaimDate else { return true }
        return !Calendar.current.isDate(lastClaim, inSameDayAs: Date())
    }
    
    var todayReward: Int {
        return getRewardForDay(currentStreak + 1)
    }
    
    func claimDailyReward() {
        guard canClaimToday else { return }
        
        let reward = todayReward
        lastClaimDate = Date()
        claimedRewards.insert(currentStreak + 1)
        currentStreak += 1
        
        saveData()
        
        // Ajouter la récompense au wallet
        WalletStore.shared.win(reward, currency: .chips, gameType: nil)
    }
    
    func getRewardForDay(_ day: Int) -> Int {
        // Récompenses croissantes par jour
        switch day {
        case 1: return 1000
        case 2: return 1500
        case 3: return 2000
        case 4: return 2500
        case 5: return 3000
        case 6: return 4000
        case 7: return 5000
        case 8: return 6000
        case 9: return 7000
        case 10: return 8000
        case 11: return 9000
        case 12: return 10000
        case 13: return 12000
        case 14: return 15000
        case 15: return 20000
        case 16: return 25000
        case 17: return 30000
        case 18: return 35000
        case 19: return 40000
        case 20: return 50000
        case 21: return 60000
        case 22: return 70000
        case 23: return 80000
        case 24: return 90000
        case 25: return 100000
        case 26: return 120000
        case 27: return 150000
        case 28: return 200000
        case 29: return 250000
        case 30: return 300000
        default: return 300000
        }
    }
    
    func isRewardClaimed(for day: Int) -> Bool {
        return claimedRewards.contains(day)
    }
    
    func getBonusForStreak(_ streak: Int) -> Int {
        // Bonus de série croissant
        switch streak {
        case 7: return 5000
        case 14: return 15000
        case 21: return 30000
        case 30: return 100000
        default: return 0
        }
    }
    
    private func checkDailyReset() {
        guard let lastClaim = lastClaimDate else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Si plus d'un jour s'est écoulé, réinitialiser la série
        if calendar.dateInterval(of: .day, for: now)?.start != calendar.dateInterval(of: .day, for: lastClaim)?.start {
            if calendar.dateInterval(of: .day, for: now)?.start != calendar.dateInterval(of: .day, for: calendar.date(byAdding: .day, value: -1, to: now)!)?.start {
                // Plus d'un jour, réinitialiser
                currentStreak = 0
                claimedRewards.removeAll()
                saveData()
            }
        }
    }
    
    private func loadData() {
        if let lastClaim = userDefaults.object(forKey: lastClaimKey) as? Date {
            lastClaimDate = lastClaim
        }
        
        if let claimedArray = userDefaults.array(forKey: claimedRewardsKey) as? [Int] {
            claimedRewards = Set(claimedArray)
        }
        
        currentStreak = userDefaults.integer(forKey: streakKey)
    }
    
    private func saveData() {
        userDefaults.set(lastClaimDate, forKey: lastClaimKey)
        userDefaults.set(Array(claimedRewards), forKey: claimedRewardsKey)
        userDefaults.set(currentStreak, forKey: streakKey)
    }
}

struct DailyRewardDay {
    let day: Int
    let reward: Int
    let isClaimed: Bool
    let isAvailable: Bool
    
    var icon: String {
        switch day {
        case 1: return "1.circle.fill"
        case 2: return "2.circle.fill"
        case 3: return "3.circle.fill"
        case 4: return "4.circle.fill"
        case 5: return "5.circle.fill"
        case 6: return "6.circle.fill"
        case 7: return "star.circle.fill"
        default: return "circle.fill"
        }
    }
    
    var color: String {
        if isClaimed {
            return "4CAF50" // Vert
        } else if isAvailable {
            return "FF9800" // Orange
        } else {
            return "9E9E9E" // Gris
        }
    }
}
