//
//  AppDelegate.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 27/08/2025.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize services here
        GMSServices.provideAPIKey("AIzaSyAxB6TxyRkLBk_HCCLbu1vk5GEIQKrZ1_c")
        GMSPlacesClient.provideAPIKey("AIzaSyAxB6TxyRkLBk_HCCLbu1vk5GEIQKrZ1_c")

        return true
    }
}
