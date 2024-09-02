//
//  ChangeThemeScreenView.swift
//  TravelPal
//
//  Created by Alexia Aldea on 02.09.2024.
//

import SwiftUI

struct ChangeThemeScreenView: View {
    @StateObject private var viewModel = ChangeThemeViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                BackButton {
                    navigation.pop(animated: true)
                }
                
                Text("Change app theme")
                    .font(.Poppins.semiBold(size: 24))
                    .foregroundColor(.black)
                
                Spacer()
            }.padding(.horizontal, 16)
                .padding(.top, 24)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("APP THEME")
                        .foregroundStyle(Color.black)
                        .font(.Poppins.bold(size: 14))
                    
                    HStack(spacing: 12) {
                        ThemeWidgetView(image: .icThemeLight, title: "Light", 
                                        isSelected: $viewModel.isLightModeSelected) {
                            viewModel.applyThemeBasedOnPreference(theme: .light)
                        }
                        ThemeWidgetView(image: .icThemeDark, title: "Dark", 
                                        isSelected: $viewModel.isDarkModeSelected) {
                            viewModel.applyThemeBasedOnPreference(theme: .dark)
                        }
                        ThemeWidgetView(image: .icThemeSystem, title: "System",
                                        isSelected: $viewModel.isSystemModeSelected) {
                            viewModel.applyThemeBasedOnPreference(theme: .system)
                        }
                    }
                }.padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .background(Color.contentSecondary.opacity(0.1))
                    .cornerRadius(8, corners: .allCorners)
                    .padding(.top, 24)
            }
        }.background(Color.bgSecondary)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.themeCompletion) { event in
                switch event {
                case .completed:
                    ToastManager.instance.show(
                        Toast(
                            text: "Payment successful!",
                            textColor: Color.accentTertiary
                        ))
                }
            }
    }
}

fileprivate struct ThemeWidgetView: View {
    let image: ImageResource
    let title: String
    @Binding var isSelected: Bool?
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 16) {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.accentMain)
                    .frame(width: 40, height: 40)
                
                Text(title)
                    .font(.Poppins.regular(size: 14))
                    .foregroundStyle(Color.black)
                
                if let isSelected = isSelected {
                    Image(isSelected ? .icCircleFill : .icCirlceStroke)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.accentMain)
                        .frame(width: 24, height: 24)
                }
            }.padding(.vertical, 20)
                .padding(.horizontal, 24)
                .background(Color.contentSecondary.opacity(0.2))
                .cornerRadius(4, corners: .allCorners)
        }
    }
}

#Preview {
    ChangeThemeScreenView()
}
