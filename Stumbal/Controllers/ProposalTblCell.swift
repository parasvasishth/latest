//
//  ProposalTblCell.swift
//  Stumbal
//
//  Created by mac on 23/03/21.
//

import UIKit

class ProposalTblCell: UITableViewCell {

    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var timelbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var deleteobj: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
