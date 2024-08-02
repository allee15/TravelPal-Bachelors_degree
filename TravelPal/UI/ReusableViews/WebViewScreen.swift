//
//  WebViewScreen.swift
//  TravelPal
//
//  Created by Aldea Alexia on 08.01.2024.
//

import Foundation
import SwiftUI
import UIKit
import WebKit

struct WebViewScreen: View {
    
    let title: String
    let url: URL
    @State var loading: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavBarView()
                .padding(.bottom, 16)

            WebView(url: url,
                    loadingHandler: { isLoading in
                loading = isLoading
            })
                .padding(.horizontal, 16)
                .overlay(loading ? AnyView(LoaderView()) : AnyView(EmptyView()))
        }.background(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
    }
}


struct WebView: UIViewRepresentable {
 
    var url: URL
    var loadingHandler: ((Bool) -> Void)?
    var webview: WKWebView?
 
    func makeUIView(context: Context) -> WKWebView {
        let webview = webview ?? WKWebView()
        webview.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webview.load(request)
        return webview
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
       
    }
    
    func makeCoordinator() -> Coordinator {
        let coord = Coordinator()
        coord.loadingHandler = loadingHandler
        return coord
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var loadingHandler: ((Bool) -> Void)?
        
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            loadingHandler?(true)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            loadingHandler?(false)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            loadingHandler?(false)
        }
        
    }
}
