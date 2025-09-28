//
//  Learnicity_iOSApp.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 01/08/2025.
//

import SwiftUI

@main
struct Learnicity_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
