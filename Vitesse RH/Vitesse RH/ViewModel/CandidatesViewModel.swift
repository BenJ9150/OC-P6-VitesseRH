//
//  CandidatesViewModel.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 25/02/2024.
//

import Foundation

final class CandidatesViewModel: ObservableObject {

    // MARK: Outputs

    @Published private(set) var candidates: [Candidate] = []

    @Published var filter = (search: "", favorites: false) {
        didSet {
            applyFilter()
        }
    }

    // MARK: Init

    init() {
        self.candidates = allCandidates
    }

    // MARK: Private properties

    // swiftlint:disable all
    private let allCandidates = [ // TODO: Get with model
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "Bob", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Marley"),
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "Kurt", linkedinURL: nil, isFavorite: false, email: "test@gmail.com", lastName: "Cobain"),
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "John", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Do"),
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "Billy", linkedinURL: nil, isFavorite: false, email: "test@gmail.com", lastName: "Idol"),
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "Bruce", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Wayne")
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
