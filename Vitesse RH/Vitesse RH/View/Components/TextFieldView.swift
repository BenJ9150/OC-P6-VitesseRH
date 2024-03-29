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

    // Error message
    @Binding var error: String

    // Launch animation
    @State private var animation = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.vitesseSubtitle)
                .padding(.leading)

            textOrSecureField
                .autocapitalization(.none)
                .keyboardType(keyboard)
                .disableAutocorrection(true)
                .foregroundStyle(.white)
                .padding()
                .background(.colorDarkGray)
                .cornerRadius(12)
                .focused($focused)
                .onChange(of: input) { _, _ in
                    if error != "" { error = "" }
                }
                // Error Animation
                .offset(y: animation ? -4 : 0)
                .onChange(of: error) { _, newErr in
                    if !newErr.isEmpty {
                        animation = true
                        withAnimation(.spring().speed(20).repeatCount(8)) {
                            animation = false
                        }
                    }
                }
                .sensoryFeedback(.error, trigger: animation)

            // Error in textfield
            Text(error)
                .font(.vitesseTextfieldError)
                .foregroundStyle(.colorRed)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 16)
        }
        .padding(.horizontal)
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
