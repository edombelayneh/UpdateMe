//
//  HomeViewController.swift
//  Updates
//
//  Created by Edom Belayneh on 4/13/25.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! MyScheduleCell
        
        let schedules = schedules[indexPath.row]
        cell.titleLabel.text = schedules.title
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Example: 2:00 PM
        
        let startTime = formatter.string(from: schedules.startDateTime)
        let endTime = formatter.string(from: schedules.endDateTime)
        
        cell.timeLabel.text = "\(startTime) - \(endTime)"
        
        
        if let day = Calendar.current.dateComponents([.day], from: schedules.startDateTime).day {
            cell.dateNumLabel.text = "\(day)"
        }
        
        
        cell.statusLabel.text = schedules.status
        cell.partnerCanSeeSwitch.isOn = schedules.partnerCanSee
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            schedules.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveUpdatesToJSON()
            emptyStateLabel.isHidden = !schedules.isEmpty
            print("🗑️ Deleted row at \(indexPath.row)")
        }
    }
    
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBAction func didTapAddSchedule(_ sender: Any) {
        performSegue(withIdentifier: "AddScheduleSegue", sender: nil)
    }
    @IBOutlet weak var myScheduleTableview: UITableView!
    @IBAction func autoUpdateButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let autoUpdateVC = storyboard.instantiateViewController(withIdentifier: "AutoUpdateVC") as? AutoUpdateViewController {
            navigationController?.pushViewController(autoUpdateVC, animated: true)
        } else {
            print("❌ Couldn't find AutoUpdateVC or cast it correctly")
        }
    }
    
    var schedules: [Schedule] = []
//    var schedule1: Schedule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScheduleTableview.delegate = self
        myScheduleTableview.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadUpdates),
                                               name: UpdateManager.updatesChangedNotification,
                                               object: nil)
        
        reloadUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("👀 viewWillAppear was called")
        reloadUpdates()
    }
    
    @objc func reloadUpdates() {
        schedules = loadUpdatesFromJSON()
        print("📦 Updates array has: \(schedules.count) items")
        myScheduleTableview.reloadData()
        emptyStateLabel.isHidden = !schedules.isEmpty
    }
    
    
    func loadUpdatesFromJSON() -> [Schedule] {
        let fileManager = FileManager.default
        let filename = "schedule.json"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsURL.appendingPathComponent(filename)
        
        // Copy from bundle if it doesn't exist
        if !fileManager.fileExists(atPath: destinationURL.path),
           let bundleURL = Bundle.main.url(forResource: "schedule", withExtension: "json") {
            do {
                try fileManager.copyItem(at: bundleURL, to: destinationURL)
                print("📥 Copied JSON to Documents")
            } catch {
                print("❌ Error copying file: \(error)")
            }
        }
        
        // Read and decode
        
        do {
            let data = try Data(contentsOf: destinationURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let schedule = try decoder.decode([Schedule].self, from: data)
            
            
            print("📁 Schedule.json path: \(destinationURL.path)")
            return schedule
        } catch {
            print("📁 Schedule.json path: \(destinationURL.path)")
            print("❌ Error decoding JSON: \(error)")
            return []
        }
    }
    
    
    func saveUpdatesToJSON() {
        let fileManager = FileManager.default
        let filename = "schedule.json"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsURL.appendingPathComponent(filename)

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601 // 👈🏽 this is the fix
            let data = try encoder.encode(schedules)
            try data.write(to: destinationURL)
            print("💾 Saved updates to JSON at: \(destinationURL.path)")
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }

    
}
