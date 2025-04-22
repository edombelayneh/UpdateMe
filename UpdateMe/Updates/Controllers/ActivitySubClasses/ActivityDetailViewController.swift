//
//  ActivityDetailViewController.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/15/25.
//

import UIKit
import AVFoundation

class ActivityDetailViewController: UIViewController {
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var audioButton: UIButton!
    
    @IBAction func audioButton(_ sender: Any) {
        guard let update = update,
              let audioData = update.audioData else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var notesLabel: UILabel!
    
    var update: Update?
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let update = update else { return }
        
        emojiLabel.text = update.emoji
        messageLabel.text = update.message
        notesLabel.text = update.notes
        dateLabel.text = formattedDate(update.timestamp)
        
        if let imageData = update.imageData {
            photoImageView.image = UIImage(data: imageData)
        } else {
            photoImageView.isHidden = true
        }
        
        if update.audioData == nil {
            audioButton.isHidden = true
        }
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
    
}
