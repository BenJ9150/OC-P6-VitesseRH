//
//  CandidatesViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 25/02/2024.
//

import Foundation
import SwiftUI

final class CandidatesViewModel: ObservableObject {

    // MARK: Private property

    let candidateService = CandidateService()

    // MARK: Outputs

    @Published private(set) var candidates: [Candidate] = []
    @Published var editMode: EditMode = .inactive
    @Published var errorMessage = "" // todo: A afficher

    var inEditMode: Bool {
        return editMode == .active
    }

    var isAdmin: Bool {
        return UserDefaults.standard.bool(forKey: "VitesseUserIsAdmin")
    }

    // MARK: Inputs

    var selection = Set<String>()

    var filter = (search: "", favorites: false) {
        didSet {
            applyFilter()
        }
    }

    func editModeToggle() {
        editMode = editMode == .active ? .inactive : .active
    }

    func deleteSelection() { // todo: Add loader view
        editMode = .inactive
        Task {
            for candidateId in selection {
                _ = await candidateService.deleteCandidate(WithId: candidateId)
            }
            selection = Set()
            getCandidates()
        }
    }

    func favoriteToggle(ofCandidateId candidateId: String) {
        Task { @MainActor in
            switch await candidateService.favoriteToggle(ForId: candidateId) {
            case .success(let success):
                self.getCandidates() // todo: A revoir, juste mettre à jour le candidat
            case .failure(let failure):
                print(failure.message) // todo: A afficher
            }
        }
        // todo: update the selected candidate (if admin)
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

    // MARK: Init

    init() {
        getCandidates()
    }
}

// MARK: Private methods

private extension CandidatesViewModel {

    func getCandidates() {
        Task { @MainActor in
//            await FakeCandidates().getFakeCandidates()

            switch await candidateService.getCandidates() {
            case .success(let allCandidates):
                self.candidates = allCandidates // todo: voir si on peut mettre seulement ça sur le main actor (idem pour les autres)

            case .failure(let failure):
                self.errorMessage = failure.title + " " + failure.message
            }
        }
    }
    func applyFilter() {
        // Favorites
        var filteredList: [Candidate]
        if filter.favorites {
            filteredList = candidates.filter({ $0.isFavorite })
        } else {
            filteredList = candidates
        }
        // Search
        if filter.search != "" {
            filteredList = filteredList.filter({ candidate in
                candidate.firstName.contains(filter.search) || candidate.lastName.contains(filter.search)
            })
        }
        // Update candidates list
        candidates = filteredList
    }
}
