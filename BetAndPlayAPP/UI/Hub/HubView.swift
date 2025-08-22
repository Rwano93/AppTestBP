import SwiftUI

struct HubView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var walletStore: WalletStore
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var dailyRewardService: DailyRewardService
    @State private var showingDailyReward = false
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // HUD Wallet
                HUDWalletView()
                
                // Contenu principal
                ScrollView {
                    VStack(spacing: 30) {
                        // Bannière de récompense quotidienne
                        if dailyRewardService.canClaimToday {
                            DailyRewardBanner {
                                showingDailyReward = true
                            }
                        }
                        
                        // Carousel des jeux
                        GameCarouselView()
                        
                        // Boutons d'action
                        ActionButtonsView()
                        
                        // Statistiques rapides
                        QuickStatsView()
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .sheet(isPresented: $showingDailyReward) {
            DailyRewardView()
        }
    }
}

struct DailyRewardBanner: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "gift.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.gold)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Récompense Quotidienne")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.text)
                    
                    Text("Cliquez pour réclamer vos jetons !")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                LinearGradient(
                    colors: [AppColors.primary.opacity(0.8), AppColors.accent.opacity(0.6)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
    }
}

struct GameCarouselView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Jeux Disponibles")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.text)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(GameType.allCases, id: \.self) { game in
                        GameCard(game: game) {
                            router.navigateToGame(game)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct GameCard: View {
    let game: GameType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Icône du jeu
                ZStack {
                    Circle()
                        .fill(Color(hex: game.color).opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: game.icon)
                        .font(.system(size: 36))
                        .foregroundColor(Color(hex: game.color))
                }
                
                // Nom du jeu
                Text(game.displayName)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.text)
                
                // Description
                Text(getGameDescription(game))
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 140, height: 160)
            .background(AppColors.card)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getGameDescription(_ game: GameType) -> String {
        switch game {
        case .blackjack:
            return "Beat the dealer to 21"
        case .roulette:
            return "Place your bets"
        case .baccarat:
            return "Punto or Banco"
        case .poker:
            return "Texas Hold'em"
        }
    }
}

struct ActionButtonsView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 15) {
            ActionButton(title: "Jouer", icon: "play.fill", color: AppColors.success) {
                // Action jouer
            }
            
            ActionButton(title: "Salons", icon: "person.3.fill", color: AppColors.primary) {
                // Action salons
            }
            
            ActionButton(title: "Boutique", icon: "cart.fill", color: AppColors.accent) {
                router.navigate(to: .shop)
            }
            
            ActionButton(title: "Battle Pass", icon: "star.fill", color: AppColors.warning) {
                router.navigate(to: .pass)
            }
            
            ActionButton(title: "Amis", icon: "person.2.fill", color: AppColors.primary) {
                router.navigate(to: .friends)
            }
            
            ActionButton(title: "Profil", icon: "person.circle.fill", color: AppColors.accent) {
                router.navigate(to: .profile)
            }
        }
        .padding(.horizontal, 40)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppTypography.button)
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(AppColors.card)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickStatsView: View {
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Statistiques Rapides")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.text)
            
            HStack(spacing: 20) {
                HubStatCard(
                    title: "Niveau",
                    value: "\(authStore.currentUser?.level ?? 1)",
                    icon: "star.fill",
                    color: AppColors.gold
                )
                
                HubStatCard(
                    title: "XP",
                    value: "\(authStore.currentUser?.xp ?? 0)",
                    icon: "bolt.fill",
                    color: AppColors.accent
                )
                
                HubStatCard(
                    title: "Parties",
                    value: "0",
                    icon: "gamecontroller.fill",
                    color: AppColors.primary
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

struct HubStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(AppTypography.balanceSmall)
                .foregroundColor(AppColors.text)
                .fontWeight(.semibold)
            
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(AppColors.card)
        .cornerRadius(12)
    }
}

#Preview {
    HubView()
        .environmentObject(Router())
        .environmentObject(WalletStore.shared)
        .environmentObject(AuthStore.shared)
        .environmentObject(DailyRewardService.shared)
}
