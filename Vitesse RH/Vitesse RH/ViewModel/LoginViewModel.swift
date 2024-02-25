//
//  LoginViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

class LoginViewModel: ObservableObject {

    // MARK: Outputs

    @Published var email: String = "admin@vitesse.com"
    @Published var password: String = "test123"

    @Published var inProgress = false
    @Published var errorMessage = ""

    // MARK: Private properties

    private let onLoginSucceed: ((_ isAdmin: Bool) -> Void)

    // MARK: Init

    init(_ callback: @escaping (_ isAdmin: Bool) -> Void) {
        self.onLoginSucceed = callback
    }

}

// MARK: Inputs

extension LoginViewModel {

    func signIn() {
        // check if is valid mail
        guard email.isValidEmail() else {
            Task { @MainActor in
                self.errorMessage = VitesseError.invalidMail.title + " " + VitesseError.invalidMail.message
            }
            return
        }

        // TODO: Empty

        // SignIn
        Task { @MainActor in
            self.inProgress = true
        }

        AuthService().signIn(withEmail: email, andPwd: password) { result in
            Task { @MainActor in
                switch result {
                case .success(let isAdmin):
                    self.onLoginSucceed(isAdmin)
                case .failure(let failure):
                    self.errorMessage = failure.title + " " + failure.message
                }
                self.inProgress = false
            }
        }
    }
}