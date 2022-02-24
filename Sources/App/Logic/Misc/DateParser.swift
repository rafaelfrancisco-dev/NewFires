//
//  File.swift
//  
//
//  Created by Rafael Francisco on 24/02/2022.
//

import Foundation

extension ProCivEvent {
    var eventDate: Date? {
        get {
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "M/dd/yyyy h:mm:ss a"
            
            return dateFormatter.date(from: self.dataOcorrencia)
        }
    }
}
