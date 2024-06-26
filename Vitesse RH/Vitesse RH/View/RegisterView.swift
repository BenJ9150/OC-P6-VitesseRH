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

    var body: some View {
        VStack {
            // Scroll view with textfields
            ScrollView {
                header(title: "Register")
                Divider()
                    .padding(.horizontal, 48)
                    .padding(.bottom)
                texfields
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            // Create button
            VStack {
                ErrorMessageView(error: registerVM.apiError)
                createButton
            }
        }
        .background(Color.colorLightGray)
//        .onChange(of: registerVM.isRegistered) { _, isRegistered in
//            if isRegistered {
//                showSuccessAlert.toggle()
//                dismiss()
//            }
//        }
        .onTapGesture {
            hideKeyboard()
        }
        // Alert success
        .alert("Welcome " + registerVM.firstName, isPresented: $registerVM.isRegistered) {
            Button("Got it!", role: .cancel, action: { dismiss() })
        } message: {
            Text("Log in with your email and password.")
        }
    }
}

// MARK: Texfields

private extension RegisterView {

    var texfields: some View {
        VStack {
            TextFieldView(
                header: "First Name",
                input: $registerVM.firstName,
                placeHolder: "Your first name",
                keyboard: .default,
                error: $registerVM.firstNameErr
            )
            .focused($fieldToFocus, equals: .lastName)
            .submitLabel(.next)

            TextFieldView(
                header: "Last Name",
                input: $registerVM.lastName,
                placeHolder: "Your last name",
                keyboard: .default,
                focused: _lastNameFocus,
                error: $registerVM.lastNameErr
            )
            .focused($fieldToFocus, equals: .email)
            .submitLabel(.next)

            TextFieldView(
                header: "Email",
                input: $registerVM.email,
                placeHolder: "Your email",
                keyboard: .emailAddress,
                focused: _emailFocus,
                error: $registerVM.mailError
            )
            .focused($fieldToFocus, equals: .password)
            .submitLabel(.next)

            TextFieldView(
                header: "Password", input: $registerVM.password,
                placeHolder: "Your password",
                keyboard: .default,
                focused: _pwdFocus,
                isSecure: true,
                error: $registerVM.pwdError
            )
            .focused($fieldToFocus, equals: .confirmPwd)
            .submitLabel(.next)

            TextFieldView(
                header: "Confirm Password",
                input: $registerVM.confirmPwd,
                placeHolder: "Confirm your password",
                keyboard: .default,
                focused: _confirmPwdFocus,
                isSecure: true,
                error: $registerVM.confirmPwdErr
            )
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
        ButtonView(title: "Create", actionInProgress: registerVM.inProgress) {
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
