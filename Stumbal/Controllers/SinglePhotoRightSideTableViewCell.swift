//
//  SinglePhotoRightSideTableViewCell.swift
//  Goal Grabber
//
//  Created by mac on 25/11/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class SinglePhotoRightSideTableViewCell: UITableViewCell {

    @IBOutlet var singleRightPhotoView: UIView!
    @IBOutlet var singleRightNameLbl: UILabel!
    @IBOutlet var singleRightPhotoImg: UIImageView!
    @IBOutlet var singlerightdtaeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
