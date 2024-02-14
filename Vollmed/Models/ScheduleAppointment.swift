//
//  ScheduleAppointment.swift
//  Vollmed
//
//  Created by Vinicius Wessner on 13/02/24.
//

import Foundation


//modelo de request
struct ScheduleAppointmentResponse: Codable, Identifiable {
    let id: String
    let specialist: String
    let patient: String
    let date: String
    let reasonToCancel: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case specialist = "especialista"
        case patient = "paciente"
        case date = "date"
        case reasonToCancel = "motivoCancelamento"
    }
}

//modelo do envio
struct ScheduleAppointmentRequest: Codable {
    let specialist: String
    let patient: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case specialist = "especialista"
        case patient = "paciente"
        case date = "data"
    }
}
