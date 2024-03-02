//
//  AuthService.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

final class AuthService: UrlSessionBuilder {

    func signIn(withEmail mail: String, andPwd password: String,
                _ completion: @escaping (Result<Bool, AppError>) -> Void) {

        // set config for url session
        let config = UrlSessionConfig(
            httpMethod: .post,
            sUrl: EndPoint.auth.url,
            parameters: [BodyKey.email: mail, BodyKey.password: password],
            withAuth: false
        )

        // get data
        buildUrlSession(config: config) { result in
            switch result {
            case .success(let data):
                // decode json
                guard let decodedJson = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                    completion(.failure(AppError.invalidJson))
                    return
                }
                // Save token
                KeychainManager.token = decodedJson.token
                completion(.success(decodedJson.isAdmin))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func register(mail: String, password: String, firstName: String, lastName: String,
                  _ completion: @escaping (Result<Bool, AppError>) -> Void) {

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

        // get data
        buildUrlSession(config: config) { result in
            switch result {
            case .success(let data):
                // decode json
                guard let decodedJson = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                    completion(.failure(AppError.invalidJson))
                    return
                }
                // Save token
                KeychainManager.token = decodedJson.token
                completion(.success(decodedJson.isAdmin))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
