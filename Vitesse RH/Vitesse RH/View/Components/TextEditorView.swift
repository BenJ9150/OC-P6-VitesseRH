//
//  TextEditorView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import SwiftUI

struct TextEditorView: View {

    @Environment(\.colorScheme) var colorScheme

    // Header
    let header: String

    // Textfield
    @Binding var input: String
    let disabled: Bool

    // Focus
    @FocusState var focused: Bool

    var body: some View {
        VStack(alignment: disabled ? .center : .leading) {
            Text(header)
                .font(.vitesseSubtitle)
                .padding(.horizontal)
                .padding(.horizontal)

            if disabled {
                TextEditor(text: $input)
                    .disableAutocorrection(false)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(colorScheme == .light ? .white : .colorDarkGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.colorDarkGray))
                    .padding(.horizontal)
                    .frame(height: 200)
                    .disabled(true)
            } else {
                TextEditor(text: $input)
                    .disableAutocorrection(false)
                    .scrollContentBackground(.hidden)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.colorDarkGray)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .frame(height: 200)
                    .focused($focused)
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    TextEditorView(header: "MY Title", input: .constant("Hello"), disabled: false)
}
