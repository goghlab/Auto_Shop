//
//  AutoShopApp.swift
//  AutoShop
//
//  Created by IZZY on 20/1/2024.
//

import SwiftUI
import Firebase

@main
struct AutoShopApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
