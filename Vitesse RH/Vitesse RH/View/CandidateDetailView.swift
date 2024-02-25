//
//  CandidateDetailView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 25/02/2024.
//

import SwiftUI

struct CandidateDetailView: View {

    let candidate: Candidate

    var body: some View {
        Text(candidate.firstName + " " + candidate.lastName)
    }
}

#Preview {
    CandidateDetailView(candidate: Candidate(id: "1", phone: nil, note: nil, firstName: "Bob",
                                             linkedinURL: nil, isFavorite: true,
                                             email: "test@gmail.com", lastName: "Marley"))
}
