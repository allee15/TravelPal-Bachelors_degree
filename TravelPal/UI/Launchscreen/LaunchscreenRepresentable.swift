//
//  SwiftUIView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 27.10.2023.
//

import SwiftUI

struct LaunchscreenRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIStoryboard(name: "Launchscreen", bundle: .main).instantiateInitialViewController()!
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
}
