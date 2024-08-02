//
//  ModalChooseOptionView.swift
//  TravelPal
//
//  Created by Alexia Aldea on 15.06.2024.
//

import SwiftUI

struct ModalChooseOptionView: View {
    let title: String
    let description: String
    let topButtonText: String
    var bottomButtonText: String?
    let onTopButtonTapped: () -> ()
    var onBottomButtonTapped: (() -> ())?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(spacing: 0) {
                
                Text(title)
                    .font(.Poppins.bold(size: 24))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)
                
                Text(description)
                    .font(.Poppins.regular(size: 16))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
                
                VStack(spacing: 12) {
                    RedButtonView(text: topButtonText) {
                        onTopButtonTapped()
                    }
                    
                    if let onBottomButtonTapped = onBottomButtonTapped,
                        let bottomButtonText = bottomButtonText {
                        BlackButtonView(text: bottomButtonText) {
                            onBottomButtonTapped()
                        }
                    }
                }
            }.padding(.horizontal, 24)
                .padding(.vertical, 36)
                .background(Color.white.cornerRadius(8))
                .padding(.horizontal, 24)
        }.ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
