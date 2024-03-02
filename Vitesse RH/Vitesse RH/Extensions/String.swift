//
//  String.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

extension String {

    func isValidEmail() -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPredicate.evaluate(with: self)

        // [A-Z0-9a-z._%+-]+ -> nom du mail avant @,
        // n'importe quelle combinaison de lettres maj et min,
        // de chiffres et de caractères spéciaux

        // @ -> Obligatoire
        // [A-Za-z0-9.-] -> domaine du mail,
        // n'importe quelle combinaison de lettres maj et min, de chiffres,
        // de points et de tirets
        // \\.[A-Za-z]{2,64} -> "." obligatoire
        // et extension du domaine avec lettres maj et min, de 2 à 64 caractères
    }

    func isValidPhone() -> Bool {
        let matches = "^(?:(?:\\+|00)33[\\s.-]{0,3}(?:\\(0\\)[\\s.-]{0,3})?|0)[1-9](?:[\\s.-]?\\d{2}){4}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", matches)
        return phonePredicate.evaluate(with: self)
    }

    mutating func applyFrPhonePattern() {
        let pattern = "## ## ## ## ##"
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                self = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != "#" else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        self = pureNumber
    }
}
