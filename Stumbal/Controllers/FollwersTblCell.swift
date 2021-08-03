//
//  FollwersTblCell.swift
//  Stumbal
//
//  Created by mac on 23/03/21.
//

import UIKit

class FollwersTblCell: UITableViewCell {

    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var codeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
