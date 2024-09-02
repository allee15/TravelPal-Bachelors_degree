//
//  BottomNavBarScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 11.08.2023.
//

import SwiftUI

enum TabBarNavigation {
    case home
    case chats
    case discover
    case account
}

class TabBarCoordinator: ObservableObject {
    static let instance = TabBarCoordinator()
    @Published var tabBarNavigation: TabBarNavigation?
}

struct TabBarScreen: View {
    @EnvironmentObject private var navigation: Navigation
    
    @ObservedObject private var tabBarCoordinator = TabBarCoordinator.instance
    @StateObject private var viewModel = TabBarViewModel()
    
    @StateObject private var homeNavigation = Navigation(root: FlightInfoScreenView().asDestination())
    @StateObject private var chatsNavigation = Navigation(root: ChatScreenView().asDestination())
    @StateObject private var discoverNavigation = Navigation(root: DiscoverScreenView().asDestination())
    @StateObject private var accountNavigation = Navigation(root: AccountScreenView().asDestination())
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { geometry in
                LazyHStack(spacing: 0) {
                    Group {
                        switch viewModel.tabBar {
                        case .home:
                            NavigationHostView(navigation: homeNavigation)
                        case .chats:
                            NavigationHostView(navigation: chatsNavigation)
                        case .discover:
                            NavigationHostView(navigation: discoverNavigation)
                        case .account:
                            NavigationHostView(navigation: accountNavigation)
                        }
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                }.onReceive(viewModel.$tabBar, perform: { value in
                    if viewModel.oldTabBar == .home, value == .home {
                        homeNavigation.popToRoot(animated: false)
                    } else if viewModel.oldTabBar == .chats, value == .chats {
                        chatsNavigation.popToRoot(animated: false)
                    } else if viewModel.oldTabBar == .discover, value == .discover {
                        discoverNavigation.popToRoot(animated: false)
                    } else if viewModel.oldTabBar == .account, value == .account {
                        accountNavigation.popToRoot(animated: false)
                    }
                })
                .onReceive(tabBarCoordinator.$tabBarNavigation) { value in
                    if let value {
                        switch value {
                        case .home:
                            if viewModel.tabBar != .home {
                                viewModel.tabBar = .home
                            }
                            homeNavigation.popToRoot(animated: true)
                            
                        case .chats:
                            if viewModel.tabBar != .chats {
                                viewModel.tabBar = .chats
                            }
                            chatsNavigation.popToRoot(animated: true)
                            
                        case .discover:
                            if viewModel.tabBar != .discover {
                                viewModel.tabBar = .discover
                            }
                            discoverNavigation.popToRoot(animated: true)
                            
                        case .account:
                            if viewModel.tabBar != .account {
                                viewModel.tabBar = .account
                            }
                            accountNavigation.popToRoot(animated: true)
                        }
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            TabBarView(tabBar: $viewModel.tabBar) { value in
                viewModel.tabBar = value
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .ignoresSafeArea([.container, .keyboard])
    }
}

struct TabBarView: View {
    @Binding var tabBar: NavTabs
    let selectionAction: (NavTabs) -> ()
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                selectionAction(.home)
            } label: {
                VStack(spacing: 4) {
                    Spacer()
                    
                    Image(systemName: "airplane")
                        .foregroundColor(tabBar == .home ? Color.accentMain : Color.contentSecondary)
                        .frame(height: 16)
                    
                    Text("Flights")
                        .font(tabBar == .home ? .Poppins.bold(size: 12): .Poppins.regular(size: 12))
                        .foregroundColor(tabBar == .home ? Color.accentMain : Color.contentSecondary)
                }
            }
            
            Spacer()
            
            Button {
                selectionAction(.chats)
            } label: {
                VStack(spacing: 4) {
                    Spacer()
                    
                    Image(systemName: "message.fill")
                        .foregroundColor(tabBar == .chats ? Color.accentMain : Color.contentSecondary)
                        .frame(height: 16)
                    
                    Text("Chats")
                        .font(tabBar == .chats ? .Poppins.bold(size: 12): .Poppins.regular(size: 12))
                        .foregroundColor(tabBar == .chats ? Color.accentMain : Color.contentSecondary)
                }
            }
            
            Spacer()
            
            Button {
                selectionAction(.discover)
            } label: {
                VStack(spacing: 4) {
                    Spacer()
                    
                    Image(.icDiscover)
                        .foregroundColor(tabBar == .discover ? Color.accentMain : Color.contentSecondary)
                        .frame(height: 16)
                    
                    Text("Discover")
                        .font(tabBar == .discover ? .Poppins.bold(size: 12): .Poppins.regular(size: 12))
                        .foregroundColor(tabBar == .discover ? Color.accentMain : Color.contentSecondary)
                }
            }
            
            Spacer()
            
            Button {
                selectionAction(.account)
            } label: {
                VStack(spacing: 4) {
                    Spacer()
                    
                    Image(systemName: "person.fill")
                        .foregroundColor(tabBar == .account ? Color.accentMain : Color.contentSecondary)
                        .frame(height: 16)
                    
                    Text("Profile")
                        .font(tabBar == .account ? .Poppins.bold(size: 12): .Poppins.regular(size: 12))
                        .foregroundColor(tabBar == .account ? Color.accentMain : Color.contentSecondary)
                }
            }
        }
        .padding(.top, 8)
        .frame(height: 32)
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity)
        .padding(.bottom, SafeAreaInsets.bottom)
        .background(.white)
    }
}
