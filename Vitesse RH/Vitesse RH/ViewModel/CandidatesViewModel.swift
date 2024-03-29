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

    private let onSignOut: (() -> Void)
    private let candidateService = CandidateService()
    private var allCandidates: [Candidate] = [] {
        didSet {
            applyFilter()
        }
    }

    // MARK: Outputs

    /// Candidates list filtered or not.
    @Published private(set) var candidates: [Candidate] = []
    @Published var editMode: EditMode = .inactive
    @Published private(set) var errorMessage = ""
    @Published private(set) var inProgress = false

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

    // MARK: Init

    init(_ callback: @escaping () -> Void) {
        self.onSignOut = callback
        getCandidates()
        // Need update notification
        NotificationCenter.default.addObserver(self, selector: #selector(needUpdate), name: .needUpdate, object: nil)
    }
}

// MARK: Inputs methods

extension CandidatesViewModel {

    func getCandidates() {
        if !inProgress {
            inProgress = true
        }
        Task {
            let result = await candidateService.getCandidates()
            await processServiceResult(result) {
                self.inProgress = false
            }
        }
    }

    func editModeToggle() {
        editMode = editMode == .active ? .inactive : .active
    }

    func deleteSelection() {
        editMode = .inactive
        inProgress = true
        Task {
            for candidateId in selection {
                _ = await candidateService.deleteCandidate(WithId: candidateId)
            }
            selection = Set()
            getCandidates()
        }
    }

    func signOut() {
        onSignOut()
    }
}

// MARK: Private method

private extension CandidatesViewModel {

    /// Process service result on MainActor.
    /// - Parameter result: The service result to process.
    /// - Parameter completion: Code that will be executed on MainActor at the end of processing.
    /// - If success: updates allCandidates property  from server candidates list value.
    /// - If error: shows an error message.

    func processServiceResult(_ result: Result<[Candidate], AppError>, completion: @escaping () -> Void) async {
        await MainActor.run {
            switch result {

            case .success(let allCandidates):
                self.allCandidates = allCandidates

            case .failure(let appError):
                errorMessage = appError.title + " " + appError.message
            }
            completion()
        }
    }

    /// Use allCandidates list to update candidates list with current filter values.
    /// ## Attention: Must be call on MainActor, view will be updated.

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

    @objc func needUpdate() {
        getCandidates()
    }
}
