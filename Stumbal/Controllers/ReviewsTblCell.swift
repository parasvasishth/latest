//
//  ReviewsTblCell.swift
//  Stumbal
//
//  Created by mac on 19/03/21.
//

import UIKit

class ReviewsTblCell: UITableViewCell {

    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var ratingObj: FloatRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
