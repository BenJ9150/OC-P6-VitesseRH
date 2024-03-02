//
//  ButtonView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct ButtonView: View { // TODO: Add background for signIn view 
    let title: String
    @Binding var actionInProgress: Bool

    var disabled = false
    let action: () -> Void

    var body: some View {
        if actionInProgress {
            ProgressView()
                .frame(height: 52)
                .padding(.bottom)
        } else {
            Button {
                action()
            } label: {
                if disabled {
                    Text(title)
                        .font(.vitesseButton)
                        .foregroundStyle(.gray)
                        .padding(.horizontal)
                        .frame(height: 52)
                        .frame(minWidth: 200)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 2))
                        .opacity(0.5)
                } else {
                    Text(title)
                        .font(.vitesseButton)
                        .foregroundStyle(.accent)
                        .padding(.horizontal)
                        .frame(height: 52)
                        .frame(minWidth: 200)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(.accent, lineWidth: 2))
                }
            }
            .disabled(disabled)
            .padding(.bottom)
        }
    }
}

#Preview {
    ButtonView(title: "MyButton", actionInProgress: .constant(false)) {
        // Action
    }
}
