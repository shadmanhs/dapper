import SwiftUI
import PassKit

// MARK: - Models

struct Transaction: Identifiable {
    let id = UUID()
    let merchant: String
    let amount: Double
    let date: Date
    let location: String
}

// MARK: - Views

struct CardDetailsView: View {
    let selectedCard: PKPaymentMethod
    @State private var transactions: [Transaction] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CardView(card: selectedCard)
                    .frame(height: 200)
                    .padding(.horizontal)
                
                TransactionListView(transactions: transactions)
            }
        }
        .navigationTitle("Card Details")
        .onAppear {
            loadTransactions()
        }
    }
    
    private func loadTransactions() {
        // TODO: Replace this with actual data fetching logic
        transactions = [
            Transaction(merchant: "Costco Whse #0243", amount: 21.37, date: Date().addingTimeInterval(-86400), location: "New York, NY"),
            Transaction(merchant: "Khaamar Baari Supermar", amount: 24.43, date: Date().addingTimeInterval(-172800), location: "New York, NY"),
            Transaction(merchant: "TST* bb.q Chicken Usa - K", amount: 29.36, date: Date().addingTimeInterval(-432000), location: "New York, NY"),
            Transaction(merchant: "Halal Top Grill", amount: 9.79, date: Date().addingTimeInterval(-518400), location: "New York, NY"),
            Transaction(merchant: "Lava Restaurant And Cafe", amount: 38.50, date: Date().addingTimeInterval(-604800), location: "New York, NY")
        ]
    }
}

struct CardView: View {
    let card: PKPaymentMethod
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(card.network?.rawValue ?? "VISA")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(card.displayName ?? "JANE DOE")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack {
                    Text("**** 5455")
                        .font(.callout)
                        .foregroundColor(.white)
                    Spacer()
                    Text("06/27")
                        .font(.callout)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
    }
}

struct TransactionListView: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Latest Transactions")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(transactions) { transaction in
                TransactionRow(transaction: transaction)
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.merchant)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(transaction.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(transaction.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(String(format: "$%.2f", transaction.amount))
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct SelectedCardView: View {
    let card: PKPaymentMethod
    
    var body: some View {
        HStack {
            Text("Selected Card:")
                .font(.headline)
            Text(card.displayName ?? "Unknown Card")
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

// Preview
struct CardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CardDetailsView(selectedCard: PKPaymentMethod())
        }
    }
}
