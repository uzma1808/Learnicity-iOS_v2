//
//  ContentView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 01/08/2025.
//

import SwiftUI

struct SplashView: View {
    @State var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path, root: {
            ZStack {
                Color.splashbg
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .padding([.leading, .trailing], 20)
            }
            .ignoresSafeArea()
            .navigationDestination(for: Route.self) { routes in
                // MARK: - NAVIGATIONS
                destinationView(for: routes)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    if UserSession.shared.isLoggedIn {
                        if UserSession.shared.selectedSubject != nil {
                            path.push(screen: .home)
                        } else {
                            path.push(screen: .chooseSubject(settings: false))
                        }
                    } else {
                        let loginView = Route.loginView
                        path.push(screen: loginView)
                    }

                })
            }
        })
    }
}

#Preview {
    SplashView()
}
