//
//  QRCodeVC.swift
//  Stumbal
//
//  Created by mac on 23/03/21.
//

import UIKit
import Kingfisher
class QRCodeVC: UIViewController {

    @IBOutlet var qrImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        self.qrImage.sd_setImage(with: URL(string:UserDefaults.standard.value(forKey: "h_qrcode") as! String), placeholderImage: UIImage(named: "qr"))
    
        let pimg:String = UserDefaults.standard.value(forKey: "h_qrcode") as! String
        
        if pimg == ""
        {
            self.qrImage.image = UIImage(named: "edefault")
        }
        else
        {
            let url = URL(string: pimg)
            let processor = DownsamplingImageProcessor(size: self.qrImage.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 0)
            self.qrImage.kf.indicatorType = .activity
            self.qrImage.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    self.qrImage.image = UIImage(named: "qr")
                }
            }
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
