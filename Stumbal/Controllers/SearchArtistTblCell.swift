//
//  SearchArtistTblCell.swift
//  Stumbal
//
//  Created by mac on 03/04/21.
//

import UIKit

class SearchArtistTblCell: UITableViewCell {

    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var artistNameLbl: UILabel!
    @IBOutlet var artistIdLbl: UILabel!
    @IBOutlet var addObj: UIButton!
    @IBOutlet var inviteObj: UIButton!
    @IBOutlet var contactLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
