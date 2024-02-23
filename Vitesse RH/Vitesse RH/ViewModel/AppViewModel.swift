//
//  AppViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

final class AppViewModel: ObservableObject {

    // MARK: - Outputs

    @Published var isLogged: Bool
    @Published var isAdmin: Bool = false

    var loginViewModel: LoginViewModel {

        return LoginViewModel { isAdmin in
            Task { @MainActor in
                self.isLogged = true
                self.isAdmin = isAdmin
            }
        }
    }

    // MARK: Init

    init() {
        isLogged = KeychainManager.userIsLogged
    }
}
