import Foundation
import Combine
import SwiftUI

class WalletStore: ObservableObject {
    static let shared = WalletStore()
    
    @Published var balance = WalletBalance()
    @Published var transactions: [Transaction] = []
    @Published var lastDelta: (currency: Currency, amount: Int)? = nil
    
    private let userDefaults = UserDefaults.standard
    private let balanceKey = "wallet_balance"
    private let transactionsKey = "wallet_transactions"
    
    private init() {
        loadData()
    }
    
    func initializeWallet() {
        if balance.chips == 0 && balance.gems == 0 {
            // Solde initial : 3M chips + 100 gems
            balance.chips = 3_000_000
            balance.gems = 100
            saveData()
        }
    }
    
    func apply(_ transaction: Transaction) {
        // Appliquer la transaction
        let oldBalance = balance[transaction.currency]
        balance[transaction.currency] += transaction.amount
        let newBalance = balance[transaction.currency]
        
        // Ajouter à l'historique
        transactions.insert(transaction, at: 0)
        
        // Limiter l'historique à 100 transactions
        if transactions.count > 100 {
            transactions = Array(transactions.prefix(100))
        }
        
        // Animer le delta
        let delta = newBalance - oldBalance
        if delta != 0 {
            animateDelta(transaction.currency, amount: delta)
        }
        
        saveData()
    }
    
    func animateDelta(_ currency: Currency, amount: Int) {
        lastDelta = (currency: currency, amount: amount)
        
        // Effacer le delta après 2 secondes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.lastDelta?.currency == currency && self.lastDelta?.amount == amount {
                self.lastDelta = nil
            }
        }
    }
    
    func canAfford(_ amount: Int, currency: Currency = .chips) -> Bool {
        return balance[currency] >= amount
    }
    
    func bet(_ amount: Int, currency: Currency = .chips) -> Bool {
        guard canAfford(amount, currency: currency) else { return false }
        
        let transaction = Transaction(
            type: .bet,
            currency: currency,
            amount: -amount,
            description: "Mise de \(amount.formatted()) \(currency.symbol)"
        )
        
        apply(transaction)
        return true
    }
    
    func win(_ amount: Int, currency: Currency = .chips, gameType: GameType? = nil) {
        let transaction = Transaction(
            type: .win,
            currency: currency,
            amount: amount,
            description: "Gain de \(amount.formatted()) \(currency.symbol)",
            gameType: gameType
        )
        
        apply(transaction)
    }
    
    func lose(_ amount: Int, currency: Currency = .chips, gameType: GameType? = nil) {
        let transaction = Transaction(
            type: .loss,
            currency: currency,
            amount: -amount,
            description: "Perte de \(amount.formatted()) \(currency.symbol)",
            gameType: gameType
        )
        
        apply(transaction)
    }
    
    func addDailyReward(_ amount: Int, currency: Currency = .chips) {
        let transaction = Transaction(
            type: .dailyReward,
            currency: currency,
            amount: amount,
            description: "Récompense quotidienne : \(amount.formatted()) \(currency.symbol)"
        )
        
        apply(transaction)
    }
    
    func addBattlePassReward(_ amount: Int, currency: Currency) {
        let transaction = Transaction(
            type: .battlePass,
            currency: currency,
            amount: amount,
            description: "Battle Pass : \(amount.formatted()) \(currency.symbol)"
        )
        
        apply(transaction)
    }
    
    func addReferralBonus(_ amount: Int, currency: Currency = .chips) {
        let transaction = Transaction(
            type: .referral,
            currency: currency,
            amount: amount,
            description: "Bonus parrainage : \(amount.formatted()) \(currency.symbol)"
        )
        
        apply(transaction)
    }
    
    func purchase(_ amount: Int, currency: Currency, cost: Int, costCurrency: Currency) {
        // Déduire le coût
        let costTransaction = Transaction(
            type: .purchase,
            currency: costCurrency,
            amount: -cost,
            description: "Achat de \(amount.formatted()) \(currency.symbol)"
        )
        apply(costTransaction)
        
        // Ajouter l'achat
        let purchaseTransaction = Transaction(
            type: .purchase,
            currency: currency,
            amount: amount,
            description: "Achat de \(amount.formatted()) \(currency.symbol)"
        )
        apply(purchaseTransaction)
    }
    
    // MARK: - Persistance
    
    private func saveData() {
        if let balanceData = try? JSONEncoder().encode(balance) {
            userDefaults.set(balanceData, forKey: balanceKey)
        }
        
        if let transactionsData = try? JSONEncoder().encode(transactions) {
            userDefaults.set(transactionsData, forKey: transactionsKey)
        }
    }
    
    private func loadData() {
        if let balanceData = userDefaults.data(forKey: balanceKey),
           let loadedBalance = try? JSONDecoder().decode(WalletBalance.self, from: balanceData) {
            balance = loadedBalance
        }
        
        if let transactionsData = userDefaults.data(forKey: transactionsKey),
           let loadedTransactions = try? JSONDecoder().decode([Transaction].self, from: transactionsData) {
            transactions = loadedTransactions
        }
    }
}

// MARK: - Extensions

extension Int {
    func formatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
