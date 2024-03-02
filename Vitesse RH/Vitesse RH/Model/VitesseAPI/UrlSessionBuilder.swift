//
//  UrlSessionBuilder.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

class UrlSessionBuilder {

    // MARK: URL Session config

    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    struct UrlSessionConfig {
        let httpMethod: HttpMethod
        let sUrl: String
        let parameters: [String: Any]?
        let withAuth: Bool
    }

    // MARK: Private property

    private var urlSession: URLSession

    // MARK: Init

    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
}

// MARK: Public method

extension UrlSessionBuilder {

    /// Get data from url session data task
    func buildUrlSession(config: UrlSessionConfig) async -> Result<Data, AppError> {
        // get url
        guard let url = URL(string: config.sUrl) else {
            return .failure(AppError.invalidUrl)
        }
        // get url request
        let urlRequest = buildRequest(
            httpMethod: config.httpMethod,
            url: url,
            param: config.parameters,
            withAuth: config.withAuth
        )
        // url session task
        do {
            let (dataResult, urlResponse) = try await urlSession.data(for: urlRequest)
            guard let response = urlResponse as? HTTPURLResponse,
                  response.statusCode == 200 || response.statusCode == 201 else {
                return .failure(AppError.badStatusCode)
            }
            return .success(dataResult)
        } catch {
            return .failure(AppError.serverErr)
        }
    }
}

// MARK: Private method

private extension UrlSessionBuilder {

    private func buildRequest(httpMethod: HttpMethod, url: URL, param: [String: Any]?, withAuth: Bool) -> URLRequest {
        // set url request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // add parameters if exist
        if let parameters = param {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        // add header if need authorization
        if withAuth {
            urlRequest.addValue("\(BodyKey.bearer) \(KeychainManager.token)", forHTTPHeaderField: BodyKey.authorization)
        }

        return urlRequest
    }
}
