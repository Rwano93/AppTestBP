import Foundation
import Combine

class OffersService: ObservableObject {
    static let shared = OffersService()
    
    @Published var currentOffers: [SpecialOffer] = []
    @Published var dailyOffer: DailyOffer?
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let offersKey = "special_offers"
    private let dailyOfferKey = "daily_offer"
    
    private init() {
        loadData()
        generateDailyOffer()
    }
    
    func generateDailyOffer() {
        let now = Date()
        let calendar = Calendar.current
        
        // Vérifier si on a déjà une offre du jour pour aujourd'hui
        if let savedDailyOffer = dailyOffer,
           calendar.isDate(savedDailyOffer.date, inSameDayAs: now) {
            return
        }
        
        // Générer une nouvelle offre du jour
        let offerTypes: [DailyOffer.DailyOfferType] = [.chips, .gems, .battlepass]
        let randomType = offerTypes.randomElement() ?? .chips
        
        let newDailyOffer = DailyOffer(
            id: UUID().uuidString,
            type: randomType,
            originalPrice: getOriginalPrice(for: randomType),
            discountedPrice: getDiscountedPrice(for: randomType),
            discountPercentage: getDiscountPercentage(for: randomType),
            bonusAmount: getBonusAmount(for: randomType),
            date: now,
            expiresAt: calendar.date(byAdding: .day, value: 1, to: now) ?? now
        )
        
        dailyOffer = newDailyOffer
        saveData()
    }
    
    func generateSpecialOffers() {
        let offers = [
            SpecialOffer(
                id: "welcome_bonus",
                title: "Bonus de Bienvenue",
                description: "Doublez vos jetons pour votre première partie !",
                type: .welcome,
                discountPercentage: 100,
                originalPrice: 100_000,
                discountedPrice: 0,
                bonusAmount: 100_000,
                expiresAt: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
                isActive: true
            ),
            SpecialOffer(
                id: "weekend_special",
                title: "Offre Weekend",
                description: "30% de réduction sur tous les packs de jetons !",
                type: .weekend,
                discountPercentage: 30,
                originalPrice: 1_000_000,
                discountedPrice: 700_000,
                bonusAmount: 50_000,
                expiresAt: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                isActive: true
            ),
            SpecialOffer(
                id: "battlepass_discount",
                title: "Battle Pass Premium",
                description: "Battle Pass Premium à -50% !",
                type: .battlepass,
                discountPercentage: 50,
                originalPrice: 1000,
                discountedPrice: 500,
                bonusAmount: 0,
                expiresAt: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                isActive: true
            )
        ]
        
        currentOffers = offers
        saveData()
    }
    
    func purchaseOffer(_ offer: SpecialOffer) {
        // Simuler l'achat de l'offre
        WalletStore.shared.purchase(
            offer.bonusAmount,
            currency: .chips,
            cost: offer.discountedPrice,
            costCurrency: .chips
        )
        
        // Marquer l'offre comme utilisée
        if let index = currentOffers.firstIndex(where: { $0.id == offer.id }) {
            currentOffers[index].isActive = false
        }
        
        saveData()
    }
    
    func purchaseDailyOffer() {
        guard let offer = dailyOffer else { return }
        
        // Simuler l'achat de l'offre du jour
        WalletStore.shared.purchase(
            offer.bonusAmount,
            currency: offer.type == .gems ? .gems : .chips,
            cost: offer.discountedPrice,
            costCurrency: .chips
        )
        
        // Marquer l'offre comme utilisée
        dailyOffer = nil
        saveData()
    }
    
    func isOfferExpired(_ offer: SpecialOffer) -> Bool {
        return Date() > offer.expiresAt
    }
    
    func isDailyOfferExpired() -> Bool {
        guard let offer = dailyOffer else { return true }
        return Date() > offer.expiresAt
    }
    
    func getTimeRemaining(for offer: SpecialOffer) -> TimeInterval {
        return offer.expiresAt.timeIntervalSince(Date())
    }
    
    func formatTimeRemaining(for offer: SpecialOffer) -> String {
        let timeRemaining = getTimeRemaining(for: offer)
        let days = Int(timeRemaining) / (24 * 60 * 60)
        let hours = (Int(timeRemaining) % (24 * 60 * 60)) / (60 * 60)
        
        if days > 0 {
            return "\(days)j \(hours)h"
        } else {
            return "\(hours)h"
        }
    }
    
    // MARK: - Helpers
    
    private func getOriginalPrice(for type: DailyOffer.DailyOfferType) -> Int {
        switch type {
        case .chips: return 100_000
        case .gems: return 500
        case .battlepass: return 1000
        }
    }
    
    private func getDiscountedPrice(for type: DailyOffer.DailyOfferType) -> Int {
        let original = getOriginalPrice(for: type)
        let discount = getDiscountPercentage(for: type)
        return original - (original * discount / 100)
    }
    
    private func getDiscountPercentage(for type: DailyOffer.DailyOfferType) -> Int {
        switch type {
        case .chips: return Int.random(in: 20...40)
        case .gems: return Int.random(in: 15...30)
        case .battlepass: return Int.random(in: 25...50)
        }
    }
    
    private func getBonusAmount(for type: DailyOffer.DailyOfferType) -> Int {
        switch type {
        case .chips: return Int.random(in: 50_000...200_000)
        case .gems: return Int.random(in: 100...500)
        case .battlepass: return 0
        }
    }
    
    // MARK: - Persistance
    
    private func saveData() {
        if let offersData = try? JSONEncoder().encode(currentOffers) {
            userDefaults.set(offersData, forKey: offersKey)
        }
        
        if let dailyOfferData = try? JSONEncoder().encode(dailyOffer) {
            userDefaults.set(dailyOfferData, forKey: dailyOfferKey)
        }
    }
    
    private func loadData() {
        if let offersData = userDefaults.data(forKey: offersKey),
           let loadedOffers = try? JSONDecoder().decode([SpecialOffer].self, from: offersData) {
            currentOffers = loadedOffers
        } else {
            generateSpecialOffers()
        }
        
        if let dailyOfferData = userDefaults.data(forKey: dailyOfferKey),
           let loadedDailyOffer = try? JSONDecoder().decode(DailyOffer.self, from: dailyOfferData) {
            dailyOffer = loadedDailyOffer
        }
    }
}

struct SpecialOffer: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let type: OfferType
    let discountPercentage: Int
    let originalPrice: Int
    let discountedPrice: Int
    let bonusAmount: Int
    let expiresAt: Date
    var isActive: Bool
    
    enum OfferType: String, Codable {
        case welcome = "welcome"
        case weekend = "weekend"
        case battlepass = "battlepass"
        case limited = "limited"
        
        var displayName: String {
            switch self {
            case .welcome: return "Bienvenue"
            case .weekend: return "Weekend"
            case .battlepass: return "Battle Pass"
            case .limited: return "Limité"
            }
        }
    }
}

struct DailyOffer: Identifiable, Codable {
    let id: String
    let type: DailyOfferType
    let originalPrice: Int
    let discountedPrice: Int
    let discountPercentage: Int
    let bonusAmount: Int
    let date: Date
    let expiresAt: Date
    
    enum DailyOfferType: String, Codable {
        case chips = "chips"
        case gems = "gems"
        case battlepass = "battlepass"
        
        var displayName: String {
            switch self {
            case .chips: return "Jetons"
            case .gems: return "Gemmes"
            case .battlepass: return "Battle Pass"
            }
        }
    }
}
