//
//  VideoLeftSideTableViewCell.swift
//  Goal Grabber
//
//  Created by mac on 25/11/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
class VideoLeftSideTableViewCell: UITableViewCell {

    @IBOutlet var leftVideoView: UIView!
    @IBOutlet var leftVideoNameLbl: UILabel!
   
    @IBOutlet var leftImg: UIImageView!
    @IBOutlet var leftSideVideoView: PlayerView!
  
    
    @IBOutlet var leftVideoTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
