//
//  AddPhotoView.swift
//  TravelPal
//
//  Created by Alexia Aldea on 02.09.2024.
//

import SwiftUI

struct AddPhotoView: View {
    
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var pickPhoto = false
    
    @Binding var selectedImage: UIImage?
    @Binding var hideBottomSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(spacing: 40) {
                BottomSheetLineView()
                
                HStack {
                    Text("Add a photo")
                        .font(.Poppins.bold(size: 28))
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 20)
                    Spacer()
                }
                
            }.padding(.top, 12)
            
            HStack(spacing: 12) {
                AddPhotoWidgetView(icon: .icCamera, title: "Camera") {
                    self.imageSource = .camera
                    self.pickPhoto = true
                }
                
                AddPhotoWidgetView(icon: .icPhoto, title: "Gallery") {
                    self.imageSource = .photoLibrary
                    self.pickPhoto = true
                }
            }.frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            
            Spacer()
            
            BlackButtonView(text: "Close") {
                self.hideBottomSheet = false
            }.padding([.horizontal, .bottom], 20)
            
        }.background(Color.white)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .sheet(isPresented: $pickPhoto) {
                ImagePickerView(sourceType: self.$imageSource) { image in
                    selectedImage = image
                }
                .ignoresSafeArea()
            }
    }
}

fileprivate struct AddPhotoWidgetView: View {
    let icon: ImageResource
    let title: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                Spacer()
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.contentSecondary)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.Poppins.regular(size: 14))
                    .foregroundStyle(Color.black)
                    .lineLimit(1)
                Spacer()
                
            }.fixedSize(horizontal: false, vertical: true)
        }.padding(.vertical, 52)
            .background(Color.contentSecondary.opacity(0.2))
            .cornerRadius(8, corners: .allCorners)
    }
}

fileprivate struct BottomSheetLineView: View {
    var body: some View {
        Rectangle()
            .fill(Color.contentSecondary)
            .frame(width: 36, height: 6)
            .cornerRadius(72, corners: .allCorners)
    }
}
