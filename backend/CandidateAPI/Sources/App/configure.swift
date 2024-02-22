import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.passwords.use(.bcrypt)
    
    
    app.jwt.signers.use(.hs256(key: "your-secret-key"))
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateCandidate())
    app.migrations.add(AddAdmin(withHashedPassword: try app.password.hash("test123")))


    // register routes
    try routes(app)
}
