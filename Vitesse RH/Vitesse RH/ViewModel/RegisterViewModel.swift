//
//  RegisterViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

final class RegisterViewModel: ObservableObject {

    // MARK: Outputs

    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var password: String = ""
    @Published var confirmPwd: String = ""

    @Published var inProgress = false
    @Published private(set) var isRegistered = false
    @Published var errorMessage = "" // TODO: Antoine: Output, Input ou les 2 ?
}

// MARK: Inputs

extension RegisterViewModel {

    func register() {
        // check empty value
        guard !email.isEmpty, !firstName.isEmpty, !lastName.isEmpty,
              !password.isEmpty, !confirmPwd.isEmpty else {
            Task { @MainActor in
                self.errorMessage = AppError.emptyTextField.title + " " + AppError.emptyTextField.message
            }
            return
        }
        // check if is valid mail
        guard email.isValidEmail() else {
            Task { @MainActor in
                self.errorMessage = AppError.invalidMail.title + " " + AppError.invalidMail.message
            }
            return
        }
        // check password confirmation
        guard password == confirmPwd else {
            Task { @MainActor in
                self.errorMessage = AppError.badPwdConfirm.title + " " + AppError.badPwdConfirm.message
            }
            return
        }
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

            case .failure(let failure):
                await MainActor.run {
                    self.errorMessage = failure.title + " " + failure.message
                    self.inProgress = false
                }
            }
        }
    }
}
