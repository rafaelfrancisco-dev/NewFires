//
//  File.swift
//  
//
//  Created by Rafael Francisco on 24/02/2022.
//

import Foundation
import Vapor

// MARK: - StatusProCivEventElement
struct StatusProCivEventElement: Codable, Content  {
    let id: Int
    let numero, estadoOcorrencia: String
    let data: Int

    enum CodingKeys: String, CodingKey {
        case id
        case numero = "Numero"
        case estadoOcorrencia = "EstadoOcorrencia"
        case data = "Data"
    }
}

typealias StatusProCivEvent = [StatusProCivEventElement]
