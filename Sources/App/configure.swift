import Fluent
import FluentMongoDriver
import QueuesMongoDriver
import MongoKitten
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    try app.databases.use(.mongo(
        connectionString: Environment.get("DATABASE_URL") ?? "mongodb://localhost:27017/vapor_database"
    ), as: .mongo)

    let mongoDatabase = try MongoDatabase.lazyConnect(Environment.get("DATABASE_URL") ?? "mongodb://localhost:27017/vapor_database", on: app.eventLoopGroup.next())

    // Setup Indexes for the Job Schema for performance (Optional)
    try app.queues.setupMongo(using: mongoDatabase)
    app.queues.use(.mongodb(mongoDatabase))

    app.queues.schedule(FetchDataJob())
            .minutely()
            .at(0)

    app.views.use(.leaf)

    try app.queues.startScheduledJobs()

    // register routes
    try routes(app)
}
