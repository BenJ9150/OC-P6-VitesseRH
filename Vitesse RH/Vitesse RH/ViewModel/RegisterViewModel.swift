//
//  RegisterViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

final class RegisterViewModel: ObservableObject {

    // MARK: Outputs

    @Published var email: String = "toto@vitesse.com"
    @Published var firstName: String = "Toto"
    @Published var lastName: String = "Toto"
    @Published var password: String = "test123"
    @Published var confirmPwd: String = "test123"

    @Published var isRegistering = false
    @Published var isRegistered = false
    @Published var errorMessage = ""
}

// MARK: Inputs

extension RegisterViewModel {

    func register() {
        // check if is valid mail
        guard email.isValidEmail() else {
            Task { @MainActor in
                self.errorMessage = VitesseError.invalidMail.title + " " + VitesseError.invalidMail.message
            }
            return
        }

        // TODO: Empty, confirm password

        // Registering
        Task { @MainActor in
            self.isRegistering = true
        }

        AuthService().register(mail: email, password: password, firstName: firstName, lastName: lastName) { result in
            Task { @MainActor in
                switch result {
                case .success(let success):
                    self.isRegistered = success
                case .failure(let failure):
                    self.errorMessage = failure.title + " " + failure.message
                }
                self.isRegistering = false
            }
        }
    }
}
