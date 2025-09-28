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
                Color.maintheme
                Text("Learnicity")
                    .customFont(style: .black, size: .h50)
                    .foregroundStyle(.white)
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
                            path.push(screen: .chooseSubject)
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
