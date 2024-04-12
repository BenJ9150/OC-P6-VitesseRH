//
//  AddCandidateViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 30/03/2024.
//

import Foundation
import SwiftUI

final class AddCandidateViewModel: ObservableObject {

    // MARK: Private property

    private let candidateService = CandidateService()

    // MARK: Outputs

    @Published private(set) var addInProgress = false
    @Published private(set) var dismissView = false

    var detailsHaveBeenEdited: Bool {
        return detailsHaveChanged()
    }

    // TextFields

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phone: String = ""
    @Published var note: String = ""
    @Published var linkedinURL: String = ""
    @Published var email: String = ""

    // Error messages

    @Published private(set)var apiError = ""
    @Published var firstNameErr = ""
    @Published var lastNameErr = ""
    @Published var mailError = ""
    @Published var phoneError = ""
    @Published var linkedInErr = ""

}

// MARK: Input

extension AddCandidateViewModel {

    /// Method to add new candidate in API database.

    func addCandidate() {
        // check if all texfields are valid
        guard textfieldsAreValid() else { return }

        // Create new candidate
        let newCandidate = Candidate(id: "",
            phone: phone == "" ? nil : phone,
            note: note == "" ? nil : note,
            firstName: firstName,
            linkedinURL: linkedinURL == "" ? nil : linkedinURL,
            isFavorite: false,
            email: email,
            lastName: lastName
        )
        addInProgress = true
        Task {
            let result = await candidateService.postToAdd(candidate: newCandidate)
            await processServiceResult(result) {
                self.addInProgress = false
            }
        }
    }
}

// MARK: Private method

private extension AddCandidateViewModel {

    /// Process service result on MainActor.
    /// - Parameter result: The service result to process.
    /// - Parameter completion: Code that will be executed on MainActor at the end of processing.
    /// - If success: dismiss view.
    /// - If error: shows an error message.

    func processServiceResult(_ result: Result<Candidate, AppError>, completion: @escaping () -> Void) async {
        await MainActor.run {
            switch result {

            case .success:
                // notify need update
                NotificationCenter.default.post(name: .needUpdate, object: nil)
                dismissView = true

            case .failure(let appError):
                apiError = appError.title + " " + appError.message
            }
            completion()
        }
    }

    /// Check if any details have been changed.
    /// - Returns: True if at least one detail has changed.

    func detailsHaveChanged() -> Bool {
        if firstName.isEmpty,
           lastName.isEmpty,
           email.isEmpty,
           linkedinURL.isEmpty,
           phone.isEmpty,
           note.isEmpty {
            return false
        }
        return true
    }

    /// Check if all textfields are valid, and display error message if not.
    /// ## Attention: Must be call on MainActor, view can be updated.
    /// - Returns: True if all texfileds are valid.

    func textfieldsAreValid() -> Bool {
        // empty value (only fistName, lastName and email must not be empty)
        guard !email.isEmpty, !firstName.isEmpty, !lastName.isEmpty else {
            // Error
            if email.isEmpty {
                mailError = AppError.emptyTextField.message
            }
            if firstName.isEmpty {
                firstNameErr = AppError.emptyTextField.message
            }
            if lastName.isEmpty {
                lastNameErr = AppError.emptyTextField.message
            }
            return false
        }
        // check if is valid mail
        guard email.isValidEmail() else {
            mailError = AppError.invalidMail.message
            return false
        }
        // valid phone
        if !phone.isEmpty {
            guard phone.isValidFrPhone() else {
                phoneError = AppError.invalidFrPhone.message
                return false
            }
        }
        // valid linkedIn url
        if !linkedinURL.isEmpty {
            guard let url = URL(string: linkedinURL), UIApplication.shared.canOpenURL(url) else {
                linkedInErr = AppError.invalidLinkedInUrl.message
                return false
            }
        }
        return true
    }
}
