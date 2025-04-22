//
//  MyScheduleCell.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/17/25.
//

import UIKit

class MyScheduleCell: UITableViewCell {

    @IBAction func partnerCanSeeSwitch(_ sender: Any) {
    }
    @IBOutlet weak var partnerCanSeeSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateNumLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
