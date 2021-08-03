//
//  SinglePhotoLeftSideTableViewCell.swift
//  Goal Grabber
//
//  Created by mac on 25/11/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class SinglePhotoLeftSideTableViewCell: UITableViewCell {

    @IBOutlet var singleLeftPhotoView: UIView!
    @IBOutlet var leftPhotonameLbl: UILabel!
    @IBOutlet var leftPhotoImg: UIImageView!
    @IBOutlet var leftPhotoTimeLbl: UILabel!
    @IBOutlet var palyImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
