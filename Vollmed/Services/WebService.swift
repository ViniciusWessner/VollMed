//
//  WebService.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import Foundation
import UIKit

let patientIDtemporary = "606f8611-2991-4b36-8470-0be3dfbcab4d"

struct WebService {
    
    
    private let baseURL = "http://localhost:3000"
    
    func cancelAppointment(appointmentID: String, reasonToCancel: String) async throws -> Bool {
        let endpoint = baseURL + "/consulta/" + appointmentID
        
        guard let url = URL(string: endpoint) else {
            print("algum erro na url")
            return false
        }
        let requestData: [String : String] = ["motivoCancelamento" : reasonToCancel]
        let jsonData = try JSONSerialization.data(withJSONObject: requestData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            return true
        }
        
        return false
    }
    
    
    func rescheduleAppointment(appointmentID: String, date: String) async throws -> ScheduleAppointmentResponse? {
        let endpoint = baseURL + "/consulta/" + appointmentID
        guard let url = URL(string: endpoint) else {
            print("erro na url")
            return nil
        }
        
        let requestData: [String: String] = ["data": date]
        //converti meu dicionario em json
        let jsonData = try JSONSerialization.data(withJSONObject: requestData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data,_) = try await URLSession.shared.data(for: request)
        let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
        return appointmentResponse
    }
    
    
    func getAllAppointmentsFromPatient(patientID: String) async throws -> [Appointment]? {
        let endpoint = baseURL + "/paciente/" + patientIDtemporary + "/consultas"
        
        guard let url = URL(string: endpoint) else {
            print("erro na url")
            return nil
        }
        let (data,_) = try await URLSession.shared.data(from: url)
        let appointments = try JSONDecoder().decode([Appointment].self, from: data)
        
        return appointments
    }
    
    func scheduleAppointment(specialistID: String, 
                             patientID: String,
                             date: String) async throws -> ScheduleAppointmentResponse? {
        let endpoint = baseURL + "/consulta"
        guard let url = URL(string: endpoint) else {
            print("erro na url")
            return nil
        }
        
        let appointment = ScheduleAppointmentRequest(specialist: specialistID, patient: patientIDtemporary, date: date)
        
        //converter em json
        let jsonDate = try JSONEncoder().encode(appointment)
        
        //criando a requisicao
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonDate
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let appointmenteResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
        
        return appointmenteResponse
    }
    
    
    //criando cache para a imagem
    let imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(from imageURL: String) async throws -> UIImage? {
        guard let url = URL(string: imageURL) else {
            print("erro na url")
            return nil
        }
        //validando se a imagem ja existe em cache
        
        if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image =  UIImage(data: data) else {
            return nil
        }
        
        //salvando a imagem no cache
        imageCache.setObject(image, forKey: imageURL as NSString)
        return image
    }
    
    
    func getAllSpecialists() async throws -> [Specialist]? {
        let endpoint = baseURL + "/especialista"
        
        guard let url = URL(string: endpoint) else {
            print("erro na url")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let specialists = try JSONDecoder().decode([Specialist].self, from: data)
        
        return specialists
    }
}
