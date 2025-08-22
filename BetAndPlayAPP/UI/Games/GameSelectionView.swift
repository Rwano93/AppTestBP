import SwiftUI

struct GameSelectionView: View {
    @Binding var gameType: GameType
    @Binding var isPresented: Bool
    @State private var selectedBuyIn: Int = 1000
    @State private var showingGameTable = false
    
    let buyInOptions = [100, 500, 1000, 5000, 10000, 25000, 50000]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Arrière-plan avec dégradé
                LinearGradient(
                    colors: [AppColors.background, gameColor.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    GameSelectionHeader(gameType: gameType, isPresented: $isPresented)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Image du jeu et description
                            GameHeroSection(gameType: gameType)
                            
                            // Sélection de buy-in
                            BuyInSelectionSection(
                                selectedBuyIn: $selectedBuyIn,
                                buyInOptions: buyInOptions,
                                gameColor: gameColor
                            )
                            
                            // Statistiques des tables
                            TableStatsSection(gameType: gameType)
                            
                            // Règles rapides
                            QuickRulesSection(gameType: gameType)
                            
                            Spacer(minLength: 120)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    
                    // Bouton de jeu en bas
                    PlayButtonSection(
                        gameType: gameType,
                        selectedBuyIn: selectedBuyIn,
                        gameColor: gameColor,
                        showingGameTable: $showingGameTable
                    )
                }
            }
        }
        .fullScreenCover(isPresented: $showingGameTable) {
            ModernGameTableView(gameType: gameType, buyIn: selectedBuyIn, isPresented: $showingGameTable)
        }
    }
    
    private var gameColor: Color {
        switch gameType {
        case .blackjack: return AppColors.cardBlack
        case .roulette: return AppColors.chipRed
        case .poker: return AppColors.chipBlue
        case .baccarat: return AppColors.gold
        }
    }
}

struct GameSelectionHeader: View {
    let gameType: GameType
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Text(gameTitle)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.text)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.accent)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(AppColors.surface.opacity(0.9))
    }
    
    private var gameTitle: String {
        switch gameType {
        case .blackjack: return "BLACKJACK"
        case .roulette: return "ROULETTE"
        case .poker: return "TEXAS POKER"
        case .baccarat: return "BACCARAT"
        }
    }
}

struct GameHeroSection: View {
    let gameType: GameType
    
    var body: some View {
        VStack(spacing: 16) {
            // Grande icône du jeu
            ZStack {
                Circle()
                    .fill(gameColor.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: gameIcon)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(gameColor)
            }
            
            VStack(spacing: 8) {
                Text(gameTitle)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Text(gameSubtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var gameColor: Color {
        switch gameType {
        case .blackjack: return AppColors.cardBlack
        case .roulette: return AppColors.chipRed
        case .poker: return AppColors.chipBlue
        case .baccarat: return AppColors.gold
        }
    }
    
    private var gameIcon: String {
        switch gameType {
        case .blackjack: return "suit.spade.fill"
        case .roulette: return "circle.grid.cross.fill"
        case .poker: return "suit.heart.fill"
        case .baccarat: return "crown.fill"
        }
    }
    
    private var gameTitle: String {
        switch gameType {
        case .blackjack: return "BLACKJACK"
        case .roulette: return "ROULETTE"
        case .poker: return "TEXAS HOLD'EM"
        case .baccarat: return "BACCARAT"
        }
    }
    
    private var gameSubtitle: String {
        switch gameType {
        case .blackjack: return "Approchez-vous de 21 sans dépasser.\nBattez le croupier pour gagner."
        case .roulette: return "Misez sur les numéros, couleurs ou sections.\nLa roue décidera de votre sort."
        case .poker: return "Formez la meilleure main possible.\nBluffez et remportez le pot."
        case .baccarat: return "Banco, Punto ou Égalité.\nJeu de cartes classique et élégant."
        }
    }
}

struct BuyInSelectionSection: View {
    @Binding var selectedBuyIn: Int
    let buyInOptions: [Int]
    let gameColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choisissez votre cave")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.text)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(buyInOptions, id: \.self) { amount in
                    BuyInOptionCard(
                        amount: amount,
                        isSelected: selectedBuyIn == amount,
                        gameColor: gameColor
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedBuyIn = amount
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct BuyInOptionCard: View {
    let amount: Int
    let isSelected: Bool
    let gameColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.gold)
                    
                    Text(formatAmount(amount))
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(isSelected ? .white : AppColors.text)
                }
                
                if isSelected {
                    Text("SÉLECTIONNÉ")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? gameColor : AppColors.surface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? gameColor : AppColors.textSecondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatAmount(_ amount: Int) -> String {
        if amount >= 1000 {
            return "\(amount / 1000)K"
        } else {
            return "\(amount)"
        }
    }
}

struct TableStatsSection: View {
    let gameType: GameType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistiques des Tables")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.text)
            
            HStack(spacing: 16) {
                StatItem(
                    icon: "person.2.fill",
                    title: "Joueurs Actifs",
                    value: "\(activePlayersCount)",
                    color: AppColors.success
                )
                
                StatItem(
                    icon: "table.furniture.fill",
                    title: "Tables Ouvertes",
                    value: "\(openTablesCount)",
                    color: AppColors.accent
                )
                
                StatItem(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Gain Moyen",
                    value: averageWin,
                    color: AppColors.gold
                )
            }
        }
    }
    
    private var activePlayersCount: Int {
        switch gameType {
        case .blackjack: return 156
        case .roulette: return 234
        case .poker: return 89
        case .baccarat: return 67
        }
    }
    
    private var openTablesCount: Int {
        switch gameType {
        case .blackjack: return 12
        case .roulette: return 8
        case .poker: return 15
        case .baccarat: return 6
        }
    }
    
    private var averageWin: String {
        switch gameType {
        case .blackjack: return "2.5K"
        case .roulette: return "3.8K"
        case .poker: return "12.1K"
        case .baccarat: return "25.7K"
        }
    }
}

struct StatItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppColors.text)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.surface)
        .cornerRadius(12)
    }
}

struct QuickRulesSection: View {
    let gameType: GameType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Règles Rapides")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.text)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(gameRules, id: \.self) { rule in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.success)
                        
                        Text(rule)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(AppColors.surface)
            .cornerRadius(12)
        }
    }
    
    private var gameRules: [String] {
        switch gameType {
        case .blackjack:
            return [
                "L'objectif est d'obtenir 21 ou de s'en approcher",
                "Les cartes valent leur valeur nominale",
                "L'As vaut 1 ou 11 selon la main",
                "Si vous dépassez 21, vous perdez automatiquement"
            ]
        case .roulette:
            return [
                "Misez sur un numéro, une couleur ou une section",
                "La bille détermine le numéro gagnant",
                "Rouge/Noir et Pair/Impair paient 1:1",
                "Un numéro plein paie 35:1"
            ]
        case .poker:
            return [
                "Formez la meilleure main de 5 cartes",
                "Vous pouvez miser, suivre ou vous coucher",
                "Quinte flush royale est la meilleure main",
                "Bluffez pour gagner même avec une main faible"
            ]
        case .baccarat:
            return [
                "Misez sur Banco, Punto ou Égalité",
                "La main la plus proche de 9 gagne",
                "Les cartes 10, J, Q, K valent 0",
                "L'As vaut 1 point"
            ]
        }
    }
}

struct PlayButtonSection: View {
    let gameType: GameType
    let selectedBuyIn: Int
    let gameColor: Color
    @Binding var showingGameTable: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: { showingGameTable = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("JOUER MAINTENANT")
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 4) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(AppColors.gold)
                            
                            Text("\(selectedBuyIn)")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                        }
                        
                        Text("Buy-in")
                            .font(.system(size: 10, weight: .medium))
                            .opacity(0.8)
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(gameColor)
                .cornerRadius(16)
                .shadow(color: gameColor.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Text("Table en cours de développement")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .opacity(0.7)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(AppColors.background.opacity(0.9))
    }
}

#Preview {
    GameSelectionView(
        gameType: .constant(.blackjack),
        isPresented: .constant(true)
    )
}
