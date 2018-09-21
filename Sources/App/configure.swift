import Vapor
import FluentPostgreSQL
import Authentication

/// Called before your application initializes.
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    try services.register(FluentPostgreSQLProvider())
    
    let postgresqlConfig = getDatabaseConfig(env)
    services.register(postgresqlConfig)
    
    var migrations = MigrationConfig()
    // TODO: Add models for migration
    services.register(migrations)
    
    try services.register(AuthenticationProvider())
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
