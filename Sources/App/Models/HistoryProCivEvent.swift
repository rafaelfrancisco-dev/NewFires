//
//  File.swift
//  
//
//  Created by Rafael Francisco on 24/02/2022.
//

import Foundation
import Vapor

// MARK: - HistoryProCivEventElement
struct HistoryProCivEventElement: Codable, Content {
    let id: Int
    let numero: String
    let numeroMeiosTerrestresEnvolvidos, numeroOperacionaisTerrestresEnvolvidos, numeroMeiosAereosEnvolvidos: Int
    let data: Double

    enum CodingKeys: String, CodingKey {
        case id
        case numero = "Numero"
        case numeroMeiosTerrestresEnvolvidos = "NumeroMeiosTerrestresEnvolvidos"
        case numeroOperacionaisTerrestresEnvolvidos = "NumeroOperacionaisTerrestresEnvolvidos"
        case numeroMeiosAereosEnvolvidos = "NumeroMeiosAereosEnvolvidos"
        case data = "Data"
    }
}

typealias HistoryProCivEvent = [HistoryProCivEventElement]
