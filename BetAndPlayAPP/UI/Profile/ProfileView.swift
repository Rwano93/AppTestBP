import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var walletStore: WalletStore
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // En-tête du profil
                        ProfileHeaderView()
                        
                        // Statistiques
                        StatisticsView()
                        
                        // Actions rapides
                        QuickActionsView()
                        
                        // Informations du compte
                        AccountInfoView()
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Retour") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct ProfileHeaderView: View {
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        VStack(spacing: 20) {
            // Avatar et informations de base
            VStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(AppColors.accent)
                
                VStack(spacing: 8) {
                    Text(authStore.currentUser?.username ?? "Joueur")
                        .font(AppTypography.title1)
                        .foregroundColor(AppColors.text)
                    
                    Text("Niveau \(authStore.currentUser?.level ?? 1)")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.gold)
                }
            }
            
            // Barre de progression XP
            VStack(spacing: 8) {
                HStack {
                    Text("XP")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Text("\(authStore.currentUser?.xp ?? 0) / \(getXPForNextLevel())")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                ProgressView(value: authStore.currentUser?.xpProgress ?? 0)
                    .progressViewStyle(LinearProgressViewStyle(tint: AppColors.accent))
                    .frame(height: 8)
                    .cornerRadius(4)
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 20)
    }
    
    private func getXPForNextLevel() -> Int {
        let currentLevel = authStore.currentUser?.level ?? 1
        return currentLevel * 1000
    }
}

struct StatisticsView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var walletStore: WalletStore
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Statistiques")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.text)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                ProfileStatCard(
                    title: "Jetons",
                    value: walletStore.balance.chips.formatted(),
                    icon: "coins.fill",
                    color: AppColors.gold
                )
                
                ProfileStatCard(
                    title: "Gemmes",
                    value: walletStore.balance.gems.formatted(),
                    icon: "diamond.fill",
                    color: AppColors.accent
                )
                
                ProfileStatCard(
                    title: "Parties Jouées",
                    value: "0",
                    icon: "gamecontroller.fill",
                    color: AppColors.primary
                )
                
                ProfileStatCard(
                    title: "Victoires",
                    value: "0",
                    icon: "trophy.fill",
                    color: AppColors.success
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

struct QuickActionsView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Actions Rapides")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.text)
            
            VStack(spacing: 12) {
                QuickActionButton(
                    title: "Récompense Quotidienne",
                    icon: "gift.fill",
                    color: AppColors.warning
                ) {
                    router.navigate(to: .daily)
                }
                
                QuickActionButton(
                    title: "Battle Pass",
                    icon: "star.fill",
                    color: AppColors.accent
                ) {
                    router.navigate(to: .pass)
                }
                
                QuickActionButton(
                    title: "Boutique",
                    icon: "cart.fill",
                    color: AppColors.primary
                ) {
                    router.navigate(to: .shop)
                }
                
                QuickActionButton(
                    title: "Amis",
                    icon: "person.2.fill",
                    color: AppColors.success
                ) {
                    router.navigate(to: .friends)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct QuickActionButton: View {
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
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(AppColors.card)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AccountInfoView: View {
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Informations du Compte")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.text)
            
            VStack(spacing: 12) {
                InfoRow(title: "ID Utilisateur", value: authStore.currentUser?.id ?? "N/A")
                InfoRow(title: "Email", value: authStore.currentUser?.email ?? "N/A")
                InfoRow(title: "Code de Parrainage", value: authStore.currentUser?.referralCode ?? "N/A")
                InfoRow(title: "Parrainé par", value: authStore.currentUser?.referredBy ?? "Aucun")
            }
            .padding(.horizontal, 20)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppTypography.body)
                .foregroundColor(AppColors.text)
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.card)
        .cornerRadius(8)
    }
}

struct ProfileStatCard: View {
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
            
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppColors.surface)
        .cornerRadius(12)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthStore.shared)
        .environmentObject(WalletStore.shared)
        .environmentObject(Router())
}
