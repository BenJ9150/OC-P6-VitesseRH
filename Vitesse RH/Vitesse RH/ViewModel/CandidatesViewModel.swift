//
//  CandidatesViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 25/02/2024.
//

import Foundation
import SwiftUI

final class CandidatesViewModel: ObservableObject {

    // MARK: Outputs

    @Published private(set) var candidates: [Candidate] = []
    @Published var editMode: EditMode = .inactive

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

    func editModeToggle() {
        editMode = editMode == .active ? .inactive : .active
    }

    func deleteSelection() {
        // TODO: delete the selected candidates
        editMode = .inactive
    }

    // MARK: Init

    init() {
        self.candidates = allCandidates
    }

    // MARK: Private properties

    // swiftlint:disable all
    private let allCandidates = [ // TODO: Get with model
        Candidate(id: "1", phone: nil, note: nil, firstName: "Bob", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Marley"),
        Candidate(id: "2", phone: nil, note: nil, firstName: "Kurt", linkedinURL: nil, isFavorite: false, email: "test@gmail.com", lastName: "Cobain"),
        Candidate(id: "3", phone: nil, note: nil, firstName: "John", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Do"),
        Candidate(id: "4", phone: nil, note: nil, firstName: "Billy", linkedinURL: nil, isFavorite: false, email: "test@gmail.com", lastName: "Idol"),
        Candidate(id: "5", phone: nil, note: nil, firstName: "Bruce", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Wayne")
    ]
    // swiftlint:enable all
}

// MARK: Private methods

private extension CandidatesViewModel {

    func applyFilter() {
        // Favorites
        var filteredList: [Candidate]
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
        // Update candidates list
        candidates = filteredList
    }
}
