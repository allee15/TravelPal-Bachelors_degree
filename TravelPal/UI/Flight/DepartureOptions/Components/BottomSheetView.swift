//
//  BottomSheetView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 18.01.2024.
//

import SwiftUI
import PassKit

struct BottomSheetView: View {
    @EnvironmentObject private var navigation: Navigation
    
    @State var image: Image?
    @State var route: Route
    @State var weekDay: String
    @State var countryDep: Country
    @State var countryArr: Country
    @State var countUsers: Int
    @State var price: Int
    
    var body: some View {
        PaymentSheetView(price: price) {
            let destinationVM = AccomodationViewModel(route: route,
                                                      weekDay: weekDay,
                                                      countryDep: countryDep,
                                                      countryArr: countryArr,
                                                      countUsers: countUsers,
                                                      image: image)
            navigation.presentPopup(LoaderView().asDestination(), animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                navigation.dismissModal(animated: true, completion: nil)
                navigation.push(AccomodationScreenView(viewModel: destinationVM).asDestination(),
                                animated: true)
            }
        } actionClose: {
            navigation.dismissModal(animated: true, completion: nil)
        }
    }
}

struct PaymentSheetView: View {
    let price: Int
    let action: () -> ()
    let actionClose: () -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    Image(.icApple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Pay")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.black)
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    Button {
                        actionClose()
                    } label: {
                        Image(.icClosePay)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .padding(.all, 10)
                            .background(
                                Circle()
                                    .fill(Color.contentSecondary.opacity(0.2))
                            )
                    }
                }.padding([.top, .horizontal], 12)
                
                HStack(spacing: 8) {
                    Image(.imgAppleCard)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Apple Card")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 18))
                        
                        Text("Lucretiu Patrascanu 4, Bucuresti")
                            .font(.system(size: 18))
                            .foregroundColor(.contentSecondary)
                    }
                    
                    Spacer()
                    
                    Image(.icItemresultArrow)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }.padding(.all, 12)
                    .background(.white)
                    .cornerRadius(6)
                    .padding(.all, 12)
                
                Spacer(minLength: 24)
            }.background(Color.bgSecondary)
            
            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pay Apple Store")
                            .font(.system(size: 16))
                            .foregroundColor(.contentSecondary)
                        
                        Text("\(price)€")
                            .bold()
                            .foregroundStyle(Color.black)
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Image(.icItemresultArrow)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 8)
                }.padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.contentSecondary.opacity(0.2))
                    .padding(.bottom, 8)
                
                ApplePayButtonView {
                    action()
                }.padding(.top, 4)
                    .padding(.bottom, 12)
                
            }.background(.white)
                .cornerRadius(6)
        }
    }
}
