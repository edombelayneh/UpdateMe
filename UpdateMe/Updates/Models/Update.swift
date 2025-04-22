//
//  Updates.swift
//  Updates
//
//  Created by Edom Belayneh on 4/13/25.
//

import Foundation

struct Update: Codable {
    var message: String
    var emoji: String?
    var notes: String?
    var timestamp: Date
    var until: Date?
    
    var imageData: Data?
    var audioData: Data?
    
   // An id (Universal Unique Identifier) used to identify an update.
    var id: String = UUID().uuidString
}
