//
//  RegisterView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct RegisterView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var registerVM = RegisterViewModel()

    @FocusState private var fieldToFocus: FieldToFocus?
    @FocusState private var lastNameFocus: Bool
    @FocusState private var emailFocus: Bool
    @FocusState private var pwdFocus: Bool
    @FocusState private var confirmPwdFocus: Bool

    // MARK: Body

    // TODO: Antoine: avertissement dans debugger quand on ouvre le keyboard

    var body: some View {
        VStack {
            // Scroll view with textfields
            ScrollView {
                header(title: "Register")
                texfields
            }
            .background(colorScheme == .dark ? Color.black : Color.white)

            // Create button
            VStack {
                ErrorMessageView(error: registerVM.errorMessage)
                createButton
            }
        }
        .background(Color.colorLightGray)
        .onChange(of: registerVM.isRegistered) { _, isRegistered in
            if isRegistered {
                dismiss()
            }
        }
    }
}

// MARK: Texfields

private extension RegisterView {

    var texfields: some View { // TODO: Voir si on enlève Username
        VStack {
            TextFieldView(header: "First Name", input: $registerVM.firstName,
                          placeHolder: "Your first name",
                          keyboard: .default, textContent: .name)
            .focused($fieldToFocus, equals: .lastName)
            .submitLabel(.next)

            TextFieldView(header: "Last Name", input: $registerVM.lastName,
                          placeHolder: "Your last name",
                          keyboard: .default, textContent: .familyName, focused: _lastNameFocus)
            .focused($fieldToFocus, equals: .email)
            .submitLabel(.next)

            TextFieldView(header: "Email / Username", input: $registerVM.email,
                          placeHolder: "Email or Username",
                          keyboard: .emailAddress, textContent: .emailAddress, focused: _emailFocus)
            .focused($fieldToFocus, equals: .password)
            .submitLabel(.next)

            TextFieldView(header: "Password", input: $registerVM.password,
                          placeHolder: "Your password",
                          keyboard: .default, textContent: .password,
                          focused: _pwdFocus, isSecure: true)
            .focused($fieldToFocus, equals: .confirmPwd)
            .submitLabel(.next)

            TextFieldView(header: "Confirm Password", input: $registerVM.confirmPwd,
                          placeHolder: "Confirm your password",
                          keyboard: .default, textContent: .password,
                          focused: _confirmPwdFocus, isSecure: true)
            .submitLabel(.join)
        }
        .onSubmit {
            switch fieldToFocus {
            case .lastName:
                lastNameFocus.toggle()
            case .email:
                emailFocus.toggle()
            case .password:
                pwdFocus.toggle()
            case .confirmPwd:
                confirmPwdFocus.toggle()
            default: // join
                registerVM.register()
            }
        }
    }
}

// MARK: Create button

private extension RegisterView {

    var createButton: some View {
        ButtonView(title: "Create", actionInProgress: $registerVM.inProgress) {
            hideKeyboard()
            registerVM.register()
        }
        .padding(.top)
    }
}

// MARK: Preview

#Preview {
    RegisterView()
}
