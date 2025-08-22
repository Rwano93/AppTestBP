import SwiftUI

struct ModernFriendsView: View {
    @EnvironmentObject var friendsService: FriendsService
    @EnvironmentObject var authStore: AuthStore
    @State private var searchText = ""
    @State private var selectedTab: FriendsTab = .friends
    @State private var showingInviteSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header avec recherche
            FriendsHeaderView(searchText: $searchText, showingInviteSheet: $showingInviteSheet)
            
            // Onglets
            FriendsTabSelector(selectedTab: $selectedTab)
            
            // Contenu selon l'onglet sélectionné
            TabView(selection: $selectedTab) {
                FriendsListView(searchText: searchText)
                    .tag(FriendsTab.friends)
                
                SearchFriendsView(searchText: searchText)
                    .tag(FriendsTab.search)
                
                InvitationsView()
                    .tag(FriendsTab.invitations)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(AppColors.background)
        .sheet(isPresented: $showingInviteSheet) {
            InviteFriendsSheet()
        }
    }
}

enum FriendsTab: String, CaseIterable {
    case friends = "Amis"
    case search = "Rechercher des amis" 
    case invitations = "Invitations"
    
    var icon: String {
        switch self {
        case .friends: return "person.2.fill"
        case .search: return "magnifyingglass"
        case .invitations: return "envelope.fill"
        }
    }
}

struct FriendsHeaderView: View {
    @Binding var searchText: String
    @Binding var showingInviteSheet: Bool
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Amis")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Button(action: { showingInviteSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accent)
                }
            }
            
            // Votre ID
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Votre ID")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    if let user = authStore.currentUser {
                        Text(user.id)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(AppColors.accent)
                    }
                }
                
                Spacer()
                
                Button(action: copyUserID) {
                    HStack(spacing: 6) {
                        Image(systemName: "doc.on.doc.fill")
                            .font(.system(size: 14))
                        
                        Text("Copier")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(AppColors.accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.accent.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(16)
            .background(AppColors.surface)
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private func copyUserID() {
        if let user = authStore.currentUser {
            UIPasteboard.general.string = user.id
            // Ajouter un feedback visuel
        }
    }
}

struct FriendsTabSelector: View {
    @Binding var selectedTab: FriendsTab
    @Namespace private var tabIndicator
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(FriendsTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTab = tab
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(tab.rawValue)
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(selectedTab == tab ? .white : AppColors.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedTab == tab ? AppColors.accent : AppColors.surface)
                                .matchedGeometryEffect(
                                    id: selectedTab == tab ? "tab_bg" : "",
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

struct FriendsListView: View {
    let searchText: String
    @EnvironmentObject var friendsService: FriendsService
    
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friendsService.friends
        }
        return friendsService.friends.filter { 
            $0.username.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                if filteredFriends.isEmpty {
                    EmptyFriendsView()
                } else {
                    ForEach(filteredFriends, id: \.id) { friend in
                        FriendCard(friend: friend)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
}

struct FriendCard: View {
    let friend: Friend
    @State private var showingProfile = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            Button(action: { showingProfile = true }) {
                ZStack {
                    Circle()
                        .fill(avatarColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: avatarIcon)
                        .font(.system(size: 24))
                        .foregroundColor(avatarColor)
                    
                    // Indicateur en ligne
                    if friend.isOnline {
                        Circle()
                            .fill(AppColors.success)
                            .frame(width: 12, height: 12)
                            .offset(x: 18, y: 18)
                            .overlay(
                                Circle()
                                    .stroke(AppColors.surface, lineWidth: 2)
                                    .frame(width: 12, height: 12)
                                    .offset(x: 18, y: 18)
                            )
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(friend.username)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.text)
                    
                    if friend.isVIP {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.gold)
                    }
                }
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("Niveau")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("\(friend.level)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(AppColors.accent)
                    }
                    
                    if friend.isOnline {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(AppColors.success)
                                .frame(width: 6, height: 6)
                            
                            Text(friend.currentGame?.rawValue.capitalized ?? "En ligne")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppColors.success)
                        }
                    } else {
                        Text("Hors ligne")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            // Actions
            HStack(spacing: 8) {
                if friend.isOnline && friend.currentGame != nil {
                    Button(action: joinFriendGame) {
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.accent)
                            .frame(width: 32, height: 32)
                            .background(AppColors.accent.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                Button(action: messageFreund) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(width: 32, height: 32)
                        .background(AppColors.surface)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(AppColors.surface)
        .cornerRadius(12)
        .sheet(isPresented: $showingProfile) {
            FriendProfileSheet(friend: friend)
        }
    }
    
    private var avatarColor: Color {
        AppAvatars.getAvatar(by: friend.avatarId)?.color ?? AppColors.accent
    }
    
    private var avatarIcon: String {
        AppAvatars.getAvatar(by: friend.avatarId)?.iconName ?? "person.circle.fill"
    }
    
    private func joinFriendGame() {
        // Logique pour rejoindre le jeu de l'ami
    }
    
    private func messageFreund() {
        // Logique pour envoyer un message
    }
}

struct EmptyFriendsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
                .opacity(0.5)
            
            VStack(spacing: 8) {
                Text("Aucun ami trouvé")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Text("Invitez vos amis pour jouer ensemble et gagner des récompenses!")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 60)
    }
}

struct SearchFriendsView: View {
    let searchText: String
    @State private var searchResults: [User] = []
    @State private var isSearching = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Zone de recherche
            VStack(spacing: 16) {
                SearchBarView(searchText: .constant(""), placeholder: "Rechercher par pseudo ou ID")
                
                Text("Vous pouvez rechercher des utilisateurs par leur pseudo ou identifiant. Laissez les joueurs savoir quel est votre identifiant et ils seront en mesure de vous ajouter à leurs amis.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 20)
            
            // Résultats de recherche
            if isSearching {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.accent))
            } else if searchResults.isEmpty && !searchText.isEmpty {
                EmptySearchResultsView()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(searchResults, id: \.id) { user in
                            SearchResultCard(user: user)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            Spacer()
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(AppColors.textSecondary)
            
            TextField(placeholder, text: $searchText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.surface)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}

struct SearchResultCard: View {
    let user: User
    @State private var isRequestSent = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(avatarColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: avatarIcon)
                    .font(.system(size: 24))
                    .foregroundColor(avatarColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(user.username)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.text)
                    
                    if user.isVIP {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.gold)
                    }
                }
                
                Text("Niveau \(user.level)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: sendFriendRequest) {
                HStack(spacing: 6) {
                    Image(systemName: isRequestSent ? "checkmark" : "person.badge.plus")
                        .font(.system(size: 14))
                    
                    Text(isRequestSent ? "Envoyé" : "Ajouter")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(isRequestSent ? AppColors.success : AppColors.accent)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background((isRequestSent ? AppColors.success : AppColors.accent).opacity(0.1))
                .cornerRadius(8)
            }
            .disabled(isRequestSent)
        }
        .padding(16)
        .background(AppColors.surface)
        .cornerRadius(12)
    }
    
    private var avatarColor: Color {
        AppAvatars.getAvatar(by: user.avatarId)?.color ?? AppColors.accent
    }
    
    private var avatarIcon: String {
        AppAvatars.getAvatar(by: user.avatarId)?.iconName ?? "person.circle.fill"
    }
    
    private func sendFriendRequest() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isRequestSent = true
        }
        // Logique pour envoyer la demande d'ami
    }
}

struct EmptySearchResultsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 50))
                .foregroundColor(AppColors.textSecondary)
                .opacity(0.5)
            
            Text("Aucun résultat trouvé")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.text)
            
            Text("Vérifiez l'orthographe ou essayez un autre terme de recherche.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
    }
}

struct InvitationsView: View {
    @EnvironmentObject var friendsService: FriendsService
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Section invitations reçues
                if !friendsService.pendingInvitations.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Invitations reçues")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppColors.text)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(friendsService.pendingInvitations, id: \.id) { invitation in
                                InvitationCard(invitation: invitation)
                            }
                        }
                    }
                }
                
                // Section inviter des amis
                InviteFriendsSection()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
}

struct InvitationCard: View {
    let invitation: FriendInvite
    @State private var isProcessing = false
    @EnvironmentObject var friendsService: FriendsService
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.accent)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(invitation.fromUsername)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Text("Vous a envoyé une demande d'ami")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(invitation.date, style: .relative)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            if !isProcessing {
                HStack(spacing: 8) {
                    Button(action: acceptInvitation) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(AppColors.success)
                            .cornerRadius(8)
                    }
                    
                    Button(action: declineInvitation) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(AppColors.error)
                            .cornerRadius(8)
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.accent))
                    .scaleEffect(0.8)
            }
        }
        .padding(16)
        .background(AppColors.surface)
        .cornerRadius(12)
    }
    
    private func acceptInvitation() {
        isProcessing = true
        // Logique pour accepter l'invitation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            friendsService.acceptInvitation(invitation.id)
            isProcessing = false
        }
    }
    
    private func declineInvitation() {
        isProcessing = true
        // Logique pour refuser l'invitation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            friendsService.declineInvitation(invitation.id)
            isProcessing = false
        }
    }
}

struct InviteFriendsSection: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var showingInviteSheet = false
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "person.2.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.accent)
                
                Text("INVITEZ VOS AMIS ET JOUEZ ENSEMBLE !")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .multilineTextAlignment(.center)
                
                Text("Comment ajouter un joueur à une table en ami :")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            // Instructions avec image et texte
            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    // Image illustrative (placeholder)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.surface)
                            .frame(width: 100, height: 80)
                        
                        VStack(spacing: 4) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(AppColors.accent)
                            
                            Text("Nickname")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(AppColors.text)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1. Appuyez sur son avatar")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.text)
                        
                        Text("2. Appuyez sur le bouton \"Ajouter\"")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.text)
                    }
                    
                    Spacer()
                }
                
                Text("Envoyez une invitation à vos amis ou trouvez-les dans le jeu")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .background(AppColors.surface)
            .cornerRadius(12)
            
            // Boutons d'action
            VStack(spacing: 12) {
                Button(action: { showingInviteSheet = true }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 16))
                        
                        Text("INVITEZ UN AMI")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.success)
                    .cornerRadius(12)
                }
                
                Button(action: findFriends) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16))
                        
                        Text("TROUVER UN AMI")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(AppColors.accent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.accent.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            // Votre ID avec récompense
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.gold)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "diamond.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.accent)
                        
                        Text("+2,000,000")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.gold)
                    }
                }
                
                Text("VOTRE AMI ET VOUS OBTIENDREZ DES JETONS QUAND VOTRE AMI ATTEINDRA LES NIVEAUX 5, 10 ET 20. OBTENEZ DES JETONS POUR LES NIVEAUX VIP DE VOTRE AMI !")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                
                // Copie de l'ID
                if let user = authStore.currentUser {
                    Button(action: copyUserID) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 14))
                            
                            Text("COPIEZ VOTRE ID : \(user.id)")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(AppColors.accent)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.accent.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding(16)
            .background(AppColors.surface)
            .cornerRadius(12)
        }
        .sheet(isPresented: $showingInviteSheet) {
            InviteFriendsSheet()
        }
    }
    
    private func findFriends() {
        // Logique pour rechercher des amis
    }
    
    private func copyUserID() {
        if let user = authStore.currentUser {
            UIPasteboard.general.string = user.id
        }
    }
}

// MARK: - Sheets et vues supplémentaires

struct InviteFriendsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Inviter des amis")
                    .font(.largeTitle)
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Text("Fonctionnalité à venir...")
                    .foregroundColor(AppColors.textSecondary)
                
                Spacer()
            }
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
    }
}

struct FriendProfileSheet: View {
    let friend: Friend
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Profil de \(friend.username)")
                    .font(.largeTitle)
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Text("Fonctionnalité à venir...")
                    .foregroundColor(AppColors.textSecondary)
                
                Spacer()
            }
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
    }
}

#Preview {
    ModernFriendsView()
        .environmentObject(FriendsService.shared)
        .environmentObject(AuthStore.shared)
}
