import Foundation
import StoreKit
import Combine

@MainActor
class StoreKitService: ObservableObject {
    static let shared = StoreKitService()
    
    @Published var products: [Product] = []
    @Published var purchasedProductIDs = Set<String>()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var productIDs = [
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
    
    private var updates: Task<Void, Error>? = nil
    
    private init() {
        updates = observeTransactionUpdates()
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await Product.products(for: productIDs)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func purchase(_ product: Product) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Vérifier la transaction
                switch verification {
                case .verified(let transaction):
                    await handlePurchase(transaction)
                case .unverified:
                    errorMessage = "Transaction non vérifiée"
                }
            case .userCancelled:
                errorMessage = "Achat annulé"
            case .pending:
                errorMessage = "Achat en attente"
            @unknown default:
                errorMessage = "Erreur inconnue"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func handlePurchase(_ transaction: StoreKit.Transaction) async {
        // Ajouter aux produits achetés
        purchasedProductIDs.insert(transaction.productID)
        
        // Traiter l'achat selon le produit
        await processPurchase(transaction.productID, amount: 1)
        
        // Finaliser la transaction
        await transaction.finish()
    }
    
    private func processPurchase(_ productID: String, amount: Int) async {
        switch productID {
        case "chips_2m":
            WalletStore.shared.purchase(2_000_000, currency: .chips, cost: 0, costCurrency: .chips)
        case "chips_10m":
            WalletStore.shared.purchase(10_000_000, currency: .chips, cost: 0, costCurrency: .chips)
        case "chips_30m":
            WalletStore.shared.purchase(30_000_000, currency: .chips, cost: 0, costCurrency: .chips)
        case "chips_120m":
            WalletStore.shared.purchase(120_000_000, currency: .chips, cost: 0, costCurrency: .chips)
        case "chips_350m":
            WalletStore.shared.purchase(350_000_000, currency: .chips, cost: 0, costCurrency: .chips)
        case "gems_2000":
            WalletStore.shared.purchase(2000, currency: .gems, cost: 0, costCurrency: .gems)
        case "gems_5000":
            WalletStore.shared.purchase(5000, currency: .gems, cost: 0, costCurrency: .gems)
        case "gems_12000":
            WalletStore.shared.purchase(12000, currency: .gems, cost: 0, costCurrency: .gems)
        case "battlepass_premium":
            BattlePassService.shared.isPremium = true
        default:
            break
        }
    }
    
    private func updatePurchasedProducts() async {
        for await result in StoreKit.Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                purchasedProductIDs.insert(transaction.productID)
            case .unverified:
                continue
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Error> {
        return Task.detached {
            for await verificationResult in StoreKit.Transaction.updates {
                switch verificationResult {
                case .verified(let transaction):
                    await self.handlePurchase(transaction)
                case .unverified:
                    continue
                }
            }
        }
    }
    
    func getProduct(for productID: String) -> Product? {
        return products.first { $0.id == productID }
    }
    
    func isPurchased(_ productID: String) -> Bool {
        return purchasedProductIDs.contains(productID)
    }
    
    func formatPrice(for product: Product) -> String {
        return product.displayPrice
    }
    
    func getChipsAmount(for productID: String) -> Int {
        switch productID {
        case "chips_2m": return 2_000_000
        case "chips_10m": return 10_000_000
        case "chips_30m": return 30_000_000
        case "chips_120m": return 120_000_000
        case "chips_350m": return 350_000_000
        default: return 0
        }
    }
    
    func getGemsAmount(for productID: String) -> Int {
        switch productID {
        case "gems_2000": return 2000
        case "gems_5000": return 5000
        case "gems_12000": return 12000
        default: return 0
        }
    }
}
