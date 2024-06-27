//
//  NetworkingManager.swift
//  CryptoPulse
//
//  Created by HLK on 6/22/24.
//

import Foundation
import Combine


class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let badURL): return "Error: [🌎] Bad Response from the URL: [ \(badURL) ]"
            case .unknownError: return "Error: [⚠️] An unknown error has occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
