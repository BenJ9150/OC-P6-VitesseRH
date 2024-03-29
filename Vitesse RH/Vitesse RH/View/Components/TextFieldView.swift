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

    // Launch animation
    @Binding var errAnimation: Bool

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
                // Error Animation
                .offset(y: errAnimation ? -4 : 0)
                .onChange(of: errAnimation) { _, _ in
                    withAnimation(.spring().speed(20).repeatCount(8)) {
                        errAnimation = false
                    }
                }
                .sensoryFeedback(.error, trigger: errAnimation)
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
