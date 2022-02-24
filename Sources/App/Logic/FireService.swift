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
                .latest
                .find(["$text" : [ "$search" : "Incêndio"]])
                .decode(ProCivEvent.self)
                .allResults()

            do {
                continuation.resume(returning: try results.wait())
            } catch {
                continuation.resume(throwing: error)
            }
        })
    }
    
    func eventExists(number: Int) async throws -> String? {
        try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<String?, Error>) in
            let result = database
                .allEvents
                .findOne("Numero" == "\(number)")
            
            do {
                let document = try result.wait()
                
                if let document = document {
                    continuation.resume(returning: document["Numero"] as? String)
                } else {
                    continuation.resume(returning: nil)
                }
            } catch {
                continuation.resume(throwing: error)
            }
        })
    }
    
    func getHistoryForEvent(number: String) async throws -> HistoryProCivEvent {
        try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<HistoryProCivEvent, Error>) in
            let results = database
                .allEvents
                .find("Numero" == number)
                .sort(["updateDate" : SortOrder.ascending])
                .decode(ProCivEvent.self)
                .map { event in
                    HistoryProCivEventElement(
                        id: UUID().hashValue,
                        numero: event.numero,
                        numeroMeiosTerrestresEnvolvidos: event.numeroMeiosTerrestresEnvolvidos,
                        numeroOperacionaisTerrestresEnvolvidos: event.numeroOperacionaisTerrestresEnvolvidos,
                        numeroMeiosAereosEnvolvidos: event.numeroMeiosAereosEnvolvidos,
                        data: event.updateDate.timeIntervalSince1970
                    )
                }
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
