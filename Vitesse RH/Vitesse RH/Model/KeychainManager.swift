//
//  KeychainManager.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation
import Security

/// Use keychain manager to store, edit or delete values in secure keychain.

final class KeychainManager {

    /// Check if user token exist in keychain.
    /// - Returns: True if token exist.
    static var userIsLogged: Bool {
        return fetchTokenFromKeychain() != ""
    }

    /// Get user token from keychain.
    /// - Returns: User token if exist or empty string if not.
    static var token: String {
        get {
            if currentToken == nil {
                currentToken = fetchTokenFromKeychain()
            }
            return currentToken!
        } set {
            saveInKeychain(token: newValue)
        }
    }
    private static var currentToken: String?
}

extension KeychainManager {

    /// Delete current user token from keychain.
    /// Delete isAdmin value from standard UserDefaults
    static func deleteTokenInKeychain() {
        // Find token and delete
        SecItemDelete(buildQuery())
        currentToken = nil

        // Clean isAdmin Value in UserDefault
        UserDefaults.standard.removeObject(forKey: "VitesseUserIsAdmin")
    }
}

// MARK: - Private Fetch or Save

private extension KeychainManager {

    static func fetchTokenFromKeychain() -> String {
        // Check if data exists in the keychain
        var item: CFTypeRef?
        SecItemCopyMatching(buildQuery(forFetch: true), &item)

        // Extract result
        if let existingItem = item as? [String: Any],
           let data = existingItem[kSecValueData as String] as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        }
        print("Token not stored in keychain")
        return ""
    }

    static func saveInKeychain(token: String) {
        // check if token already saved
        if fetchTokenFromKeychain() == "" {
            // Store the token
            SecItemAdd(buildQuery(withValue: token), nil)
        } else {
            // Update token
            let attributes: [String: Any] = [kSecValueData as String: token.data(using: .utf8)!]
            SecItemUpdate(buildQuery(), attributes as CFDictionary)
        }
        // Save current value
        currentToken = token
    }
}

// MARK: Private Query builder

private extension KeychainManager {

    static func buildQuery(forFetch: Bool = false, withValue value: String = "") -> CFDictionary {
        // basis of query
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "VitesseTokenAccount"
        ]
        // fetch value in keychain
        if forFetch {
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            query[kSecReturnAttributes as String] = true
            query[kSecReturnData as String] = true
            return query as CFDictionary
        }
        // set value in keychain
        if value != "" {
            query[kSecValueData as String] = value.data(using: .utf8)!
            return query as CFDictionary
        }
        // update value in keychain
        return query as CFDictionary
    }
}
