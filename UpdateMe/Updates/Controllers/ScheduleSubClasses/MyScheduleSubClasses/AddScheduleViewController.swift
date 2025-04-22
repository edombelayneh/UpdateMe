//
//  AddScheduleViewController.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/18/25.
//

import UIKit

class AddScheduleViewController: UIViewController {
    
    @IBOutlet weak var didTapCancelButton: UIBarButtonItem!
    
    
    @IBOutlet weak var setStatusButton: UIButton!
    @IBAction func makeVisibleToPartner(_ sender: Any) {
        
    }
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBAction func setStatusButton(_ sender: Any) {
    }
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        guard let customSchedule = titleTextField.text, !customSchedule.isEmpty else {
            presentAlert(title: "Oops...", message: "Make sure to add a Title for your schedule!")
            return
        }
        
        guard let description = descriptionTextField.text, !description.isEmpty else {
            presentAlert(title: "Oops...", message: "Make sure to add a description for your schedule!")
            return
        }
        
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        guard let selectedStatus = setStatusButton.title(for: .normal), selectedStatus != "Choose Status" else {
            presentAlert(title: "Oops...", message: "Please select a status.")
            return
        }
        
        // Optional: check if "visible to partner" toggle was selected
        let partnerVisible = true // or false depending on your implementation — see below
        
        let createSchedule = Schedule(
            title: customSchedule,
            description: description,
            startDateTime: startDate,
            endDateTime: endDate,
            status: selectedStatus,
            partnerCanSee: partnerVisible
        )
        
        print("Created Schedule: \(createSchedule)")
        schedules.append(createSchedule)
        saveSchedules(schedules)
        dismiss(animated: true)
        
        
    }
    
    var schedules: [Schedule] = []
    var schedule: Schedule?
    var partnerCanSee = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        schedules = loadSchedules()
        
        // Do any additional setup after loading the view.
        let statusOptions = ["Busy", "Idle", "Free"]
        
        var actions = [UIAction]()
        for option in statusOptions {
            let action = UIAction(title: option, handler: { [weak self] action in
                self?.setStatusButton.setTitle(option, for: .normal)
            })
            actions.append(action)
        }
        
        setStatusButton.menu = UIMenu(title: "Choose Status", children: actions)
        setStatusButton.showsMenuAsPrimaryAction = true
        
        print("Start date:", startDatePicker.date)
        print("End date:", endDatePicker.date)
        print("Status:", actions)

        
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
    
    func getScheduleFileURL() -> URL {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("schedule.json")
    }

    func loadSchedules() -> [Schedule] {
        let fileURL = getScheduleFileURL()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let data = try? Data(contentsOf: fileURL),
              let schedules = try? decoder.decode([Schedule].self, from: data) else {
            print("⚠️ Returning empty array")
            return []
        }

        return schedules
    }
    
    func saveSchedules(_ schedules: [Schedule]) {
        let fileURL = getScheduleFileURL()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601

        do {
            let data = try encoder.encode(schedules)
            try data.write(to: fileURL)
            print("✅ Saved schedules to JSON")
        } catch {
            print("❌ Error saving schedules: \(error)")
        }
    }

    
    
}
