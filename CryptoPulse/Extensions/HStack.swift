//
//  View.swift
//  CryptoPulse
//
//  Created by HLK on 6/23/24.
//

import Foundation
import SwiftUI

extension HStack {
    func withoutAnimation() -> some View {
        self.animation(nil, value: UUID())
    }
}
