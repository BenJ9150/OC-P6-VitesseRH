//
//  VitesseAppViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

final class VitesseAppViewModel: ObservableObject {

    // MARK: - Outputs

    @Published private(set) var isLogged: Bool

    var loginVM: LoginViewModel {
        return LoginViewModel {
            Task { @MainActor in
                self.isLogged = true
            }
        }
    }

    var candiatesVM: CandidatesViewModel {
        return CandidatesViewModel {
            KeychainManager.deleteTokenInKeychain()
            Task { @MainActor in
                self.isLogged = false
            }
        }
    }

    // MARK: Init

    init() {
        isLogged = KeychainManager.userIsLogged
    }
}
