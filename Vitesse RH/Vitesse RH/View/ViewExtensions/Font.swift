//
//  Font.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 22/02/2024.
//

import SwiftUI

extension Font {

    static let vitesseHeader = Font.custom("Copperplate-Bold", size: 36)
    static let vitesseTitle = Font.custom("Copperplate-Light", size: 28)
    static let vitesseSubtitle = Font.custom("Copperplate-Light", size: 20)
    static let vitesseText = Font.system(size: 16)
    static let vitesseButton = Font.custom("Copperplate-Bold", size: 20)
    static let vitesseError = Font.system(size: 16).bold()
    static let vitesseToolbar = Font.custom("Copperplate-Light", size: 20)
}
