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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ChangeThemeScreenView()
}
