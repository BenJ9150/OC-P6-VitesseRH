//
//  CandidatesView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import SwiftUI
import CoreSpotlight

struct CandidatesView: View {

    @ObservedObject var candidatesVM: CandidatesViewModel
    @State var showAlertSignOut = false

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack {
                candidatesBackground
                VStack {
                    ErrorMessageView(error: candidatesVM.errorMessage)
                    if candidatesVM.inProgress {
                        ProgressView()
                    } else {
                        candidatesList
                    }
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("")
            .toolbar { toolbarItems() }
            .searchable(text: $candidatesVM.filter.search, placement: .navigationBarDrawer(displayMode: .always))
            .environment(\.editMode, $candidatesVM.editMode)
            .alert("Sign out?", isPresented: $showAlertSignOut) {
                Button("Yes") { candidatesVM.signOut() }
                Button("Cancel", role: .cancel, action: {})
            }
            // Spotlight result
            .onContinueUserActivity(CSSearchableItemActionType, perform: candidatesVM.handleSpotlight)
            .navigationDestination(item: $candidatesVM.spotlightCandidate) { candidate in
                CandidateDetailView(candidate)
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
                    NavigationLink("", destination: CandidateDetailView(candidate))
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
        .refreshable {
            candidatesVM.getCandidates()
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
            Button {
                candidatesVM.editModeToggle()
            } label: {
                Text(candidatesVM.inEditMode ? "Cancel" : "Edit")
                    .font(.vitesseButton)
            }
        }

        // Toolbar Title
        ToolbarItem(placement: .principal) {
            Text("Candidates")
                .font(.vitesseToolbar)
        }

        // Delete Button
        if candidatesVM.inEditMode {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    candidatesVM.deleteSelection()
                } label: {
                    Text("Delete")
                        .font(.vitesseButton)
                }
            }
        } else {
            // Favorites Button
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    candidatesVM.filter.favorites.toggle()
                } label: {
                    Image(systemName: candidatesVM.filter.favorites ? "star.fill" : "star")
                        .foregroundStyle(.accent)
                }
            }
            // Sign out button
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAlertSignOut.toggle()
                } label: {
                    Image("icon_exit")
                        .renderingMode(.template) // for accent color
                        .foregroundStyle(.accent)
                }
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
    CandidatesView(candidatesVM: CandidatesViewModel({
        // nothing
    }))
}
