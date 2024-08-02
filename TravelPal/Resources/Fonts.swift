//
//  CustomFont.swift
//  TravelPal
//
//  Created by Aldea Alexia on 09.08.2023.
//

import Foundation
import SwiftUI
import UIKit

fileprivate enum PoppinsFontNames: String {
    case bold = "Poppins-Bold"
    case semiBold = "Poppins-SemiBold"
    case regular = "Poppins-Regular"
}

extension Font {
    enum Poppins {
        static func bold(size: CGFloat) -> Font {
            return Font.custom(PoppinsFontNames.bold.rawValue, size: size)
        }
        
        static func semiBold(size: CGFloat) -> Font {
            return Font.custom(PoppinsFontNames.semiBold.rawValue, size: size)
        }
        
        static func regular(size: CGFloat) -> Font {
            return Font.custom(PoppinsFontNames.regular.rawValue, size: size)
        }
    }
}

extension UIFont {
    
    enum Poppins {
        static func bold(size: CGFloat) -> UIFont {
            return UIFont(name: PoppinsFontNames.bold.rawValue, size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            return UIFont(name: PoppinsFontNames.semiBold.rawValue, size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            return UIFont(name: PoppinsFontNames.regular.rawValue, size: size)!
        }
    }
}
