//
//  ActivityTableViewCell.swift
//  UpdateMe
//
//  Created by Edom Belayneh on 4/15/25.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
