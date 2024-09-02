//
//  SwiftUIView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 27.10.2023.
//

import UIKit
import SwiftUI

struct ControllerRepresentable: UIViewControllerRepresentable {
    let controller: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
