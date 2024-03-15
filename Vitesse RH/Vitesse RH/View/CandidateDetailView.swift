//
//  CandidateDetailView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 25/02/2024.
//

import SwiftUI

struct CandidateDetailView: View {

    @ObservedObject var candidatesVM: CandidatesViewModel
    let candidate: Candidate

    @State private var isEditing = false
    @State private var phone: String
    @State private var email: String
    @State private var linkedinURL: String
    @State private var note: String

    @FocusState private var fieldToFocus: FieldToFocus?

    // MARK: Init

    init(candidatesVM: CandidatesViewModel, candidate: Candidate) {
        self.candidatesVM = candidatesVM
        self.candidate = candidate
        self.phone = candidate.phone == nil ? "" : candidate.phone!
        self.email = candidate.email
        self.linkedinURL = candidate.linkedinURL == nil ? "" : candidate.linkedinURL!
        self.note = candidate.note == nil ? "" : candidate.note!
    }

    // MARK: Body

    var body: some View {
        ZStack {
            candidateBackground
            ScrollView {
                nameAndFavorite
                candidatePhone
                candidateEmail
                candidateLinkedin
                candidateNote
            }
        }
        .navigationTitle("")
        .toolbar { toolbarItems() }
        .navigationBarBackButtonHidden(isEditing)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

// MARK: Header

private extension CandidateDetailView {

    var nameAndFavorite: some View {
        HStack {
            header(title: candidate.firstName + " " + candidate.lastName)
            Spacer()
            favoriteButton
        }
        .padding(.vertical)
    }

    var favoriteButton: some View {
        Button {
            candidatesVM.favoriteToggle(ofCandidateId: candidate.id)
        } label: {
            Image(candidate.isFavorite ? "icon_starFill" : "icon_star")
                .renderingMode(.template)
                .foregroundStyle(candidatesVM.isAdmin ? .accent : .orange)
                .padding(.trailing)
        }
        .disabled(!candidatesVM.isAdmin)
        .padding()
    }
}

// MARK: Phone

private extension CandidateDetailView {

    var candidatePhone: some View {
        Group {
            if isEditing {
                TextFieldView(header: "Phone", input: $phone,
                              placeHolder: "Candidate phone number",
                              keyboard: .phonePad, textContent: .telephoneNumber)
                .focused($fieldToFocus, equals: .phone)
                .onChange(of: phone) { _, _ in
                    phone.applyFrPhonePattern()
                    if phone.count > 14 {
                        phone = String(phone.prefix(14))
                    }
                }
            } else {
                ParagraphView(title: "Phone", text: phone)
            }
        }
        .onAppear {
            phone.applyFrPhonePattern()
        }
    }
}

// MARK: Mail

private extension CandidateDetailView {

    var candidateEmail: some View {
        Group {
            if isEditing {
                TextFieldView(header: "Email", input: $email,
                              placeHolder: "Candidate email",
                              keyboard: .emailAddress, textContent: .emailAddress)
            } else {
                ParagraphView(title: "Email", text: email)
                    .padding(.bottom, 48)
            }
        }
    }
}

// MARK: Linkedin

private extension CandidateDetailView {

    var candidateLinkedin: some View {
        Group {
            if isEditing {
                TextFieldView(header: "LinkedIn", input: $linkedinURL,
                              placeHolder: "LinkedIn url",
                              keyboard: .URL, textContent: .URL)
            } else {
                ErrorMessageView(error: candidatesVM.errorMessage)
                ButtonView(title: linkedinURL == "" ? "No Linkedin" : "Go on Linkedin",
                           actionInProgress: .constant(false), disabled: linkedinURL == "") {
                    candidatesVM.openLinkedIn(withURL: linkedinURL)
                }
            }
        }
    }
}

// MARK: Note

private extension CandidateDetailView {

    var candidateNote: some View {
        TextEditorView(header: "Note", input: $note, disabled: !isEditing)
            .focused($fieldToFocus, equals: .note)
            .padding(.top, isEditing ? 0 : 16)
    }
}

// MARK: Toolbar

private extension CandidateDetailView {

    @ToolbarContentBuilder
    func toolbarItems() -> some ToolbarContent {

        // Cancel Button
        if isEditing {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    // todo: Dismiss modif
                    hideKeyboard()
                    isEditing.toggle()
                } label: {
                    Text("Cancel")
                        .font(.vitesseButton)
                }
            }
        }

        // Edit Button
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                if isEditing {
                    // todo: Save modif
                    hideKeyboard()
                }
                isEditing.toggle()
            } label: {
                Text(isEditing ? "Done" : "Edit")
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
            if !isEditing {
                Image("image_BottomBackground")
                    .resizable()
                    .scaledToFit()
            }
        }
        .ignoresSafeArea()
        .background(Color.colorLightGray)
    }
}

// MARK: Preview

#Preview {
    CandidateDetailView(candidatesVM: CandidatesViewModel(),
                        candidate: Candidate(id: "1", phone: "0600000000",
                                             note: nil,
                                             firstName: "Bob",
                                             linkedinURL: nil,
                                             isFavorite: true,
                                             email: "test@gmail.com",
                                             lastName: "Marley"))
}
