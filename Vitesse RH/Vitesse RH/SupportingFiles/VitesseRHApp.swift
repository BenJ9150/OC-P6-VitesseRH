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

    var body: some Scene {
        WindowGroup {
            Group {
                if vitesseAppVM.isLogged {
                    CandidatesView(candidatesVM: vitesseAppVM.candiatesVM)
                } else {
                    LoginView(loginVM: vitesseAppVM.loginVM)
                }
            }
        }
    }
}
