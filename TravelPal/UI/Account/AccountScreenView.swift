//
//  AccountScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 12.08.2023.
//

import SwiftUI

struct AccountScreenView: View {
    @ObservedObject var viewModel = AccountViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    
    var body: some View {
        VStack(spacing: 0) {
            if let user = viewModel.user, !user.isAnonymous {
                HStack(spacing: 0) {
                    Image("logo_app1")
                        .resizable()
                        .frame(width: 153, height: 27)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                }.padding(.top, 20)
                
                ScrollView(showsIndicators: false) {
                    
                    MoreNavBarView(userName: viewModel.username)
                        .padding(.top, 28)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        WidgetView(title: "Terms and Conditions", icon: "ic_terms") {
                            let webview = WebViewScreen(
                                title: "Terms and Conditions",
                                url: URL(string: "https://www.termsandconditionsgenerator.com/live.php?token=PiVV3ZACQYyqXIbXBFFhQMDNtBY90XBx")!
                            ).asDestination()
                            navigation.push(webview, animated: true)
                        }
                        
                        WidgetView(title: "Contact us", icon: "ic_contactus") {
                            let email = "alexia.elena.aldea@gmail.com"
                            let urlString = "mailto:\(email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            
                            if let url = URL(string: urlString ?? "") {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                        
                        WidgetView(title: "Change language", icon: "ic_change_language") {
                            let appSettingsURL = URL(string: UIApplication.openSettingsURLString)!
                                .appendingPathComponent(Bundle.main.bundleIdentifier!)
                            if let openSettingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                            }
                        }
                        
                        WidgetView(title: "Edit account", icon: "ic_editaccount") {
                            navigation.push(EditAccountScreenView().asDestination(),
                                            animated: true)
                        }
                        
                        WidgetView(title: "Logout", icon: "ic_logout") {
                            let modal = ModalChooseOptionView(title: "Are you sure you want to logout?",
                                                              description: "You will not have access to your chats and you will not be able to buy new flight tickets if you are logged out.",
                                                              topButtonText: "Logout",
                                                              bottomButtonText: "Cancel") {
                                viewModel.logOut()
                                navigation.dismissModal(animated: true, completion: nil)
                            } onBottomButtonTapped: {
                                navigation.dismissModal(animated: true, completion: nil)
                            }
                            
                            navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                        }
                        
                        WidgetView(title: "Delete account", icon: "ic_deleteaccount") {
                            let modal = ModalChooseOptionView(title: "Are you sure you want to delete your account?",
                                                              description: "You will not be able to recover it after deleting it. All your data will be lost, including your chats and your past flight tickets.",
                                                              topButtonText: "Delete my account",
                                                              bottomButtonText: "Cancel") {
                                viewModel.deleteAccount()
                                navigation.dismissModal(animated: true, completion: nil)
                            } onBottomButtonTapped: {
                                navigation.dismissModal(animated: true, completion: nil)
                            }
                            
                            navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                        }
                    }
                }
            } else {
                UnloggedUserView()
            }
        }.background(Color.bgSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.eventSubject) { eventSubject in
                switch eventSubject {
                case .logout:
                    navigation.dismissModal(animated: true, completion: nil)
                    navigation.push(LogInScreenView().asDestination(), animated: true)
                    
                case .failure(let error):
                    let modal = ModalChooseOptionView(title: "Something went wrong",
                                                      description: "An error has occured and we couldn't complete the action. Please try again later.",
                                                      topButtonText: "Back") {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                    
                case .delete:
                    navigation.dismissModal(animated: true, completion: nil)
                    ToastManager.instance?.show(
                        Toast(
                            text: "Account deleted successfully!",
                            textColor: Color.accentTertiary
                        ))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        navigation.push(LogInScreenView().asDestination(), animated: true)
                    }
                }
            }
    }
}

fileprivate struct WidgetView: View {
    let title: String
    let icon: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Image(icon)
                    .resizable()
                    .frame(width: 16, height: 16)
                
                Text(title)
                    .font(.Poppins.regular(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image("ic_itemresult_arrow")
                    .resizable()
                    .frame(width: 16, height: 16)
            }.padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.white)
                .padding(.horizontal, 16)
        }
    }
}

fileprivate struct MoreNavBarView: View {
    let userName: String
    
    var body: some View {
        HStack(spacing: 0) {
            ProfilePicPlaceHolder(userName: userName)
            VStack(alignment: .leading, spacing: 6) {
                Text("Nice to see you again,")
                    .font(.Poppins.regular(size: 16))
                    .foregroundColor(.black)
                
                if userName.isEmpty {
                    Text("Traveler")
                        .font(.Poppins.bold(size: 22))
                        .foregroundColor(.black)
                } else {
                    Text(userName)
                        .font(.Poppins.bold(size: 22))
                        .foregroundColor(.black)
                }
            }.padding(.leading, 16)
            Spacer()
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
    }
}

fileprivate struct ProfilePicPlaceHolder: View {
    let userName: String
    
    var body: some View {
        Circle()
            .fill(Color.accentMain)
            .frame(width: 62)
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Text(userName.first?.uppercased() ?? "T")
                    .font(.Poppins.bold(size: 20))
                    .foregroundColor(.white)
            )
            .shadow(color: Color.contentSecondary,
                    radius: 12,
                    x: 0,
                    y: 3)
    }
}
