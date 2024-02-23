//
//  ButtonView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct ButtonView: View {
    let title: String
    @Binding var actionInProgress: Bool
    let action: () -> Void

    var body: some View {
        if actionInProgress {
            ProgressView()
                .frame(height: 52)
                .padding(.bottom)
        } else {
            Button(action: action, label: {
                Text(title)
                    .font(.vitesseButton)
                    .foregroundStyle(.accent)
                    .padding(.horizontal)
                    .frame(height: 52)
                    .frame(minWidth: 200)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(.accent, lineWidth: 2))
            })
            .padding(.bottom)
        }
    }
}

#Preview {
    ButtonView(title: "MyButton", actionInProgress: .constant(false)) {
        // Action
    }
}
