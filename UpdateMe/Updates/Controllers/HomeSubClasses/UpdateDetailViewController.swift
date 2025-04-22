//
//  UpdateDetailViewController.swift
//  Updates
//
//  Created by Edom Belayneh on 4/14/25.
//

import UIKit
import AVFoundation

class UpdateDetailViewController: UIViewController {
    
    
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var notesLabel: UILabel!
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
    
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    var update: Update?
    var audioPlayer: AVAudioPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let update = update else { return }
        
        emojiLabel.text = update.emoji
        messageLabel.text = update.message
        notesLabel.text = update.notes
        dateAndTimeLabel.text = formattedDate(update.timestamp)
        
        if let imageData = update.imageData {
            photoImageView.image = UIImage(data: imageData)
        } else {
            photoImageView.isHidden = true
        }
        
        if update.audioData == nil {
            audioButton.isHidden = true
        }
    

        // Do any additional setup after loading the view.
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
    
    
}
