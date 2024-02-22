//
//  RegisterView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct RegisterView: View {

    @Environment(\.dismiss) var dismiss

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPwd = ""

    // MARK: Body

    var body: some View {
        VStack {
            ScrollView {
                header(title: "Register")
                texfields
            }
            createButton
        }
    }
}

// MARK: Texfields

private extension RegisterView {

    var texfields: some View {
        Group {
            TextFieldView(header: "First Name", input: $firstName, placeHolder: "Your first name",
                          keyboard: .default, textContent: .name)

            TextFieldView(header: "Last Name", input: $lastName, placeHolder: "Your last name",
                          keyboard: .default, textContent: .familyName)

            TextFieldView(header: "Email / Username", input: $email, placeHolder: "Email or Username",
                          keyboard: .emailAddress, textContent: .emailAddress)

            TextFieldView(header: "Password", input: $password, placeHolder: "Your password",
                          keyboard: .default, textContent: .password, isSecure: true)

            TextFieldView(header: "Confirm Password", input: $confirmPwd, placeHolder: "Confirm your password",
                          keyboard: .default, textContent: .password, isSecure: true)
        }
    }
}

// MARK: Create button

private extension RegisterView {

    var createButton: some View {
        ButtonView(title: "Create") {
            // TODO: Register with loader and dismiss view
            dismiss()
        }
    }
}

// MARK: Preview

#Preview {
    RegisterView()
}
