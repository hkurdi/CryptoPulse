import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            print("Invalid URL")
            return
        }
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching market data")
                case .failure(let error):
                    print("Error fetching market data: \(error)")
                }
            }, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                print("Received market data: \(String(describing: returnedGlobalData.data))")
                self?.marketDataSubscription?.cancel()
            })
    }
}
