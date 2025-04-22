//
//  HomeViewController.swift
//  Updates
//
//  Created by Edom Belayneh on 4/13/25.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsData[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        let item = settingsData[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item
        
//        // Optional: Accessory logic
//        switch item {
//        case "Share with Partner", "Hide Location", "Dark Mode", "Backup & Restore":
//            let toggle = UISwitch()
//            toggle.isOn = false
//            toggle.tag = indexPath.row
//            toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
//            cell.accessoryView = toggle
//        default:
//            cell.accessoryType = .disclosureIndicator
//            cell.accessoryView = nil
//        }
        
        return cell
    }
    
    
    @IBOutlet weak var settingsTableview: UITableView!
    
    var settingsData: [Setting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view.
        settingsTableview.delegate = self
        settingsTableview.dataSource = self
        
        setupSettingsData()
    }
    
    func setupSettingsData() {
        settingsData = [
            Setting(title: "Privacy & Sharing", items: ["Share with Partner", "Hide Location"]),
            Setting(title: "Customization", items: ["Update Templates", "Time Zone", "Notification Settings"]),
            Setting(title: "Account", items: ["Partner Info", "Reset Shared Link", "Sync Calendar"]),
            Setting(title: "App Settings", items: ["Backup & Restore", "Dark Mode"])
        ]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.count
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
