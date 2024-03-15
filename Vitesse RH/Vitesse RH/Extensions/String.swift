//
//  String.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

extension String {

    /// Check if string value is a correct email.
    ///
    /// What to respect:
    /// - Before '@': any combination of upper and lower case letters, numbers, and special characters.
    /// - Email domain: any combination of upper and lower case letters, numbers, dots and dashes.
    /// - Domain extension: any combination of upper and lower case letters, from 2 to 64 characters.
    /// - Returns: True if is an email, or false if not.

    func isValidEmail() -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPredicate.evaluate(with: self)
    }

    /// Check if string value is a correct french phone number without an  international code.
    ///
    /// What to respect:
    /// - The phone number must start with a '0'.
    /// - The phone number must have 10 numbers.
    /// - Spacing is possible between 2 numbers.
    /// - Returns: True if is a phone number, or false if not.

    func isValidFrPhone() -> Bool {
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", "^(0\\d(?:[\\s.-]?\\d{2}){4}|0\\d{9})$")
        return phonePredicate.evaluate(with: self)
    }

    /// Mutating function to apply french phone pattern to string value.
    /// Pattern will be '## ## ## ## ##'.

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

    /// Method to get french phone pattern from string value.
    /// - Returns: A string with '## ## ## ## ##' pattern.

    func getFrPhonePattern() -> String {
        let pattern = "## ## ## ## ##"
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                return pureNumber
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != "#" else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
