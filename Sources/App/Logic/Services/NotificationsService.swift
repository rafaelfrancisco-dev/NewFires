//
//  File.swift
//  
//
//  Created by Rafael Francisco on 26/02/2022.
//

import Foundation
import Vapor
import MongoKitten

class NotificationsService {
    private let database: MongoDatabase
    private let logger = Logger(label: "NotificationsJob")

    init(database: MongoDatabase) {
        self.database = database
    }
    
    func registerForFire(token: String, fire: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
            do {
                let entry = try database.notifications
                    .findOne("token" == token)
                    .decode(NotificationEntry.self)
                    .wait()
                
                if let entry = entry {
                    var internalEntry = entry
                    
                    if !internalEntry.containsFire(fire: fire) {
                        internalEntry.fires.append(NotificationCheck(fire: fire, lastStatus: nil))
                    }
                    
                    _ = try database.notifications
                        .updateEncoded(where: "token" == token, to: internalEntry)
                        .wait()
                    
                    logger.log(level: .debug, "Adding fire \(fire) to token \(token)")
                    continuation.resume(returning: true)
                } else {
                    let newEntry = NotificationEntry(token: token, fires: [NotificationCheck(fire: fire, lastStatus: nil)])
                    _ = try database.notifications.insertEncoded(newEntry).wait()
                    
                    continuation.resume(returning: false)
                }
            } catch {
                logger.report(error: error)
                continuation.resume(throwing: error)
            }
        }
    }
    
    func deregisterForFire(token: String, fire: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
            do {
                let entry = try database.notifications
                    .findOne("token" == token)
                    .decode(NotificationEntry.self)
                    .wait()
                
                if let entry = entry {
                    var internalEntry = entry
                    
                    if internalEntry.containsFire(fire: fire) {
                        internalEntry.removeFire(fire: fire)
                    }
                    
                    _ = try database.notifications
                        .updateEncoded(where: "token" == token, to: internalEntry)
                        .wait()
                    
                    logger.log(level: .debug, "Removing fire \(fire) to token \(token)")
                    continuation.resume(returning: true)
                } else {
                    logger.log(level: .error, "No entry existed for token \(token)")
                    continuation.resume(returning: false)
                }
            } catch {
                logger.report(error: error)
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getAllFollowedFires(token: String) async throws -> [String] {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[String], Error>) in
            do {
                let entry = try database.notifications
                    .findOne("token" == token)
                    .decode(NotificationEntry.self)
                    .wait()
                
                if let entry = entry {
                    logger.log(level: .debug, "Found \(entry.fires.count) fires for token \(token)")
                    continuation.resume(returning: entry.fires.map{ $0.fire })
                } else {
                    continuation.resume(returning: [])
                }
            } catch {
                logger.report(error: error)
                continuation.resume(throwing: error)
            }
        }
    }
}
