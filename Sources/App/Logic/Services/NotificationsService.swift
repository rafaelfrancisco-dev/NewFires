//
//  File.swift
//  
//
//  Created by Rafael Francisco on 26/02/2022.
//

import Foundation
import MongoKitten

class NotificationsService {
    private let database: MongoDatabase

    init(database: MongoDatabase) {
        self.database = database
    }
    
    func registerForFire(token: String, fire: String) async throws -> UpdateReply? {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<UpdateReply?, Error>) in
            do {
                let entry = try database.notifications
                    .findOne("token" == token)
                    .decode(NotificationEntry.self)
                    .wait()
                
                if let entry = entry {
                    var internalEntry = entry
                    
                    if !internalEntry.fires.contains(fire) {
                        internalEntry.fires.append(fire)
                    }
                    
                    let result = try database.notifications
                        .updateEncoded(where: "token" == token, to: internalEntry)
                        .wait()
                    
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(returning: nil)
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func deregisterForFire(token: String, fire: String) async throws -> UpdateReply? {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<UpdateReply?, Error>) in
            do {
                let entry = try database.notifications
                    .findOne("token" == token)
                    .decode(NotificationEntry.self)
                    .wait()
                
                if let entry = entry {
                    var internalEntry = entry
                    
                    if internalEntry.fires.contains(fire) {
                        internalEntry.fires.removeAll { fireId in
                            fireId == fire
                        }
                    }
                    
                    let result = try database.notifications
                        .updateEncoded(where: "token" == token, to: internalEntry)
                        .wait()
                    
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(returning: nil)
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
