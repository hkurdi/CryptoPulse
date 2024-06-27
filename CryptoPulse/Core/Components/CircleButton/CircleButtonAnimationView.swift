//
//  CircleButtonAnimationView.swift
//  CryptoPulse
//
//  Created by HLK on 6/21/24.
//

import SwiftUI



struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? .easeOut(duration: 1.0) : .none, value: animate)
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
        .foregroundStyle(Color.red)
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
}
