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

    func updateCandidate() { // todo: add loader, + verif champs vide ou inexacte
        if !needCandidateUpdate() {
            return
        }
        Task {
            switch await candidateService.update(candidate: candidate) {
            case .success(let candidate):
                self.candidate = candidate
                await MainActor.run { self.updateCandidateDetail() }

            case .failure(let failure):
                await MainActor.run { self.errorMessage = failure.title + " " + failure.message }
            }
        }
    }

    func cancel() {
        Task { @MainActor in
            self.updateCandidateDetail()
        }
    }

    func favoriteToggle() { // todo: add loader
        Task {
            switch await candidateService.favoriteToggle(ForId: candidate.id) {
            case .success(let candidate):
                self.candidate = candidate
                await MainActor.run { self.updateCandidateDetail() }

            case .failure(let failure):
                await MainActor.run { self.errorMessage = failure.title + " " + failure.message }
            }
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

    func updateCandidateDetail() {
        isFavorite = candidate.isFavorite
        candidateDetail = CandidateDetail(
            phone: self.candidate.phone?.getFrPhonePattern() ?? "",
            note: self.candidate.note ?? "",
            linkedinURL: self.candidate.linkedinURL ?? "",
            email: self.candidate.email
        )
    }

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
}
