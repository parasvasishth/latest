//
//  InviteTblCell.swift
//  Stumbal
//
//  Created by mac on 23/03/21.
//

import UIKit

class InviteTblCell: UITableViewCell {
    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var codeLbl: UILabel!
    @IBOutlet var inviteobj: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
