//
//  ViewAutoUpdateViewController.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/17/25.
//

import UIKit
import AVFoundation


class ViewAutoUpdateViewController: UIViewController {
    @IBAction func audioButton(_ sender: Any) {
        guard let autoUpdate = autoUpdate,
              let audioData = autoUpdate.audioData else { return }

        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
  
    @IBOutlet weak var emojiLabel: UILabel!
    
    var autoUpdate: AutoUpdate?
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let autoUpdate = autoUpdate else { return }
        
        emojiLabel.text = autoUpdate.emoji
        messageLabel.text = autoUpdate.message
        timeLabel.text = autoUpdate.time
       
        
        if let imageData = autoUpdate.imageData {
            photoImageView.image = UIImage(data: imageData)
        } else {
            photoImageView.isHidden = true
        }
        
        if autoUpdate.audioData == nil {
            audioButton.isHidden = true
        }
        
        noteLabel.text = autoUpdate.notes

    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    

}
