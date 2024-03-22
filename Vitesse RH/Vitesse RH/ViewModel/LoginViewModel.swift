//
//  LoginViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

class LoginViewModel: ObservableObject {

    // MARK: Private property

    private let onLoginSucceed: (() -> Void)

    // MARK: Outputs

    @Published var email: String = "admin@vitesse.com" // TODO: To remove
    @Published var password: String = "test123"
//    @Published var email: String = ""
//    @Published var password: String = ""

    @Published var inProgress = false
    @Published var errorMessage = ""

    // MARK: Init

    init(_ callback: @escaping () -> Void) {
        self.onLoginSucceed = callback
    }

}

// MARK: Inputs

extension LoginViewModel {

    func signIn() {
        // check if all texfields are valid
        guard textfieldsAreValid() else { return }
        inProgress = true
        // SignIn
        Task {
            let result = await AuthService().signIn(withEmail: email, andPwd: password)
            await processServiceResult(result)
        }
    }
}

// MARK: Private method

private extension LoginViewModel {

    /// Process service result on MainActor.
    /// - Parameter result: The service result to process.
    /// - If success:
    ///     - Save administrator status in UserDefaults.
    ///     - Call onLoginSucceed()
    /// - If error:
    ///     - Shows an error message.
    ///     - Sets inProgress property to false.

    func processServiceResult(_ result: Result<Bool, AppError>) async {
        await MainActor.run {
            switch result {

            case .success(let isAdmin):
                // Save isAdmin Value in UserDefault
                UserDefaults.standard.set(isAdmin, forKey: "VitesseUserIsAdmin")
                onLoginSucceed()

            case .failure(let failure):
                errorMessage = failure.title + " " + failure.message
                inProgress = false
            }
        }
    }

    /// Check if all textfields are valid, and display error message if not.
    /// ## Attention: Must be call on MainActor, view can be updated.
    /// - Returns: True if all texfileds are valid.

    func textfieldsAreValid() -> Bool {
        // check empty value
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = AppError.emptyTextField.title + " " + AppError.emptyTextField.message
            return false
        }
        // check if is valid mail
        guard email.isValidEmail() else {
            errorMessage = AppError.invalidMail.title + " " + AppError.invalidMail.message
            return false
        }
        return true
    }
}
