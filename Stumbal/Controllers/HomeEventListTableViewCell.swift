//
//  HomeEventListTableViewCell.swift
//  Stumbal
//
//  Created by Dr.Mac on 09/12/21.
//

import UIKit

class HomeEventListTableViewCell: UITableViewCell {

    @IBOutlet weak var eventListView: UIView!
    @IBOutlet weak var eventimg: UIImageView!
    @IBOutlet weak var eventNameLbl: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
