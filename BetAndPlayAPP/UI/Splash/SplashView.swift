import SwiftUI

struct SplashView: View {
    @EnvironmentObject var router: Router
    @State private var progress: Double = 0
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Arrière-plan avec dégradé
            LinearGradient(
                colors: [AppColors.background, AppColors.primary.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Logo CasinoX avec animation
                VStack(spacing: 20) {
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 100))
                        .foregroundColor(AppColors.gold)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    Text("CasinoX")
                        .font(AppTypography.largeTitle)
                        .foregroundColor(AppColors.gold)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    Text("L'expérience casino la plus immersive")
                        .font(AppTypography.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                        .opacity(logoOpacity)
                }
                
                // Barre de progression
                VStack(spacing: 15) {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: AppColors.accent))
                        .frame(width: 250, height: 8)
                        .scaleEffect(y: 2)
                        .cornerRadius(4)
                    
                    Text("Chargement... \(Int(progress * 100))%")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Animation du logo
        withAnimation(.easeOut(duration: 1.0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Animation de la barre de progression
        withAnimation(.easeInOut(duration: 2.5)) {
            progress = 1.0
        }
        
        // Navigation automatique après 3 secondes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            router.navigate(to: .auth)
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(Router())
}
