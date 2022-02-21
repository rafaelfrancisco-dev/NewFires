//
// Created by rafael on 2/21/22.
//

import Vapor
import Fluent

final class ProCivEvent: Model, Content {
    static let schema = "prociv_events"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "numero")
    var numero: String

    @Field(key: "dataOcorrencia")
    var dataOcorrencia: String

    @Field(key: "natureza")
    var natureza: String

    @Field(key: "estadoOcorrencia")
    var estadoOcorrencia: String

    @Field(key: "distrito")
    var distrito: String

    @Field(key: "concelho")
    var concelho: String

    @Field(key: "freguesia")
    var freguesia: String

    @Field(key: "localidade")
    var localidade: String

    @Field(key: "latitude")
    var latitude : Double

    @Field(key: "longitude")
    var longitude : Double

    @Field(key: "numeroMeiosTerrestresEnvolvidos")
    var numeroMeiosTerrestresEnvolvidos: Int

    @Field(key: "numeroOperacionaisTerrestresEnvolvidos")
    var numeroOperacionaisTerrestresEnvolvidos: Int

    @Field(key: "numeroMeiosAereosEnvolvidos")
    var numeroMeiosAereosEnvolvidos : Int

    @Field(key: "numeroOperacionaisAereosEnvolvidos")
    var numeroOperacionaisAereosEnvolvidos: Int

    @Timestamp(key: "updatedDate", on: .update)
    var updatedDate: Date?

    init() { }

    init(id: UUID? = nil, numero: String, dataOcorrencia: String, natureza: String, estadoOcorrencia: String, distrito: String, concelho: String, freguesia: String, localidade: String, latitude: Double, longitude: Double, numeroMeiosTerrestresEnvolvidos: Int, numeroOperacionaisTerrestresEnvolvidos: Int, numeroMeiosAereosEnvolvidos: Int, numeroOperacionaisAereosEnvolvidos: Int) {
        self.id = id
        self.numero = numero
        self.dataOcorrencia = dataOcorrencia
        self.natureza = natureza
        self.estadoOcorrencia = estadoOcorrencia
        self.distrito = distrito
        self.concelho = concelho
        self.freguesia = freguesia
        self.localidade = localidade
        self.latitude = latitude
        self.longitude = longitude
        self.numeroMeiosTerrestresEnvolvidos = numeroMeiosTerrestresEnvolvidos
        self.numeroOperacionaisTerrestresEnvolvidos = numeroOperacionaisTerrestresEnvolvidos
        self.numeroMeiosAereosEnvolvidos = numeroMeiosAereosEnvolvidos
        self.numeroOperacionaisAereosEnvolvidos = numeroOperacionaisAereosEnvolvidos
    }
}
