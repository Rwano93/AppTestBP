import Foundation
import UIKit
import CryptoKit

class RNGService: ObservableObject {
    static let shared = RNGService()
    
    private var currentSeed: UInt64 = 0
    private var gameHistory: [GameResult] = []
    private let userDefaults = UserDefaults.standard
    private let historyKey = "rng_game_history"
    
    private init() {
        loadHistory()
        generateNewSeed()
    }
    
    // MARK: - Seed Management
    
    func generateNewSeed() {
        // Utiliser une combinaison de sources pour le seed
        let timestamp = UInt64(Date().timeIntervalSince1970)
        let randomBytes = UInt64.random(in: 0...UInt64.max)
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let deviceHash = UInt64(deviceId.hashValue)
        
        currentSeed = timestamp ^ randomBytes ^ deviceHash
        
        // Ajouter de l'entropie supplémentaire
        if let entropy = getSystemEntropy() {
            currentSeed ^= entropy
        }
    }
    
    private func getSystemEntropy() -> UInt64? {
        // Utiliser des sources d'entropie système
        let memoryUsage = ProcessInfo.processInfo.physicalMemory
        let cpuCount = UInt64(ProcessInfo.processInfo.processorCount)
        let uptime = UInt64(ProcessInfo.processInfo.systemUptime)
        
        return memoryUsage ^ cpuCount ^ uptime
    }
    
    func getCurrentSeed() -> UInt64 {
        return currentSeed
    }
    
    func setSeed(_ seed: UInt64) {
        currentSeed = seed
    }
    
    // MARK: - Random Number Generation
    
    func randomInt(in range: ClosedRange<Int>) -> Int {
        let count = range.count
        let randomValue = lcgNext() % UInt64(count)
        return range.lowerBound + Int(randomValue)
    }
    
    func randomDouble() -> Double {
        let randomValue = lcgNext()
        return Double(randomValue) / Double(UInt64.max)
    }
    
    // Linear Congruential Generator pour générer des nombres pseudo-aléatoires
    private func lcgNext() -> UInt64 {
        currentSeed = currentSeed &* 6364136223846793005 &+ 1442695040888963407
        return currentSeed
    }
    
    func randomBool() -> Bool {
        return randomDouble() < 0.5
    }
    
    func randomElement<T>(from array: [T]) -> T? {
        guard !array.isEmpty else { return nil }
        let index = randomInt(in: 0...(array.count - 1))
        return array[index]
    }
    
    func shuffleArray<T>(_ array: [T]) -> [T] {
        var shuffled = array
        for i in (1..<shuffled.count).reversed() {
            let j = randomInt(in: 0...i)
            shuffled.swapAt(i, j)
        }
        return shuffled
    }
    
    // MARK: - Game-Specific RNG
    
    func rollDice(sides: Int = 6) -> Int {
        return randomInt(in: 1...sides)
    }
    
    func flipCoin() -> Bool {
        return randomBool()
    }
    
    func drawCard(from deck: [String]) -> String? {
        return randomElement(from: deck)
    }
    
    func spinRoulette() -> Int {
        // Roulette européenne (0-36)
        return randomInt(in: 0...36)
    }
    
    func dealCards(count: Int, from deck: inout [String]) -> [String] {
        var dealtCards: [String] = []
        
        for _ in 0..<count {
            if let card = drawCard(from: deck) {
                dealtCards.append(card)
                deck.removeAll { $0 == card }
            }
        }
        
        return dealtCards
    }
    
    // MARK: - Blackjack Specific
    
    func dealBlackjackHand(from deck: inout [String]) -> [String] {
        return dealCards(count: 2, from: &deck)
    }
    
    func shouldDealerHit(dealerHand: [String], playerHand: [String]) -> Bool {
        let dealerValue = calculateBlackjackValue(dealerHand)
        _ = calculateBlackjackValue(playerHand)
        
        // Stratégie de base du croupier : hit sur soft 17
        if dealerValue < 17 {
            return true
        } else if dealerValue == 17 && hasAce(dealerHand) {
            return true // Soft 17
        }
        
        return false
    }
    
    private func calculateBlackjackValue(_ hand: [String]) -> Int {
        var value = 0
        var aces = 0
        
        for card in hand {
            if card.hasSuffix("A") {
                aces += 1
            } else if card.hasSuffix("K") || card.hasSuffix("Q") || card.hasSuffix("J") {
                value += 10
            } else {
                // Extraire la valeur numérique
                let cardValue = String(card.dropLast())
                value += Int(cardValue) ?? 0
            }
        }
        
        // Ajouter les as
        for _ in 0..<aces {
            if value + 11 <= 21 {
                value += 11
            } else {
                value += 1
            }
        }
        
        return value
    }
    
    private func hasAce(_ hand: [String]) -> Bool {
        return hand.contains { $0.hasSuffix("A") }
    }
    
    // MARK: - Poker Specific
    
    func dealPokerHand(from deck: inout [String]) -> [String] {
        return dealCards(count: 2, from: &deck)
    }
    
    func dealCommunityCards(count: Int, from deck: inout [String]) -> [String] {
        return dealCards(count: count, from: &deck)
    }
    
    // MARK: - Baccarat Specific
    
    func dealBaccaratHand(from deck: inout [String]) -> [String] {
        return dealCards(count: 2, from: &deck)
    }
    
    func shouldDrawThirdCard(playerHand: [String], bankerHand: [String], playerDrew: Bool) -> Bool {
        let playerValue = calculateBaccaratValue(playerHand)
        let bankerValue = calculateBaccaratValue(bankerHand)
        
        // Règles de tirage du baccarat
        if playerValue >= 8 || bankerValue >= 8 {
            return false // Natural
        }
        
        if !playerDrew {
            return playerValue <= 5
        }
        
        // Règles du banquier
        if bankerValue <= 2 {
            return true
        } else if bankerValue == 3 && !playerDrew {
            return true
        } else if bankerValue == 4 && playerDrew {
            let playerThirdCard = playerHand.last ?? ""
            let thirdCardValue = getBaccaratCardValue(playerThirdCard)
            return ![1, 8, 9, 10].contains(thirdCardValue)
        } else if bankerValue == 5 && playerDrew {
            let playerThirdCard = playerHand.last ?? ""
            let thirdCardValue = getBaccaratCardValue(playerThirdCard)
            return ![1, 2, 3, 8, 9, 10].contains(thirdCardValue)
        } else if bankerValue == 6 && playerDrew {
            let playerThirdCard = playerHand.last ?? ""
            let thirdCardValue = getBaccaratCardValue(playerThirdCard)
            return ![6, 7].contains(thirdCardValue)
        }
        
        return false
    }
    
    private func calculateBaccaratValue(_ hand: [String]) -> Int {
        var value = 0
        for card in hand {
            value += getBaccaratCardValue(card)
        }
        return value % 10
    }
    
    private func getBaccaratCardValue(_ card: String) -> Int {
        let cardValue = String(card.dropLast())
        if cardValue == "A" {
            return 1
        } else if ["K", "Q", "J"].contains(cardValue) {
            return 0
        } else {
            return Int(cardValue) ?? 0
        }
    }
    
    // MARK: - Game History
    
    func recordGameResult(_ result: GameResult) {
        gameHistory.append(result)
        
        // Limiter l'historique à 1000 parties
        if gameHistory.count > 1000 {
            gameHistory = Array(gameHistory.suffix(1000))
        }
        
        saveHistory()
    }
    
    func getGameHistory() -> [GameResult] {
        return gameHistory
    }
    
    func getGameHistory(for gameType: GameType) -> [GameResult] {
        return gameHistory.filter { $0.gameType == gameType }
    }
    
    func getWinRate(for gameType: GameType) -> Double {
        let games = getGameHistory(for: gameType)
        guard !games.isEmpty else { return 0 }
        
        let wins = games.filter { $0.result == .win }.count
        return Double(wins) / Double(games.count)
    }
    
    // MARK: - Persistance
    
    private func saveHistory() {
        if let data = try? JSONEncoder().encode(gameHistory) {
            userDefaults.set(data, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        if let data = userDefaults.data(forKey: historyKey),
           let history = try? JSONDecoder().decode([GameResult].self, from: data) {
            gameHistory = history
        }
    }
}

// MARK: - Supporting Types

struct GameResult: Codable {
    let id: String
    let gameType: GameType
    let result: GameResultType
    let betAmount: Int
    let winAmount: Int
    let timestamp: Date
    let seed: UInt64
    
    enum GameResultType: String, Codable {
        case win = "win"
        case loss = "loss"
        case tie = "tie"
    }
    
    init(gameType: GameType, result: GameResultType, betAmount: Int, winAmount: Int, seed: UInt64) {
        self.id = UUID().uuidString
        self.gameType = gameType
        self.result = result
        self.betAmount = betAmount
        self.winAmount = winAmount
        self.timestamp = Date()
        self.seed = seed
    }
}

// MARK: - Extensions

extension ClosedRange where Bound == Int {
    var count: Int {
        return upperBound - lowerBound + 1
    }
}
