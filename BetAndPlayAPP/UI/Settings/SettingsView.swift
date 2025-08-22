import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Section Audio
                        SettingsSection(title: "Audio") {
                            VStack(spacing: 12) {
                                SettingsToggle(
                                    title: "Son",
                                    icon: "speaker.wave.2.fill",
                                    isOn: !themeManager.isMuted
                                ) {
                                    themeManager.isMuted.toggle()
                                }
                                
                                SettingsToggle(
                                    title: "Musique",
                                    icon: "music.note",
                                    isOn: true
                                ) {
                                    // Toggle musique
                                }
                                
                                SettingsToggle(
                                    title: "Haptics",
                                    icon: "iphone.radiowaves.left.and.right",
                                    isOn: true
                                ) {
                                    // Toggle haptics
                                }
                            }
                        }
                        
                        // Section Affichage
                        SettingsSection(title: "Affichage") {
                            VStack(spacing: 12) {
                                SettingsToggle(
                                    title: "Mode Sombre",
                                    icon: "moon.fill",
                                    isOn: true
                                ) {
                                    // Toggle dark mode
                                }
                                
                                SettingsToggle(
                                    title: "Animations",
                                    icon: "sparkles",
                                    isOn: true
                                ) {
                                    // Toggle animations
                                }
                                
                                SettingsToggle(
                                    title: "Notifications Push",
                                    icon: "bell.fill",
                                    isOn: true
                                ) {
                                    // Toggle notifications
                                }
                            }
                        }
                        
                        // Section Jeu
                        SettingsSection(title: "Jeu") {
                            VStack(spacing: 12) {
                                SettingsToggle(
                                    title: "Mode Auto-Play",
                                    icon: "play.circle.fill",
                                    isOn: false
                                ) {
                                    // Toggle auto-play
                                }
                                
                                SettingsToggle(
                                    title: "Conseils de Jeu",
                                    icon: "lightbulb.fill",
                                    isOn: true
                                ) {
                                    // Toggle game tips
                                }
                                
                                SettingsToggle(
                                    title: "Historique des Parties",
                                    icon: "clock.fill",
                                    isOn: true
                                ) {
                                    // Toggle game history
                                }
                            }
                        }
                        
                        // Section Compte
                        SettingsSection(title: "Compte") {
                            VStack(spacing: 12) {
                                SettingsButton(
                                    title: "Changer d'Avatar",
                                    icon: "person.circle.fill",
                                    color: AppColors.accent
                                ) {
                                    // Change avatar
                                }
                                
                                SettingsButton(
                                    title: "Modifier le Pseudo",
                                    icon: "pencil",
                                    color: AppColors.primary
                                ) {
                                    // Edit username
                                }
                                
                                SettingsButton(
                                    title: "Code de Parrainage",
                                    icon: "gift.fill",
                                    color: AppColors.warning
                                ) {
                                    // Show referral code
                                }
                            }
                        }
                        
                        // Section Support
                        SettingsSection(title: "Support") {
                            VStack(spacing: 12) {
                                SettingsButton(
                                    title: "Aide et FAQ",
                                    icon: "questionmark.circle.fill",
                                    color: AppColors.primary
                                ) {
                                    // Help and FAQ
                                }
                                
                                SettingsButton(
                                    title: "Signaler un Bug",
                                    icon: "exclamationmark.triangle.fill",
                                    color: AppColors.error
                                ) {
                                    // Report bug
                                }
                                
                                SettingsButton(
                                    title: "Nous Contacter",
                                    icon: "envelope.fill",
                                    color: AppColors.accent
                                ) {
                                    // Contact us
                                }
                            }
                        }
                        
                        // Section Légale
                        SettingsSection(title: "Légal") {
                            VStack(spacing: 12) {
                                SettingsButton(
                                    title: "Conditions d'Utilisation",
                                    icon: "doc.text.fill",
                                    color: AppColors.textSecondary
                                ) {
                                    // Terms of service
                                }
                                
                                SettingsButton(
                                    title: "Politique de Confidentialité",
                                    icon: "hand.raised.fill",
                                    color: AppColors.textSecondary
                                ) {
                                    // Privacy policy
                                }
                                
                                SettingsButton(
                                    title: "Jeu Responsable",
                                    icon: "shield.fill",
                                    color: AppColors.success
                                ) {
                                    // Responsible gaming
                                }
                            }
                        }
                        
                        // Bouton de déconnexion
                        Button(action: { showingLogoutAlert = true }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.error)
                                    .frame(width: 24)
                                
                                Text("Se Déconnecter")
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.error)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(AppColors.card)
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Paramètres")
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
        .alert("Se Déconnecter", isPresented: $showingLogoutAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Déconnexion", role: .destructive) {
                authStore.logout()
                dismiss()
            }
        } message: {
            Text("Êtes-vous sûr de vouloir vous déconnecter ?")
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(AppTypography.title2)
                .foregroundColor(AppColors.text)
                .padding(.horizontal, 20)
            
            content
                .padding(.horizontal, 20)
        }
    }
}

struct SettingsToggle: View {
    let title: String
    let icon: String
    @State var isOn: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            isOn.toggle()
            action()
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(AppColors.card)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsButton: View {
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

#Preview {
    SettingsView()
        .environmentObject(AuthStore.shared)
        .environmentObject(ThemeManager())
}
