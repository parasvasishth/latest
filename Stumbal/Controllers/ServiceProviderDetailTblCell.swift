//
//  ServiceProviderDetailTblCell.swift
//  Stumbal
//
//  Created by mac on 24/03/21.
//

import UIKit

class ServiceProviderDetailTblCell: UITableViewCell {

    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
