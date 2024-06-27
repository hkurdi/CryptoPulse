import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        PortfolioInputSection
                    }
                    
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(dismiss: _dismiss)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            }
            .onChange(of: vm.searchText) { oldValue, newValue in
                if newValue.isEmpty {
                    removeSelectedCoin()
                }
            }
            .overlay(
                ZStack {
                    if showCheckmark {
                        ModalView(modalText: "Saved!", time: 0.93, iconName: "checkmark.circle.fill", show: $showCheckmark)
                    }
                }
            )
        }
    }
}
    
struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.bouncy) {
//                                selectedCoin = coin
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1))
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        })
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
            
        
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var PortfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimal() ?? "")
            }
            .withoutAnimation()
            .padding()
            .font(.headline)
            Divider()
            HStack {
                Text("Amount Holding: ")
                Spacer()
                TextField("Example: 1.0", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            .withoutAnimation()
            .padding()
            .font(.headline)
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimal())
            }
            .withoutAnimation()
            .padding()
            .font(.headline)
        }
    }
    
    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Button(action: {
                saveButtonPressed()
            }) {
                Text("Save".uppercased())
            }
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)
        }
        .font(.headline)
    }
    
    private func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
            else { return }
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            showCheckmark = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.93) {
                withAnimation(.easeInOut) {
                    removeSelectedCoin()
                }
            }
         }
        
        UIApplication.shared.endEditing()
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
