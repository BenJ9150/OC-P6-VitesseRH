//
//  RegisterViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

final class RegisterViewModel: ObservableObject {

    // MARK: Outputs

    @Published var email: String = "ben@vitesse.com" // TODO: To remove
    @Published var firstName: String = "Ben"
    @Published var lastName: String = "Lef"
    @Published var password: String = "test123"
    @Published var confirmPwd: String = "test123"

//    @Published var email: String = ""
//    @Published var firstName: String = ""
//    @Published var lastName: String = ""
//    @Published var password: String = ""
//    @Published var confirmPwd: String = ""

    @Published var inProgress = false
    @Published private(set) var isRegistered = false
    @Published private(set) var errorMessage = ""
}

// MARK: Inputs

extension RegisterViewModel {

    func register() {
        // check if is valid mail
        guard email.isValidEmail() else {
            Task { @MainActor in
                self.errorMessage = AppError.invalidMail.title + " " + AppError.invalidMail.message
            }
            return
        }

        // todo: Empty, confirm password

        // Registering
        Task {
            await MainActor.run { self.inProgress = true }

            switch await AuthService().register(
                mail: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            ) {
            case .success(let success):
                await MainActor.run { self.isRegistered = success }

            case .failure(let failure): // todo: Utilisateur existant
                await MainActor.run {
                    self.errorMessage = failure.title + " " + failure.message
                    self.inProgress = false
                }
            }
        }
    }
}
