//
//  MenuTblCell.swift
//  Stumbal
//
//  Created by mac on 18/03/21.
//

import UIKit

class MenuTblCell: UITableViewCell {

    @IBOutlet var menuImg: UIImageView!
    @IBOutlet var menuNamelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
