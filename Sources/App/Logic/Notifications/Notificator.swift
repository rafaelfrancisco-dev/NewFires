//
//  File.swift
//  
//
//  Created by Rafael Francisco on 27/02/2022.
//

import Foundation
import Vapor
import FirebaseHelpers

actor Notificator {
    private let logger = Logger(label: "Notificator")
    
    func sendNotification(token: String, event: ProCivEvent) {
        logger.log(level: .debug, "Sending notification to \(token)")
    }
}
