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
        try mongoDB = MongoDatabase.lazyConnect(connectionString, on: eventLoopGroup)

        // Setup Indexes for the Job Schema for performance (Optional)
        try queues.setupMongo(using: mongoDB)
        queues.use(.mongodb(mongoDB))
    }
}