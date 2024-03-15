//
//  UrlSessionBuilder.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

/// Build URL session and get API response.

class UrlSessionBuilder {

    /// List of http methods for API call.
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    /// Create configuration for URL request.
    /// - Parameters:
    ///   - httpMethod: HTTP method to use for url request.
    ///   - sUrl: String url to use for url request.
    ///   - params: Dictionnary of parameters to add to http body.
    ///   - withAuth: If true, auth token is added to http header.

    struct UrlSessionConfig {
        let httpMethod: HttpMethod
        let sUrl: String
        let params: [String: Any]?
        let withAuth: Bool
    }

    // MARK: Private property

    private var urlSession: URLSession

    // MARK: Init

    /// Dependency injection for Unit Testing.
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
}

// MARK: Public method

extension UrlSessionBuilder {

    /// Create and launch async url session data task.
    /// - Parameters:
    ///   - config: Configuration for URL request.
    /// - Returns: The data result of task if success, or the App Error if failure.

    func createUrlSessionDataTask(config: UrlSessionConfig) async -> Result<Data, AppError> {
        // get url
        guard let url = URL(string: config.sUrl) else {
            return .failure(AppError.invalidUrl)
        }
        // get url request
        let urlRequest = buildRequest(
            httpMethod: config.httpMethod,
            url: url,
            params: config.params,
            withAuth: config.withAuth
        )
        // url session task
        do {
            let (dataResult, urlResponse) = try await urlSession.data(for: urlRequest)
            // Check url response
            guard let response = urlResponse as? HTTPURLResponse else {
                return .failure(AppError.badStatusCode) // todo: changer erreur + unit test
            }
            // Check status code
            guard response.statusCode/100 == 2 else {
                print("badStatusCode: \(response.statusCode)")
                if response.statusCode == 500 {
                    return .failure(AppError.emailAlreadyExist)
                }
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

    /// Build URL request.
    /// - Parameters:
    ///   - httpMethod: HTTP method to use for url request.
    ///   - url: The URL to use for url request.
    ///   - params: Dictionnary of parameters to add to http body.
    ///   - withAuth: If true, auth token is added to http header.
    /// - Returns: The url request to use with urlSession data task.

    private func buildRequest(httpMethod: HttpMethod, url: URL, params: [String: Any]?, withAuth: Bool) -> URLRequest {
        // set url request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // add parameters if exist
        if let parameters = params {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        // add header if need authorization
        if withAuth {
            urlRequest.addValue(
                "\(HeaderKey.bearer) \(KeychainManager.token)",
                forHTTPHeaderField: HeaderKey.authorization
            )
        }
        return urlRequest
    }
}
