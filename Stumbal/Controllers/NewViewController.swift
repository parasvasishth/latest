//
//  NewViewController.swift
//  Stumbal
//
//  Created by mac on 03/08/21.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        firstViewHeight.constant = 0
        secondViewHeight.constant = 0
        thirdViewHeight.constant = 0
        upcomingHeight.constant = 0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
