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
    var fires: [String]
}
