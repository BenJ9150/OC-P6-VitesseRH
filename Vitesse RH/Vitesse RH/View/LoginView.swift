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

    @FocusState private var focusedField: FocusedField?
    @FocusState private var pwdFocused: Bool

    private enum FocusedField {
        case mailToPwd, join
    }

    // MARK: Body
    
    var body: some View { // TODO: Antoine: avertissement dans debugger quand on ouvre le keyboard
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
        }
    }
}

// MARK: Texfields

private extension LoginView {

    var texfields: some View {
        VStack { // TODO: Voir si on enlève Username
            TextFieldView(header: "Email / Username", input: $loginVM.email,
                          placeHolder: "Email or Username",
                          keyboard: .emailAddress, textContent: .emailAddress)
            .focused($focusedField, equals: .mailToPwd)
            .submitLabel(.next)

            TextFieldView(header: "Password", input: $loginVM.password,
                          placeHolder: "Password",
                          keyboard: .default, textContent: .password, focused: _pwdFocused, isSecure: true)
            .submitLabel(.join)
        }
        .onSubmit {
            switch focusedField {
            case .mailToPwd:
                pwdFocused.toggle()
            default:
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
