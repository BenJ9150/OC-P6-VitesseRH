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
        if !textfieldsAreValid() { return }
        if !needCandidateUpdate() { return }

        Task { // TODO: Antoine: ça fait des await MainActor.run partout, on peut faire mieux ?
            await MainActor.run {
                isEditing.toggle()
                updateInProgress = true
            }
            // update candidate
            switch await candidateService.update(candidate: candidate) {
            case .success(let candidate):
                self.candidate = candidate
                await MainActor.run { self.updateCandidateDetail() }

            case .failure(let failure):
                await MainActor.run { self.errorMessage = failure.title + " " + failure.message }
            }
            await MainActor.run { updateInProgress = false }
        }
    }

    func cancel() {
        Task { @MainActor in
            // Use server value to remove modification
            updateCandidateDetail()
            // Clean error
            errorMessage = ""
        }
    }

    func favoriteToggle() {
        Task {
            await MainActor.run { favoriteInProgress = true }
            // Toggle favorite state
            switch await candidateService.favoriteToggle(ForId: candidate.id) {
            case .success(let candidate):
                self.candidate = candidate
                await MainActor.run { self.updateCandidateDetail() }

            case .failure(let failure):
                await MainActor.run { self.errorMessage = failure.title + " " + failure.message }
            }
            await MainActor.run { favoriteInProgress = false }
            // TODO: Antoine: quand je met un breakpoint ligne 96, je ne vois pas le loader
            // Est-ce que du coup la methode peut être appelée avant que le bouton favoris ne switch d'état ?
        }
    }

    func openLinkedIn(withURL stringURL: String) {
        guard stringURL != "" else {
            Task { @MainActor in
                self.errorMessage = AppError.linkedInUrlEmpty.message
            }
            return
        }
        guard let url = URL(string: stringURL) else {
            Task { @MainActor in
                self.errorMessage = AppError.invalidLinkedInUrl.message
            }
            return
        }
        UIApplication.shared.open(url)
    }
}

// MARK: Private method

private extension CandidateDetailViewModel {

    /// Update candidateDetail property from server candidate values.

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
    /// - Returns: True if all texfileds are valid.

    func textfieldsAreValid() -> Bool {
        // empty value
        guard !candidateDetail.phone.isEmpty,
              !candidateDetail.email.isEmpty,
              !candidateDetail.linkedinURL.isEmpty else {

            Task { @MainActor in
                self.errorMessage = AppError.emptyTextField.title + " " + AppError.emptyTextField.message
            }
            return false
        }
        // valid mail
        guard candidateDetail.email.isValidEmail() else {
            Task { @MainActor in
                self.errorMessage = AppError.invalidMail.title + " " + AppError.invalidMail.message
            }
            return false
        }
        // valid phone
        guard candidateDetail.phone.isValidFrPhone() else {
            Task { @MainActor in
                self.errorMessage = AppError.invalidFrPhone.title + " " + AppError.invalidFrPhone.message
            }
            return false
        }
        return true
    }
}
