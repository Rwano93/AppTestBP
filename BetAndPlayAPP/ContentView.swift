//
//  ContentView.swift
//  BetAndPlayAPP
//
//  Created by Erwan gueganic on 22/08/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        Group {
            switch router.currentRoute {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .auth:
                if authStore.isAuthenticated {
                    MainTabView()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                } else {
                    LoginView()
                        .transition(.move(edge: .leading).combined(with: .opacity))
                }
            case .hub:
                MainTabView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            default:
                // Toutes les autres routes sont maintenant gérées par MainTabView
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: router.currentRoute)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Import des vues séparées
// Les vues sont maintenant dans leurs propres fichiers pour une meilleure organisation

// MARK: - Les vues complètes sont maintenant dans leurs propres fichiers

#Preview {
    ContentView()
        .environmentObject(Router())
        .environmentObject(AuthStore.shared)
        .environmentObject(WalletStore.shared)
}
