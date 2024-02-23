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

    // MARK: Body

    var body: some View {
        VStack {
            ScrollView {
                header(title: "Register")
                texfields
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            if registerVM.isRegistering {
                ProgressView()
            } else {
                VStack {
                    ErrorMessageView(error: registerVM.errorMessage)
                    createButton
                }
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

    var texfields: some View {
        Group {
            TextFieldView(header: "First Name", input: $registerVM.firstName,
                          placeHolder: "Your first name",
                          keyboard: .default, textContent: .name)

            TextFieldView(header: "Last Name", input: $registerVM.lastName,
                          placeHolder: "Your last name",
                          keyboard: .default, textContent: .familyName)

            TextFieldView(header: "Email / Username", input: $registerVM.email,
                          placeHolder: "Email or Username",
                          keyboard: .emailAddress, textContent: .emailAddress)

            TextFieldView(header: "Password", input: $registerVM.password,
                          placeHolder: "Your password",
                          keyboard: .default, textContent: .password, isSecure: true)

            TextFieldView(header: "Confirm Password", input: $registerVM.confirmPwd,
                          placeHolder: "Confirm your password",
                          keyboard: .default, textContent: .password, isSecure: true)
        }
    }
}

// MARK: Create button

private extension RegisterView {

    var createButton: some View {
        ButtonView(title: "Create") {
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
