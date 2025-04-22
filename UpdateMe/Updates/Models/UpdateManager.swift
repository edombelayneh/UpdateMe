//
//  UpdateManager.swift
//  Updates
//
//  Created by Edom Belayneh on 4/13/25.
//

import Foundation

class UpdateManager {
    static let shared = UpdateManager()
    private let updatesKey = "savedUpdates"
    
    // Notification name
    static let updatesChangedNotification = Notification.Name("updatesChanged")
    
    func saveAll(_ updates: [Update]) {
        if let data = try? JSONEncoder().encode(updates) {
            UserDefaults.standard.set(data, forKey: updatesKey)
        }
        
    }

    func save(update: Update) {
        var updates = fetchUpdates()
        updates.insert(update, at: 0) // newest first
        if let data = try? JSONEncoder().encode(updates) {
            UserDefaults.standard.set(data, forKey: updatesKey)
        }
        refreshUpdates()
    }

    func fetchUpdates() -> [Update] {
        guard let data = UserDefaults.standard.data(forKey: updatesKey),
              let updates = try? JSONDecoder().decode([Update].self, from: data) else {
            return []
        }
        return updates
    }

    func clearAll() {
        UserDefaults.standard.removeObject(forKey: updatesKey)
    }
    
    func refreshUpdates() {
        NotificationCenter.default.post(name: UpdateManager.updatesChangedNotification, object: nil)
    }
}

