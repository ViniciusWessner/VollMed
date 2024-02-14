//
//  MyAppointmentsView.swift
//  Vollmed
//
//  Created by Vinicius Wessner on 13/02/24.
//

import SwiftUI

struct MyAppointmentsView: View {
    let service = WebService()
    
    @State private var appointments: [Appointment] = []
    
    func getAllAppointments() async {
        do{
            if let appointments = try await service.getAllAppointmentsFromPatient(patientID: patientIDtemporary) {
                self.appointments = appointments
            }
        }catch{
            print("Ocorreu um erro ao obter suas consultas: \(error)")
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(appointments) { appointment in
                SpecialistCardView(specialist: appointment.specialist, appointment: appointment)
            }
        }
        .navigationTitle("Minhas consultas")
        .padding()
        .onAppear {
            Task {
                await getAllAppointments()
            }
        }
    }
}

#Preview {
    MyAppointmentsView()
}
