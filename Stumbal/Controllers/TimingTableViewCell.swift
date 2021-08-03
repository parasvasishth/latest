//
//  TimingTableViewCell.swift
//  ACCESS
//
//  Created by mac on 16/02/21.
//  Copyright © 2021 mac. All rights reserved.
//

import UIKit

class TimingTableViewCell: UITableViewCell {

    @IBOutlet var dayLbl: UILabel!
    @IBOutlet var dayTimingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
