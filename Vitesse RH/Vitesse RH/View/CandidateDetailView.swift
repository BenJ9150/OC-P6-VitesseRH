//
//  CandidateDetailView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 25/02/2024.
//

import SwiftUI

struct CandidateDetailView: View {

    @ObservedObject private var candidateVM: CandidateDetailViewModel
    @FocusState private var fieldToFocus: FieldToFocus?

    // MARK: Init

    init(_ candidate: Candidate) {
        self.candidateVM = CandidateDetailViewModel(candidate)
    }

    // MARK: Body

    var body: some View {
        ZStack {
            candidateBackground
            ScrollView {
                nameAndFavorite
                ErrorMessageView(error: candidateVM.errorMessage)
                candidatePhone
                candidateEmail
                candidateLinkedin
                candidateNote
            }
        }
        .navigationTitle("")
        .toolbar { toolbarItems() }
        .navigationBarBackButtonHidden(candidateVM.isEditing)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

// MARK: Header, Favorite

private extension CandidateDetailView {

    var nameAndFavorite: some View {
        HStack {
            header(title: candidateVM.name)
            Spacer()
            if !candidateVM.isEditing {
                favoriteButton
            }
        }
        .padding(.vertical)
    }

    var favoriteButton: some View {
        Button {
            candidateVM.favoriteToggle()
        } label: {
            Image(candidateVM.isFavorite ? "icon_starFill" : "icon_star")
                .renderingMode(.template)
                .foregroundStyle(candidateVM.isAdmin ? .accent : .orange)
                .padding(.trailing)
        }
        .disabled(!candidateVM.isAdmin)
        .padding()
    }
}

// MARK: Phone

private extension CandidateDetailView {

    var candidatePhone: some View {
        Group {
            if candidateVM.isEditing {
                TextFieldView(header: "Phone", input: $candidateVM.candidateDetail.phone,
                              placeHolder: "Candidate phone number",
                              keyboard: .phonePad, textContent: .telephoneNumber)
                .focused($fieldToFocus, equals: .phone)
                .onChange(of: candidateVM.candidateDetail.phone) { _, _ in
                    candidateVM.candidateDetail.phone.applyFrPhonePattern()
                    if candidateVM.candidateDetail.phone.count > 14 {
                        candidateVM.candidateDetail.phone = String(candidateVM.candidateDetail.phone.prefix(14))
                    }
                }
            } else {
                ParagraphView(title: "Phone", text: candidateVM.candidateDetail.phone)
            }
        }
    }
}

// MARK: Mail

private extension CandidateDetailView {

    var candidateEmail: some View {
        Group {
            if candidateVM.isEditing {
                TextFieldView(header: "Email", input: $candidateVM.candidateDetail.email,
                              placeHolder: "Candidate email",
                              keyboard: .emailAddress, textContent: .emailAddress)
            } else {
                ParagraphView(title: "Email", text: candidateVM.candidateDetail.email)
                    .padding(.bottom, 48)
            }
        }
    }
}

// MARK: Linkedin

private extension CandidateDetailView {

    var candidateLinkedin: some View {
        Group {
            if candidateVM.isEditing {
                TextFieldView(header: "LinkedIn", input: $candidateVM.candidateDetail.linkedinURL,
                              placeHolder: "LinkedIn url",
                              keyboard: .URL, textContent: .URL)
            } else {
                ButtonView(title: candidateVM.candidateDetail.linkedinURL == "" ? "No Linkedin" : "Go on Linkedin",
                           actionInProgress: .constant(false),
                           disabled: candidateVM.candidateDetail.linkedinURL == "") {
                    candidateVM.openLinkedIn(withURL: candidateVM.candidateDetail.linkedinURL)
                }
            }
        }
    }
}

// MARK: Note

private extension CandidateDetailView {

    var candidateNote: some View {
        TextEditorView(header: "Note", input: $candidateVM.candidateDetail.note, disabled: !candidateVM.isEditing)
            .focused($fieldToFocus, equals: .note)
            .padding(.top, candidateVM.isEditing ? 0 : 16)
    }
}

// MARK: Toolbar

private extension CandidateDetailView {

    @ToolbarContentBuilder
    func toolbarItems() -> some ToolbarContent {

        // Cancel Button
        if candidateVM.isEditing {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    hideKeyboard()
                    candidateVM.cancel()
                    candidateVM.isEditing.toggle()
                } label: {
                    Text("Cancel")
                        .font(.vitesseButton)
                }
            }
        }

        // Edit or done Button
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                if candidateVM.isEditing {
                    hideKeyboard()
                    candidateVM.updateCandidate()
                }
                candidateVM.isEditing.toggle()
            } label: {
                Text(candidateVM.isEditing ? "Done" : "Edit")
                    .font(.vitesseButton)
            }
        }

        // Done button to numeric keyboard
        ToolbarItem(placement: .keyboard) {
            if fieldToFocus == .phone || fieldToFocus == .note {
                Button("Done") {
                    hideKeyboard()
                }
            }
        }
    }
}

// MARK: Background

private extension CandidateDetailView {

    var candidateBackground: some View {
        VStack {
            Image("image_TopBackground")
                .resizable()
                .scaledToFit()
            Spacer()
            if !candidateVM.isEditing {
                Image("image_BottomBackground")
                    .resizable()
                    .scaledToFit()
            }
        }
        .ignoresSafeArea()
        .background(Color.colorLightGray)
    }
}
