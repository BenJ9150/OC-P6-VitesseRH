//
//  LoginView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct LoginView: View {

    @ObservedObject var loginVM: LoginViewModel
    @State private var showRegisterView = false

    @FocusState private var fieldToFocus: FieldToFocus?
    @FocusState private var pwdFocus: Bool

    // MARK: Body

    // TODO: Antoine: avertissement dans debugger quand on ouvre le keyboard

    var body: some View {
        NavigationStack {
            ZStack {
                imageBottom
                VStack {
                    imageTop
                    Spacer()
                    header(title: "Login")
                    Spacer()
                    texfields
                    Spacer()
                    ErrorMessageView(error: loginVM.errorMessage)
                    buttons
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showRegisterView) {
                RegisterView()
            }
            .onTapGesture {
                // TODO: Antoine: comment on peut masquer le clavier proprement ?
                // La, le clic ne fonctionne pas partout
                hideKeyboard()
            }
        }
    }
}

// MARK: Texfields

private extension LoginView {

    var texfields: some View { // TODO: Voir si on enlève Username
        VStack {
            TextFieldView(header: "Email / Username", input: $loginVM.email,
                          placeHolder: "Email or Username",
                          keyboard: .emailAddress, textContent: .emailAddress)
            .focused($fieldToFocus, equals: .password)
            .submitLabel(.next)

            TextFieldView(header: "Password", input: $loginVM.password,
                          placeHolder: "Password",
                          keyboard: .default, textContent: .password,
                          focused: _pwdFocus, isSecure: true)
            .submitLabel(.join)
        }
        .onSubmit {
            switch fieldToFocus {
            case .password:
                pwdFocus.toggle()
            default: // join
                loginVM.signIn()
            }
        }
    }
}

// MARK: Buttons

private extension LoginView {

    var buttons: some View {
        Group {
            ButtonView(title: "Sign in") {
                hideKeyboard()
                loginVM.signIn()
            }

            ButtonView(title: "Register") {
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
    }

    var imageBottom: some View {
        VStack {
            Spacer()
            Image("icon_wave")
                .resizable()
                .scaledToFit()
                .padding(.top)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: Preview

// #Preview {
//    LoginView()
// }
