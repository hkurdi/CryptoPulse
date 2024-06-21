//
//  CryptoPulseApp.swift
//  CryptoPulse
//
//  Created by HLK on 6/20/24.
//

import SwiftUI

@main
struct CryptoPulseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
