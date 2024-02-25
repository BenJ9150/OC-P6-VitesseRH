//
//  CandidatesView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import SwiftUI

struct CandidatesView: View {

    @Environment(\.colorScheme) var colorScheme

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

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack {
                candidatesBackground
                candidatesList
                    .toolbarTitleDisplayMode(.inline)
                    .navigationTitle("")
                    .toolbar { toolbarItems() }
                    .searchable(text: $search)
            }
        }
    }
}

// MARK: Candidates list

private extension CandidatesView {

    var candidatesList: some View {
        List(candidatesVM, id: \.id) { candidate in
            CandidateRowView(candidate: candidate)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.colorGray, lineWidth: 2)
                        .background(colorScheme == .dark ? Color.colorDarkGray : Color.white)
                )
        }
        .listRowSeparator(.hidden)
        .listRowSpacing(12)
        .scrollContentBackground(.hidden)
    }

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

// MARK: Background

private extension CandidatesView {

    var candidatesBackground: some View {
        VStack {
            Image("image_TopBackground")
                .resizable()
                .scaledToFit()
            Spacer()
            Image("image_BottomBackground")
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea()
        .background(Color.colorLightGray)
    }
}

// MARK: Preview

#Preview {
    CandidatesView(isAdmin: true)
}