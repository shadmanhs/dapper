//
//  ContentView.swift
//  Dapper
//
//  Created by zahin on 11/6/24.
//

import SwiftUI
import PassKit

struct ContentView: View {
    @State private var showApplePayRequest = true
    @State private var showCardSelection = false
    @State private var selectedCard: PKPaymentMethod?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    if showApplePayRequest {
                        Button(action: {
                            requestApplePayAccess()
                        }) {
                            Text("Request Apple Pay Access")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Button(action: {
                            showCardSelection = true
                        }) {
                            Text("Select Payment Card")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        if let card = selectedCard {
                            SelectedCardView(card: card)
                            
                            Button(action: {
                                initiatePayment()
                            }) {
                                Text("Pay with Selected Card")
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: CardDetailsView(selectedCard: card)) {
                                Text("View Card Details")
                                    .padding()
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dapper")
            .sheet(isPresented: $showCardSelection) {
                CardSelectionView(selectedCard: $selectedCard)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                requestApplePayAccess()
            }
        }
    }
    
    func requestApplePayAccess() {
        let paymentNetworks = [PKPaymentNetwork.visa, .masterCard, .amex]
        if PKPaymentAuthorizationController.canMakePayments(usingNetworks: paymentNetworks) {
            showApplePayRequest = false
            print("Apple Pay is available")
        } else {
            print("Apple Pay is not available")
        }
    }
    
    func initiatePayment() {
        print("Initiating payment with selected card")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
