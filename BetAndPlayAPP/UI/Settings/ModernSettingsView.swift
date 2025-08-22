import SwiftUI

struct ModernSettingsView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var showingLogoutAlert = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    SettingsHeaderView()
                    
                    // Sections de paramètres
                    VStack(spacing: 16) {
                        GameSettingsSection()
                        AppearanceSettingsSection()
                        NotificationSettingsSection()
                        AccountSettingsSection(showingLogoutAlert: $showingLogoutAlert)
                        SupportSettingsSection(showingAbout: $showingAbout)
                        LegalSettingsSection()
                    }
                    
                    // Version info
                    VersionInfoView()
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(AppColors.background)
            .navigationBarHidden(true)
        }
        .alert("Déconnexion", isPresented: $showingLogoutAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Déconnexion", role: .destructive) {
                authStore.signOut()
            }
        } message: {
            Text("Êtes-vous sûr de vouloir vous déconnecter ?")
        }
        .sheet(isPresented: $showingAbout) {
            AboutSheet()
        }
    }
}

struct SettingsHeaderView: View {
    var body: some View {
        HStack {
            Text("Paramètres")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppColors.text)
            
            Spacer()
            
            Image(systemName: "gearshape.2.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.accent)
        }
    }
}

struct GameSettingsSection: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("musicEnabled") private var musicEnabled = true
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("autoPlayEnabled") private var autoPlayEnabled = false
    
    var body: some View {
        ModernSettingsSection(title: "Jeu", icon: "gamecontroller.fill", iconColor: AppColors.accent) {
            VStack(spacing: 0) {
                SettingsToggleRow(
                    title: "Sons des effets",
                    subtitle: "Sons lors des actions de jeu",
                    icon: "speaker.wave.2.fill",
                    isOn: $soundEnabled
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsToggleRow(
                    title: "Musique de fond",
                    subtitle: "Musique d'ambiance",
                    icon: "music.note",
                    isOn: $musicEnabled
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsToggleRow(
                    title: "Vibrations",
                    subtitle: "Retour haptique",
                    icon: "iphone.radiowaves.left.and.right",
                    isOn: $vibrationEnabled
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsToggleRow(
                    title: "Jeu automatique",
                    subtitle: "Actions automatiques en mode spectateur",
                    icon: "play.circle.fill",
                    isOn: $autoPlayEnabled
                )
            }
        }
    }
}

struct AppearanceSettingsSection: View {
    @AppStorage("darkModeEnabled") private var darkModeEnabled = true
    @AppStorage("animationsEnabled") private var animationsEnabled = true
    @AppStorage("highQualityGraphics") private var highQualityGraphics = true
    
    var body: some View {
        ModernSettingsSection(title: "Apparence", icon: "paintbrush.fill", iconColor: AppColors.gold) {
            VStack(spacing: 0) {
                SettingsToggleRow(
                    title: "Mode sombre",
                    subtitle: "Interface en mode sombre",
                    icon: "moon.fill",
                    isOn: $darkModeEnabled
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsToggleRow(
                    title: "Animations",
                    subtitle: "Animations et transitions",
                    icon: "sparkles",
                    isOn: $animationsEnabled
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsToggleRow(
                    title: "Graphismes haute qualité",
                    subtitle: "Meilleure qualité visuelle",
                    icon: "sparkle",
                    isOn: $highQualityGraphics
                )
            }
        }
    }
}

struct NotificationSettingsSection: View {
    @AppStorage("pushNotificationsEnabled") private var pushNotificationsEnabled = true
    @AppStorage("friendNotificationsEnabled") private var friendNotificationsEnabled = true
    @AppStorage("promotionNotificationsEnabled") private var promotionNotificationsEnabled = false
    
    var body: some View {
        ModernSettingsSection(title: "Notifications", icon: "bell.fill", iconColor: AppColors.chipRed) {
            VStack(spacing: 0) {
                SettingsToggleRow(
                    title: "Notifications push",
                    subtitle: "Recevoir des notifications",
                    icon: "bell.badge.fill",
                    isOn: $pushNotificationsEnabled
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsToggleRow(
                    title: "Activité des amis",
                    subtitle: "Notifications des amis en ligne",
                    icon: "person.2.fill",
                    isOn: $friendNotificationsEnabled
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsToggleRow(
                    title: "Promotions",
                    subtitle: "Offres et promotions spéciales",
                    icon: "gift.fill",
                    isOn: $promotionNotificationsEnabled
                )
            }
        }
    }
}

struct AccountSettingsSection: View {
    @Binding var showingLogoutAlert: Bool
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        ModernSettingsSection(title: "Compte", icon: "person.circle.fill", iconColor: AppColors.success) {
            VStack(spacing: 0) {
                SettingsActionRow(
                    title: "Modifier le profil",
                    subtitle: "Nom, avatar, informations",
                    icon: "pencil.circle.fill",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsActionRow(
                    title: "Changer de mot de passe",
                    subtitle: "Sécurité du compte",
                    icon: "key.fill",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsActionRow(
                    title: "Gestion des données",
                    subtitle: "Sauvegarde et synchronisation",
                    icon: "icloud.fill",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsActionRow(
                    title: "Déconnexion",
                    subtitle: "Se déconnecter de l'application",
                    icon: "rectangle.portrait.and.arrow.right.fill",
                    titleColor: AppColors.error,
                    action: { showingLogoutAlert = true }
                )
            }
        }
    }
}

struct SupportSettingsSection: View {
    @Binding var showingAbout: Bool
    
    var body: some View {
        ModernSettingsSection(title: "Support", icon: "questionmark.circle.fill", iconColor: AppColors.accent) {
            VStack(spacing: 0) {
                SettingsActionRow(
                    title: "Centre d'aide",
                    subtitle: "Questions fréquentes",
                    icon: "book.fill",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsActionRow(
                    title: "Contacter le support",
                    subtitle: "Besoin d'aide ?",
                    icon: "envelope.fill",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsActionRow(
                    title: "Signaler un problème",
                    subtitle: "Bug ou dysfonctionnement",
                    icon: "exclamationmark.triangle.fill",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsActionRow(
                    title: "À propos",
                    subtitle: "Informations sur l'application",
                    icon: "info.circle.fill",
                    action: { showingAbout = true }
                )
            }
        }
    }
}

struct LegalSettingsSection: View {
    var body: some View {
        ModernSettingsSection(title: "Légal", icon: "doc.text.fill", iconColor: AppColors.textSecondary) {
            VStack(spacing: 0) {
                SettingsActionRow(
                    title: "Conditions d'utilisation",
                    subtitle: "Termes et conditions",
                    icon: "doc.plaintext.fill",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsActionRow(
                    title: "Politique de confidentialité",
                    subtitle: "Protection des données",
                    icon: "hand.raised.fill",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsActionRow(
                    title: "Licences",
                    subtitle: "Bibliothèques tierces",
                    icon: "doc.badge.gearshape.fill",
                    action: {}
                )
            }
        }
    }
}

struct ModernSettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    let content: Content
    
    init(title: String, icon: String, iconColor: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.surface)
            .cornerRadius(12)
        }
    }
}

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.accent)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: AppColors.accent))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct SettingsActionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    var titleColor: Color = AppColors.text
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(titleColor == AppColors.text ? AppColors.accent : titleColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(titleColor)
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct VersionInfoView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("BetAndPlay Casino")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.text)
            
            Text("Version 1.0.0 (Build 1)")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
            
            Text("© 2025 BetAndPlay. Tous droits réservés.")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
    }
}

struct AboutSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo et nom
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(AppColors.accent.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "suit.spade.fill")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(AppColors.accent)
                        }
                        
                        VStack(spacing: 8) {
                            Text("BetAndPlay Casino")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppColors.text)
                            
                            Text("L'expérience casino ultime")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 16) {
                        Text("À propos de l'application")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppColors.text)
                        
                        Text("BetAndPlay Casino vous offre une expérience de jeu authentique avec vos jeux de casino préférés. Jouez au Blackjack, à la Roulette, au Poker et bien plus encore dans un environnement sécurisé et amusant.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    // Fonctionnalités
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Fonctionnalités")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppColors.text)
                        
                        VStack(spacing: 12) {
                            FeatureRow(icon: "suit.spade.fill", title: "Jeux de casino classiques", description: "Blackjack, Roulette, Poker, Baccarat")
                            FeatureRow(icon: "person.2.fill", title: "Multijoueur", description: "Jouez avec vos amis en ligne")
                            FeatureRow(icon: "trophy.fill", title: "Tournois", description: "Participez à des compétitions")
                            FeatureRow(icon: "gift.fill", title: "Récompenses quotidiennes", description: "Jetons gratuits chaque jour")
                        }
                    }
                    
                    // Informations techniques
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Informations")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppColors.text)
                        
                        VStack(spacing: 8) {
                            ModernInfoRow(title: "Version", value: "1.0.0")
                            ModernInfoRow(title: "Build", value: "1")
                            ModernInfoRow(title: "Plateforme", value: "iOS 16.0+")
                            ModernInfoRow(title: "Développé avec", value: "SwiftUI")
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
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

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.accent)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Text(description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
    }
}

struct ModernInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.text)
        }
    }
}

#Preview {
    ModernSettingsView()
        .environmentObject(AuthStore.shared)
}
