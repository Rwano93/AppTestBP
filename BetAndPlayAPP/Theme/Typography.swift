import SwiftUI

struct AppTypography {
    // Titres
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let title1 = Font.system(size: 28, weight: .semibold, design: .default)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .default)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
    
    // Corps de texte
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    
    // Chiffres monospaces pour les soldes
    static let balance = Font.system(size: 24, weight: .semibold, design: .monospaced)
    static let balanceLarge = Font.system(size: 32, weight: .bold, design: .monospaced)
    static let balanceSmall = Font.system(size: 16, weight: .medium, design: .monospaced)
    
    // Texte spécialisé
    static let button = Font.system(size: 17, weight: .semibold, design: .default)
    static let label = Font.system(size: 14, weight: .medium, design: .default)
    static let chip = Font.system(size: 12, weight: .bold, design: .default)
}

// Extensions pour les styles de texte
extension Text {
    func largeTitleStyle() -> some View {
        self.font(AppTypography.largeTitle)
            .foregroundColor(AppColors.text)
    }
    
    func titleStyle() -> some View {
        self.font(AppTypography.title1)
            .foregroundColor(AppColors.text)
    }
    
    func headlineStyle() -> some View {
        self.font(AppTypography.headline)
            .foregroundColor(AppColors.text)
    }
    
    func bodyStyle() -> some View {
        self.font(AppTypography.body)
            .foregroundColor(AppColors.text)
    }
    
    func balanceStyle() -> some View {
        self.font(AppTypography.balance)
            .foregroundColor(AppColors.gold)
    }
    
    func chipStyle() -> some View {
        self.font(AppTypography.chip)
            .foregroundColor(AppColors.text)
    }
    
    func secondaryStyle() -> some View {
        self.font(AppTypography.subheadline)
            .foregroundColor(AppColors.textSecondary)
    }
}
