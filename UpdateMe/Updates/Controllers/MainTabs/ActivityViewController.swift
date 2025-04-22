//
//  HomeViewController.swift
//  Updates
//
//  Created by Edom Belayneh on 4/13/25.
//

import UIKit

private struct RawUpdate: Decodable {
    var message: String
    var emoji: String?
    var timestamp: Date
    var until: Date?
    var imageData: String?
    var audioData: String?
    var id: String
}


class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell
        
        let update = updates[indexPath.row]
        cell.messageLabel.text = "\(update.message) \(update.emoji ?? "")"
        
        let addPlus = checkPlus(update: update)
        
        if addPlus != true {
            cell.plusLabel.isHidden = !addPlus
        }
        
        let updateDate = update.timestamp
        //        let now = Date()
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if calendar.isDateInToday(updateDate) {
            formatter.dateFormat = "h:mm a"
            cell.timeLabel.text = formatter.string(from: updateDate)
        } else if calendar.isDateInYesterday(updateDate) {
            formatter.dateFormat = "h:mm a"
            let timeString = formatter.string(from: updateDate)
            cell.timeLabel.text = "Yesterday at \(timeString)"
        } else {
            formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
            cell.timeLabel.text = formatter.string(from: updateDate)
        }
        
        
        
//        // Alternating colors:
//        if indexPath.row % 2 == 0 {
//                cell.backgroundColor = UIColor.systemGray6 // light gray
//            } else {
//                cell.backgroundColor = UIColor.white // or whatever matches your design
//            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let update = updates[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ActivityDetailVC") as? ActivityDetailViewController {
            detailVC.update = update
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var activityTableview: UITableView!
    
    var updates: [Update] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityTableview.delegate = self
        activityTableview.dataSource = self
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadUpdates),
                                               name: UpdateManager.updatesChangedNotification,
                                               object: nil)
        
        reloadUpdates()
    }
    
    
    @objc func reloadUpdates() {
        updates = loadUpdatesFromJSON()
        print("📦 Updates array has: \(updates.count) items")
        activityTableview.reloadData()
        emptyStateLabel.isHidden = !updates.isEmpty
    }
    
    private func checkPlus(update: Update) -> Bool {
        let updateNote = update.notes
        let updateAudio = update.audioData
        let updatePic = update.imageData
        
        if updateNote != nil || updateAudio != nil || updatePic != nil {
            return true
        }
        
        return false
    }
    
//    func loadUpdatesFromJSON() -> [Update] {
//        guard let url = Bundle.main.url(forResource: "updates", withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let updates = try? JSONDecoder().decode([Update].self, from: data) else {
//            print("❌ Failed to load or decode updates.json")
//            return []
//        }
//        return updates
//    }
//    func loadUpdatesFromJSON() -> [Update] {
//        guard let url = Bundle.main.url(forResource: "updates", withExtension: "json") else {
//            print("❌ Couldn't find updates.json")
//            return []
//        }
//        
//        print("📂 Found updates.json at: \(url)")
//        
//        do {
//            let data = try Data(contentsOf: url)
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            let decodedUpdates = try decoder.decode([Update].self, from: data)
//            print("✅ Successfully decoded \(decodedUpdates.count) updates")
//            return decodedUpdates
//        } catch {
//            print("❌ Error decoding JSON: \(error)")
//            return []
//        }
//    }
    
    func loadUpdatesFromJSON() -> [Update] {
        guard let url = Bundle.main.url(forResource: "updates", withExtension: "json") else {
            print("❌ Couldn't find updates.json")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let rawUpdates = try decoder.decode([RawUpdate].self, from: data)

            let finalUpdates = rawUpdates.map { raw in
                return Update(
                    message: raw.message,
                    emoji: raw.emoji,
                    timestamp: raw.timestamp,
                    until: raw.until,
                    imageData: raw.imageData.flatMap { Data(base64Encoded: $0) },
                    audioData: raw.audioData.flatMap { Data(base64Encoded: $0) },
                    id: raw.id
                )
            }

            print("✅ Successfully decoded \(finalUpdates.count) updates")
            return finalUpdates
        } catch {
            print("❌ Error decoding JSON: \(error)")
            return []
        }
    }


    
    
    
    
}
