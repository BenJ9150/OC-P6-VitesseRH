//
//  CandidatesView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import SwiftUI

struct CandidatesView: View {

    @StateObject var candidatesVM = CandidatesViewModel()

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack {
                candidatesBackground
                candidatesList
                    .toolbarTitleDisplayMode(.inline)
                    .navigationTitle("")
                    .toolbar { toolbarItems() }
                    .searchable(text: $candidatesVM.filter.search)
                    .environment(\.editMode, $candidatesVM.editMode)
            }
        }
    }
}

// MARK: Candidates list

private extension CandidatesView {

    var candidatesList: some View {
        List(candidatesVM.candidates, selection: $candidatesVM.selection) { candidate in
            // Row
            CandidateRowView(candidate: candidate, editMode: candidatesVM.editMode)
                .overlay(
                    NavigationLink("", destination: CandidateDetailView(candidate: candidate))
                        .opacity(0)
                )
        }
        .listRowSeparator(.hidden)
        .listRowSpacing(12)
        .scrollContentBackground(.hidden)
        .animation(.easeOut, value: candidatesVM.editMode)
        .onAppear {
            candidatesVM.selection = Set()
        }
    }

    struct CandidateRowView: View {

        @Environment(\.colorScheme) var colorScheme
        let candidate: Candidate
        let editMode: EditMode

        var body: some View {
            HStack {
                Text(candidate.firstName + " " + candidate.lastName)
                    .font(.vitesseText)
                Spacer()
                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(.orange)
                    .animation(nil, value: editMode)
            }
            .padding()
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.colorGray, lineWidth: 2)
                    .background(colorScheme == .dark ? Color.colorDarkGray : Color.white)
            )
        }
    }
}

// MARK: Toolbar

private extension CandidatesView {

    @ToolbarContentBuilder
    func toolbarItems() -> some ToolbarContent {

        // Edit Button
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                candidatesVM.editModeToggle()
            }, label: {
                Text(candidatesVM.inEditMode ? "Cancel" : "Edit")
                    .font(.vitesseButton)
                    .animation(.bouncy, value: candidatesVM.editMode)
            })
        }

        // Toolbar Title
        ToolbarItem(placement: .principal) {
            Text("Candidates")
                .font(.vitesseToolbar)
        }

        // Delete Button
        if candidatesVM.inEditMode {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    candidatesVM.deleteSelection()
                }, label: {
                    Text("Delete")
                        .font(.vitesseButton)
                })
            }
        } else {
            // Only Favorites Button
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    candidatesVM.filter.favorites.toggle()
                }, label: {
                    Image(systemName: candidatesVM.filter.favorites ? "star.fill" : "star")
                        .foregroundStyle(.accent)
                })
            }
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
    CandidatesView()
}
