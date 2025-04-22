//
//  ScheduleCellTableViewCell.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/15/25.
//

import UIKit

class ScheduleCellTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var onSwitch: UISwitch!
    var onSwitchToggled: ((Bool) -> Void)?
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        onSwitchToggled?(sender.isOn)
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
