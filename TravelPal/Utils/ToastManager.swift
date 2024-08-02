//
//  ToastManager.swift
//  TravelPal
//
//  Created by Aldea Alexia on 22.01.2024.
//

import SwiftUI

class ToastManager: ObservableObject {
    
    static weak var instance: ToastManager?
    
    @Published private(set) var toast: Toast?
    
    var timer: Timer?
    
    func show(_ toast: Toast) {
        self.toast = toast
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: toast.timeInterval, repeats: false, block: { [weak self] timer in
            timer.invalidate()
            self?.toast = nil
        })
    }
    
    func hideToast() {
        toast = nil
    }
}

struct Toast: Equatable {
    
    private let id = UUID().uuidString
    
    let text: String
    var textColor: Color = .black
    var timeInterval: TimeInterval = 2
    
    static func ==(lhs: Toast, rhs: Toast) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ToastView: View {
    
    let toast: Toast
    
    var body: some View {
        Text(toast.text)
            .font(.Poppins.semiBold(size: 12))
            .foregroundColor(toast.textColor)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(toast.textColor.opacity(0.1).background(Color.white))
            .cornerRadius(8)
            .padding(.horizontal, 20)
            .multilineTextAlignment(.center)
    }
}
