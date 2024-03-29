//
//  FakeCandidates.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 08/03/2024.
//

import Foundation

class FakeCandidates {

    func getFakeCandidates() async {

        for candidate in allCandidates {
            _ = await CandidateService().postToAdd(candidate: candidate)
        }
    }

    // swiftlint:disable all
    private let allCandidates = [
        Candidate(id: "1", phone: "0600000000", note: nil, firstName: "Bob", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Marley"),
        Candidate(id: "2", phone: nil, note: nil, firstName: "Kurt", linkedinURL: "https://openclassrooms.com", isFavorite: false, email: "test@gmail.com", lastName: "Cobain"),
        Candidate(id: "3", phone: nil, note: nil, firstName: "John", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Do"),
        Candidate(id: "4", phone: nil, note: nil, firstName: "Billy", linkedinURL: nil, isFavorite: false, email: "test@gmail.com", lastName: "Idol"),
        Candidate(id: "5", phone: nil, note: nil, firstName: "Bruce", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Wayne"),
        Candidate(id: "5", phone: nil, note: nil, firstName: "Benjamin", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "Lef")
    ]
    // swiftlint:enable all
}
