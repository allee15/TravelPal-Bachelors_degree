//
//  Buttons.swift
//  TravelPal
//
//  Created by Aldea Alexia on 21.08.2023.
//

import Foundation
import SwiftUI

struct BackButton: View {
    @EnvironmentObject private var navigation: Navigation
    var imageName: String? = "ic_nav_up"
    var action: (()->())?
    
    var body: some View {
        Button {
            if let action = action {
                action()
            } else {
                navigation.pop(animated: true)
            }
        } label: {
            if let imageName = imageName {
                Image(imageName)
                    .frame(width: 32, height: 32)
            }
        }
    }
}

struct CloseButton: View {
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        Button {
            navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
        } label: {
            Image("ic_nav_close")
                .frame(width: 32, height: 32)
        }
    }
}

struct RedButtonView: View {
    let text: String
    var action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.Poppins.semiBold(size: 14))
                .padding(.all, 12)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.accentMain)
                .cornerRadius(4, corners: .allCorners)
        }
    }
}

struct BlackButtonView: View {
    let text: String
    var isDisabled: Bool = false
    var icon: ImageResource?
    var action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            HStack (spacing: 8) {
                Text(text)
                    
                if let icon = icon {
                    Image(icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }.font(.Poppins.semiBold(size: 14))
                .padding(.all, 12)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(isDisabled ? Color.black.opacity(0.5) : Color.black)
                .cornerRadius(4, corners: .allCorners)
        }.disabled(isDisabled)
    }
}
