//
//  DetailViewModel.swift
//  CryptoPulse
//
//  Created by HLK on 6/25/24.
//

import Foundation
import Combine


class DetailViewModel: ObservableObject {
        
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    
    @Published var coin: CoinModel
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStats)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)

    }
    
    
    private func mapDataToStats(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)
        return (overviewArray, additionalArray)
    }
    
    
private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith6Decimal()
        let changeInPricePercent = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: changeInPricePercent)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let changeInMarketCap = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: changeInMarketCap)
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)

        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
        priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }
    
private func createAdditionalArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticModel] {
        let high = coinModel.low24H?.asCurrencyWith6Decimal() ?? "N/A"
        let highStat = StatisticModel(title: "24H High", value: high)
        let low = coinModel.low24H?.asCurrencyWith6Decimal() ?? "N/A"
        let lowStat = StatisticModel(title: "24H Low", value: low)
        let changeInPrice = coinModel.priceChange24H?.asCurrencyWith6Decimal() ?? "N/A"
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24H Price Change", value: changeInPrice, percentageChange: pricePercentageChange)
        let marketCapChange = "$" + (coinModel.marketCapChangePercentage24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24H Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        let hashing = coinDetailModel?.hashingAlgorithm ?? "N/A"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
        highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return additionalArray
    }
    
}
