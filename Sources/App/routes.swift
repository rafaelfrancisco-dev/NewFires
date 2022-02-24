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
    
    app.get("history") { req async throws -> HistoryProCivEvent in
        let service = FireService(database: app.mongoDB)
        
        guard let number = req.query[Int.self, at: "number"] else {
            throw Abort(.badRequest)
        }
        
        let numero = try await service.eventExists(number: number)
        
        if let numero = numero {
            return try await service.getHistoryForEvent(number: numero)
        } else {
            throw Abort(.noContent)
        }
    }
}
