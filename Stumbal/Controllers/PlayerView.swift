//
//  PlayerView.swift
//  Goal Grabber
//
//  Created by mac on 29/09/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import AVKit;
import AVFoundation;
class PlayerView: UIView {

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
    }

   
