import SwiftUI

struct ModernProfileView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var walletStore: WalletStore
    @State private var selectedTab: ProfileTab = .infos
    @State private var showingAvatarSelection = false
    @State private var showingEditProfile = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header avec avatar et infos principales
            ModernProfileHeaderView(
                showingAvatarSelection: $showingAvatarSelection,
                showingEditProfile: $showingEditProfile
            )
            
            // Onglets
            ProfileTabSelector(selectedTab: $selectedTab)
            
            // Contenu selon l'onglet sélectionné
            TabView(selection: $selectedTab) {
                ProfileInfosView()
                    .tag(ProfileTab.infos)
                
                ProfileSuccessView()
                    .tag(ProfileTab.success)
                
                ProfilePropertiesView()
                    .tag(ProfileTab.properties)
                
                ProfileCollectionsView()
                    .tag(ProfileTab.collections)
                
                ProfileTrophiesView()
                    .tag(ProfileTab.trophies)
                
                ProfileVIPView()
                    .tag(ProfileTab.vip)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(AppColors.background)
        .sheet(isPresented: $showingAvatarSelection) {
            AvatarSelectionSheet()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileSheet()
        }
    }
}

enum ProfileTab: String, CaseIterable {
    case infos = "Infos"
    case success = "Succès"
    case properties = "Propriété"
    case collections = "Collections"
    case trophies = "Trophées"
    case vip = "VIP"
    
    var icon: String {
        switch self {
        case .infos: return "person.circle.fill"
        case .success: return "star.fill"
        case .properties: return "house.fill"
        case .collections: return "square.grid.2x2.fill"
        case .trophies: return "trophy.fill"
        case .vip: return "crown.fill"
        }
    }
}

struct ModernProfileHeaderView: View {
    @Binding var showingAvatarSelection: Bool
    @Binding var showingEditProfile: Bool
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var walletStore: WalletStore
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Profil")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Button(action: { showingEditProfile = true }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accent)
                }
            }
            
            if let user = authStore.currentUser {
                VStack(spacing: 16) {
                    // Avatar et infos principales
                    HStack(spacing: 20) {
                        // Avatar
                        Button(action: { showingAvatarSelection = true }) {
                            ZStack {
                                Circle()
                                    .fill(avatarColor.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: avatarIcon)
                                    .font(.system(size: 40))
                                    .foregroundColor(avatarColor)
                                
                                // Badge VIP si applicable
                                if user.isVIP {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.gold)
                                        .background(
                                            Circle()
                                                .fill(AppColors.background)
                                                .frame(width: 24, height: 24)
                                        )
                                        .offset(x: 25, y: -25)
                                }
                                
                                // Indicateur d'édition
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.accent)
                                    .background(
                                        Circle()
                                            .fill(AppColors.background)
                                            .frame(width: 24, height: 24)
                                    )
                                    .offset(x: 25, y: 25)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            // Nom et statut
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(user.username)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AppColors.text)
                                    
                                    Button(action: { showingEditProfile = true }) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 14))
                                            .foregroundColor(AppColors.accent)
                                    }
                                }
                                
                                Text("Dites quelque chose à vos amis")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .italic()
                            }
                            
                            // Statistiques principales
                            HStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.gold)
                                        
                                        Text("\(formatNumber(walletStore.balance.chips))")
                                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                                            .foregroundColor(AppColors.text)
                                    }
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "diamond.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.accent)
                                        
                                        Text("\(walletStore.balance.gems)")
                                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                                            .foregroundColor(AppColors.text)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("ID: \(user.id)")
                                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    Text("Niveau \(user.level)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(AppColors.accent)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // Statistiques détaillées
                    ProfileStatsCard(user: user)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var avatarColor: Color {
        if let user = authStore.currentUser {
            return AppAvatars.getAvatar(by: user.avatarId)?.color ?? AppColors.accent
        }
        return AppColors.accent
    }
    
    private var avatarIcon: String {
        if let user = authStore.currentUser {
            return AppAvatars.getAvatar(by: user.avatarId)?.iconName ?? "person.circle.fill"
        }
        return "person.circle.fill"
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

struct ProfileStatsCard: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            // Header avec gain le plus élevé
            VStack(spacing: 8) {
                Text("GAIN LE PLUS ÉLEVÉ")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(AppColors.textSecondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "dice.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.gold)
                    
                    Text("322,000")
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(AppColors.gold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(AppColors.gold.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            // Statistiques détaillées
            HStack(spacing: 20) {
                StatColumn(
                    title: "PARTIES DISPUTÉES",
                    value: "190",
                    subtitle: "GAIN LE PLUS ÉLEVÉ",
                    subvalue: "322K",
                    icon: "gamecontroller.fill",
                    color: AppColors.accent
                )
                
                StatColumn(
                    title: "PREMIÈRE PARTIE",
                    value: "15/03/2025",
                    subtitle: "",
                    subvalue: "",
                    icon: "calendar.badge.clock",
                    color: AppColors.success
                )
            }
            
            // Barre de niveau avec icônes
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    ProfileIconCard(icon: "crown.fill", title: "EXPÉRIENCE", subtitle: "NIVEAU : 13", color: AppColors.gold)
                    ProfileIconCard(icon: "star.fill", title: "SUCCÈS", subtitle: "INARRÊTABLE", color: AppColors.chipRed)
                    ProfileIconCard(icon: "circle.fill", title: "LIGUES", subtitle: "QUALIFICATION", color: AppColors.accent)
                    ProfileIconCard(icon: "square.grid.2x2.fill", title: "COLLECTIONS", subtitle: "TEXAS & OMAHA POKER", color: AppColors.woodDark)
                    ProfileIconCard(icon: "trophy.fill", title: "TROPHÉES", subtitle: "VIDE", color: AppColors.textSecondary)
                }
            }
        }
        .padding(16)
        .background(AppColors.surface)
        .cornerRadius(16)
    }
}

struct StatColumn: View {
    let title: String
    let value: String
    let subtitle: String
    let subvalue: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(AppColors.textSecondary)
            
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(AppColors.textSecondary)
                
                if !subvalue.isEmpty {
                    Text(subvalue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(color)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ProfileIconCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(8)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(subtitle)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(AppColors.text)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileTabSelector: View {
    @Binding var selectedTab: ProfileTab
    @Namespace private var tabIndicator
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ProfileTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(selectedTab == tab ? AppColors.accent : AppColors.textSecondary)
                            
                            Text(tab.rawValue)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(selectedTab == tab ? AppColors.accent : AppColors.textSecondary)
                        }
                        .frame(width: 80)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTab == tab ? AppColors.accent.opacity(0.1) : Color.clear)
                                .matchedGeometryEffect(
                                    id: selectedTab == tab ? "profile_tab_bg" : "",
                                    in: tabIndicator
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Onglets de contenu

struct ProfileInfosView: View {
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                if let user = authStore.currentUser {
                    // Informations personnelles
                    ProfileInfoSection(
                        title: "Informations Personnelles",
                        items: [
                            ProfileInfoItem(icon: "person.fill", title: "Nom d'utilisateur", value: user.username),
                            ProfileInfoItem(icon: "envelope.fill", title: "Email", value: user.email),
                            ProfileInfoItem(icon: "calendar", title: "Membre depuis", value: user.memberSince.formatted(date: .abbreviated, time: .omitted)),
                            ProfileInfoItem(icon: "location.fill", title: "Région", value: "France"),
                        ]
                    )
                    
                    // Statistiques de jeu
                    ProfileInfoSection(
                        title: "Statistiques de Jeu",
                        items: [
                            ProfileInfoItem(icon: "gamecontroller.fill", title: "Parties jouées", value: "190"),
                            ProfileInfoItem(icon: "trophy.fill", title: "Victoires", value: "127"),
                            ProfileInfoItem(icon: "percent", title: "Taux de réussite", value: "67%"),
                            ProfileInfoItem(icon: "chart.line.uptrend.xyaxis", title: "Gain total", value: "1.2M jetons"),
                        ]
                    )
                    
                    // Préférences
                    ProfileInfoSection(
                        title: "Préférences",
                        items: [
                            ProfileInfoItem(icon: "suit.spade.fill", title: "Jeu préféré", value: "Blackjack"),
                            ProfileInfoItem(icon: "clock.fill", title: "Temps de jeu total", value: "45h 30m"),
                            ProfileInfoItem(icon: "star.fill", title: "Niveau VIP", value: user.isVIP ? "Actif" : "Inactif"),
                        ]
                    )
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
}

struct ProfileInfoSection: View {
    let title: String
    let items: [ProfileInfoItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppColors.text)
            
            VStack(spacing: 12) {
                ForEach(items, id: \.title) { item in
                    HStack(spacing: 16) {
                        Image(systemName: item.icon)
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.accent)
                            .frame(width: 24)
                        
                        Text(item.title)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Spacer()
                        
                        Text(item.value)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppColors.text)
                    }
                    .padding(.vertical, 8)
                    
                    if item != items.last {
                        Divider()
                            .background(AppColors.textSecondary.opacity(0.2))
                    }
                }
            }
            .padding(16)
            .background(AppColors.surface)
            .cornerRadius(12)
        }
    }
}

struct ProfileInfoItem: Equatable {
    let icon: String
    let title: String
    let value: String
    
    static func == (lhs: ProfileInfoItem, rhs: ProfileInfoItem) -> Bool {
        return lhs.title == rhs.title
    }
}

struct ProfileSuccessView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Succès et Achievements")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .padding(.top, 20)
                
                ComingSoonView(title: "Système de Succès", description: "Débloquez des achievements en jouant et gagnez des récompenses exclusives")
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ProfilePropertiesView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Propriétés et Objets")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .padding(.top, 20)
                
                ComingSoonView(title: "Inventaire", description: "Gérez vos objets, avatars et propriétés virtuelles")
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ProfileCollectionsView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Collections de Cartes")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .padding(.top, 20)
                
                ComingSoonView(title: "Collections", description: "Collectionnez des cartes rares et débloquez des bonus spéciaux")
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ProfileTrophiesView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Trophées et Récompenses")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .padding(.top, 20)
                
                ComingSoonView(title: "Vitrine de Trophées", description: "Affichez vos trophées et récompenses gagnées")
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ProfileVIPView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Statut VIP")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .padding(.top, 20)
                
                ComingSoonView(title: "Programme VIP", description: "Accédez aux avantages exclusifs et aux bonus premium")
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ComingSoonView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
                .opacity(0.5)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Text("Bientôt Disponible")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.accent)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.accent.opacity(0.1))
                .cornerRadius(20)
        }
        .padding(.vertical, 40)
    }
}

// MARK: - Sheets

struct AvatarSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authStore: AuthStore
    @State private var selectedAvatarId: Int = 1
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Choisissez votre avatar")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(AppAvatars.allAvatars, id: \.id) { avatar in
                            Button(action: { selectedAvatarId = avatar.id }) {
                                VStack(spacing: 6) {
                                    Image(systemName: avatar.iconName)
                                        .font(.system(size: 32))
                                        .foregroundColor(selectedAvatarId == avatar.id ? AppColors.accent : avatar.color)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            Circle()
                                                .fill(selectedAvatarId == avatar.id ? AppColors.accent.opacity(0.2) : Color.clear)
                                        )
                                        .overlay(
                                            Circle()
                                                .stroke(selectedAvatarId == avatar.id ? AppColors.accent : Color.clear, lineWidth: 2)
                                        )
                                    
                                    Text(avatar.name)
                                        .font(.system(size: 8, weight: .medium))
                                        .foregroundColor(selectedAvatarId == avatar.id ? AppColors.accent : AppColors.textSecondary)
                                        .lineLimit(1)
                                        .frame(width: 60)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 200)
                
                Spacer()
                
                Button("Confirmer") {
                    authStore.updateAvatar(selectedAvatarId)
                    dismiss()
                }
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.accent)
                .cornerRadius(16)
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
            .background(AppColors.background)
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
        .onAppear {
            if let user = authStore.currentUser {
                selectedAvatarId = user.avatarId
            }
        }
    }
}

struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authStore: AuthStore
    @State private var username: String = ""
    @State private var status: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Modifier le profil")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nom d'utilisateur")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        TextField("Votre nom d'utilisateur", text: $username)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.text)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(AppColors.surface)
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Statut")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        TextField("Dites quelque chose à vos amis", text: $status)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.text)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(AppColors.surface)
                            .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                Button("Sauvegarder") {
                    saveProfile()
                    dismiss()
                }
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.accent)
                .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(AppColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .onAppear {
            if let user = authStore.currentUser {
                username = user.username
                status = user.status ?? ""
            }
        }
    }
    
    private func saveProfile() {
        authStore.updateProfile(username: username, status: status)
    }
}

#Preview {
    ModernProfileView()
        .environmentObject(AuthStore.shared)
        .environmentObject(WalletStore.shared)
}
