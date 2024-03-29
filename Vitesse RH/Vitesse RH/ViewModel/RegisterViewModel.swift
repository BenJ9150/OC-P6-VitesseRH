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
    @Published var errorMessage = ""
}

// MARK: Inputs

extension RegisterViewModel {

    func register() {
        // check if all texfields are valid
        guard textfieldsAreValid() else { return }
        inProgress = true
        // registering
        Task {
            let result = await AuthService().register(
                mail: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
            await processServiceResult(result) {
                self.inProgress = false
            }
        }
    }
}

// MARK: Private method

private extension RegisterViewModel {

    /// Process service result on MainActor.
    /// - Parameter result: The service result to process.
    /// - Parameter completion: Code that will be executed on MainActor at the end of processing.
    /// - If success: sets isRegistered property to true
    /// - If error: shows an error message.

    func processServiceResult(_ result: Result<Bool, AppError>, completion: @escaping () -> Void) async {
        await MainActor.run {
            switch result {

            case .success(let success):
                isRegistered = success

            case .failure(let appError):
                errorMessage = appError.title + " " + appError.message
            }
            completion()
        }
    }

    /// Check if all textfields are valid, and display error message if not.
    /// ## Attention: Must be call on MainActor, view can be updated.
    /// - Returns: True if all texfileds are valid.

    func textfieldsAreValid() -> Bool {
        // check empty value
        guard !email.isEmpty, !firstName.isEmpty, !lastName.isEmpty,
              !password.isEmpty, !confirmPwd.isEmpty else {

            errorMessage = AppError.emptyTextField.title + " " + AppError.emptyTextField.message
            return false
        }
        // check if is valid mail
        guard email.isValidEmail() else {
            errorMessage = AppError.invalidMail.title + " " + AppError.invalidMail.message
            return false
        }
        // check password confirmation
        guard password == confirmPwd else {
            errorMessage = AppError.badPwdConfirm.title + " " + AppError.badPwdConfirm.message
            return false
        }
        return true
    }
}
