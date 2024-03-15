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
    @Published private(set) var errorMessage = ""

    // MARK: Init

    init(_ callback: @escaping () -> Void) {
        self.onLoginSucceed = callback
    }

}

// MARK: Inputs

extension LoginViewModel {

    func signIn() {
        // check if is valid mail
        guard email.isValidEmail() else {
            Task { @MainActor in
                self.errorMessage = AppError.invalidMail.title + " " + AppError.invalidMail.message
            }
            return
        }

        // todo: Check Empty textfied

        // SignIn
        Task {
            await MainActor.run { self.inProgress = true }

            switch await AuthService().signIn(withEmail: email, andPwd: password) {
            case .success(let isAdmin):
                // Save isAdmin Value in UserDefault
                UserDefaults.standard.set(isAdmin, forKey: "VitesseUserIsAdmin")
                await MainActor.run { self.onLoginSucceed() }

            case .failure(let failure):
                await MainActor.run {
                    self.errorMessage = failure.title + " " + failure.message
                    self.inProgress = false
                }
            }
        }
    }
}
