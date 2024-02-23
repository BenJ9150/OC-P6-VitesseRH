//
//  CandidatesView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import SwiftUI

struct CandidatesView: View {

    // swiftlint:disable all
    let candidatesVM = [
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "Candidat", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "1"),
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "Candidat", linkedinURL: nil, isFavorite: false, email: "test@gmail.com", lastName: "2"),
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "Candidat", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "3"),
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "Candidat", linkedinURL: nil, isFavorite: false, email: "test@gmail.com", lastName: "4"),
        Candidate(phone: nil, note: nil, id: "\(UUID())", firstName: "Candidat", linkedinURL: nil, isFavorite: true, email: "test@gmail.com", lastName: "5")
    ]
    // swiftlint:enable all

    let isAdmin: Bool

    @State private var search: String = ""

    var body: some View {
        NavigationStack {
            List(candidatesVM, id: \.id) { candidate in
                CandidateRowView(candidate: candidate)
            }
            .listRowSeparator(.hidden)
            .listRowSpacing(12)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("")
            .toolbar { toolbarItems() }
            .searchable(text: $search)
        }
    }
}

// MARK: Row

extension CandidatesView {

    struct CandidateRowView: View {
        let candidate: Candidate

        var body: some View {
            HStack {
                Text(candidate.firstName + " " + candidate.lastName)
                    .font(.vitesseText)
                Spacer()
                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(.orange)
            }
            .padding()
        }
    }
}

// MARK: Toolbar

private extension CandidatesView {

    @ToolbarContentBuilder
    func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                // To do
            }, label: {
                Text("Edit")
                    .font(.vitesseButton)
            })
        }
        ToolbarItem(placement: .principal) {
            Text("Candidates")
                .font(.vitesseToolbar)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                // To do
            }, label: {
                Image(systemName: "star.fill")
                    .foregroundStyle(.accent)
            })
        }
    }
}
#Preview {
    CandidatesView(isAdmin: true)
}
