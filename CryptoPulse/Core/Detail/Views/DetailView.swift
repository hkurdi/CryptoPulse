//
//  DetailView.swift
//  CryptoPulse
//
//  Created by HLK on 6/25/24.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
    
}

struct DetailView: View {
    
    let coin: CoinModel
    
    @StateObject private var vm: DetailViewModel
    @State private var showFullDesc: Bool = false
    
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        self.coin = coin
        _vm =  StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initalizing details for the coin: \(coin.name)")
    }
    
    
    var body: some View {
        ScrollView {
            
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}


extension DetailView {
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descSection: some View {
        ZStack {
            if let coinDesc = vm.coinDescription, !coinDesc.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDesc)
                        .lineLimit(showFullDesc ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                        .transition(.opacity)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDesc.toggle()
                        }
                    }, label: {
                        Text(showFullDesc ? "Collapse" : "Read more..")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.vertical, 4)
                    })
                    .tint(.cyan)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
                
        }
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }

    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = vm.websiteURL, let websiteURL = URL(string: websiteString) {
                Link("Website", destination: websiteURL)
            }
            if let redditString = vm.redditURL, let redditURL = URL(string: redditString) {
                Link("Reddit", destination: redditURL)
            }
        }
        .tint(.cyan)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
}
