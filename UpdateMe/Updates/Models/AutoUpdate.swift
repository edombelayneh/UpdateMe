//
//  AutoUpdates.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/17/25.
//

import Foundation

struct AutoUpdate: Codable {
    var message: String
    var time: String
    var isOn: Bool
    var emoji: String?
    var notes: String?
    var frequency: [Int]?

    var imageData: Data?
    var audioData: Data?

    var id: String = UUID().uuidString
}
