//
//  AutoUpdateViewController.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/15/25.
//

import UIKit

class AutoUpdateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        autoUpdates.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            autoUpdates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveUpdatesToJSON()
            emptyStateLabel.isHidden = !autoUpdates.isEmpty
            print("🗑️ Deleted row at \(indexPath.row)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "autoScheduleCell", for: indexPath) as! ScheduleCellTableViewCell
        
        let autoUpdate = autoUpdates[indexPath.row]
        cell.messageLabel.text = autoUpdate.message
        cell.timeLabel.text = autoUpdate.time
        cell.onSwitch.isOn = autoUpdate.isOn
        
        cell.onSwitchToggled = { [weak self] isOn in
            self?.autoUpdates[indexPath.row].isOn = isOn
            print("🔁 Toggled row \(indexPath.row) to \(isOn)")
            self?.saveUpdatesToJSON()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let autoUpdate = autoUpdates[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "AutoUpdateDetailVC") as? ViewAutoUpdateViewController {
            detailVC.autoUpdate = autoUpdate
            
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    @IBAction func addAutoUpdateButton(_ sender: Any) {
        performSegue(withIdentifier: "CreateAutoUpdateSegue", sender: nil)
    }
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var scheduleTimeview: UITableView!
    var autoUpdates: [AutoUpdate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTimeview.delegate = self
        scheduleTimeview.dataSource = self
        
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
        autoUpdates = loadUpdatesFromJSON()
        print("📦 Updates array has: \(autoUpdates.count) items")
        scheduleTimeview.reloadData()
        emptyStateLabel.isHidden = !autoUpdates.isEmpty
    }
    
    
    func loadUpdatesFromJSON() -> [AutoUpdate] {
        let fileManager = FileManager.default
        let filename = "autoUpdates.json"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsURL.appendingPathComponent(filename)
        
        // Copy from bundle if it doesn't exist
        if !fileManager.fileExists(atPath: destinationURL.path),
           let bundleURL = Bundle.main.url(forResource: "autoUpdates", withExtension: "json") {
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
            let updates = try decoder.decode([AutoUpdate].self, from: data)
            return updates
        } catch {
            print("❌ Error decoding JSON: \(error)")
            return []
        }
    }
    
    
    func saveUpdatesToJSON() {
        let fileManager = FileManager.default
        let filename = "autoUpdates.json"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsURL.appendingPathComponent(filename)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(autoUpdates)
            try data.write(to: destinationURL)
            print("💾 Saved updates to JSON at: \(destinationURL.path)")
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }
    
    
    
    
    
    
}
