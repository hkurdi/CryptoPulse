//
//  CryptoPulseApp.swift
//  CryptoPulse
//
//  Created by HLK on 6/20/24.
//

import SwiftUI

@main
struct CryptoPulseApp: App {
    
    @StateObject private var vm = HomeViewModel()

    @State private var isDarkMode: Bool = false
    @State private var showLaunchView: Bool = true

    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView(isDarkMode: $isDarkMode)
                        .toolbar(.hidden)
                }
                .environmentObject(vm)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.slide)
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
