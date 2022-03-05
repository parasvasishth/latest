//
//  NewUpcomingEventTableViewCell.swift
//  Stumbal
//
//  Created by Dr.Mac on 27/01/22.
//

import UIKit

class NewUpcomingEventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var remainingLbl: UILabel!
    @IBOutlet weak var acceptObj: UIButton!
    @IBOutlet weak var declineObj: UIButton!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    
    @IBOutlet weak var eventnLbl: UnderlinedLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
