import SwiftUI

struct ShopView: View {
    @EnvironmentObject var storeKitService: StoreKitService
    @EnvironmentObject var walletStore: WalletStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: ShopCategory = .chips
    
    enum ShopCategory: String, CaseIterable {
        case chips = "Jetons"
        case gems = "Gemmes"
        case battlepass = "Battle Pass"
        
        var icon: String {
            switch self {
            case .chips: return "coins.fill"
            case .gems: return "diamond.fill"
            case .battlepass: return "star.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // En-tête avec soldes
                    ShopHeaderView()
                    
                    // Catégories
                    CategorySelectorView(selectedCategory: $selectedCategory)
                    
                    // Produits
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                            ForEach(getProductsForCategory(), id: \.id) { product in
                                ProductCard(product: product)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Boutique")
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
    
    private func getProductsForCategory() -> [MockProduct] {
        switch selectedCategory {
        case .chips:
            return [
                MockProduct(id: "chips_2m", name: "Pack Jetons", description: "2 000 000 jetons", price: "2.99 €", amount: 2_000_000, type: .chips),
                MockProduct(id: "chips_10m", name: "Pack Jetons", description: "10 000 000 jetons", price: "9.99 €", amount: 10_000_000, type: .chips),
                MockProduct(id: "chips_30m", name: "Pack Jetons", description: "30 000 000 jetons", price: "24.99 €", amount: 30_000_000, type: .chips),
                MockProduct(id: "chips_120m", name: "Pack Jetons", description: "120 000 000 jetons", price: "89.99 €", amount: 120_000_000, type: .chips)
            ]
        case .gems:
            return [
                MockProduct(id: "gems_2000", name: "Pack Gemmes", description: "2 000 gemmes", price: "4.99 €", amount: 2000, type: .gems),
                MockProduct(id: "gems_5000", name: "Pack Gemmes", description: "5 000 gemmes", price: "9.99 €", amount: 5000, type: .gems),
                MockProduct(id: "gems_12000", name: "Pack Gemmes", description: "12 000 gemmes", price: "19.99 €", amount: 12000, type: .gems)
            ]
        case .battlepass:
            return [
                MockProduct(id: "battlepass_premium", name: "Battle Pass Premium", description: "Accès premium + récompenses", price: "9.99 €", amount: 0, type: .battlepass)
            ]
        }
    }
}

struct ShopHeaderView: View {
    @EnvironmentObject var walletStore: WalletStore
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("₿")
                        .font(AppTypography.balanceSmall)
                        .foregroundColor(AppColors.gold)
                    
                    Text(walletStore.balance.chips.formatted())
                        .font(AppTypography.balanceSmall)
                        .foregroundColor(AppColors.gold)
                }
                
                HStack(spacing: 8) {
                    Text("💎")
                        .font(AppTypography.caption)
                    
                    Text(walletStore.balance.gems.formatted())
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.accent)
                }
            }
            
            Spacer()
            
            Image(systemName: "cart.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.accent)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(AppColors.surface)
        .cornerRadius(16)
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

struct CategorySelectorView: View {
    @Binding var selectedCategory: ShopView.ShopCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(ShopView.ShopCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 15)
    }
}

struct CategoryButton: View {
    let category: ShopView.ShopCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? AppColors.text : AppColors.textSecondary)
                
                Text(category.rawValue)
                    .font(AppTypography.body)
                    .foregroundColor(isSelected ? AppColors.text : AppColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? AppColors.primary : AppColors.card)
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProductCard: View {
    let product: MockProduct
    @State private var isPurchasing = false
    
    var body: some View {
        VStack(spacing: 15) {
            // Icône du produit
            ZStack {
                Circle()
                    .fill(getProductColor().opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: getProductIcon())
                    .font(.system(size: 36))
                    .foregroundColor(getProductColor())
            }
            
            // Informations du produit
            VStack(spacing: 8) {
                Text(product.name)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.text)
                
                Text(product.description)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                
                Text(product.price)
                    .font(AppTypography.balanceSmall)
                    .foregroundColor(AppColors.gold)
                    .fontWeight(.semibold)
            }
            
            // Bouton d'achat
            Button(action: {
                isPurchasing = true
                // Simuler l'achat
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isPurchasing = false
                }
            }) {
                HStack {
                    if isPurchasing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Acheter")
                            .font(AppTypography.button)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(AppColors.primary)
                .cornerRadius(12)
            }
            .disabled(isPurchasing)
        }
        .padding(20)
        .background(AppColors.card)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private func getProductColor() -> Color {
        switch product.type {
        case .chips: return AppColors.gold
        case .gems: return AppColors.accent
        case .battlepass: return AppColors.warning
        }
    }
    
    private func getProductIcon() -> String {
        switch product.type {
        case .chips: return "coins.fill"
        case .gems: return "diamond.fill"
        case .battlepass: return "star.fill"
        }
    }
}

struct MockProduct {
    let id: String
    let name: String
    let description: String
    let price: String
    let amount: Int
    let type: ShopView.ShopCategory
}

#Preview {
    ShopView()
        .environmentObject(StoreKitService.shared)
        .environmentObject(WalletStore.shared)
}
