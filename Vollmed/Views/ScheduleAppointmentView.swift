//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Vinicius Wessner on 13/02/24.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let service = WebService()
    var specialistID: String
    var isRescheduleView: Bool
    var appointmentID: String?
    
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @State private var isAppointmentScheduled = false
    
    init(specialistID: String, isRescheduleView: Bool = false, appointmentID: String? = nil){
        self.specialistID = specialistID
        self.isRescheduleView = isRescheduleView
        self.appointmentID = appointmentID
    }
    
    func rescheduleAppointment() async {
        guard let appointmentID else {
            print("Houve um erro ao obter o id da consulta")
            return
        }
        do{
            if let appointment = try await service.rescheduleAppointment(appointmentID: appointmentID, date: selectedDate.convertToString()) {
                isAppointmentScheduled = true
            } else {
                isAppointmentScheduled = false
            }
        } catch {
            print("ocorreu um erro ao remarcar consulta: \(error)")
            isAppointmentScheduled = false
        }
        showAlert = true
    }
    
    func scheduleAppointment() async {
        do {
            if let appointment =  try await 
                service.scheduleAppointment(specialistID: specialistID,
                                            patientID: patientIDtemporary,
                                            date: selectedDate.convertToString()) {
                isAppointmentScheduled = true
            } else {
                isAppointmentScheduled = false
            }
        } catch {
            print("ocorreu um erro ao agendar a consulta: \(error)")
            isAppointmentScheduled = false
        }
        
        showAlert = true
    }
    
    var body: some View {
        VStack {
            Text("Selecione a data e o horario da consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            DatePicker("Escolha a data da consulta", selection: $selectedDate, in: Date()...)
                .datePickerStyle(.graphical)
                
            
            Button(action: {
                Task {
                    if isRescheduleView {
                        await rescheduleAppointment()
                    } else {
                        await scheduleAppointment()

                    }
                }
                print(selectedDate.convertToString())
            }, label: {
                ButtonView(text: isRescheduleView ? "Reagendar consulta" : "Agendar Consulta")
            })
        }
        .padding()
        .navigationTitle(isRescheduleView ? "Reagendar Consulta" : "Agendar Consulta")
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 25
        }
        .alert(isAppointmentScheduled ? "Sucesso" : "Ops! Algo de errado", isPresented: $showAlert, presenting: isAppointmentScheduled) { isSchaduled in
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Ok")
            })
        } message: { isSchadulet in
            if isSchadulet {
                Text("A consulta foi \(isRescheduleView ? "reagendada" : "agaendada") com sucesso")
            } else {
                Text("Houve um erro ao \(isRescheduleView ? "reagendadar" : "agendar") sua consulta.\n Por favor tente novamente ou faca um contato atraves do telefone 51 3632-2233")
            }
        }

    }
}

#Preview {
    ScheduleAppointmentView(specialistID: "123")
}
