//
//  AddCandidateView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 30/03/2024.
//

import SwiftUI

struct AddCandidateView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject var addCandidateVM = AddCandidateViewModel()
    @State private var showDiscardChangesAlert = false

    @FocusState private var fieldToFocus: FieldToFocus?
    @FocusState private var lastNameFocus: Bool
    @FocusState private var emailFocus: Bool
    @FocusState private var phoneFocus: Bool
    @FocusState private var noteFocus: Bool
    @FocusState private var linkedInFocus: Bool

    // MARK: Body

    var body: some View {
        ZStack {
            candidateBackground
            if addCandidateVM.addInProgress {
                ProgressView()
            } else {
                ScrollView {
                    ErrorMessageView(error: addCandidateVM.apiError)
                    texfields
                }
            }
        }
        .navigationTitle("")
        .toolbar { toolbarItems() }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
        .alert("Discard changes?", isPresented: $showDiscardChangesAlert) {
            Button("Yes") { dismiss() }
            Button("No", role: .cancel, action: {})
        }
        .onChange(of: addCandidateVM.dismissView) { _, dismiss in
            if dismiss { self.dismiss() }
        }
    }
}

// MARK: Texfields

private extension AddCandidateView {

    var texfields: some View {
        VStack {
            TextFieldView(
                header: "First Name",
                input: $addCandidateVM.firstName,
                placeHolder: "Your first name",
                keyboard: .default,
                error: $addCandidateVM.firstNameErr
            )
            .focused($fieldToFocus, equals: .lastName)
            .submitLabel(.next)

            TextFieldView(
                header: "Last Name",
                input: $addCandidateVM.lastName,
                placeHolder: "Your last name",
                keyboard: .default,
                focused: _lastNameFocus,
                error: $addCandidateVM.lastNameErr
            )
            .focused($fieldToFocus, equals: .email)
            .submitLabel(.next)

            TextFieldView(
                header: "Email",
                input: $addCandidateVM.email,
                placeHolder: "Your email",
                keyboard: .emailAddress,
                focused: _emailFocus,
                error: $addCandidateVM.mailError
            )
            .focused($fieldToFocus, equals: .linkedIn)
            .submitLabel(.next)

            TextFieldView(
                header: "LinkedIn",
                input: $addCandidateVM.linkedinURL,
                placeHolder: "LinkedIn url",
                keyboard: .URL,
                focused: _linkedInFocus,
                error: $addCandidateVM.linkedInErr
            )
            .focused($fieldToFocus, equals: .phone)
            .submitLabel(.next)

            TextFieldView(
                header: "Phone",
                input: $addCandidateVM.phone,
                placeHolder: "Candidate phone number",
                keyboard: .phonePad,
                focused: _phoneFocus,
                error: $addCandidateVM.phoneError
            )
            .focused($fieldToFocus, equals: .note)
            .onChange(of: addCandidateVM.phone) { _, _ in
                addCandidateVM.phone.applyFrPhonePattern()
            }

            TextEditorView(header: "Note", input: $addCandidateVM.note, disabled: false)
                .focused($fieldToFocus, equals: .note)
        }
        .padding(.top)
        .padding(.bottom)
        .onSubmit {
            switch fieldToFocus {
            case .lastName:
                lastNameFocus.toggle()
            case .email:
                emailFocus.toggle()
            case .phone:
                phoneFocus.toggle()
            case .linkedIn:
                linkedInFocus.toggle()
            default:
                break
            }
        }
    }
}

// MARK: Toolbar

private extension AddCandidateView {

    @ToolbarContentBuilder
    func toolbarItems() -> some ToolbarContent {

        // Cancel Button
        ToolbarItem(placement: .topBarLeading) {
            Button {
                hideKeyboard()
                if addCandidateVM.detailsHaveBeenEdited {
                    showDiscardChangesAlert.toggle()
                } else {
                    dismiss()
                }
            } label: {
                Text("Cancel")
                    .font(.vitesseButton)
            }
        }

        // done Button
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                hideKeyboard()
                addCandidateVM.addCandidate()
            } label: {
                Text("Done")
                    .font(.vitesseButton)
            }
        }

        // Done button to numeric or textEditor keyboard
        ToolbarItem(placement: .keyboard) {
            if fieldToFocus == .note {
                Button("Done") {
                    hideKeyboard()
                }
            }
        }
    }
}

// MARK: Background

private extension AddCandidateView {

    var candidateBackground: some View {
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
