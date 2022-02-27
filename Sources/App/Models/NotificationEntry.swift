//
//  File.swift
//  
//
//  Created by Rafael Francisco on 26/02/2022.
//

import Foundation
import Vapor
import BSON

struct NotificationEntry: Codable, Content {
    let token: String
    var fires: [NotificationCheck]
    
    func containsFire(fire: String) -> Bool {
        return !fires.filter { $0.fire == fire}.isEmpty
    }
    
    mutating func removeFire(fire: String) {
        fires.removeAll { entry in
            entry.fire == fire
        }
    }
}

struct NotificationCheck: Codable, Content {
    let fire: String
    let lastStatus: String?
}
