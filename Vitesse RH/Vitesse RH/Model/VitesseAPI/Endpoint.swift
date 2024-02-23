//
//  Endpoint.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

enum EndPoint {

    case auth
    case register
    case candidate
    case candidateWithId

    // MARK: URL Builder

    /// Call example: let url = EndPoint.auth.url
    var url: String {
        let domain = "http://127.0.0.1:8080"

        switch self {
        case .auth:
            return "\(domain)/user/auth" // POST
        case .register:
            return "\(domain)/user/register" // POST
        case .candidate:
            return "\(domain)/candidate" // GET or POST with Auth
        case .candidateWithId:
            return "\(domain)/candidate/:" // + id // GET, PUT or DELETE with Auth
        }
    }
}
