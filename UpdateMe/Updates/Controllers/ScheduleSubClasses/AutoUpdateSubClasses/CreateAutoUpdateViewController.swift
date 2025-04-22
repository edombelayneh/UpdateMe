//
//  CreateAutoUpdateViewController.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/15/25.
//



import UIKit
import AVFoundation

class CreateAutoUpdateViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, AVAudioRecorderDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var selectedDays: Set<Int> = []
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? DayCell else {
            return UICollectionViewCell()
        }
        
        let day = daysOfWeek[indexPath.item]
        cell.dayLabel.text = day
        
        // Style selected/unselected
        let isSelected = selectedDays.contains(indexPath.item)
        cell.backgroundColor = isSelected ? .systemBlue : .systemGray5
        cell.dayLabel.textColor = isSelected ? .white : .black
        cell.layer.cornerRadius = 12
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedDays.contains(indexPath.item) {
            selectedDays.remove(indexPath.item)
        } else {
            selectedDays.insert(indexPath.item)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    
    
    @IBAction func didTapCencelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        guard let message = messageLabel.text, !message.isEmpty else {
            presentAlert(title: "Missing Info", message: "Please enter a message.")
            return
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: datePicker.date)
        
        let emoji = emojiLabel.text
        let notes = notesLabel.text
        
        let imageData = photoImageview.image?.jpegData(compressionQuality: 0.8)
        
        var audioData: Data?
        if let url = audioFilename {
            audioData = try? Data(contentsOf: url)
        }
        
        let frequencyArray = Array(selectedDays).sorted()
        
        let update = AutoUpdate(
            message: message,
            time: time,
            isOn: true,
            emoji: emoji,
            notes: notes,
            frequency: frequencyArray,
            imageData: imageData,
            audioData: audioData
        )
        
        saveAutoUpdateToFile(update)
        dismiss(animated: true)
    }
    
    
    @IBAction func audioButton(_ sender: UIButton) {
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
    
    
    @IBAction func imageButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var emojiLabel: UITextField!
    
    @IBOutlet weak var messageLabel: UITextField!
    
    
    @IBOutlet weak var notesLabel: UITextField!
    
    @IBOutlet weak var audioButton: UIButton!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var photoImageview: UIImageView!
    
    // audio properties
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioFilename: URL?
    var isRecording = false
    var hasRecorded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        
        NotificationCenter.default.post(name: UpdateManager.updatesChangedNotification, object: nil)

        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoImageview.image = image
        }
        dismiss(animated: true, completion: nil)
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
            audioButton.setTitle("▶️ Play Voice Note", for: .normal)
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
    
    
}

extension CreateAutoUpdateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
}

func getAutoUpdatesFileURL() -> URL? {
    let fileManager = FileManager.default
    guard let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    return docs.appendingPathComponent("autoUpdates.json")
}

func saveAutoUpdateToFile(_ update: AutoUpdate) {
    guard let fileURL = getAutoUpdatesFileURL() else { return }
    
    var existingUpdates: [AutoUpdate] = []
    
    // Try loading existing updates
    if let data = try? Data(contentsOf: fileURL),
       let decoded = try? JSONDecoder().decode([AutoUpdate].self, from: data) {
        existingUpdates = decoded
    }
    
    // Append new one
    existingUpdates.append(update)
    
    // Encode and save
    do {
        let data = try JSONEncoder().encode(existingUpdates)
        try data.write(to: fileURL)
        print("✅ Saved to autoUpdates.json")
    } catch {
        print("❌ Save failed: \(error.localizedDescription)")
    }
}


