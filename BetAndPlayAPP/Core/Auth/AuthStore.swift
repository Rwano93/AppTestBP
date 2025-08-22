import Foundation
import Combine

class AuthStore: ObservableObject {
    static let shared = AuthStore()
    
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "current_user"
    
    private init() {
        loadUser()
    }
    
    func login(email: String, username: String, avatarId: Int, referralCode: String? = nil) {
        isLoading = true
        
        // Simuler un délai de connexion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let user = User(
                id: self.generateUserId(),
                email: email,
                username: username,
                avatarId: avatarId,
                level: 1,
                xp: 0,
                referralCode: self.generateReferralCode(),
                referredBy: referralCode,
                memberSince: Date(),
                status: nil,
                isVIP: false
            )
            
            self.currentUser = user
            self.isAuthenticated = true
            self.saveUser()
            self.isLoading = false
            
            // Traiter le code de parrainage si fourni
            if let referralCode = referralCode {
                self.processReferralCode(referralCode)
            }
        }
    }
    
    func register(email: String, username: String, avatarId: Int, referralCode: String? = nil) {
        isLoading = true
        
        // Simuler un délai d'inscription
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let user = User(
                id: self.generateUserId(),
                email: email,
                username: username,
                avatarId: avatarId,
                level: 1,
                xp: 0,
                referralCode: self.generateReferralCode(),
                referredBy: referralCode,
                memberSince: Date(),
                status: nil,
                isVIP: false
            )
            
            self.currentUser = user
            self.isAuthenticated = true
            self.saveUser()
            self.isLoading = false
            
            // Traiter le code de parrainage si fourni
            if let referralCode = referralCode {
                self.processReferralCode(referralCode)
            }
        }
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        userDefaults.removeObject(forKey: userKey)
    }
    
    func updateUser(_ user: User) {
        currentUser = user
        saveUser()
    }
    
    func addXP(_ amount: Int) {
        guard var user = currentUser else { return }
        
        user.xp += amount
        
        // Calculer le niveau
        let newLevel = calculateLevel(xp: user.xp)
        if newLevel > user.level {
            user.level = newLevel
            // Récompense de niveau
            WalletStore.shared.addBattlePassReward(1000, currency: .chips)
        }
        
        updateUser(user)
    }
    
    private func calculateLevel(xp: Int) -> Int {
        // Formule simple : 1000 XP par niveau
        return (xp / 1000) + 1
    }
    
    private func generateReferralCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map { _ in letters.randomElement()! })
    }
    
    private func processReferralCode(_ code: String) {
        // Simuler le traitement du code de parrainage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Bonus pour le parrainé
            WalletStore.shared.addReferralBonus(50_000, currency: .chips)
            
            // Bonus pour le parrain (simulé)
            // En réalité, cela serait géré côté serveur
        }
    }
    
    // MARK: - Persistance
    
    private func saveUser() {
        if let userData = try? JSONEncoder().encode(currentUser) {
            userDefaults.set(userData, forKey: userKey)
        }
    }
    
    private func loadUser() {
        if let userData = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            isAuthenticated = true
        }
    }
    
    private func generateUserId() -> String {
        // Générer un ID utilisateur plus lisible (comme dans les captures d'écran)
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let random = String(Int.random(in: 1000...9999))
        return "\(timestamp.suffix(3))-\(random)-\(timestamp.suffix(4))"
    }
    
    func updateAvatar(_ avatarId: Int) {
        guard var user = currentUser else { return }
        user.avatarId = avatarId
        currentUser = user
        saveUser()
    }
    
    func updateProfile(username: String, status: String?) {
        guard var user = currentUser else { return }
        user.username = username
        user.status = status
        currentUser = user
        saveUser()
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        userDefaults.removeObject(forKey: userKey)
    }
}

struct User: Codable {
    let id: String
    let email: String
    var username: String
    var avatarId: Int
    var level: Int
    var xp: Int
    let referralCode: String
    let referredBy: String?
    let memberSince: Date
    var status: String?
    var isVIP: Bool
    
    var displayName: String {
        return username
    }
    
    var avatarImage: String {
        return "avatar_\(avatarId)"
    }
    
    var xpToNextLevel: Int {
        _ = (level - 1) * 1000
        return level * 1000 - xp
    }
    
    var xpProgress: Double {
        let xpForCurrentLevel = (level - 1) * 1000
        let xpForNextLevel = level * 1000
        let currentLevelXP = xp - xpForCurrentLevel
        let xpNeeded = xpForNextLevel - xpForCurrentLevel
        return Double(currentLevelXP) / Double(xpNeeded)
    }
}
