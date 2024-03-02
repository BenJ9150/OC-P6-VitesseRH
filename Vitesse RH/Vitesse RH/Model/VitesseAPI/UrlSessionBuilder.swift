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
    func buildUrlSession(config: UrlSessionConfig, _ completion: @escaping (Result<Data, AppError>) -> Void) {
        // get url
        guard let url = URL(string: config.sUrl) else {
            completion(.failure(AppError.invalidUrl))
            return
        }
        // get url request
        let urlRequest = buildRequest(httpMethod: config.httpMethod, url: url,
                                      param: config.parameters, withAuth: config.withAuth)

        // create url session task
        urlSession.dataTask(with: urlRequest) { dataResult, urlResponse, error in
            if error != nil {
                completion(.failure(AppError.serverErr))
                return
            }
            guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(AppError.badStatusCode))
                return
            }
            guard let data = dataResult else {
                completion(.failure(AppError.invalidData))
                return
            }
            completion(.success(data))
        }
        .resume()
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
