import SwiftUI

struct HUDWalletView: View {
    @EnvironmentObject var walletStore: WalletStore
    @EnvironmentObject var authStore: AuthStore
    @State private var showingTransactions = false
    
    var body: some View {
        HStack {
            // Avatar et niveau
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.accent)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(authStore.currentUser?.username ?? "Joueur")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.text)
                    
                    Text("Niveau \(authStore.currentUser?.level ?? 1)")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            // Soldes avec animations
            VStack(alignment: .trailing, spacing: 5) {
                // Jetons
                HStack(spacing: 8) {
                    Text("₿")
                        .font(AppTypography.balanceSmall)
                        .foregroundColor(AppColors.gold)
                    
                    Text("\(walletStore.balance.chips.formatted())")
                        .font(AppTypography.balanceSmall)
                        .foregroundColor(AppColors.gold)
                        .animation(.easeInOut(duration: 0.3), value: walletStore.balance.chips)
                }
                
                // Gemmes
                HStack(spacing: 8) {
                    Text("💎")
                        .font(AppTypography.caption)
                    
                    Text("\(walletStore.balance.gems.formatted())")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.accent)
                        .animation(.easeInOut(duration: 0.3), value: walletStore.balance.gems)
                }
            }
            
            // Bouton historique
            Button(action: {
                showingTransactions = true
            }) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(AppColors.surface)
        .cornerRadius(16)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .overlay(
            // Animation de delta
            Group {
                if let delta = walletStore.lastDelta {
                    DeltaAnimationView(delta: delta)
                }
            }
        )
        .sheet(isPresented: $showingTransactions) {
            TransactionsView()
        }
    }
}

struct DeltaAnimationView: View {
    let delta: (currency: Currency, amount: Int)
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                
                HStack(spacing: 4) {
                    Text(delta.amount >= 0 ? "+" : "")
                        .font(AppTypography.balanceSmall)
                        .foregroundColor(delta.amount >= 0 ? AppColors.success : AppColors.error)
                    
                    Text(delta.currency.symbol)
                        .font(AppTypography.balanceSmall)
                        .foregroundColor(delta.amount >= 0 ? AppColors.success : AppColors.error)
                    
                    Text("\(abs(delta.amount).formatted())")
                        .font(AppTypography.balanceSmall)
                        .foregroundColor(delta.amount >= 0 ? AppColors.success : AppColors.error)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.surface.opacity(0.9))
                .cornerRadius(12)
                .offset(y: offset)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 2.0)) {
                        offset = -50
                        opacity = 0
                    }
                }
                
                Spacer()
            }
        }
        .padding(.trailing, 40)
    }
}

#Preview {
    HUDWalletView()
        .environmentObject(WalletStore.shared)
        .environmentObject(AuthStore.shared)
}
