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

    private let candidateService = CandidateService()
    private var allCandidates: [Candidate] = [] {
        didSet {
            applyFilter()
        }
    }

    // MARK: Outputs

    @Published private(set) var candidates: [Candidate] = []
    @Published var editMode: EditMode = .inactive
    @Published private(set) var errorMessage = "" // todo: A afficher

    var inEditMode: Bool {
        return editMode == .active
    }

    // MARK: Inputs

    var selection = Set<String>()
    var filter = (search: "", favorites: false) {
        didSet {
            applyFilter()
        }
    }
}

// MARK: Inputs methods

extension CandidatesViewModel {

    func getCandidates() { // todo: add loader
        Task {
//            await FakeCandidates().getFakeCandidates()
            switch await candidateService.getCandidates() {
            case .success(let allCandidates):
                await MainActor.run { self.allCandidates = allCandidates }

            case .failure(let failure):
                await MainActor.run { self.errorMessage = failure.title + " " + failure.message }
            }
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
}

// MARK: Private method

private extension CandidatesViewModel {

    func applyFilter() {
        var filteredList: [Candidate] = []
        // Favorites
        if filter.favorites {
            filteredList = allCandidates.filter({ $0.isFavorite })
        } else {
            filteredList = allCandidates
        }
        // Search
        if filter.search != "" {
            filteredList = filteredList.filter({ candidate in
                candidate.firstName.contains(filter.search) || candidate.lastName.contains(filter.search)
            })
        }
        // update candidates
        self.candidates = filteredList
    }
}
