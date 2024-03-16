//
//  TextFieldView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct TextFieldView: View {
    // Header
    let header: String

    // Textfield
    @Binding var input: String
    let placeHolder: String
    let keyboard: UIKeyboardType

    // Focus
    @FocusState var focused: Bool

    // Secure?
    var isSecure = false

    // Error message to clean when texfield change
    @Binding var errToClean: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.vitesseSubtitle)
                .padding(.horizontal)
                .padding(.horizontal)

            textOrSecureField
                .autocapitalization(.none)
                .keyboardType(keyboard)
                .disableAutocorrection(true)
                .foregroundStyle(.white)
                .padding()
                .background(.colorDarkGray)
                .cornerRadius(12)
                .padding(.horizontal)
                .focused($focused)
                .onChange(of: input) { _, _ in
                    if errToClean != "" {
                        errToClean = ""
                    }
                }
        }
        .padding(.bottom)
    }

    private var textOrSecureField: some View {
        Group {
            if isSecure {
                SecureField("", text: $input, prompt: Text(placeHolder).foregroundStyle(.colorPlaceholder))
            } else {
                TextField("", text: $input, prompt: Text(placeHolder).foregroundStyle(.colorPlaceholder))
            }
        }
    }
}
