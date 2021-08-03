//
//  RightViewCell.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit

class RightViewCell: UITableViewCell {

    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainerView.rounded(radius: 8)
        messageContainerView.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
//    func configureCell(message: Message) {
//        textMessageLabel.text = message.text
//    }
}
