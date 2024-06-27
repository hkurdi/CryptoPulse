 //
//  HomeView.swift
//  CryptoPulse
//
//  Created by HLK on 6/20/24.
//

import SwiftUI

struct HomeView: View {
    
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var isDarkMode: Bool
    
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    
    var body: some View {
        ZStack {
//            background layer
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            
//            content layer
            VStack {
                HomeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                if(!showPortfolio) {
                    allCoinsList
                    .transition(.move(edge: .leading))
                } else {
                    ZStack(alignment: .top) {
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                            noCoinsInPortfolio
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
           
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView(isDarkMode: $isDarkMode)
            })
        }
        .background(
            NavigationStack {
                EmptyView()
                    .navigationDestination(isPresented: $showDetailView) {
                        DetailLoadingView(coin: $selectedCoin)
                }
            }
        )
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView(isDarkMode: .constant(false)).toolbar(.hidden)
        }
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var HomeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "pencil" : "info")
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .animation(.none, value: showPortfolio)
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(nil, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                    CoinRowView(coin: coin, showHoldingsColumn: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                        .onTapGesture {
                            segue(coin: coin)
                        }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            vm.reloadData()
        }
    }
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins, content: { coin in CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            })
        }
        .listStyle(PlainListStyle())
    }
    
    private var noCoinsInPortfolio: some View {
        Text("You have not added any coins to your portfolio yet.")
            .font(.callout)
            .foregroundStyle(Color.theme.secondaryText)
            .multilineTextAlignment(.center)
            .padding(70)
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
