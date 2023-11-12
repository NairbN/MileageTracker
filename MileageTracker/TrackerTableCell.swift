//
//  TrackerTableCell.swift
//  MileageTracker
//
//  Created by Brian Nguyen on 6/29/23.
//

import UIKit

class TrackerTableCell: UITableViewCell {

    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
