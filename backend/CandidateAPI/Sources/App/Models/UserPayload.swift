import Vapor
import JWT

struct UserPayload: JWTPayload {
    var email: String
    var isAdmin: Bool

    func verify(using signer: JWTSigner) throws {
        // You can add additional verification if needed
    }
}
