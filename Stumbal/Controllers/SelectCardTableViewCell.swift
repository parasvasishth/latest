//
//  SelectCardTableViewCell.swift
//  Next Door
//
//  Created by mac on 11/07/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class SelectCardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var selectcardObj: UIButton!
    @IBOutlet weak var deleteObj: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
