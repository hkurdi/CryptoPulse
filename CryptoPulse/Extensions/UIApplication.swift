//
//  UIApplication.swift
//  CryptoPulse
//
//  Created by HLK on 6/22/24.
//

import Foundation
import SwiftUI


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
