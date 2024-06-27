//
//  Color.swift
//  CryptoPulse
//
//  Created by HLK on 6/20/24.
//

import Foundation
import SwiftUI


 
extension Color {
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    let modalColor = Color("ModalColor")
}

struct LaunchTheme {
    
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
    
}
