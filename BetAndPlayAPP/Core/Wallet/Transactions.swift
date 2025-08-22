import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject var walletStore: WalletStore
    @State private var selectedCurrency: Currency = .chips
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Sélecteur de devise
                Picker("Devise", selection: $selectedCurrency) {
                    ForEach(Currency.allCases, id: \.self) { currency in
                        Text(currency.displayName)
                            .tag(currency)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Liste des transactions
                List {
                    ForEach(filteredTransactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Historique")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var filteredTransactions: [Transaction] {
        return walletStore.transactions.filter { $0.currency == selectedCurrency }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            // Icône du type de transaction
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .frame(width: 30, height: 30)
                .background(iconColor.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.text)
                
                if let gameType = transaction.gameType {
                    Text(gameType.displayName)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Text(transaction.timestamp, style: .relative)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(amountText)
                    .font(AppTypography.balanceSmall)
                    .foregroundColor(amountColor)
                    .fontWeight(.semibold)
                
                Text(transaction.currency.symbol)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var iconName: String {
        switch transaction.type {
        case .bet: return "minus.circle.fill"
        case .win: return "plus.circle.fill"
        case .loss: return "minus.circle.fill"
        case .purchase: return "cart.fill"
        case .dailyReward: return "gift.fill"
        case .battlePass: return "star.fill"
        case .referral: return "person.2.fill"
        case .bonus: return "sparkles"
        }
    }
    
    private var iconColor: Color {
        switch transaction.type {
        case .win, .dailyReward, .battlePass, .referral, .bonus:
            return AppColors.success
        case .bet, .loss, .purchase:
            return AppColors.error
        }
    }
    
    private var amountText: String {
        let sign = transaction.amount >= 0 ? "+" : ""
        return "\(sign)\(transaction.amount.formatted())"
    }
    
    private var amountColor: Color {
        return transaction.amount >= 0 ? AppColors.success : AppColors.error
    }
}

#Preview {
    TransactionsView()
        .environmentObject(WalletStore.shared)
}
