//
//  AuthService.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation
import SwiftUI // for haptic feedback

/// Use AuthService to connect or register user to API.

final class AuthService: UrlSessionBuilder {

    // MARK: SignIn

    /// Method to connect user to API. If success, token is saved in keychain.
    /// - Parameters:
    ///   - mail: The email of current user.
    ///   - password: The password of current user.
    /// - Returns: The administrator status of user if success, or the App Error if failure.

    func postToSignIn(withEmail mail: String, andPwd password: String) async -> Result<Bool, AppError> {
        // set config for url session
        let config = UrlSessionConfig(
            httpMethod: .post,
            sUrl: EndPoint.auth.url,
            params: [BodyKey.email: mail, BodyKey.password: password],
            withAuth: false
        )
        // get data
        switch await createUrlSessionDataTask(config: config) {
        case .success(let data):
            // decode
            guard let decodedJson = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                await UINotificationFeedbackGenerator().notificationOccurred(.error)
                return .failure(AppError.invalidJson)
            }
            // Save token
            KeychainManager.token = decodedJson.token
            await UINotificationFeedbackGenerator().notificationOccurred(.success)
            return .success(decodedJson.isAdmin)

        case .failure(let failure):
            await UINotificationFeedbackGenerator().notificationOccurred(.error)
            return .failure(failure)
        }
    }
}

// MARK: Register

extension AuthService {

    /// Method to register user to API. If success, token is saved in keychain.
    /// - Parameters:
    ///   - mail: The email of new user.
    ///   - password: The password of new user.
    ///   - firstName: The fisrt name of new user.
    ///   - lastName: The last name of new user.
    /// - Returns: True if success, or the App Error if failure.

    func postToRegister(mail: String, password: String, firstName: String, lastName: String) async -> Result<Bool, AppError> {
        // set config for url session
        let config = UrlSessionConfig(
            httpMethod: .post,
            sUrl: EndPoint.register.url,
            params: [
                BodyKey.email: mail,
                BodyKey.password: password,
                BodyKey.firstName: firstName,
                BodyKey.lastName: lastName
            ],
            withAuth: false
        )
        // Check success (201 Created)
        switch await createUrlSessionDataTask(config: config) {
        case .success:
            await UINotificationFeedbackGenerator().notificationOccurred(.success)
            return .success(true)

        case .failure(let failure):
            await UINotificationFeedbackGenerator().notificationOccurred(.error)
            return .failure(failure)
        }
    }
}
