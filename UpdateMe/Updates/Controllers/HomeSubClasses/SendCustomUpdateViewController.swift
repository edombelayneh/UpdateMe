//
//  SendCustomUpdateViewController.swift
//  Updates
//
//  Created by Edom Belayneh on 4/14/25.
//

import UIKit
import AVFoundation

class SendCustomUpdateViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, AVAudioRecorderDelegate {
    
    // Date picker
    @IBOutlet weak var untilDatePicker: UIDatePicker!
    
    // ImageView for picture
    @IBOutlet weak var addedPhotoImageView: UIImageView!
    
    // Voice Picker
    @IBAction func recordVoiceButton(_ sender: UIButton) {
        if !hasRecorded{
            if !isRecording{
                startRecording()
                isRecording = true
                sender.setTitle("⏹ Stop Recording", for: .normal)
            }
            else{
                stopRecording()
                isRecording = false
                sender.setTitle("▶️ Play Voice Note", for: .normal)
            }
        }
        else{
            playVoiceNote()
        }
    }
    
    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        audioFilename = FileManager.default.temporaryDirectory.appendingPathComponent("voiceNote.m4a")

        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
 
    func stopRecording(){
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            hasRecorded = true
            recordVoiceButton.setTitle("▶️ Play Voice Note", for: .normal)
        } else {
            print("Recording failed.")
        }
    }

    
    func playVoiceNote() {
        guard let url = audioFilename else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Playback failed: \(error.localizedDescription)")
        }
    }

    
    @IBOutlet weak var recordVoiceButton: UIButton!
    
    // Image picker
    @IBAction func addPhotoButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    // Note, emoji and Message textfield
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var emojiTextfield: UITextField!
    
    // audio properties
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioFilename: URL?
    var isRecording = false
    var hasRecorded = false
    
    
    // Tapping buttons
    @IBAction func didTapSendButton(_ sender: Any) {
        guard let customMessage = messageTextfield.text,
              !customMessage.isEmpty else {
            presentAlert(title: "Oops...", message: "Make sure to add a Message!")
            return
        }
        
        // Use the current time as the timestamp
        let currentTimestamp = Date()
        let until = untilDatePicker.date
        let emoji = emojiTextfield.text
        let note = noteTextField.text
        
        // Convert image to Data
        let imageData = addedPhotoImageView.image?.jpegData(compressionQuality: 0.8)
        
        // TODO: Replace with actual voice data once recording is implemented
        let voiceData: Data? = {
            guard let url = audioFilename else { return nil }
            return try? Data(contentsOf: url)
        }()
        
        // Create update
        let customUpdate = Update(
            message: customMessage,
            emoji: emoji,
            notes: note,
            timestamp: currentTimestamp,
            until: until,
            imageData: imageData,
            audioData: voiceData
        )
        
        print("Created Update: \(customUpdate)")
        UpdateManager().save(update: customUpdate)
        dismiss(animated: true)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            addedPhotoImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func presentAlert(title: String, message: String) {
        // 1.
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        // 2.
        let okAction = UIAlertAction(title: "OK", style: .default)
        // 3.
        alertController.addAction(okAction)
        // 4.
        present(alertController, animated: true)
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
