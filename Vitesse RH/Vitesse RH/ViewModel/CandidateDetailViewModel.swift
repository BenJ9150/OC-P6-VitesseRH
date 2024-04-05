//
//  CandidateDetailViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 15/03/2024.
//

import Foundation
import SwiftUI

final class CandidateDetailViewModel: ObservableObject {

    // MARK: Private property

    private let candidateService = CandidateService()
    private var candidate: Candidate

    // MARK: Outputs

    let isAdmin = UserDefaults.standard.bool(forKey: "VitesseUserIsAdmin")
    let name: String

    @Published private(set) var isFavorite = false
    @Published var isEditing = false {
        didSet { apiError = "" }
    }

    var candidateHasBeenEdited: Bool {
        return candidateDetailsHaveChanged()
    }

    // Progress View

    @Published private(set) var updateInProgress = false
    @Published private(set) var favoriteInProgress = false

    // TextFields

    @Published var phone: String = ""
    @Published var note: String = ""
    @Published var linkedinURL: String = ""
    @Published var email: String = ""

    // Error messages

    @Published var apiError = ""
    @Published var mailError = ""
    @Published var phoneError = ""
    @Published var linkedInErr = ""

    // MARK: Init

    init(_ candidate: Candidate) {
        self.candidate = candidate
        self.name = candidate.firstName + " " + candidate.lastName
        self.isFavorite = candidate.isFavorite
        // update details
        updateCandidateDetails()
    }
}

// MARK: Inputs

extension CandidateDetailViewModel {

    func updateCandidate() {
        // check if all texfields are valid and candidate need update
        guard textfieldsAreValid() else { return }
        // Remove edition
        isEditing = false
        // check if candidate need update
        guard candidateDetailsHaveChanged() else { return }

        // update candidate property
        candidate.email = email
        candidate.linkedinURL = linkedinURL
        candidate.note = note
        candidate.phone = phone.replacingOccurrences(of: " ", with: "")

        // Launch progress view and update
        updateInProgress = true
        Task {
            let result = await candidateService.putUpdate(candidate: candidate)
            await processServiceResult(result) {
                self.updateInProgress = false
            }
        }
    }

    func cancel() {
        // Use server value to remove modification
        updateCandidateDetails()
        // Clean error
        apiError = ""
        mailError = ""
        phoneError = ""
        linkedInErr = ""
        // remove editing mode
        isEditing = false
    }

    func favoriteToggle() {
        favoriteInProgress = true
        Task {
            let result = await candidateService.putFavoriteToggle(ForId: candidate.id)
            await processServiceResult(result) {
                self.favoriteInProgress = false
            }
        }
    }

    func openLinkedIn(withURL stringURL: String) {
        guard stringURL != "" else {
            apiError = AppError.linkedInUrlEmpty.message
            return
        }
        guard let url = URL(string: stringURL), UIApplication.shared.canOpenURL(url) else {
            apiError = AppError.invalidLinkedInUrl.message
            return
        }
        UIApplication.shared.open(url)
    }
}

// MARK: Private method

private extension CandidateDetailViewModel {

    /// Process service result on MainActor.
    /// - Parameter result: The service result to process.
    /// - Parameter completion: Code that will be executed on MainActor at the end of processing.
    /// - If success: 
    ///     - Updates candidate and candidateDetail properties from server candidate values.
    ///     - Notifies candidates need update.
    /// - If error: shows an error message.

    func processServiceResult(_ result: Result<Candidate, AppError>, completion: @escaping () -> Void) async {
        await MainActor.run {
            switch result {

            case .success(let candidate):
                self.candidate = candidate
                // notify need update
                NotificationCenter.default.post(name: .needUpdate, object: nil)
                // use server value to update candidateDetail
                updateCandidateDetails()

            case .failure(let appError):
                apiError = appError.title + " " + appError.message
            }
            completion()
        }
    }

    /// Update candidate details property from server candidate values.
    /// ## Attention: Must be call on MainActor, view will be updated.

    func updateCandidateDetails() {
        isFavorite = candidate.isFavorite
        phone = candidate.phone?.getFrPhonePattern() ?? ""
        note = candidate.note ?? ""
        linkedinURL = candidate.linkedinURL ?? ""
        email = candidate.email
    }

    /// Check if any candidate detail have been changed.
    /// - Returns: True if at least one detail has changed.

    func candidateDetailsHaveChanged() -> Bool {
        let cleanedPhone = phone.replacingOccurrences(of: " ", with: "")
        // check diff
        if email == candidate.email,
           linkedinURL == candidate.linkedinURL ?? "",
           cleanedPhone == candidate.phone ?? "",
           note == candidate.note ?? "" {
            return false
        }
        return true
    }

    /// Check if all textfields are valid, and display error message if not.
    /// ## Attention: Must be call on MainActor, view can be updated.
    /// - Returns: True if all texfileds are valid.

    func textfieldsAreValid() -> Bool {
        // empty value (Only the email must not be empty)
        guard !email.isEmpty else {
            mailError = AppError.emptyTextField.message
            return false
        }
        // valid mail
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
