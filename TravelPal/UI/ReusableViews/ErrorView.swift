//
//  ErrorView.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import SwiftUI

struct ErrorView: View {
   var title: String = "At the moment there weren't found any available flights."
   
   var body: some View {
       VStack(alignment: .center, spacing: 12) {
           
           Text(title)
               .foregroundColor(Color.accentMain)
               .font(.Poppins.regular(size: 16))
               .multilineTextAlignment(.center)
           
           HStack(spacing: 8) {
               Text("Come back later or refresh the page!")
                   .foregroundColor(.black)
                   .font(.Poppins.regular(size: 16))
                   .multilineTextAlignment(.center)
               
               Image(.icSad)
                   .resizable()
                   .frame(width: 24, height: 24)
           }
       }
       .padding(.horizontal, 16)
       .padding(.top, 32)
   }
}
