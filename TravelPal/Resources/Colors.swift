//
//  CustomColors.swift
//  TravelPal
//
//  Created by Aldea Alexia on 10.08.2023.
//

import Foundation
import SwiftUI

extension Color {
    static let accentMain = Color(hex: "#D8263E")
    static let contentSecondary = Color(hex: "#91909B")
    static let bgSecondary = Color(hex: "#F5F5F5")
    static let accentTertiary = Color(hex: "#1B998B")
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: 0, green: 0, blue: 0, opacity: 0)
            return
        }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            self.init(red: 0, green: 0, blue: 0, opacity: 0)
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
