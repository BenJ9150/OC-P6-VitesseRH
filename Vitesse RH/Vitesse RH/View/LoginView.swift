//
//  LoginView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""

    // MARK: Body

    var body: some View {
        VStack {
            imageTop
            Spacer()
            header
            Spacer()
            texfields
            Spacer()
            buttons
            imageButton
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: Texfields

private extension LoginView {

    var header: some View {
        Text("Login")
            .font(.vitesseTitle)
    }

    var texfields: some View {
        Group {
            TextFieldView(header: "Email / Username", input: $email, placeHolder: "Email or Username",
                          keyboard: .emailAddress, textContent: .emailAddress)

            TextFieldView(header: "Password", input: $password, placeHolder: "Password",
                          keyboard: .default, textContent: .password, isSecure: true)
        }
    }
}

// MARK: Buttons

private extension LoginView {

    var buttons: some View {
        Group {
            ButtonView(title: "Sign in") {
                // TODO: sign In
            }

            ButtonView(title: "Register") {
                // TODO: sign In
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

    var imageButton: some View {
        Image("icon_wave")
            .resizable()
            .scaledToFit()
            .padding(.top)
    }
}

#Preview {
    LoginView()
}
