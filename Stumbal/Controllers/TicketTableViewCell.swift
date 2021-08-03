//
//  TicketTableViewCell.swift
//  Stumbal
//
//  Created by mac on 01/05/21.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    @IBOutlet var ticketIdLbl: UILabel!
    @IBOutlet var deleteObj: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
