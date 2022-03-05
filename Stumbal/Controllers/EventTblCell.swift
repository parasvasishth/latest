//
//  EventTblCell.swift
//  Stumbal
//
//  Created by mac on 19/03/21.
//

import UIKit

class EventTblCell: UITableViewCell {

    @IBOutlet var eventImg: UIImageView!
    @IBOutlet var eventNamelbl: UILabel!
    @IBOutlet var eventAddressLbl: UILabel!
    @IBOutlet var eventTimelbl: UILabel!
    @IBOutlet var ticketObj: UIButton!
    @IBOutlet var artistObj: UIButton!
    @IBOutlet var vendorNameLbl: UILabel!
    @IBOutlet var categorylbl: UILabel!
    @IBOutlet var qrObj: UIButton!
    @IBOutlet var qrheight: NSLayoutConstraint!
    @IBOutlet var qrtopHeight: NSLayoutConstraint!
    @IBOutlet var qrstackObj: UIStackView!
    @IBOutlet var refundObj: UIButton!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var newImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
