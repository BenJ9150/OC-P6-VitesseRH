//
//  VitesseAppViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

final class VitesseAppViewModel: ObservableObject {

    // MARK: - Outputs

    @Published var isLogged: Bool

    var loginViewModel: LoginViewModel {

        return LoginViewModel {
            Task { @MainActor in
                self.isLogged = true
            }
        }
    }

    // MARK: Init

    init() {
        isLogged = KeychainManager.userIsLogged
    }
}
