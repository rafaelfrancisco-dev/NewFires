//
//  File.swift
//  
//
//  Created by Rafael Francisco on 26/02/2022.
//

import Vapor
import Queues
import MongoKitten

struct NotificationsJob: AsyncScheduledJob {
    let logger = Logger(label: "NotificationsJob")

    func run(context: QueueContext) async throws {
        logger.log(level: .info, "Updating notifications")
        
        let database = context.application.mongoDB
        
        
    }
}
