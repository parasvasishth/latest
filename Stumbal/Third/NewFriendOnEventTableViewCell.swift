//
//  NewFriendOnEventTableViewCell.swift
//  Stumbal
//
//  Created by Dr.Mac on 29/01/22.
//

import UIKit

class NewFriendOnEventTableViewCell: UITableViewCell {

    @IBOutlet weak var friendObj: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userprofileObj: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
