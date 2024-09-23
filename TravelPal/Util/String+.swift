//
//  String+.swift
//  TravelPal
//
//  Created by Alexia Aldea on 15.06.2024.
//

import SwiftUI

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9\\+\\.\\_\\%\\-]{1,256}@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func replaceSpacesWithUnderscores() -> String {
        return self.replacingOccurrences(of: " ", with: "_")
    }
}
