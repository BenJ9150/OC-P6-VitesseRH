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
//        Button(action: action, label: {
//            Text(title)
//                .font(.vitesseButton)
//                .foregroundStyle(.white)
//                .padding()
//                .padding(.horizontal)
//                .frame(minWidth: 200)
//                .background(.colorRed)
//                .cornerRadius(24)
//                .padding(3)
//                .overlay(RoundedRectangle(cornerRadius: 27).stroke(.colorDarkGray, lineWidth: 2))
//        })
//        .padding(.bottom)
        
        Button(action: action, label: {
            Text(title)
                .font(.vitesseButton)
                .foregroundStyle(.colorRed)
                .padding()
                .padding(.horizontal)
                .frame(minWidth: 200)
                .background(RoundedRectangle(cornerRadius: 12).stroke(.colorRed, lineWidth: 2))
        })
        .padding(.bottom)
    }
}

#Preview {
    ButtonView(title: "MyButton") {
        // Action
    }
}
