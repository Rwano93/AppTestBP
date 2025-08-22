import SwiftUI

struct ModernShopView: View {
    @EnvironmentObject var storeKitService: StoreKitService
    @EnvironmentObject var walletStore: WalletStore
    @State private var selectedCategory: ShopCategory = .tokens
    @State private var showingPurchaseConfirmation = false
    @State private var selectedProduct: ShopProduct?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ModernShopHeaderView()
            
            // Catégories
            ShopCategorySelector(selectedCategory: $selectedCategory)
            
            // Contenu
            TabView(selection: $selectedCategory) {
                TokensShopView(selectedProduct: $selectedProduct, showingPurchase: $showingPurchaseConfirmation)
                    .tag(ShopCategory.tokens)
                
                GemsShopView(selectedProduct: $selectedProduct, showingPurchase: $showingPurchaseConfirmation)
                    .tag(ShopCategory.gems)
                
                SpecialOffersView(selectedProduct: $selectedProduct, showingPurchase: $showingPurchaseConfirmation)
                    .tag(ShopCategory.offers)
                
                PowerupsShopView(selectedProduct: $selectedProduct, showingPurchase: $showingPurchaseConfirmation)
                    .tag(ShopCategory.powerups)
                
                GoldShopView(selectedProduct: $selectedProduct, showingPurchase: $showingPurchaseConfirmation)
                    .tag(ShopCategory.gold)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(AppColors.background)
        .sheet(item: $selectedProduct) { product in
            PurchaseConfirmationSheet(product: product)
        }
    }
}

enum ShopCategory: String, CaseIterable {
    case tokens = "Jetons"
    case gems = "Autre"
    case offers = "Lancers gratuits"
    case powerups = "Power Hands"
    case gold = "Or"
    
    var icon: String {
        switch self {
        case .tokens: return "circle.fill"
        case .gems: return "diamond.fill"
        case .offers: return "gift.fill"
        case .powerups: return "bolt.fill"
        case .gold: return "crown.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .tokens: return AppColors.gold
        case .gems: return AppColors.accent
        case .offers: return AppColors.success
        case .powerups: return AppColors.chipRed
        case .gold: return AppColors.gold
        }
    }
}

struct ShopProduct: Identifiable {
    let id = UUID()
    let name: String
    let amount: String
    let price: String
    let originalPrice: String?
    let discount: String?
    let bonus: String?
    let isPopular: Bool
    let isBestValue: Bool
    let category: ShopCategory
    let productId: String
}

struct ModernShopHeaderView: View {
    @EnvironmentObject var walletStore: WalletStore
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Boutique")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            // Wallet display étendu
            HStack(spacing: 16) {
                WalletCard(
                    icon: "circle.fill",
                    color: AppColors.gold,
                    title: "Jetons",
                    amount: formatLargeNumber(walletStore.balance.chips)
                )
                
                WalletCard(
                    icon: "diamond.fill",
                    color: AppColors.accent,
                    title: "Gemmes",
                    amount: "\(walletStore.balance.gems)"
                )
                
                WalletCard(
                    icon: "crown.fill",
                    color: AppColors.gold,
                    title: "Or",
                    amount: "0"
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private func formatLargeNumber(_ number: Int) -> String {
        if number >= 1_000_000_000 {
            return String(format: "%.1fB", Double(number) / 1_000_000_000)
        } else if number >= 1_000_000 {
            return String(format: "%.1fM", Double(number) / 1_000_000)
        } else if number >= 1_000 {
            return String(format: "%.1fK", Double(number) / 1_000)
        } else {
            return "\(number)"
        }
    }
}

struct WalletCard: View {
    let icon: String
    let color: Color
    let title: String
    let amount: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(amount)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(AppColors.text)
                
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppColors.surface)
        .cornerRadius(12)
    }
}

struct ShopCategorySelector: View {
    @Binding var selectedCategory: ShopCategory
    @Namespace private var categoryIndicator
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ShopCategory.allCases, id: \.self) { category in
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedCategory = category
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: category.icon)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedCategory == category ? .white : category.color)
                            
                            Text(category.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedCategory == category ? .white : AppColors.text)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedCategory == category ? category.color : AppColors.surface)
                                .matchedGeometryEffect(
                                    id: selectedCategory == category ? "category_bg" : "",
                                    in: categoryIndicator
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

struct TokensShopView: View {
    @Binding var selectedProduct: ShopProduct?
    @Binding var showingPurchase: Bool
    
    let tokenProducts = [
        ShopProduct(
            name: "JETONS GRATUITS",
            amount: "Bonus quotidien",
            price: "GRATUIT",
            originalPrice: nil,
            discount: nil,
            bonus: "Récupérez chaque jour",
            isPopular: false,
            isBestValue: false,
            category: .tokens,
            productId: "free_tokens"
        ),
        ShopProduct(
            name: "2M JETONS",
            amount: "2,000,000",
            price: "2,99 €",
            originalPrice: nil,
            discount: nil,
            bonus: nil,
            isPopular: false,
            isBestValue: false,
            category: .tokens,
            productId: "tokens_2m"
        ),
        ShopProduct(
            name: "10M JETONS",
            amount: "10,000,000",
            price: "9,99 €",
            originalPrice: nil,
            discount: nil,
            bonus: "+2M Bonus",
            isPopular: true,
            isBestValue: false,
            category: .tokens,
            productId: "tokens_10m"
        ),
        ShopProduct(
            name: "30M JETONS",
            amount: "30,000,000",
            price: "22,99 €",
            originalPrice: "29,99 €",
            discount: "SUPER OFFRE",
            bonus: "+10M Bonus",
            isPopular: false,
            isBestValue: false,
            category: .tokens,
            productId: "tokens_30m"
        ),
        ShopProduct(
            name: "120M JETONS",
            amount: "120,000,000",
            price: "59,99 €",
            originalPrice: "79,99 €",
            discount: "25% OFF",
            bonus: "+40M Bonus",
            isPopular: false,
            isBestValue: true,
            category: .tokens,
            productId: "tokens_120m"
        ),
        ShopProduct(
            name: "350M JETONS",
            amount: "350,000,000",
            price: "99,99 €",
            originalPrice: "139,99 €",
            discount: "MEILLEUR PRIX",
            bonus: "+150M Bonus",
            isPopular: false,
            isBestValue: false,
            category: .tokens,
            productId: "tokens_350m"
        )
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                ForEach(tokenProducts, id: \.id) { product in
                    ModernProductCard(product: product) {
                        selectedProduct = product
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
}

struct GemsShopView: View {
    @Binding var selectedProduct: ShopProduct?
    @Binding var showingPurchase: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Autres Achats")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ComingSoonCard(title: "Gemmes Premium", description: "Achetez des gemmes pour débloquer des fonctionnalités exclusives")
                    ComingSoonCard(title: "Avatars Spéciaux", description: "Collection d'avatars uniques et animés")
                    ComingSoonCard(title: "Thèmes de Table", description: "Personnalisez l'apparence de vos tables de jeu")
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct SpecialOffersView: View {
    @Binding var selectedProduct: ShopProduct?
    @Binding var showingPurchase: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Lancers Gratuits")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ComingSoonCard(title: "Machine à Sous", description: "Tentez votre chance avec nos machines à sous virtuelles")
                    ComingSoonCard(title: "Roue de la Fortune", description: "Tournez la roue pour gagner des prix quotidiens")
                    ComingSoonCard(title: "Mini-Jeux", description: "Collection de mini-jeux avec des récompenses")
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct PowerupsShopView: View {
    @Binding var selectedProduct: ShopProduct?
    @Binding var showingPurchase: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Power Hands")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ComingSoonCard(title: "Multiplicateur de Gains", description: "Doublez vos gains pendant une durée limitée")
                    ComingSoonCard(title: "Vision des Cartes", description: "Voyez la prochaine carte pendant 3 mains")
                    ComingSoonCard(title: "Chance du Débutant", description: "Augmentez vos chances de gagner temporairement")
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct GoldShopView: View {
    @Binding var selectedProduct: ShopProduct?
    @Binding var showingPurchase: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Boutique d'Or")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ComingSoonCard(title: "Lingots d'Or", description: "Monnaie premium pour les achats exclusifs")
                    ComingSoonCard(title: "Coffres Légendaires", description: "Ouvrez des coffres contenant des récompenses rares")
                    ComingSoonCard(title: "Pass VIP", description: "Accès VIP avec bonus quotidiens et avantages")
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ModernProductCard: View {
    let product: ShopProduct
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Badges
                HStack {
                    if product.isBestValue {
                        Badge(text: "MEILLEUR PRIX", color: AppColors.success)
                    } else if product.isPopular {
                        Badge(text: "POPULAIRE", color: AppColors.chipRed)
                    } else if product.discount != nil {
                        Badge(text: product.discount!, color: AppColors.warning)
                    }
                    
                    Spacer()
                }
                
                // Icône et montant
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(productColor.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: productIcon)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(productColor)
                    }
                    
                    if product.productId == "free_tokens" {
                        VStack(spacing: 4) {
                            Text(product.name)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppColors.text)
                                .multilineTextAlignment(.center)
                            
                            Text(product.amount)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    } else {
                        Text(product.amount)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(AppColors.text)
                    }
                }
                
                // Prix et bonus
                VStack(spacing: 4) {
                    if let originalPrice = product.originalPrice {
                        Text(originalPrice)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                            .strikethrough()
                    }
                    
                    Text(product.price)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(product.productId == "free_tokens" ? AppColors.success : AppColors.accent)
                    
                    if let bonus = product.bonus {
                        Text(bonus)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(AppColors.gold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(AppColors.gold.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(16)
            .background(AppColors.surface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(product.isBestValue ? AppColors.success : productColor.opacity(0.3), lineWidth: product.isBestValue ? 2 : 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var productColor: Color {
        switch product.category {
        case .tokens: return AppColors.gold
        case .gems: return AppColors.accent
        case .offers: return AppColors.success
        case .powerups: return AppColors.chipRed
        case .gold: return AppColors.gold
        }
    }
    
    private var productIcon: String {
        if product.productId == "free_tokens" {
            return "gift.fill"
        }
        return product.category.icon
    }
}

struct Badge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 8, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(8)
    }
}

struct ComingSoonCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.fill")
                .font(.system(size: 40))
                .foregroundColor(AppColors.textSecondary)
                .opacity(0.5)
            
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Text(description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Text("Bientôt Disponible")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(AppColors.accent)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(AppColors.accent.opacity(0.1))
                .cornerRadius(16)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(AppColors.surface)
        .cornerRadius(16)
    }
}

struct PurchaseConfirmationSheet: View {
    let product: ShopProduct
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Product preview
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(product.category.color.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: product.category.icon)
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(product.category.color)
                    }
                    
                    VStack(spacing: 8) {
                        Text(product.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.text)
                        
                        Text(product.amount)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.textSecondary)
                        
                        if let bonus = product.bonus {
                            Text(bonus)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.gold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(AppColors.gold.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                
                Spacer()
                
                // Purchase button
                VStack(spacing: 16) {
                    if product.productId == "free_tokens" {
                        Button(action: claimFreeTokens) {
                            HStack {
                                if isPurchasing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "gift.fill")
                                        .font(.system(size: 18))
                                }
                                
                                Text(isPurchasing ? "Récupération..." : "RÉCUPÉRER GRATUITEMENT")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.success)
                            .cornerRadius(16)
                        }
                        .disabled(isPurchasing)
                    } else {
                        Button(action: purchaseProduct) {
                            HStack {
                                if isPurchasing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "creditcard.fill")
                                        .font(.system(size: 18))
                                }
                                
                                Text(isPurchasing ? "Achat en cours..." : "ACHETER \(product.price)")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.accent)
                            .cornerRadius(16)
                        }
                        .disabled(isPurchasing)
                    }
                    
                    Button("Annuler") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(AppColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("✕") {
                        dismiss()
                    }
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
    }
    
    private func claimFreeTokens() {
        isPurchasing = true
        // Simulate claiming free tokens
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isPurchasing = false
            dismiss()
        }
    }
    
    private func purchaseProduct() {
        isPurchasing = true
        // Simulate purchase
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isPurchasing = false
            dismiss()
        }
    }
}

#Preview {
    ModernShopView()
        .environmentObject(StoreKitService.shared)
        .environmentObject(WalletStore.shared)
}
