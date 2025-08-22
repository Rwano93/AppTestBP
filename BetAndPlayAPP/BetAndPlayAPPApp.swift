//
//  BetAndPlayAPPApp.swift
//  BetAndPlayAPP
//
//  Created by Erwan gueganic on 22/08/2025.
//

import SwiftUI

@main
struct CasinoXApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var router = Router()
    @StateObject private var walletStore = WalletStore.shared
    @StateObject private var authStore = AuthStore.shared
    @StateObject private var dailyRewardService = DailyRewardService.shared
    @StateObject private var battlePassService = BattlePassService.shared
    @StateObject private var friendsService = FriendsService.shared
    @StateObject private var storeKitService = StoreKitService.shared
    @StateObject private var backendAdapter = LocalMockAdapter()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(router)
                .environmentObject(walletStore)
                .environmentObject(authStore)
                .environmentObject(dailyRewardService)
                .environmentObject(battlePassService)
                .environmentObject(friendsService)
                .environmentObject(storeKitService)
                .environmentObject(backendAdapter)
                .preferredColorScheme(.dark)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // Configuration initiale
        walletStore.initializeWallet()
        battlePassService.checkBattlePass()
    }
}

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    @Published var isMuted: Bool = false
    
    // Couleurs du thème
    static let primary = Color(hex: "0E5A9C")
    static let accent = Color(hex: "21B1FF")
    static let tableGreen = Color(hex: "0F6A5B")
    static let tableBlue = Color(hex: "0B5589")
    static let woodDark = Color(hex: "4C2E1A")
    static let gold = Color(hex: "D7B55A")
    static let chipRed = Color(hex: "CF3030")
    static let chipBlue = Color(hex: "3E78FF")
    static let chipGreen = Color(hex: "129644")
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
