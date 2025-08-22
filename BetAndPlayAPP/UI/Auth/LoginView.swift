import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var router: Router
    
    @State private var email = ""
    @State private var username = ""
    @State private var referralCode = ""
    @State private var selectedAvatarId = 21
    @State private var selectedRarity: AvatarData.AvatarRarity?
    @State private var currentPage = 0
    @State private var isLoading = false
    
    private let avatarsPerPage = 20
    
    var body: some View {
        NavigationView {
            ZStack {
                // Arrière-plan
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        // Header avec logo
                        VStack(spacing: 16) {
                            // Logo triangulaire
                            Triangle()
                                .fill(AppColors.gold)
                                .frame(width: 60, height: 60)
                                .rotationEffect(.degrees(180))
                            
                            Text("CasinoX")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppColors.gold)
                            
                            Text("Rejoignez l'aventure casino")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.top, 40)
                        
                        // Formulaire
                        VStack(spacing: 20) {
                            // Email
                            InputField(
                                icon: "envelope.fill",
                                placeholder: "Email",
                                text: $email
                            )
                            
                            // Nom d'utilisateur
                            InputField(
                                icon: "person.fill",
                                placeholder: "Nom d'utilisateur",
                                text: $username
                            )
                            
                            // Code de parrainage
                            InputField(
                                icon: "gift.fill",
                                placeholder: "Code de parrainage (optionnel)",
                                text: $referralCode
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Sélection d'avatar
                        VStack(spacing: 16) {
                            HStack {
                                Text("Choisissez votre avatar")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.text)
                                
                                Spacer()
                                
                                Text("\(currentPage + 1)/\(Int(ceil(Double(AppAvatars.allAvatars.count) / Double(avatarsPerPage))))")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .padding(.horizontal, 20)
                            
                            // Filtres de rareté
                            AvatarRarityFilter(selectedRarity: $selectedRarity)
                            
                            // Grille d'avatars avec pagination
                            VStack(spacing: 16) {
                                let filteredAvatars = selectedRarity == nil ? AppAvatars.allAvatars : AppAvatars.getAvatarsByRarity(selectedRarity!)
                                let startIndex = currentPage * avatarsPerPage
                                let endIndex = min(startIndex + avatarsPerPage, filteredAvatars.count)
                                let pageAvatars = Array(filteredAvatars[startIndex..<endIndex])
                                
                                AvatarSelectionGrid(
                                    selectedAvatarId: $selectedAvatarId,
                                    avatars: pageAvatars
                                )
                                
                                // Pagination
                                if filteredAvatars.count > avatarsPerPage {
                                    HStack(spacing: 16) {
                                        Button(action: previousPage) {
                                            Image(systemName: "chevron.left")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(currentPage > 0 ? AppColors.accent : AppColors.textSecondary)
                                        }
                                        .disabled(currentPage == 0)
                                        
                                        ForEach(0..<Int(ceil(Double(filteredAvatars.count) / Double(avatarsPerPage))), id: \.self) { page in
                                            Circle()
                                                .fill(page == currentPage ? AppColors.accent : AppColors.textSecondary.opacity(0.3))
                                                .frame(width: 8, height: 8)
                                        }
                                        
                                        Button(action: nextPage) {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(currentPage < Int(ceil(Double(filteredAvatars.count) / Double(avatarsPerPage))) - 1 ? AppColors.accent : AppColors.textSecondary)
                                        }
                                        .disabled(currentPage >= Int(ceil(Double(filteredAvatars.count) / Double(avatarsPerPage))) - 1)
                                    }
                                }
                            }
                            
                            // Avatar sélectionné
                            if let selectedAvatar = AppAvatars.getAvatar(by: selectedAvatarId) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppColors.success)
                                        .font(.system(size: 16))
                                    
                                    Text("Avatar sélectionné : \(selectedAvatar.name)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.text)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.surface)
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Bouton de connexion
                        Button(action: handleLogin) {
                            HStack(spacing: 12) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                
                                Text(isLoading ? "Connexion..." : "Se connecter")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.accent)
                            )
                        }
                        .disabled(isLoading || email.isEmpty || username.isEmpty)
                        .opacity((email.isEmpty || username.isEmpty) ? 0.6 : 1.0)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func handleLogin() {
        isLoading = true
        
        // Simuler un délai de connexion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            if referralCode.isEmpty {
                authStore.register(email: email, username: username, avatarId: selectedAvatarId)
            } else {
                authStore.register(email: email, username: username, avatarId: selectedAvatarId, referralCode: referralCode)
            }
            
            router.navigate(to: .hub)
        }
    }
    
    private func nextPage() {
        let filteredAvatars = selectedRarity == nil ? AppAvatars.allAvatars : AppAvatars.getAvatarsByRarity(selectedRarity!)
        let maxPage = Int(ceil(Double(filteredAvatars.count) / Double(avatarsPerPage))) - 1
        
        if currentPage < maxPage {
            currentPage += 1
        }
    }
    
    private func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
}

struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.textSecondary)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .foregroundColor(AppColors.text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.surface)
        )
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthStore.shared)
        .environmentObject(Router())
}
