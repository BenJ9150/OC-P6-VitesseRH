//
//  ContentView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("logo_Vitesse")
                .resizable()
                .scaledToFit()

            Text("VITESSE")
                .font(Font.custom("Copperplate-Bold", size: 40))
                .tracking(12)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
