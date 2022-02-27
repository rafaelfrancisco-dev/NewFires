//
// Created by rafael on 2/22/22.
//

import Foundation
import MongoKitten
import Vapor

extension Request {
    public var mongoDB: MongoDatabase {
        application.mongoDB.hopped(to: eventLoop)
    }
}

private struct MongoDBStorageKey: StorageKey {
    typealias Value = MongoDatabase
}

extension Application {
    public var mongoDB: MongoDatabase {
        get {
            storage[MongoDBStorageKey.self]!
        }
        set {
            storage[MongoDBStorageKey.self] = newValue
        }
    }

    public func initializeMongoDB(connectionString: String) throws {
        let logger = Logger(label: "MongoDB")

        logger.log(level: .debug, "Connecting to MongoDB at: \(connectionString)")
        try mongoDB = MongoDatabase.lazyConnect(connectionString, on: eventLoopGroup)
        
        try setIndexes(mongoDB: mongoDB)
        try queues.setupMongo(using: mongoDB)
        
        queues.use(.mongodb(mongoDB))
        logger.log(level: .notice, "MongoDB setup complete")
    }
    
    private func setIndexes(mongoDB: MongoDatabase) throws {
        let logger = Logger(label: "MongoDBIndexes")
        logger.log(level: .info, "Setting up collection indexes")
        
        let _ = try mongoDB.latest.createIndex(named: "numero_index", keys: ["Numero" : 1]).wait()
        let _ = try mongoDB.latest.createIndex(named: "natureza_index", keys: ["Natureza" : "text"]).wait()
        
        let _ = try mongoDB.allEvents.createIndex(named: "numero_index", keys: ["Numero" : 1]).wait()
        let _ = try mongoDB.allEvents.createIndex(named: "natureza_index", keys: ["Natureza" : "text"]).wait()
        
        let _ = try mongoDB.notifications.createIndex(named: "token_index", keys: ["token" : 1]).wait()
        
        logger.log(level: .info, "Finished setting up collection indexes")
    }
}
