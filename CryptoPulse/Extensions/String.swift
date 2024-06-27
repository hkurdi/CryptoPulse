//
//  String.swift
//  CryptoPulse
//
//  Created by HLK on 6/25/24.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
