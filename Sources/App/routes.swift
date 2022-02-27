import Vapor
import MongoKittenCore

func routes(_ app: Application) throws {
    app.get { req in
        req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req -> String in
        "Hello, world!"
    }

    app.get("all") { req async throws -> [ProCivEvent] in
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
    
    app.get("status") { req async throws -> StatusProCivEvent in
        let service = FireService(database: app.mongoDB)
        
        guard let number = req.query[Int.self, at: "number"] else {
            throw Abort(.badRequest)
        }
        
        let numero = try await service.eventExists(number: number)
        
        if let numero = numero {
            return try await service.getStatusForEvent(number: numero)
        } else {
            throw Abort(.noContent)
        }
    }
    
    app.get("register") { req async throws -> String in
        let service = NotificationsService(database: app.mongoDB)
        
        guard let fire = req.query[String.self, at: "fire"] else {
            throw Abort(.badRequest)
        }
        
        guard let token = req.query[String.self, at: "token"] else {
            throw Abort(.badRequest)
        }
        
        let response = try await service.registerForFire(token: token, fire: fire)
        
        return response.description
    }
    
    app.get("unregister") { req async throws -> String in
        let service = NotificationsService(database: app.mongoDB)
        
        guard let fire = req.query[String.self, at: "fire"] else {
            throw Abort(.badRequest)
        }
        
        guard let token = req.query[String.self, at: "token"] else {
            throw Abort(.badRequest)
        }
        
        let response = try await service.deregisterForFire(token: token, fire: fire)
        
        return response.description
    }
    
    app.get("followedfires") { req async throws -> [String] in
        let service = NotificationsService(database: app.mongoDB)
        
        guard let token = req.query[String.self, at: "token"] else {
            throw Abort(.badRequest)
        }
        
        return try await service.getAllFollowedFires(token: token)
    }
}
