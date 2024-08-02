//
//  TabButton.swift
//  TravelPal
//
//  Created by Aldea Alexia on 18.01.2024.
//

import SwiftUI

enum TabSelected {
    case flight
    case car
}

struct TabButton: View {
    var title: String
    var isSelectedOn: TabSelected
    var selectedTab: TabSelected
    
    @State private var lineWidth: CGFloat = 0
    
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            if selectedTab == isSelectedOn {
                VStack(spacing: 4) {
                    Text(title)
                        .font(Font.Poppins.bold(size: 16))
                        .foregroundColor(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(1)
                        .background(
                            GeometryReader { proxy in
                                Color.clear.onAppear {
                                    self.lineWidth = proxy.size.width
                                }
                            }
                        )
                    
                    Rectangle()
                        .frame(width: lineWidth, height: 4)
                        .foregroundColor(Color.accentMain)
                        .cornerRadius(4)
                }
            } else {
                VStack(spacing: 4) {
                    Text(title)
                        .font(Font.Poppins.regular(size: 16))
                        .foregroundColor(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(1)
                        .background(
                            GeometryReader { proxy in
                                Color.clear.onAppear {
                                    self.lineWidth = proxy.size.width
                                }
                            }
                        )
                    
                    Rectangle()
                        .frame(width: lineWidth, height: 4)
                        .foregroundColor(Color.clear)
                        .cornerRadius(4)
                }
            }
        }
    }
}
