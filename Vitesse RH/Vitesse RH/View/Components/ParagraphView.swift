//
//  ParagraphView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import SwiftUI

struct ParagraphView: View {

    let title: String
    let text: String

    var body: some View {
        VStack {
            HStack {
                Text(title + ":")
                    .font(.vitesseTitle)
                    .padding(.trailing)
                    .padding(.bottom, 4)
                    .frame(minWidth: 120, alignment: .leading)
                Text(text)
                    .font(.vitesseText)
                Spacer()
            }
            Divider()
                .padding(.horizontal, 24)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    Group {
        ParagraphView(title: "Phone", text: "06 00 00 00 00")
        ParagraphView(title: "Email", text: "test@vitesse.com")
    }
}
