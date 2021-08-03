//
//  ChatListTblCell.swift
//  Stumbal
//
//  Created by mac on 19/03/21.
//

import UIKit

class ChatListTblCell: UITableViewCell {

    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var messagelbl: UILabel!
    @IBOutlet var timelbl: UILabel!
    @IBOutlet var notiLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
