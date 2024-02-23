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
    let textContent: UITextContentType

    // Focus
    @FocusState var focused: Bool

    // Secure?
    var isSecure = false

    var body: some View {
        VStack {
            Text(header)
                .font(.vitesseSubtitle)

            textOrSecureField
                .autocapitalization(.none)
                .keyboardType(keyboard)
                .textContentType(textContent)
                .disableAutocorrection(true)
                .foregroundStyle(.white)
                .padding()
                .background(.colorDarkGray)
                .cornerRadius(12)
                .padding(.horizontal)
                .focused($focused)
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

#Preview {
    TextFieldView(header: "My title", input: .constant(""),
                  placeHolder: "My place holder",
                  keyboard: .emailAddress, textContent: .name, isSecure: true)
}
