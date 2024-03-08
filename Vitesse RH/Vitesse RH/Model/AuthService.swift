//
//  AuthService.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

final class AuthService: UrlSessionBuilder {

    // MARK: SignIn

    func signIn(withEmail mail: String, andPwd password: String) async -> Result<Bool, AppError> {
        // set config for url session
        let config = UrlSessionConfig(
            httpMethod: .post,
            sUrl: EndPoint.auth.url,
            parameters: [BodyKey.email: mail, BodyKey.password: password],
            withAuth: false
        )
        // get data
        switch await buildUrlSession(config: config) {
        case .success(let data):
            // decode
            guard let decodedJson = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                return .failure(AppError.invalidJson)
            }
            // Save token
            KeychainManager.token = decodedJson.token
            return .success(decodedJson.isAdmin)

        case .failure(let failure):
            return .failure(failure)
        }
    }

    // MARK: Register

    func register(mail: String, password: String, firstName: String, lastName: String) async -> Result<Bool, AppError> {
        // set config for url session
        let config = UrlSessionConfig(
            httpMethod: .post,
            sUrl: EndPoint.register.url,
            parameters: [
                BodyKey.email: mail,
                BodyKey.password: password,
                BodyKey.firstName: firstName,
                BodyKey.lastName: lastName
            ],
            withAuth: false
        )
        // Check success (201 Created)
        switch await buildUrlSession(config: config) {
        case .success:
            return .success(true)

        case .failure(let failure):
            return .failure(failure)
        }
    }
}
