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

    @State var showSignOutAlert = false
    @State var showAddCandidateView = false

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                candidatesBackground
                VStack {
                    ErrorMessageView(error: candidatesVM.errorMessage)
                    if candidatesVM.inProgress {
                        ProgressView()
                    } else {
                        candidatesList
                    }
                }
                if candidatesVM.isAdmin {
                    addCandidateBtn
                }
            }
            // Toolbar
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("")
            .toolbar { toolbarItems() }
            .searchable(text: $candidatesVM.filter.search, placement: .navigationBarDrawer(displayMode: .always))
            .environment(\.editMode, $candidatesVM.editMode)
            // Alert
            .alert("Sign out?", isPresented: $showSignOutAlert) {
                Button("Yes") { candidatesVM.signOut() }
                Button("Cancel", role: .cancel, action: {})
            }
            // Spotlight result
            .onContinueUserActivity(CSSearchableItemActionType, perform: candidatesVM.handleSpotlight)
            // Navigation
            .navigationDestination(item: $candidatesVM.spotlightCandidate) { candidate in
                CandidateDetailView(candidate)
            }
            .navigationDestination(isPresented: $showAddCandidateView) {
                AddCandidateView()
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
        .safeAreaPadding(.bottom, 100) // for add button
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
        // Toolbar Title
        ToolbarItem(placement: .principal) {
            Text("Candidates")
                .font(.vitesseToolbar)
        }
        if candidatesVM.inEditMode {
            // Cancel button
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    candidatesVM.editModeToggle()
                } label: {
                    Text("Cancel")
                        .font(.vitesseButton)
                }
            }
            // Delete button
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    candidatesVM.deleteSelection()
                } label: {
                    Text("Delete")
                        .font(.vitesseButton)
                }
            }
        } else {
            // Sign out button
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showSignOutAlert.toggle()
                } label: {
                    Image("icon_exit")
                        .renderingMode(.template) // for accent color
                        .foregroundStyle(.accent)
                }
            }
            // Favorites Button
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    candidatesVM.filter.favorites.toggle()
                } label: {
                    Image(systemName: candidatesVM.filter.favorites ? "star.fill" : "star")
                        .foregroundStyle(.accent)
                }
                .sensoryFeedback(.success, trigger: candidatesVM.filter.favorites)
            }
            // Edit button
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    candidatesVM.editModeToggle()
                } label: {
                    Image(systemName: "highlighter")
                        .renderingMode(.template) // for accent color
                        .foregroundStyle(.accent)
                }
            }
        }
    }
}

// MARK: Add candidate

private extension CandidatesView {

    var addCandidateBtn: some View {
        ZStack {
            ButtonView(title: "New candidate") {
                showAddCandidateView.toggle()
            }
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(.colorLightGray)
                .blur(radius: 10)
                .opacity(0.9)
                .ignoresSafeArea()
        )
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
