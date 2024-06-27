//
//  PortfolioDataService.swift
//  CryptoPulse
//
//  Created by HLK on 6/24/24.
//

import Foundation
import CoreData


class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let portfolioEntityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores {
            (_, error) in if let error = error {
                print("Error: Core Data has not been loaded. Error: \(error)")
            }
            self.getPortfolio()
        }
    }
    
    //MARK: PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        if let entity = savedEntities.first(where: { $0.coinID == coin.id } ) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                remove(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: portfolioEntityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Portfolio entities have not been fetched. Error: \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error: Core data has not been saved. Error: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}
