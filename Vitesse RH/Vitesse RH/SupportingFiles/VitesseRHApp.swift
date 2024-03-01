//
//  VitesseRHApp.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

@main
struct VitesseRHApp: App {

    @StateObject var userViewModel = UserViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if !userViewModel.isLogged { // TODO: Remove "!"
                    CandidatesView()
                } else {
                    LoginView(loginVM: userViewModel.loginViewModel)
                }
            }
            .environmentObject(userViewModel)
        }
    }
}
