//
//  ButtonView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct ButtonView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .font(.vitesseButton)
                .foregroundStyle(.accent)
                .padding()
                .padding(.horizontal)
                .frame(minWidth: 200)
                .background(RoundedRectangle(cornerRadius: 12).stroke(.accent, lineWidth: 2))
        })
        .padding(.bottom)
    }
}

#Preview {
    ButtonView(title: "MyButton") {
        // Action
    }
}
