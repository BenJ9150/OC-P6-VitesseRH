import Vapor
import Fluent
import JWT

struct CreateCandidateRequest: Content {
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let linkedinURL: String?
    let note: String?
}

final class CandidateController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let candidatesRoute = routes.grouped("candidate")
        let tokenAuthMiddleware = UserTokenAuthMiddleware()
        let protectedRoutes = candidatesRoute.grouped(tokenAuthMiddleware)

        protectedRoutes.get(use: getAllCandidates)
            .description("Get all candidates")

        protectedRoutes.post(use: createCandidate)
            .description("Create a new candidate")
            
        
        protectedRoutes.get(":candidateID", use: getCandidate)
            .description("Get a specific candidate by ID")
     
        
        protectedRoutes.put(":candidateID", use: updateCandidate)
            .description("Update a candidate by ID")
        
        protectedRoutes.delete(":candidateID", use: removeCandidate)
            .description("Remove a candidate by ID")
        
        protectedRoutes.post(":candidateID", "favorite", use: favoriteCandidate)
            .description("Mark a candidate as favorite (Admin only)")
    }

    func getAllCandidates(req: Request) throws -> EventLoopFuture<[Candidate]> {
        return Candidate.query(on: req.db).all()
    }

    func createCandidate(req: Request) throws -> EventLoopFuture<Candidate> {
        let createReq = try req.content.decode(CreateCandidateRequest.self)
        let candidate = Candidate(from: createReq)
        return candidate.save(on: req.db).map { candidate }
    }

    func getCandidate(req: Request) throws -> EventLoopFuture<Candidate> {
        return Candidate.find(req.parameters.get("candidateID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func updateCandidate(req: Request) throws -> EventLoopFuture<Candidate> {
        let updateReq = try req.content.decode(CreateCandidateRequest.self)
        return Candidate.find(req.parameters.get("candidateID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { candidate in
                let id = candidate.id
                candidate.update(from: updateReq)
                candidate.id = id
                return candidate.save(on: req.db).map { candidate }
            }
    }
    
    func removeCandidate(req: Request) async throws -> HTTPStatus {
        guard let candidate = try await Candidate.find(req.parameters.get("candidateID"), on: req.db) else {
            throw Abort(.notFound)
        }
            
        try await candidate.delete(on: req.db)
        return .ok
    }

    func favoriteCandidate(req: Request) throws -> EventLoopFuture<Candidate> {
        let user = try req.auth.require(User.self)
        guard user.isAdmin else {
            throw Abort(.forbidden)
        }
        
        return Candidate.find(req.parameters.get("candidateID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { candidate in
                candidate.isFavorite.toggle()
                return candidate.save(on: req.db).map { candidate }
            }
    }
}


extension Candidate {
    func update(from req: CreateCandidateRequest) {
        self.firstName = req.firstName
        self.lastName = req.lastName
        self.email = req.email
        self.phone = req.phone
        self.linkedinURL = req.linkedinURL
        self.note = req.note
    }
}

extension Candidate {
    convenience init(from req: CreateCandidateRequest) {
        self.init(firstName: req.firstName, lastName: req.lastName, email: req.email, phone: req.phone, linkedinURL: req.linkedinURL, note: req.note)
    }
}
