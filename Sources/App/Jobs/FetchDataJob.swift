//
// Created by rafael on 2/21/22.
//

import Vapor
import Queues
import MongoKitten

struct FetchDataJob: AsyncScheduledJob {
    let logger = Logger(label: "FetchDataJob")

    func run(context: QueueContext) async throws {
        logger.log(level: .info, "Starting to fetch data")

        do {
            let response = try await context.application.client.get("http://www.prociv.pt/en-US/Pages/export.aspx?ex=1&l=0&d=&c=&f=&t=0&n=0&e=1")
            logger.log(level: .debug, "Got response")

            guard let byteBuffer = response.body.wrapped else { throw Abort(.badRequest) }
            logger.log(level: .debug, "Got valid ByteBuffer")

            let data = Data(buffer: byteBuffer)
            logger.log(level: .debug, "Valid ByteBuffer to Data conversion, size is \(MemoryLayout.size(ofValue: data)) bytes")

            let body = String(data: data, encoding: .windowsCP1250)
            logger.log(level: .debug, "Body is valid")

            guard let body = body else { throw Abort(.badRequest) }

            let handler = try CsvHandler(csvBody: body)
            logger.log(level: .info, "CSV loaded")

            try storeOnDatabase(events: handler.eventsFromCSV(), database: context.application.mongoDB)
            logger.log(level: .notice, "Inserted new events")
        } catch {
            logger.log(level: .error, "\(error.localizedDescription)")
            logger.report(error: error)
        }
    }

    private func storeOnDatabase(events: [ProCivEvent], database: MongoDatabase) throws {
        let response = try database.allEvents.insertManyEncoded(events).wait()
        logger.log(level: .debug, "\(response.debugDescription)")

        let _ = try database.latest.deleteAll(where: [:]).wait()
        let latestResponse = try database.latest.insertManyEncoded(events).wait()

        logger.log(level: .debug, "\(latestResponse.debugDescription)")
    }
}
