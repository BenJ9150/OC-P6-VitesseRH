import Fluent

struct CreateCandidate: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("candidates")
            .id()
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .field("email", .string, .required)
            .field("phone", .string)
            .field("linkedin_url", .string)
            .field("note", .string)
            .field("is_favorite", .bool, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("candidates").delete()
    }
}


