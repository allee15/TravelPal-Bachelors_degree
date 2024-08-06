//
//  ApplePayButtonView.swift
//  TravelPal
//
//  Created by Alexia Aldea on 06.08.2024.
//

import SwiftUI
import PassKit

struct ApplePayButtonView: View {
    let action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Image(.icAppleIconWhite)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                
                Text("Pay")
                    .font(.system(size: 16))
            }.foregroundColor(.white)
                .padding(.all, 10)
                .frame(maxWidth: .infinity)
                .background(Color.black)
        }
        .buttonStyle(ApplePayButtonStyle())
        .padding(.horizontal, 16)
    }
}

struct ApplePayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

