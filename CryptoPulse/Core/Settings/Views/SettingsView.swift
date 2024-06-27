//
//  SettingsView.swift
//  CryptoPulse
//
//  Created by HLK on 6/25/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var isDarkMode: Bool
    private let linkedinURL = URL(string: "https://www.linkedin.com/in/hamza-al-kurdi")!
    private let portfolioURL = URL(string: "https://www.whoishlk.dev")!
    private let githubURL = URL(string: "https://www.github.com/hkurdi")!
    
    
    var body: some View {
        NavigationStack {
            List {
                mainHeader
                themeChange
                stayConnected
                specialThanks
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    SettingsView(isDarkMode: .constant(false))
}


extension SettingsView {
    
    private var mainHeader: some View {
        Section (header: Text("about"), content: {
            HStack(alignment: .center, spacing: 16) {
                Image("wallet-info")
                    .resizable()
                    .frame(width: 95, height: 95)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading, spacing: 0) {
                    Text("Crypto Pulse")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .lineLimit(1)
                    Text("Version 1.0")
                        .lineLimit(1)
                        .font(.caption2)
                        .foregroundStyle(Color.theme.secondaryText)

                    Text("This project was built using Swift and SwiftUI. It features a portfolio management system, and uses MVVM architecture, Combine, and CoreData.")
                        .padding(.top)
                        .font(.caption)
                        .lineLimit(4)
                        .foregroundStyle(isDarkMode ? Color.theme.accent : Color.theme.modalColor)
                    Spacer()
                    Text("Developed by Hamza Luay Kurdi, 2024.")
                        .font(.system(size: 9.3, design: .monospaced))
                }
                .padding(.vertical)
            }
        })
    }
    
    private var themeChange: some View {
        Section(header: Text("Appearance"), content: {
               Toggle(isOn: $isDarkMode) {
                   Text("Dark Mode")
               }
               .onChange(of: isDarkMode) { oldValue, newValue in
                   withAnimation(.easeInOut) {
                       isDarkMode = newValue
                   }
               }
           })
    }
    
    private var stayConnected: some View {
        Section (header: Text("keep in touch"), content: {
            Text("Stay Connected with Me")
                .bold()
            HStack(alignment: .firstTextBaseline) {
                Link("Github", destination: githubURL)
                Spacer()
                Link("Linkedin", destination: linkedinURL)
                Spacer()
                Link("Website", destination: linkedinURL)
            }
            .tint(.blue)
            .font(.caption)
            .bold()
        })
    }
    
    private var specialThanks: some View {
        Section (header: Text("special thanks"), content: {
            Text("To whom is reading this, thank you. I came a long way from learning to make CLI calculators and quizzes with python, to learning and mastering full-Stack development using JS frameworks, to making end-to-end ML projects, and now to advanced Swift development! I would also like to give thanks to Nick Sarno for his amazing help throughout this journey, and to CoinGecko for this amazing API! Thank you! Your's truly, HLK")
        })
    }
    
}
