import SwiftUI

// MARK: - Vues Placeholder pour les autres écrans

struct FriendsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.accent)
                    
                    Text("Amis")
                        .font(AppTypography.title1)
                        .foregroundColor(AppColors.text)
                    
                    Text("Fonctionnalité en cours de développement")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Amis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
        }
    }
}

struct BattlePassView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.warning)
                    
                    Text("Battle Pass")
                        .font(AppTypography.title1)
                        .foregroundColor(AppColors.text)
                    
                    Text("Fonctionnalité en cours de développement")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Battle Pass")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
        }
    }
}

struct BlackjackView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "suit.club.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.tableGreen)
                    
                    Text("Blackjack")
                        .font(AppTypography.title1)
                        .foregroundColor(AppColors.text)
                    
                    Text("Jeu en cours de développement")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Blackjack")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
        }
    }
}

struct RouletteView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "circle.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.chipRed)
                    
                    Text("Roulette")
                        .font(AppTypography.title1)
                        .foregroundColor(AppColors.text)
                    
                    Text("Jeu en cours de développement")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Roulette")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
        }
    }
}

struct BaccaratView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.tableBlue)
                    
                    Text("Baccarat")
                        .font(AppTypography.title1)
                        .foregroundColor(AppColors.text)
                    
                    Text("Jeu en cours de développement")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Baccarat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
        }
    }
}

struct PokerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "suit.spade.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.woodDark)
                    
                    Text("Poker")
                        .font(AppTypography.title1)
                        .foregroundColor(AppColors.text)
                    
                    Text("Jeu en cours de développement")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Poker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
        }
    }
}

struct GameTableView: View {
    let game: GameType
    let buyIn: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: game.icon)
                        .font(.system(size: 80))
                        .foregroundColor(Color(hex: game.color))
                    
                    Text("Table \(game.displayName)")
                        .font(AppTypography.title1)
                        .foregroundColor(AppColors.text)
                    
                    Text("Buy-in: \(buyIn.formatted()) jetons")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.gold)
                    
                    Text("Table en cours de développement")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Table \(game.displayName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
        }
    }
}

struct ReferralCodeView: View {
    let referralCode: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.warning)
                    
                    Text("Code de Parrainage")
                        .font(AppTypography.title1)
                        .foregroundColor(AppColors.text)
                    
                    Text("Code: \(referralCode)")
                        .font(AppTypography.balance)
                        .foregroundColor(AppColors.accent)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(AppColors.card)
                        .cornerRadius(12)
                    
                    Text("Fonctionnalité en cours de développement")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Parrainage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
        }
    }
}
