import SwiftUI
import PassKit
import Contacts

// Your imports remain the same

struct CardSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCard: PKPaymentMethod?
    @State private var availableCards: [MockPaymentMethod] = []
    
    var body: some View {
        NavigationView {
            List(availableCards) { card in
                Button(action: {
                    selectedCard = card.paymentMethod
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(card.displayName)
                        Spacer()
                        // Change this comparison
                        if selectedCard?.displayName == card.displayName {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationTitle("Select a Card")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            loadMockCards()
        }
    }
    
    private func loadMockCards() {
        availableCards = [
            MockPaymentMethod(id: "1", displayName: "Visa •••• 1234", network: .visa),
            MockPaymentMethod(id: "2", displayName: "Mastercard •••• 5678", network: .masterCard),
            MockPaymentMethod(id: "3", displayName: "American Express •••• 9012", network: .amex)
        ]
    }
}

// Replace MockPaymentMethod struct and extension with this
struct MockPaymentMethod: Identifiable {
    let id: String
    let paymentMethod: PKPaymentMethod
    
    var displayName: String {
        return paymentMethod.displayName ?? "Unknown Card"
    }
    
    init(id: String, displayName: String, network: PKPaymentNetwork) {
        self.id = id
        self.paymentMethod = MockPKPaymentMethod(displayName: displayName, network: network)
    }
}

// Add this new class
class MockPKPaymentMethod: PKPaymentMethod {
    override var displayName: String? {
        return _displayName
    }
    
    override var network: PKPaymentNetwork? {
        return _network
    }
    
    private let _displayName: String?
    private let _network: PKPaymentNetwork?
    
    init(displayName: String?, network: PKPaymentNetwork?) {
        self._displayName = displayName
        self._network = network
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct CardSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardSelectionView(selectedCard: .constant(nil))
    }
}
