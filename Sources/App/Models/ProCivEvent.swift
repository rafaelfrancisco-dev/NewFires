//
// Created by rafael on 2/21/22.
//

import Vapor

// MARK: - ProCivEvent
struct ProCivEvent: Codable {
    let numero, dataOcorrencia, natureza, estadoOcorrencia: String
    let distrito, concelho, freguesia, localidade: String
    let latitude, longitude: Double
    let numeroMeiosTerrestresEnvolvidos, numeroOperacionaisTerrestresEnvolvidos: Int
    let numeroMeiosAereosEnvolvidos, numeroOperacionaisAereosEnvolvidos: Int
    let updateDate: Date = Date()

    enum CodingKeys: String, CodingKey {
        case numero = "Numero"
        case dataOcorrencia = "DataOcorrencia"
        case natureza = "Natureza"
        case estadoOcorrencia = "EstadoOcorrencia"
        case distrito = "Distrito"
        case concelho = "Concelho"
        case freguesia = "Freguesia"
        case localidade = "Localidade"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case numeroMeiosTerrestresEnvolvidos = "NumeroMeiosTerrestresEnvolvidos"
        case numeroOperacionaisTerrestresEnvolvidos = "NumeroOperacionaisTerrestresEnvolvidos"
        case numeroMeiosAereosEnvolvidos = "NumeroMeiosAereosEnvolvidos"
        case numeroOperacionaisAereosEnvolvidos = "NumeroOperacionaisAereosEnvolvidos"
        case updateDate = "updateDate"
    }
}