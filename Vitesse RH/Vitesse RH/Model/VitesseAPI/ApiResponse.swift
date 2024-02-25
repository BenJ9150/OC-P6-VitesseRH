//
//  ApiResponse.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

// MARK: Authentification

struct AuthResponse: Codable {
    let token: String
    let isAdmin: Bool
}

// MARK: Register

// Register response: `201 Created`

// MARK: Candidates

struct CandidateResponse: Codable {
    let candidates: [Candidate]
}

// MARK: candidate Id

struct Candidate: Codable, Identifiable {
    let id: String
    let phone: String?
    let note: String?
    let firstName: String
    let linkedinURL: String?
    let isFavorite: Bool
    let email: String
    let lastName: String
}

// MARK: Delete candidate

// Delete response: `20O Ok`
