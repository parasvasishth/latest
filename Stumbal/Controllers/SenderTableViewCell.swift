//
//  SenderTableViewCell.swift
//  DogoApp
//
//  Created by mac on 02/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var sMessageLbl: UILabel!
    @IBOutlet weak var sTimeLbl: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var snameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
  
    
}
