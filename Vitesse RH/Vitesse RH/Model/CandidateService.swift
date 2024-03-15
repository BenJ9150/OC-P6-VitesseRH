//
//  CandidateService.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 08/03/2024.
//

import Foundation

final class CandidateService: UrlSessionBuilder {

    // MARK: Get

    func getCandidates() async -> Result<[Candidate], AppError> {
        // get data
        switch await buildUrlSession(config: getUrlConfig()) {
        case .success(let data):
            // decode
            guard let decodedJson = try? JSONDecoder().decode([Candidate].self, from: data) else {
                return .failure(AppError.invalidJson)
            }
            return .success(decodedJson)

        case .failure(let failure):
            return .failure(failure)
        }
    }

    func getCandidate(WithId candidateId: String) async -> Result<Candidate, AppError> {
        let urlSessionConfig = getUrlConfig(withId: candidateId)
        return await urlSessionResult(config: urlSessionConfig)
    }

    // MARK: Create

    func add(candidate: Candidate) async -> Result<Candidate, AppError> {
        let urlSessionConfig = addOrUpdateUrlConfig(candidate: candidate)
        return await urlSessionResult(config: urlSessionConfig)
    }

    // MARK: Update

    func update(candidate: Candidate) async -> Result<Candidate, AppError> {
        let urlSessionConfig = addOrUpdateUrlConfig(candidate: candidate, update: true)
        return await urlSessionResult(config: urlSessionConfig)
    }

    // MARK: Favorite

    func favoriteToggle(ForId candidateId: String) async -> Result<Candidate, AppError> {
        // set config for url session
        let config = UrlSessionConfig(
            httpMethod: .post, // Error in API (README: put method, but CandidateController use post)
            sUrl: EndPoint.favorite(withId: candidateId).url,
            parameters: nil,
            withAuth: true
        )
        return await urlSessionResult(config: config)
    }

    // MARK: Delete

    func deleteCandidate(WithId candidateId: String) async -> Result<Bool, AppError> {
        // set config for url session
        let config = UrlSessionConfig(
            httpMethod: .delete,
            sUrl: EndPoint.candidate(withId: candidateId).url,
            parameters: nil,
            withAuth: true
        )
        // Check success (200 Ok)
        switch await buildUrlSession(config: config) {
        case .success:
            return .success(true)

        case .failure(let failure):
            return .failure(failure)
        }
    }
}

// MARK: Private method

private extension CandidateService {

    func urlSessionResult(config: UrlSessionConfig) async -> Result<Candidate, AppError> {
        // get data
        switch await buildUrlSession(config: config) {
        case .success(let data):
            // decode
            guard let decodedJson = try? JSONDecoder().decode(Candidate.self, from: data) else {
                return .failure(AppError.invalidJson)
            }
            return .success(decodedJson)

        case .failure(let failure):
            return .failure(failure)
        }
    }

    func getUrlConfig(withId key: String = "") -> UrlSessionConfig {
        return UrlSessionConfig(
            httpMethod: .get,
            sUrl: key == "" ? EndPoint.candidates.url : EndPoint.candidate(withId: key).url,
            parameters: nil,
            withAuth: true
        )
    }

    func addOrUpdateUrlConfig(candidate: Candidate, update: Bool = false) -> UrlSessionConfig {
        return UrlSessionConfig(
            httpMethod: update ? .put : .post,
            sUrl: update ? EndPoint.candidate(withId: candidate.id).url : EndPoint.candidates.url,
            parameters: [
                "email": candidate.email,
                "note": candidate.note as Any,
                "linkedinURL": candidate.linkedinURL as Any,
                "firstName": candidate.firstName,
                "lastName": candidate.lastName,
                "phone": candidate.phone as Any
            ],
            withAuth: true
        )
    }
}
