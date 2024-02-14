//
//  CancelAppointmentView.swift
//  Vollmed
//
//  Created by Vinicius Wessner on 14/02/24.
//

import SwiftUI

struct CancelAppointmentView: View {
    
    @Environment(\.presentationMode) var presentationMode

    
    var service = WebService()
    var appointmentID: String
    
    //exibe alerta
    @State private var showAlert = false
    //houve erro?
    @State private var cancelAppointment = false
    
    @State private var reasonToCancel = ""
    
    func cancelAppointment() async {
        do {
            if try await service.cancelAppointment(appointmentID: appointmentID, reasonToCancel: reasonToCancel) {
                print("consulta cancelada com sucesso")
                cancelAppointment = true
                
            } else {
                cancelAppointment = false
            }
        } catch {
            print("ocorreu um erro ao cancelar a consulta: \(error)")
            cancelAppointment = false
        }
        
        showAlert = true
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Conte-nos o motivo do cancelamento da sua consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            TextEditor(text: $reasonToCancel)
                .padding()
                .font(.title3)
                .foregroundStyle(.accent)
                .scrollContentBackground(.hidden)
                .background(Color(.lightBlue).opacity(0.15))
                .cornerRadius(16.0)
                .frame(maxHeight: 300)
            
            Button(action: {
                Task {
                    await cancelAppointment()
                }
            }, label: {
                ButtonView(text: "Cancelar Consulta", buttonType: .cancel)
            })
        }
        .padding()
        .navigationTitle("Cancelar Consulta")
        .alert(cancelAppointment ? "consulta cancelada" : "Ops, nao conseguimos cancelar", isPresented: $showAlert, presenting: cancelAppointment) { isCancel  in
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Ok")
            })
        } message: { isCancel in
            if isCancel {
                Text("A consulta foi cancelado com sucesso")
            } else {
                Text("Houve um erro ao cancelar sua consulta.\n Por favor tente novamente ou faca um contato atraves do telefone 51 3632-2233")
            }
        }
        
    }
}

#Preview {
    CancelAppointmentView(appointmentID: "1234")
}
