//
//  LoginView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct LoginView: View {

    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var loginVM: LoginViewModel
    @State private var showRegisterView = false

    @FocusState private var fieldToFocus: FieldToFocus?
    @FocusState private var pwdFocus: Bool

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack {
                imageBottom
                VStack {
                    imageTop
                    Divider()
                        .padding(.horizontal, 48)
                    header(title: "Login")
                    texfields
                    ErrorMessageView(error: loginVM.apiError)
                    buttons
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showRegisterView) {
                RegisterView()
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

// MARK: Texfields

private extension LoginView {

    var texfields: some View {
        VStack {
            TextFieldView(
                header: "Email",
                input: $loginVM.email,
                placeHolder: "Your email",
                keyboard: .emailAddress,
                error: $loginVM.mailError
            )
            .focused($fieldToFocus, equals: .password)
            .submitLabel(.next)

            TextFieldView(
                header: "Password",
                input: $loginVM.password,
                placeHolder: "Your password",
                keyboard: .default,
                focused: _pwdFocus,
                isSecure: true,
                error: $loginVM.pwdError
            )
            .submitLabel(.join)
        }
        .padding(.bottom, 24)
        .onSubmit {
            switch fieldToFocus {
            case .password:
                pwdFocus.toggle()
            default: // join
                hideKeyboard()
                loginVM.signIn()
            }
        }
    }
}

// MARK: Buttons

private extension LoginView {

    var buttons: some View {
        Group {
            ButtonView(title: "Sign in", actionInProgress: loginVM.inProgress) {
//                hideKeyboard()
                loginVM.signIn()
            }

            ButtonView(title: "Register", hidden: loginVM.inProgress) {
                hideKeyboard()
                showRegisterView.toggle()
            }
        }
    }
}

// MARK: Background

private extension LoginView {

    var imageTop: some View {
        Image("logo_vitesse")
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 64)
            .padding(.bottom, 48)
            .padding(.top)
    }

    var imageBottom: some View {
        VStack {
            Spacer()
            Image("image_wave")
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
        // add background for tap gesture to hide keyboard
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

// MARK: Preview

#Preview {
    LoginView(loginVM: LoginViewModel({
        // nothing
    }))
}
