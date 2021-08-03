//
//  VideoRightSideTableViewCell.swift
//  Goal Grabber
//
//  Created by mac on 25/11/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class VideoRightSideTableViewCell: UITableViewCell {

    @IBOutlet var rightVideoView: UIView!
    @IBOutlet var videoRightNameLbl: UILabel!
    @IBOutlet var videorightTimeLbl: UILabel!
    @IBOutlet var rightImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override static var layerClass: AnyClass {
           return AVPlayerLayer.self;
       }

       var playerLayer: AVPlayerLayer {
           return layer as! AVPlayerLayer;
       }
       
       var player: AVPlayer? {
           get {
               return playerLayer.player;
           }
           set {
               playerLayer.player = newValue;
           }
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
