//
//  VitesseRHApp.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

@main
struct VitesseRHApp: App {

    @StateObject var vitesseAppVM = VitesseAppViewModel()

//    init() { // TODO: To remove, or add sign out button
//        KeychainManager.deleteTokenInKeychain()
//    }

    var body: some Scene {
        WindowGroup {
            Group {
                if vitesseAppVM.isLogged {
                    CandidatesView()
                } else {
                    LoginView(loginVM: vitesseAppVM.loginViewModel)
                }
            }
        }
    }
}

// TODO: App icon
