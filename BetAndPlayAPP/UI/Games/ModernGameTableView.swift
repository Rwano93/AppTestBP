import SwiftUI

struct ModernGameTableView: View {
    let gameType: GameType
    let buyIn: Int
    @Binding var isPresented: Bool
    @State private var showingExitAlert = false
    
    var body: some View {
        ZStack {
            // Arrière-plan du jeu
            LinearGradient(
                colors: [gameBackgroundColor, AppColors.background],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header de la table
                GameTableHeader(
                    gameType: gameType,
                    buyIn: buyIn,
                    showingExitAlert: $showingExitAlert
                )
                
                Spacer()
                
                // Zone de jeu principale
                GamePlayArea(gameType: gameType)
                
                Spacer()
                
                // Contrôles de jeu
                GameControlsArea(gameType: gameType)
            }
        }
        .preferredColorScheme(.dark)
        .alert("Quitter la table", isPresented: $showingExitAlert) {
            Button("Rester", role: .cancel) { }
            Button("Quitter", role: .destructive) {
                isPresented = false
            }
        } message: {
            Text("Êtes-vous sûr de vouloir quitter la table ? Vos jetons seront conservés.")
        }
    }
    
    private var gameBackgroundColor: Color {
        switch gameType {
        case .blackjack: return Color(red: 0.0, green: 0.3, blue: 0.0)
        case .roulette: return Color(red: 0.3, green: 0.0, blue: 0.0)
        case .poker: return Color(red: 0.0, green: 0.0, blue: 0.3)
        case .baccarat: return Color(red: 0.3, green: 0.2, blue: 0.0)
        }
    }
}

struct GameTableHeader: View {
    let gameType: GameType
    let buyIn: Int
    @Binding var showingExitAlert: Bool
    @EnvironmentObject var walletStore: WalletStore
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Bouton retour
                Button(action: { showingExitAlert = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text("Fermer")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(AppColors.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.surface.opacity(0.8))
                    .cornerRadius(20)
                }
                
                Spacer()
                
                // Titre du jeu
                Text(gameTitle)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                // Menu
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.text)
                        .frame(width: 32, height: 32)
                        .background(AppColors.surface.opacity(0.8))
                        .cornerRadius(8)
                }
            }
            
            // Informations de la table
            HStack {
                // Buy-in
                HStack(spacing: 6) {
                    Text("Buy-in:")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(AppColors.gold)
                        
                        Text("\(buyIn)")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(AppColors.text)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.surface.opacity(0.8))
                .cornerRadius(12)
                
                Spacer()
                
                // Solde actuel
                HStack(spacing: 6) {
                    Text("Solde:")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(AppColors.gold)
                        
                        Text(formatNumber(walletStore.balance.chips))
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(AppColors.text)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.surface.opacity(0.8))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private var gameTitle: String {
        switch gameType {
        case .blackjack: return "Table Blackjack"
        case .roulette: return "Table Roulette"
        case .poker: return "Table Poker"
        case .baccarat: return "Table Baccarat"
        }
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1_000_000 {
            return String(format: "%.1fM", Double(number) / 1_000_000)
        } else if number >= 1_000 {
            return String(format: "%.1fK", Double(number) / 1_000)
        } else {
            return "\(number)"
        }
    }
}

struct GamePlayArea: View {
    let gameType: GameType
    
    var body: some View {
        VStack(spacing: 40) {
            // Icône du jeu
            ZStack {
                Circle()
                    .fill(gameColor.opacity(0.2))
                    .frame(width: 150, height: 150)
                
                Image(systemName: gameIcon)
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(gameColor)
            }
            
            VStack(spacing: 16) {
                Text(gameTitle)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Text("Table en cours de développement")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                
                Text(gameDescription)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
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
        case .poker: return "POKER"
        case .baccarat: return "BACCARAT"
        }
    }
    
    private var gameDescription: String {
        switch gameType {
        case .blackjack:
            return "La table de Blackjack sera bientôt disponible avec des graphismes 3D immersifs et un gameplay authentique."
        case .roulette:
            return "Vivez l'excitation de la roulette avec une roue réaliste et des animations fluides."
        case .poker:
            return "Affrontez d'autres joueurs dans des parties de Texas Hold'em palpitantes."
        case .baccarat:
            return "Découvrez l'élégance du Baccarat dans un environnement luxueux."
        }
    }
}

struct GameControlsArea: View {
    let gameType: GameType
    
    var body: some View {
        VStack(spacing: 16) {
            // Boutons d'action simulés
            HStack(spacing: 16) {
                GameActionButton(
                    title: getActionTitle(0),
                    icon: getActionIcon(0),
                    color: AppColors.success,
                    isEnabled: false
                )
                
                GameActionButton(
                    title: getActionTitle(1),
                    icon: getActionIcon(1),
                    color: AppColors.warning,
                    isEnabled: false
                )
                
                GameActionButton(
                    title: getActionTitle(2),
                    icon: getActionIcon(2),
                    color: AppColors.error,
                    isEnabled: false
                )
            }
            
            // Informations de développement
            VStack(spacing: 8) {
                Text("🚧 En développement 🚧")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.warning)
                
                Text("Cette fonctionnalité sera disponible dans une prochaine mise à jour")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(AppColors.warning.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
    
    private func getActionTitle(_ index: Int) -> String {
        switch gameType {
        case .blackjack:
            return ["Tirer", "Rester", "Doubler"][index]
        case .roulette:
            return ["Miser", "Tourner", "Effacer"][index]
        case .poker:
            return ["Suivre", "Relancer", "Coucher"][index]
        case .baccarat:
            return ["Banco", "Punto", "Égalité"][index]
        }
    }
    
    private func getActionIcon(_ index: Int) -> String {
        switch gameType {
        case .blackjack:
            return ["plus.circle.fill", "hand.raised.fill", "arrow.up.circle.fill"][index]
        case .roulette:
            return ["circle.fill", "arrow.clockwise.circle.fill", "xmark.circle.fill"][index]
        case .poker:
            return ["checkmark.circle.fill", "arrow.up.circle.fill", "xmark.circle.fill"][index]
        case .baccarat:
            return ["b.circle.fill", "p.circle.fill", "equal.circle.fill"][index]
        }
    }
}

struct GameActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let isEnabled: Bool
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(isEnabled ? .white : color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isEnabled ? color : color.opacity(0.2))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    ModernGameTableView(
        gameType: .blackjack,
        buyIn: 1000,
        isPresented: .constant(true)
    )
    .environmentObject(WalletStore.shared)
}
