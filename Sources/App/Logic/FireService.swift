//
// Created by rafael on 2/23/22.
//

import Foundation
import MongoKitten

class FireService {
    private let database: MongoDatabase

    init(database: MongoDatabase) {
        self.database = database
    }

    func getAllFires() async throws -> [ProCivEvent] {
        try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<[ProCivEvent], Error>) in
            let results = database
                    .singleEventAggregate()
                    .decode(ProCivEvent.self)
                    .allResults()

            do {
                continuation.resume(returning: try results.wait())
            } catch {
                continuation.resume(throwing: error)
            }
        })
    }

    /*func getLatestStatusForFireId() -> ProCivEvent {

    }*/
}