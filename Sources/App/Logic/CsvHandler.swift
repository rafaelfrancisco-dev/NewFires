//
// Created by rafael on 2/21/22.
//

import Foundation
import SwiftCSV

class CsvHandler {
    private let csv: CSV

    init(csvBody: String) throws {
        csv = try CSV(string: csvBody, delimiter: "|")
    }

    func eventsFromCSV() throws -> [ProCivEvent] {
        var returnArray = [ProCivEvent]()

        try csv.enumerateAsArray(startAt: 1, rowLimit: nil) { array in
            returnArray.append(ProCivEvent(
                    numero: array[0],
                    dataOcorrencia: array[1],
                    natureza: array[2],
                    estadoOcorrencia: array[3],
                    distrito: array[4],
                    concelho: array[5],
                    freguesia: array[6],
                    localidade: array[7],
                    latitude: Double(array[8]) ?? 0,
                    longitude: Double(array[9]) ?? 0,
                    numeroMeiosTerrestresEnvolvidos: Int(array[10]) ?? 0,
                    numeroOperacionaisTerrestresEnvolvidos: Int(array[11]) ?? 0,
                    numeroMeiosAereosEnvolvidos: Int(array[12]) ?? 0,
                    numeroOperacionaisAereosEnvolvidos: Int(array[13]) ?? 0
            ))
        }

        return returnArray
    }
}
