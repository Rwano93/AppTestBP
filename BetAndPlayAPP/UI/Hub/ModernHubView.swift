import SwiftUI

struct ModernHubView: View {
    @EnvironmentObject var walletStore: WalletStore
    @EnvironmentObject var authStore: AuthStore
    @State private var showingGameSelection = false
    @State private var selectedGameType: GameType = .blackjack
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Section jeux principaux
                GamesSectionView(showingGameSelection: $showingGameSelection, selectedGameType: $selectedGameType)
                
                // Section tournois et événements
                TournamentsSectionView()
                
                // Section récompenses quotidiennes
                DailyRewardsSectionView()
                
                // Section statistiques rapides
                QuickStatsSection()
                
                Spacer(minLength: 100) // Pour la tab bar
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .fullScreenCover(isPresented: $showingGameSelection) {
            GameSelectionView(gameType: $selectedGameType, isPresented: $showingGameSelection)
        }
    }
}

struct GamesSectionView: View {
    @Binding var showingGameSelection: Bool
    @Binding var selectedGameType: GameType
    
    let games = [
        GameCardData(type: .blackjack, title: "BLACKJACK", subtitle: "Table classique", minBet: "100", maxBet: "50K", players: 156),
        GameCardData(type: .roulette, title: "ROULETTE", subtitle: "Européenne", minBet: "50", maxBet: "25K", players: 234),
        GameCardData(type: .poker, title: "TEXAS POKER", subtitle: "Hold'em", minBet: "200", maxBet: "100K", players: 89),
        GameCardData(type: .baccarat, title: "BACCARAT", subtitle: "Punto Banco", minBet: "500", maxBet: "200K", players: 67)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tables de Jeu")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Button("Voir tout") {
                    // Action pour voir tous les jeux
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.accent)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(games, id: \.type) { game in
                    ModernGameCard(game: game) {
                        selectedGameType = game.type
                        showingGameSelection = true
                    }
                }
            }
        }
    }
}

struct ModernGameCard: View {
    let game: GameCardData
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Icône du jeu
                ZStack {
                    Circle()
                        .fill(gameColor.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: gameIcon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(gameColor)
                }
                
                VStack(spacing: 4) {
                    Text(game.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Text(game.subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                // Informations de mise
                VStack(spacing: 2) {
                    HStack {
                        Text("Min:")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 8))
                                .foregroundColor(AppColors.gold)
                            
                            Text(game.minBet)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(AppColors.text)
                        }
                    }
                    
                    HStack {
                        Text("Max:")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 8))
                                .foregroundColor(AppColors.gold)
                            
                            Text(game.maxBet)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(AppColors.text)
                        }
                    }
                }
                
                // Nombre de joueurs
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.success)
                    
                    Text("\(game.players) joueurs")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppColors.success)
                }
            }
            .padding(16)
            .background(AppColors.surface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(gameColor.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var gameColor: Color {
        switch game.type {
        case .blackjack: return AppColors.cardBlack
        case .roulette: return AppColors.chipRed
        case .poker: return AppColors.chipBlue
        case .baccarat: return AppColors.gold
        }
    }
    
    private var gameIcon: String {
        switch game.type {
        case .blackjack: return "suit.spade.fill"
        case .roulette: return "circle.grid.cross.fill"
        case .poker: return "suit.heart.fill"
        case .baccarat: return "crown.fill"
        }
    }
}

struct TournamentsSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tournois en Cours")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Button("Voir tout") {
                    // Action pour voir tous les tournois
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.accent)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    TournamentCard(
                        title: "Tournoi À Étoiles",
                        prize: "1K",
                        timeLeft: "2:42:07",
                        participants: 89
                    )
                    
                    TournamentCard(
                        title: "Sunday Million",
                        prize: "500K",
                        timeLeft: "5:15:30",
                        participants: 1247
                    )
                    
                    TournamentCard(
                        title: "Freeroll Daily",
                        prize: "100",
                        timeLeft: "1:08:45",
                        participants: 345
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }
}

struct TournamentCard: View {
    let title: String
    let prize: String
    let timeLeft: String
    let participants: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.gold)
                
                Spacer()
                
                Text("🏆")
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                HStack(spacing: 4) {
                    Text("Gagnez")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack(spacing: 2) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(AppColors.gold)
                        
                        Text(prize)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppColors.gold)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.warning)
                    
                    Text(timeLeft)
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppColors.warning)
                }
                
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.accent)
                    
                    Text("\(participants) joueurs")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Button("Rejoindre") {
                // Action pour rejoindre le tournoi
            }
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(AppColors.accent)
            .cornerRadius(8)
        }
        .padding(16)
        .frame(width: 180)
        .background(AppColors.surface)
        .cornerRadius(16)
    }
}

struct DailyRewardsSectionView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Récompenses Quotidiennes")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Button("Voir tout") {
                    // Navigation vers la vue complète
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.accent)
            }
            
            HStack(spacing: 12) {
                // Carte de récompense quotidienne
                DailyRewardCard()
                
                // Carte Lucky Combo
                LuckyComboCard()
            }
        }
    }
}

struct DailyRewardCard: View {
    @EnvironmentObject var dailyRewardService: DailyRewardService
    @EnvironmentObject var router: Router
    
    var body: some View {
        Button(action: {
            router.navigate(to: .daily)
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: dailyRewardService.canClaimToday ? "gift.fill" : "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(dailyRewardService.canClaimToday ? AppColors.gold : AppColors.success)
                    
                    Spacer()
                    
                    Text(dailyRewardService.canClaimToday ? "DISPONIBLE" : "RÉCUPÉRÉ")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(dailyRewardService.canClaimToday ? AppColors.success : AppColors.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(dailyRewardService.canClaimToday ? AppColors.success.opacity(0.2) : AppColors.textSecondary.opacity(0.1))
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Récompense Quotidienne")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.text)
                    
                    Text("\(dailyRewardService.todayReward.formatted()) + bonus série")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.gold)
                }
                
                Spacer()
                
                Button(action: {
                    if dailyRewardService.canClaimToday {
                        dailyRewardService.claimDailyReward()
                    }
                }) {
                    HStack {
                        Image(systemName: dailyRewardService.canClaimToday ? "gift.fill" : "checkmark.fill")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text(dailyRewardService.canClaimToday ? "Récupérer" : "Récupéré")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(dailyRewardService.canClaimToday ? AppColors.success : AppColors.textSecondary)
                    )
                }
                .disabled(!dailyRewardService.canClaimToday)
            }
            .padding(16)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.surface)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LuckyComboCard: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.accent)
                
                Spacer()
                
                Text("ACTIF")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(AppColors.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.accent.opacity(0.2))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Lucky Combo")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Text("Multiplicateur x2.5")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            // Barre de progression
            VStack(spacing: 4) {
                HStack {
                    Text("Progress")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Text("7/10 victoires")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(AppColors.accent)
                }
                
                ProgressView(value: 0.7)
                    .progressViewStyle(LinearProgressViewStyle(tint: AppColors.accent))
            }
        }
        .padding(16)
        .background(AppColors.surface)
        .cornerRadius(16)
    }
}

struct QuickStatsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistiques Rapides")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(AppColors.text)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ModernStatCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Gain Total",
                    value: "125.5K",
                    subtitle: "+12% cette semaine",
                    color: AppColors.success
                )
                
                ModernStatCard(
                    icon: "gamecontroller.fill",
                    title: "Parties Jouées",
                    value: "847",
                    subtitle: "Ce mois-ci",
                    color: AppColors.accent
                )
                
                ModernStatCard(
                    icon: "crown.fill",
                    title: "Victoires",
                    value: "623",
                    subtitle: "73% de réussite",
                    color: AppColors.gold
                )
                
                ModernStatCard(
                    icon: "calendar",
                    title: "Série Actuelle",
                    value: "12",
                    subtitle: "Jours consécutifs",
                    color: AppColors.chipRed
                )
            }
        }
    }
}

struct ModernStatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(subtitle)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(color)
            }
        }
        .padding(16)
        .background(AppColors.surface)
        .cornerRadius(16)
    }
}

struct GameCardData {
    let type: GameType
    let title: String
    let subtitle: String
    let minBet: String
    let maxBet: String
    let players: Int
}

#Preview {
    ModernHubView()
        .environmentObject(WalletStore.shared)
        .environmentObject(AuthStore.shared)
        .background(AppColors.background)
}
