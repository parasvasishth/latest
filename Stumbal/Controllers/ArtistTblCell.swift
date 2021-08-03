//
//  ArtistTblCell.swift
//  Stumbal
//
//  Created by mac on 18/03/21.
//

import UIKit

class ArtistTblCell: UITableViewCell {

    @IBOutlet var eventImg: UIImageView!
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var ratinglbl: UILabel!
    @IBOutlet var addfriendObj: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
