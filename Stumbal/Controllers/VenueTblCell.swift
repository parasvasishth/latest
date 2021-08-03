//
//  VenueTblCell.swift
//  Stumbal
//
//  Created by mac on 19/03/21.
//

import UIKit

class VenueTblCell: UITableViewCell {

    @IBOutlet var venueImg: UIImageView!
    @IBOutlet var venueNamelbl: UILabel!
    @IBOutlet var venueAddressLbl: UILabel!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var addObj: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
