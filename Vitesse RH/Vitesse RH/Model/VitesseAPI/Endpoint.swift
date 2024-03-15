//
//  Endpoint.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

/// List of API endpoints.
///
/// Call example for authentication:
/// - 'let url = EndPoint.auth.url'

enum EndPoint {

    case auth
    case register
    case candidates
    case candidate(withId: String)
    case favorite(withId: String)

    // MARK: URL Builder

    var url: String {
        let domain = "http://127.0.0.1:8080"

        switch self {
        case .auth:
            return "\(domain)/user/auth" // POST

        case .register:
            return "\(domain)/user/register" // POST

        case .candidates:
            return "\(domain)/candidate" // GET or POST with Auth

        case .candidate(let candidateId):
            return "\(domain)/candidate/\(candidateId)" // GET, PUT or DELETE with Auth

        case .favorite(let candidateId):
            return "\(domain)/candidate/\(candidateId)/favorite" // PUT with Auth
        }
    }
}
