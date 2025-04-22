//
//  HomeViewController.swift
//  Updates
//
//  Created by Edom Belayneh on 4/13/25.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var personImageview: UIImageView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var recentTimeLabel: UILabel!
    @IBOutlet weak var recentTableview: UITableView!
    @IBOutlet weak var recentUpdatesLabel: UILabel!
    
    @IBAction func sendCustomUpdateButton(_ sender: UIButton) {
        performSegue(withIdentifier: "CustomUpdateSegue", sender: nil)
        
    }
    
    @IBAction func cantTalkButton(_ sender: UIButton) {
        sendUpdate(message: "Can’t talk", emoji: "❤️")
    }
    
    @IBAction func communtingButton(_ sender: UIButton) {
        sendUpdate(message: "Commuting", emoji: "🚍")
    }
    
    @IBAction func withFrienduttons(_ sender: UIButton) {
        sendUpdate(message: "With friends", emoji: "👯")
    }
    
    @IBAction func atWorkButton(_ sender: UIButton) {
        sendUpdate(message: "At work", emoji: "👩🏾‍💻")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath) as! UpdateCell
        
        let update = updates[indexPath.row]
        cell.messageLabel.text = "\(update.emoji ?? "") \(update.message)"
        
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
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            updates.remove(at: indexPath.row)
            UpdateManager.shared.saveAll(updates) // Save the updated list
            
            recentTableview.deleteRows(at: [indexPath], with: .automatic)
            emptyStateLabel.isHidden = !updates.isEmpty
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let update = updates[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "UpdateDetailVC") as? UpdateDetailViewController {
            detailVC.update = update
            
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    var updates = [Update]()
    var update: Update!
    var partnerStatus: String = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updates = UpdateManager.shared.fetchUpdates()
        recentTableview.delegate = self
        recentTableview.dataSource = self
        
        
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fullPath = documentsDirectory.appendingPathComponent("autoUpdates.json")
            print("📁 File path: \(fullPath.path)")
        }
        
        updateStatusDot(for: partnerStatus ?? "")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPartnerIcon))
        personImageview.isUserInteractionEnabled = true
        personImageview.addGestureRecognizer(tapGesture)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshUI),
            name: UpdateManager.updatesChangedNotification,
            object: nil
        )
        
        // Do any additional setup after loading the view.
        //        refreshUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshUpdates()
    }
    
    func updateStatusDot(for status: String) {
        switch status.lowercased() {
        case "free":
            statusView.backgroundColor = .systemGreen
        case "idle":
            statusView.backgroundColor = .systemYellow
        case "busy":
            statusView.backgroundColor = .systemRed
        default:
            statusView.backgroundColor = .lightGray // unknown status
        }
    }
    
    func sendUpdate(message: String, emoji: String){
        let newUpdate = Update(message: message, emoji: emoji, timestamp: Date())
        UpdateManager.shared.save(update: newUpdate)
        
        updates.insert(newUpdate, at: 0)
        recentTableview.reloadData()
        refreshUpdates()
    }
    
    private func refreshUpdates() {
        updates = UpdateManager.shared.fetchUpdates()
        emptyStateLabel.isHidden = !updates.isEmpty
        recentTableview.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    //    ----------------------------------------------------------------------------
    @objc func refreshUI() {
        updates = UpdateManager.shared.fetchUpdates()
        recentTableview.reloadData()
    }
    
    @objc func didTapPartnerIcon() {
        performSegue(withIdentifier: "showPartnerProfile", sender: self)
    }
}

