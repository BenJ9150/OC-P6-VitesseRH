//
//  CandidateDetailViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 15/03/2024.
//

import Foundation
import SwiftUI

final class CandidateDetailViewModel: ObservableObject {

    struct CandidateDetail {
        var phone: String = ""
        var note: String = ""
        var linkedinURL: String = ""
        var email: String = ""
    }

    // MARK: Private property

    private let candidateService = CandidateService()
    private var candidate: Candidate

    // MARK: Outputs

    let isAdmin = UserDefaults.standard.bool(forKey: "VitesseUserIsAdmin")
    let name: String

    @Published var candidateDetail = CandidateDetail()
    @Published var isEditing = false
    @Published private(set) var isFavorite = false
    @Published private(set) var updateInProgress = false
    @Published private(set) var favoriteInProgress = false
    @Published var errorMessage = ""

    // MARK: Init

    init(_ candidate: Candidate) {
        self.candidate = candidate
        self.name = candidate.firstName + " " + candidate.lastName
        self.isFavorite = candidate.isFavorite
        // update detail
        updateCandidateDetail()
    }
}

// MARK: Inputs

extension CandidateDetailViewModel {

    func updateCandidate() {
        // check if all texfields are valid and candidate need update
        guard textfieldsAreValid() else { return }
        guard needCandidateUpdate() else { return }

        // Remove edition and launch progress view
        isEditing.toggle()
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
        updateCandidateDetail()
        // Clean error
        errorMessage = ""
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
            errorMessage = AppError.linkedInUrlEmpty.message
            return
        }
        guard let url = URL(string: stringURL) else {
            errorMessage = AppError.invalidLinkedInUrl.message
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
                updateCandidateDetail()

            case .failure(let appError):
                errorMessage = appError.title + " " + appError.message
            }
            completion()
        }
    }

    /// Update candidateDetail property from server candidate values.
    /// ## Attention: Must be call on MainActor, view will be updated.

    func updateCandidateDetail() {
        isFavorite = candidate.isFavorite
        candidateDetail = CandidateDetail(
            phone: self.candidate.phone?.getFrPhonePattern() ?? "",
            note: self.candidate.note ?? "",
            linkedinURL: self.candidate.linkedinURL ?? "",
            email: self.candidate.email
        )
    }

    /// Check if any candidate detail have been changed.
    /// - Returns: True if at least one detail has changed.

    func needCandidateUpdate() -> Bool {
        let cleanedPhone = candidateDetail.phone.replacingOccurrences(of: " ", with: "")
        // check diff
        if candidateDetail.email == candidate.email,
           candidateDetail.linkedinURL == candidate.linkedinURL,
           cleanedPhone == candidate.note,
           candidateDetail.phone == candidate.phone {
            return false
        }
        // update candidate property
        candidate.email = candidateDetail.email
        candidate.linkedinURL = candidateDetail.linkedinURL
        candidate.note = candidateDetail.note
        candidate.phone = cleanedPhone
        return true
    }

    /// Check if all textfields are valid, and display error message if not.
    /// ## Attention: Must be call on MainActor, view can be updated.
    /// - Returns: True if all texfileds are valid.

    func textfieldsAreValid() -> Bool {
        // empty value (Only the email must not be empty)
        guard !candidateDetail.email.isEmpty else {
            errorMessage = AppError.emptyTextField.title + " " + AppError.emptyTextField.message
            return false
        }
        // valid mail
        guard candidateDetail.email.isValidEmail() else {
            errorMessage = AppError.invalidMail.title + " " + AppError.invalidMail.message
            return false
        }
        // valid phone
        if !candidateDetail.phone.isEmpty {
            guard candidateDetail.phone.isValidFrPhone() else {
                errorMessage = AppError.invalidFrPhone.title + " " + AppError.invalidFrPhone.message
                return false
            }
        }
        return true
    }
}
