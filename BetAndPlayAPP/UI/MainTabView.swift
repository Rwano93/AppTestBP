import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var walletStore: WalletStore
    @State private var selectedTab: TabItem = .hub
    
    var body: some View {
        ZStack {
            // Arrière-plan principal
            LinearGradient(
                colors: [AppColors.background, AppColors.primary.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header avec wallet et notifications
                TopBarView()
                
                // Contenu principal
                TabView(selection: $selectedTab) {
                    // Hub / Accueil
                    ModernHubView()
                        .tag(TabItem.hub)
                    
                    // Amis
                    ModernFriendsView()
                        .tag(TabItem.friends)
                    
                    // Boutique
                    ModernShopView()
                        .tag(TabItem.shop)
                    
                    // Profil
                    ModernProfileView()
                        .tag(TabItem.profile)
                    
                    // Paramètres
                    ModernSettingsView()
                        .tag(TabItem.settings)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Barre de navigation personnalisée
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

enum TabItem: String, CaseIterable {
    case hub = "Hub"
    case friends = "Amis"
    case shop = "Boutique"
    case profile = "Profil"
    case settings = "Paramètres"
    
    var icon: String {
        switch self {
        case .hub: return "house.fill"
        case .friends: return "person.2.fill"
        case .shop: return "bag.fill"
        case .profile: return "person.crop.circle.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var activeIcon: String {
        switch self {
        case .hub: return "house.fill"
        case .friends: return "person.2.fill"
        case .shop: return "bag.fill"
        case .profile: return "person.crop.circle.badge.checkmark"
        case .settings: return "gearshape.2.fill"
        }
    }
}

struct TopBarView: View {
    @EnvironmentObject var walletStore: WalletStore
    @EnvironmentObject var authStore: AuthStore
    @State private var showingNotifications = false
    
    var body: some View {
        HStack {
            // Avatar utilisateur
            if let user = authStore.currentUser {
                HStack(spacing: 8) {
                    Image(systemName: AppAvatars.getAvatar(by: user.avatarId)?.iconName ?? "person.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(AppAvatars.getAvatar(by: user.avatarId)?.color ?? AppColors.accent)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(user.username)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.text)
                        
                        Text("Niveau \(user.level)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            // Wallet display
            HStack(spacing: 12) {
                // Jetons
                HStack(spacing: 4) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.gold)
                    
                    Text(formatCurrency(walletStore.balance.chips))
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppColors.text)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.surface)
                .cornerRadius(20)
                
                // Gemmes
                HStack(spacing: 4) {
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.accent)
                    
                    Text("\(walletStore.balance.gems)")
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppColors.text)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.surface)
                .cornerRadius(20)
            }
            
            // Notifications
            Button(action: { showingNotifications.toggle() }) {
                ZStack {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.textSecondary)
                    
                    // Badge de notification
                    Circle()
                        .fill(AppColors.error)
                        .frame(width: 8, height: 8)
                        .offset(x: 8, y: -8)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(AppColors.surface.opacity(0.9))
    }
    
    private func formatCurrency(_ amount: Int) -> String {
        if amount >= 1_000_000 {
            return String(format: "%.1fM", Double(amount) / 1_000_000)
        } else if amount >= 1_000 {
            return String(format: "%.1fK", Double(amount) / 1_000)
        } else {
            return "\(amount)"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Namespace private var tabIndicator
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    namespace: tabIndicator
                ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.surface.opacity(0.95))
                .shadow(color: AppColors.background.opacity(0.3), radius: 20, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarItem: View {
    let tab: TabItem
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.accent.opacity(0.2))
                            .frame(width: 50, height: 32)
                            .matchedGeometryEffect(id: "tab_indicator", in: namespace)
                    }
                    
                    Image(systemName: isSelected ? tab.activeIcon : tab.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSelected ? AppColors.accent : AppColors.textSecondary)
                }
                
                Text(tab.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accent : AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthStore.shared)
        .environmentObject(WalletStore.shared)
}
