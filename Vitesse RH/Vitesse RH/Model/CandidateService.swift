//
//  CandidateService.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 08/03/2024.
//

import Foundation
import CoreSpotlight

/// Use CandidateService to get, add, edit or delete candidate from API database.

final class CandidateService: UrlSessionBuilder {

    // MARK: Get

    /// Method to get all candidates of API database.
    /// - Returns: All candidates if success, or the App Error if failure.

    func getCandidates() async -> Result<[Candidate], AppError> {
        // get data
        switch await createUrlSessionDataTask(config: getUrlConfig()) {
        case .success(let data):
            // decode
            guard let decodedJson = try? JSONDecoder().decode([Candidate].self, from: data) else {
                return .failure(AppError.invalidJson)
            }
            await indexToSpotlight(candidates: decodedJson)
            return .success(decodedJson)

        case .failure(let failure):
            return .failure(failure)
        }
    }

    /// Method to get a specific candidate from API database.
    /// - Parameters:
    ///   - candidateId: The ID of candidate.
    /// - Returns: The candidate  if success, or the App Error if failure.

    func getCandidate(WithId candidateId: String) async -> Result<Candidate, AppError> {
        let urlSessionConfig = getUrlConfig(withId: candidateId)
        return await urlSessionResult(config: urlSessionConfig)
    }
}

// MARK: Create

extension CandidateService {

    /// Method to add new candidate in API database.
    /// - Parameters:
    ///   - candidate: The new candidate (id parameter is ignored, so can be empty).
    /// - Returns: The new candidate with new ID if success, or the App Error if failure.

    func postToAdd(candidate: Candidate) async -> Result<Candidate, AppError> {
        let urlSessionConfig = addOrUpdateUrlConfig(candidate: candidate)
        return await urlSessionResult(config: urlSessionConfig)
    }
}

// MARK: Edit

extension CandidateService {

    /// Method to update a candidate in API database.
    /// - Parameters:
    ///   - candidate: The candidate with new values.
    /// - Returns: The candidate with new saved values if success, or the App Error if failure.

    func putUpdate(candidate: Candidate) async -> Result<Candidate, AppError> {
        let urlSessionConfig = addOrUpdateUrlConfig(candidate: candidate, update: true)
        return await urlSessionResult(config: urlSessionConfig)
    }

    /// Method to toggle favorite state of candidate in API database.
    /// - Parameters:
    ///   - candidateId: The candidate ID.
    /// - Returns: The candidate with new saved values if success, or the App Error if failure.

    func putFavoriteToggle(ForId candidateId: String) async -> Result<Candidate, AppError> {
        // set config for url session
        let config = UrlSessionConfig(
            httpMethod: .post, // Error in API (README: put method, but CandidateController use post)
            sUrl: EndPoint.favorite(withId: candidateId).url,
            params: nil,
            withAuth: true
        )
        return await urlSessionResult(config: config)
    }
}

// MARK: Delete

extension CandidateService {

    /// Method to delete candidate from API database.
    /// - Parameters:
    ///   - candidateId: The candidate ID to delete.
    /// - Returns: True if success, or the App Error if failure.

    func deleteCandidate(WithId candidateId: String) async -> Result<Bool, AppError> {
        // set config for url session
        let config = UrlSessionConfig(
            httpMethod: .delete,
            sUrl: EndPoint.candidate(withId: candidateId).url,
            params: nil,
            withAuth: true
        )
        // Check success (200 Ok)
        switch await createUrlSessionDataTask(config: config) {
        case .success:
            return .success(true)

        case .failure(let failure):
            return .failure(failure)
        }
    }
}

// MARK: - Private method

private extension CandidateService {

    func urlSessionResult(config: UrlSessionConfig) async -> Result<Candidate, AppError> {
        // get data
        switch await createUrlSessionDataTask(config: config) {
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
            params: nil,
            withAuth: true
        )
    }

    func addOrUpdateUrlConfig(candidate: Candidate, update: Bool = false) -> UrlSessionConfig {
        return UrlSessionConfig(
            httpMethod: update ? .put : .post,
            sUrl: update ? EndPoint.candidate(withId: candidate.id).url : EndPoint.candidates.url,
            params: [
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

    func indexToSpotlight(candidates: [Candidate]) async {
        do {
            // Clean old index
            try await CSSearchableIndex.default().deleteAllSearchableItems()
            var searchableItems: [CSSearchableItem] = []

            for candidate in candidates {
                // Set attributes
                let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
                attributeSet.displayName = candidate.firstName + " " + candidate.lastName
                let description = candidate.isFavorite ? "Favorite vitesse candidate" : "Vitesse candidate"
                attributeSet.contentDescription = description

                if let phone = candidate.phone {
                    attributeSet.phoneNumbers = [phone]
                    attributeSet.supportsPhoneCall = 1
                }

                // Create searchable item
                let searchableItem = CSSearchableItem(
                    uniqueIdentifier: candidate.id,
                    domainIdentifier: "com.benjaminlefrancois.Vitesse-RH",
                    attributeSet: attributeSet
                )
                searchableItems.append(searchableItem)
            }
            // Submit for indexing
            try await CSSearchableIndex.default().indexSearchableItems(searchableItems)

        } catch {}
    }
}
