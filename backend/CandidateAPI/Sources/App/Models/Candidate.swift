import Fluent
import Vapor

final class Candidate: Model, Content {
    static let schema = "candidates"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "first_name")
    var firstName: String

    @Field(key: "last_name")
    var lastName: String

    @Field(key: "email")
    var email: String

    @Field(key: "phone")
    var phone: String?

    @Field(key: "linkedin_url")
    var linkedinURL: String?

    @Field(key: "note")
    var note: String?

    @Field(key: "is_favorite")
    var isFavorite: Bool

    init() {}

    init(id: UUID? = nil, firstName: String, lastName: String, email: String, phone: String?, linkedinURL: String?, note: String?, isFavorite: Bool = false) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.linkedinURL = linkedinURL
        self.note = note
        self.isFavorite = isFavorite
    }
}
