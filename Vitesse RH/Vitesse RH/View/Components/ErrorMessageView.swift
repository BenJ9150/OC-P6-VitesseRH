//
//  ErrorMessageView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import SwiftUI

struct ErrorMessageView: View {

    let error: String

    var body: some View {
        if error.isEmpty {
            EmptyView()
        } else {
            Text(error)
                .font(.vitesseError)
                .foregroundStyle(.colorRed)
                .multilineTextAlignment(.center)
                .padding()
                .padding(.horizontal)
        }
    }
}
