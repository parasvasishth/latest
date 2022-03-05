//
//  UserCategoryTableViewCell.swift
//  Stumbal
//
//  Created by Dr.Mac on 24/12/21.
//

import UIKit

class UserCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var catNamelbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var deleteObj: UIButton!
    @IBOutlet weak var addArtistObj: UIButton!
    @IBOutlet weak var deleteArtistObj: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
