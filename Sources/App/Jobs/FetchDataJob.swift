//
// Created by rafael on 2/21/22.
//

import Vapor
import Queues

struct FetchDataJob: AsyncScheduledJob {
    let logger = Logger(label: "FetchDataJob")

    func run(context: QueueContext) async throws {
        logger.log(level: .info, "Starting to fetch data")
    }
}