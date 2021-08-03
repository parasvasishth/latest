//
//  PowerVC.swift
//  Stumbal
//
//  Created by mac on 25/03/21.
//

import UIKit

class PowerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "TabCategoryVC") as! TabCategoryVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }

}
