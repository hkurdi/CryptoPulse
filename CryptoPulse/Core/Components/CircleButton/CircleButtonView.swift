//
//  CircleButtonView.swift
//  CryptoPulse
//
//  Created by HLK on 6/20/24.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color.theme.background
                    ))
                    .shadow(
                        color: Color.theme.secondaryText.opacity(0.27),
                        radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 0)
                    .padding()
    }
}

#Preview {
    Group {
        CircleButtonView(iconName: "info")
            .previewLayout(.sizeThatFits)
        CircleButtonView(iconName: "plus")
            .previewLayout(.sizeThatFits).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
