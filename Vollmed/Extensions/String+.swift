//
//  String+.swift
//  Vollmed
//
//  Created by Vinicius Wessner on 13/02/24.
//

import Foundation

extension String {
    func convertDateStringToReadableDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = inputFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy 'ás' HH:mm"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
}
