import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req -> String in
        "Hello, world!"
    }

    app.get("fires", "all") { req async throws -> [ProCivEvent] in
        try await FireService(database: app.mongoDB).getAllFires()
    }
}
