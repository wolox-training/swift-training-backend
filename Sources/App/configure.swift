import Vapor
import FluentPostgreSQL

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    try services.register(FluentPostgreSQLProvider())
    
    let postgresqlConfig = getDatabaseConfig(env)
    services.register(postgresqlConfig)
    
    var contentConfig = ContentConfig.default()
    let jsonEncoder = createJsonEncoder()
    let jsonDecoder = createJsonDecoder()
    contentConfig.use(encoder: jsonEncoder, for: .json)
    contentConfig.use(decoder: jsonDecoder, for: .json)
    services.register(contentConfig)
    
    var migrations = MigrationConfig()
    migrations.add(model: Book.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Rent.self, database: .psql)
    migrations.add(model: Wish.self, database: .psql)
    migrations.add(model: Comment.self, database: .psql)
    migrations.add(model: Suggestion.self, database: .psql)
    services.register(migrations)
}


private func getDatabaseConfig(_ env: Environment) -> PostgreSQLDatabaseConfig {
    if env.isRelease {
        let databaseUrl = ProcessInfo.processInfo.environment["DATABASE_URL"]!
        return PostgreSQLDatabaseConfig(url: databaseUrl)!
    } else {
        return PostgreSQLDatabaseConfig(
            hostname: "127.0.0.1",
            port: 5432,
            username: "postgres",
            database: "wbooks",
            password: nil
        )
    }
}


private func createJsonEncoder() -> JSONEncoder {
    let jsonEncoder = JSONEncoder()
    let dateFormatter = DateUtils.getFormatter()
    jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)
    return jsonEncoder
}

private func createJsonDecoder() -> JSONDecoder {
    let jsonDecoder = JSONDecoder()
    let dateFormatter = DateUtils.getFormatter()
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    return jsonDecoder
}
