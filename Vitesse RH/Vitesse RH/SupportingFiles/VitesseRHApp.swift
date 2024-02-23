//
//  VitesseRHApp.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

@main
struct VitesseRHApp: App {

    @StateObject var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            if appViewModel.isLogged {
                CandidatesView(isAdmin: appViewModel.isAdmin)
            } else {
                LoginView(loginVM: appViewModel.loginViewModel)
            }
        }
    }
}
