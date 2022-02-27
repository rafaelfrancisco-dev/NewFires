//
//  File.swift
//  
//
//  Created by Rafael Francisco on 26/02/2022.
//

@preconcurrency import Vapor
import Queues
import MongoKitten

struct NotificationsJob: AsyncScheduledJob, Sendable {
    private let logger = Logger(label: "NotificationsJob")
    private let notificator = Notificator()

    func run(context: QueueContext) async throws {
        logger.log(level: .info, "Updating notifications")
        
        let database = context.application.mongoDB
        let notifications = database.notifications
        
        do {
            let entries = try await notifications
                .find()
                .decode(NotificationEntry.self)
                .allResults()
            
            try await entries.asyncForEach { entry in
                try await checkIfNeedsToBeNotificated(entry: entry, database: database)
            }
        } catch {
            logger.report(error: error)
        }
        
        logger.log(level: .info, "Finished updating notifications")
    }
    
    private func checkIfNeedsToBeNotificated(entry: NotificationEntry, database: MongoDatabase) async throws {
        for checkEntry in entry.fires {
            if let status = checkEntry.lastStatus {
                let currentStatus = try database.latest
                    .findOne("numero" == checkEntry.fire)
                    .decode(ProCivEvent.self)
                    .map{ $0?.estadoOcorrencia }
                    .wait()
                
                if let currentStatus = currentStatus {
                    if currentStatus != status {
                        try await notificate(fire: checkEntry.fire, token: entry.token, database: database)
                    }
                }
            } else {
                try await notificate(fire: checkEntry.fire, token: entry.token, database: database)
            }
        }
    }
    
    private func notificate(fire: String, token: String, database: MongoDatabase) async throws {
        let event = try database.latest
            .findOne("numero" == fire)
            .decode(ProCivEvent.self)
            .wait()
        
        if let event = event {
            await notificator.sendNotification(token: token, event: event)
        }
    }
}
