//
//  Date.swift
//  CryptoPulse
//
//  Created by HLK on 6/25/24.
//

import Foundation

extension Date {
    
    
    
    init(cgString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: cgString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateStr() -> String {
        return shortFormatter.string(from: self)
    }
    
}
