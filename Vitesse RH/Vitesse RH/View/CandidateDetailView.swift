//
//  CandidateDetailView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 25/02/2024.
//

import SwiftUI

struct CandidateDetailView: View {

    @EnvironmentObject var userViewModel: UserViewModel
    let candidate: Candidate

    @State private var isEditing = false

    // MARK: Body

    var body: some View {
        ScrollView {
            nameAndFavorite
        }
    }
}

// MARK: - Common View

private extension CandidateDetailView {

    var nameAndFavorite: some View {
        HStack {
            header(title: candidate.firstName + " " + candidate.lastName)
            Spacer()
            favoriteButton
        }
        .padding()
    }

    var favoriteButton: some View {
        Button {
            // TODO: switch favoris ou non
        } label: {
            Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                .foregroundStyle(.accent)
        }
        .disabled(!false) // TODO: Antoine Remplacer false par userViewModel.isAdmin (fait crasher le preview)
    }
}

// MARK: - Non editable view

private extension CandidateDetailView {

}

// MARK: - Editable view

private extension CandidateDetailView {

}

// MARK: - Preview

#Preview {
    CandidateDetailView(candidate: Candidate(id: "1", phone: nil, note: nil, firstName: "Bob",
                                             linkedinURL: nil, isFavorite: true,
                                             email: "test@gmail.com", lastName: "Marley"))
}
