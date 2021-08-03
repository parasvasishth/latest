//
//  ShowSelectImageVC.swift
//  Goal Grabber
//
//  Created by mac on 03/12/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ShowSelectImageVC: UIViewController {
    @IBOutlet var selectImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.selectImg.sd_setImage(with: URL(string:UserDefaults.standard.value(forKey: "SelectImg") as! String
        ), placeholderImage: UIImage(named: "logo"))
        
        selectImg.isUserInteractionEnabled = true
        let pinchMethod = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender:)))
        selectImg.addGestureRecognizer(pinchMethod)
        
    }
    
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {
        // guard  case let sender.view != nil else { return }
        
        if let scale = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) {
            guard scale.a > 1.0 else { return }
            guard scale.d > 1.0 else { return }
            sender.view?.transform = scale
            sender.scale = 1.0
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
