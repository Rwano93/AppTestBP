import SwiftUI

struct DailyRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dailyRewardService: DailyRewardService
    @EnvironmentObject var walletStore: WalletStore
    
    @State private var showingRewardAnimation = false
    @State private var selectedDay: Int = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header avec statistiques
                        DailyRewardHeader()
                        
                        // Grille des récompenses
                        DailyRewardGrid()
                        
                        // Bonus de série
                        if dailyRewardService.currentStreak > 0 {
                            StreakBonusCard()
                        }
                        
                        // Progression de la série
                        StreakProgressCard()
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Récompenses Quotidiennes")
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
        .overlay(
            // Animation de récompense
            Group {
                if showingRewardAnimation {
                    RewardAnimationView()
                }
            }
        )
    }
}

struct DailyRewardHeader: View {
    @EnvironmentObject var dailyRewardService: DailyRewardService
    
    var body: some View {
        VStack(spacing: 16) {
            // Titre principal
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SÉRIE QUOTIDIENNE")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("Récompenses croissantes")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.text)
                }
                
                Spacer()
                
                // Statistiques rapides
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Série actuelle")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("\(dailyRewardService.currentStreak) jours")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.accent)
                }
            }
            
            // Cartes de statistiques
            HStack(spacing: 12) {
                DailyRewardStatCard(
                    title: "Série actuelle",
                    value: "\(dailyRewardService.currentStreak) jours",
                    icon: "flame.fill",
                    color: AppColors.warning
                )
                
                DailyRewardStatCard(
                    title: "Total réclamé",
                    value: "\(calculateTotalClaimed().formatted()) ₿",
                    icon: "coins.fill",
                    color: AppColors.gold
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surface)
        )
    }
    
    private func calculateTotalClaimed() -> Int {
        var total = 0
        for day in 1...dailyRewardService.currentStreak {
            total += dailyRewardService.getRewardForDay(day)
        }
        return total
    }
}

struct DailyRewardGrid: View {
    @EnvironmentObject var dailyRewardService: DailyRewardService
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Calendrier des récompenses")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 7), spacing: 12) {
                ForEach(1...30, id: \.self) { day in
                    DailyRewardDayView(
                        day: day,
                        reward: dailyRewardService.getRewardForDay(day),
                        isClaimed: dailyRewardService.isRewardClaimed(for: day),
                        isAvailable: day <= dailyRewardService.currentStreak + 1,
                        isToday: day == dailyRewardService.currentStreak + 1
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surface)
        )
    }
}

struct DailyRewardDayView: View {
    let day: Int
    let reward: Int
    let isClaimed: Bool
    let isAvailable: Bool
    let isToday: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            // Icône du jour
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 40, height: 40)
                
                if isClaimed {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.success)
                } else if isToday && isAvailable {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.gold)
                } else if isAvailable {
                    Image(systemName: "circle")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.textSecondary)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.textSecondary.opacity(0.5))
                }
            }
            
            // Numéro du jour
            Text("\(day)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(textColor)
            
            // Récompense
            Text("\(reward.formatted())")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(rewardColor)
                .lineLimit(1)
        }
        .frame(width: 50, height: 70)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(dayBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: isToday ? 2 : 0)
        )
    }
    
    private var backgroundColor: Color {
        if isClaimed {
            return AppColors.success.opacity(0.2)
        } else if isToday && isAvailable {
            return AppColors.gold.opacity(0.2)
        } else if isAvailable {
            return AppColors.accent.opacity(0.1)
        } else {
            return AppColors.textSecondary.opacity(0.1)
        }
    }
    
    private var dayBackgroundColor: Color {
        if isClaimed {
            return AppColors.success.opacity(0.1)
        } else if isToday && isAvailable {
            return AppColors.gold.opacity(0.1)
        } else {
            return AppColors.surface
        }
    }
    
    private var textColor: Color {
        if isClaimed {
            return AppColors.success
        } else if isToday && isAvailable {
            return AppColors.gold
        } else if isAvailable {
            return AppColors.text
        } else {
            return AppColors.textSecondary.opacity(0.5)
        }
    }
    
    private var rewardColor: Color {
        if isClaimed {
            return AppColors.success
        } else if isToday && isAvailable {
            return AppColors.gold
        } else if isAvailable {
            return AppColors.textSecondary
        } else {
            return AppColors.textSecondary.opacity(0.3)
        }
    }
    
    private var borderColor: Color {
        if isToday && isAvailable {
            return AppColors.gold
        } else {
            return Color.clear
        }
    }
}

struct StreakBonusCard: View {
    @EnvironmentObject var dailyRewardService: DailyRewardService
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "star.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.gold)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Bonus de série")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Text("Continuez pour débloquer des bonus")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Prochain bonus")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text("\(getNextBonusDay())")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.gold)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surface)
        )
    }
    
    private func getNextBonusDay() -> String {
        let currentStreak = dailyRewardService.currentStreak
        let bonusDays = [7, 14, 21, 30]
        
        if let nextBonus = bonusDays.first(where: { $0 > currentStreak }) {
            return "Jour \(nextBonus)"
        } else {
            return "Max atteint"
        }
    }
}

struct StreakProgressCard: View {
    @EnvironmentObject var dailyRewardService: DailyRewardService
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Progression de la série")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Text("\(dailyRewardService.currentStreak)/30")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            // Barre de progression
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.textSecondary.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.accent, AppColors.gold],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
            
            // Indicateurs de bonus
            HStack(spacing: 20) {
                ForEach([7, 14, 21, 30], id: \.self) { bonusDay in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(bonusDay <= dailyRewardService.currentStreak ? AppColors.gold : AppColors.textSecondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                        
                        Text("\(bonusDay)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(bonusDay <= dailyRewardService.currentStreak ? AppColors.gold : AppColors.textSecondary.opacity(0.5))
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surface)
        )
    }
    
    private var progress: Double {
        return Double(dailyRewardService.currentStreak) / 30.0
    }
}

struct DailyRewardStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.background)
        )
    }
}

struct RewardAnimationView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "gift.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.gold)
                
                Text("Récompense récupérée !")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Continuez votre série quotidienne")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    DailyRewardView()
        .environmentObject(DailyRewardService.shared)
        .environmentObject(WalletStore.shared)
}
