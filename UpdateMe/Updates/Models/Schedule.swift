//
//  Schedule.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/18/25.
//

import Foundation

struct Schedule: Codable {
    var title: String
    var description: String
    var startDateTime: Date
    var endDateTime: Date
    var status: String  // busy, open, idle
    var partnerCanSee: Bool
}

