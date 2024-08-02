//
//  PaymentButton.swift
//  TravelPal
//
//  Created by Aldea Alexia on 17.01.2024.
//

import SwiftUI
import PassKit

struct PaymentButton: View {
    var action: () -> ()
    
    var body: some View {
        Representable(action: action)
            .frame(height: 38)
            .frame(maxWidth: .infinity)
            .cornerRadius(0)
    }
}

extension PaymentButton {
    struct Representable: UIViewRepresentable {
        var action: () -> Void
        
        func makeCoordinator() -> Coordinator {
            Coordinator(action: action)
        }
        
        func makeUIView(context: Context) -> some UIView {
            context.coordinator.button
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            context.coordinator.action = action
        }
    }
    
    class Coordinator: NSObject {
        var action: () -> Void
        var button = PKPaymentButton(paymentButtonType: .checkout,
                                     paymentButtonStyle: .black)
        
        init(action: @escaping () -> Void) {
            self.action = action
            super.init()
            
            button.addTarget(self,
                             action: #selector(callback(_:)),
                             for: .touchUpInside)
        }
        
        @objc
        func callback(_ sender: Any) {
            action()
        }
    }
}

struct ApplePayButtonView: View {
    let action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Image("ic_apple_icon_white")
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
