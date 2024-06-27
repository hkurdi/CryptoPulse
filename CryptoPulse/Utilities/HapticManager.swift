//
//  HapticManager.swift
//  CryptoPulse
//
//  Created by HLK on 6/24/24.
//

import Foundation
import SwiftUI


class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
