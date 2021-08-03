//
//  TermsVC.swift
//  Stumbal
//
//  Created by mac on 13/04/21.
//

import UIKit
import WebKit
class TermsVC: UIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var statusLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "Terms") == true
        {
            statusLbl.text = "Terms And Condition"
        }
        else
        {
            statusLbl.text = "Privacy Policy"
        }
        
        let url = NSURL (string: "https://cyberimpulses.com/Android/Next_door/about.php");

               let requestObj = NSURLRequest(url: url! as URL);
        webView.load(requestObj as URLRequest);
                   self.view.addSubview(webView)
    
        webView.scrollView.bounces = false
        // Do any additional setup after loading the view.
    }
    

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }


}
