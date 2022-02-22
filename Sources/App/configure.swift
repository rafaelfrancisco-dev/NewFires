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
    try app.initializeMongoDB(connectionString: Environment.get("DATABASE_URL") ?? "mongodb://localhost:27017/vapor_database")

    app.queues.schedule(FetchDataJob())
            .minutely()
            .at(0)

    try app.queues.startScheduledJobs()
    app.views.use(.leaf)

    // register routes
    try routes(app)
}
