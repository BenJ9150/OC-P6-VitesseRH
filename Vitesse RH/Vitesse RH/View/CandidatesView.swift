//
//  CandidatesView.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import SwiftUI

struct CandidatesView: View {

    let isAdmin: Bool

    var body: some View {
        Text("is Admin: " + (isAdmin ? "Yes" : "No"))
    }
}

#Preview {
    CandidatesView(isAdmin: true)
}
