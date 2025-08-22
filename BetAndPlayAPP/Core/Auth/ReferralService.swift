import Foundation
import Combine

class ReferralService: ObservableObject {
    static let shared = ReferralService()
    
    @Published var referrals: [Referral] = []
    @Published var totalEarnings: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let referralsKey = "user_referrals"
    private let earningsKey = "referral_earnings"
    
    private init() {
        loadData()
    }
    
    func addReferral(_ referral: Referral) {
        referrals.append(referral)
        totalEarnings += referral.earnings
        saveData()
    }
    
    func validateReferralCode(_ code: String) -> Bool {
        // Simuler la validation d'un code de parrainage
        // En réalité, cela vérifierait contre une base de données
        return code.count == 8 && code.allSatisfy { $0.isLetter || $0.isNumber }
    }
    
    func getReferralStats() -> ReferralStats {
        let totalReferrals = referrals.count
        let activeReferrals = referrals.filter { $0.isActive }.count
        let totalEarnings = referrals.reduce(0) { $0 + $1.earnings }
        
        return ReferralStats(
            totalReferrals: totalReferrals,
            activeReferrals: activeReferrals,
            totalEarnings: totalEarnings
        )
    }
    
    func generateReferralLink(for user: User) -> String {
        return "casinox://referral?code=\(user.referralCode)"
    }
    
    // MARK: - Persistance
    
    private func saveData() {
        if let referralsData = try? JSONEncoder().encode(referrals) {
            userDefaults.set(referralsData, forKey: referralsKey)
        }
        userDefaults.set(totalEarnings, forKey: earningsKey)
    }
    
    private func loadData() {
        if let referralsData = userDefaults.data(forKey: referralsKey),
           let loadedReferrals = try? JSONDecoder().decode([Referral].self, from: referralsData) {
            referrals = loadedReferrals
        }
        
        totalEarnings = userDefaults.integer(forKey: earningsKey)
    }
}

struct Referral: Identifiable, Codable {
    let id = UUID()
    let referredUserId: String
    let referredUsername: String
    let referralDate: Date
    let earnings: Int
    var isActive: Bool
    
    init(referredUserId: String, referredUsername: String, earnings: Int = 0) {
        self.referredUserId = referredUserId
        self.referredUsername = referredUsername
        self.referralDate = Date()
        self.earnings = earnings
        self.isActive = true
    }
}

struct ReferralStats {
    let totalReferrals: Int
    let activeReferrals: Int
    let totalEarnings: Int
    
    var earningsFormatted: String {
        return totalEarnings.formatted()
    }
}
