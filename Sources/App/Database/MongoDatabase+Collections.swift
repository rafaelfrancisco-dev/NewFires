//
// Created by rafael on 2/23/22.
//

import Foundation
import MongoKitten

extension MongoDatabase {
    var allEvents: MongoCollection {
        get {
            self["prociv_events"]
        }
    }

    var latest: MongoCollection {
        get {
            self["latest"]
        }
    }
}
