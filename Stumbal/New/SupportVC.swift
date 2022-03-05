//
//  SupportVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 07/01/22.
//

import UIKit
import Alamofire
class SupportVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var requestLbl: UILabel!
    @IBOutlet weak var messageLbnl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var messageTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false

        if UserDefaults.standard.bool(forKey: "Abuse")
        {
            requestLbl.text = "Spam or Abuse"
            //let c:String =
        //    messageLbnl.text = "\"Briefly explain what happened.  Let us know what we can do better.\""
            messageLbnl.text = "Briefly explain what happened.  Let us know what we can do better."
            messageTxtView.text = "Enter issue here"
            messageTxtView.textColor = UIColor.lightGray
            messageTxtView.delegate = self
        }
        else if UserDefaults.standard.bool(forKey: "Isn't")
        {
            requestLbl.text = "Something Isn't Working"
            messageLbnl.text = "Briefly explain what happened. How do you reproduce the issue?"
            messageTxtView.text = "Enter issue here"
            messageTxtView.textColor = UIColor.lightGray
            messageTxtView.delegate = self
        }
        else
        {
            requestLbl.text = "General Feedback"
            messageLbnl.text = "Briefly explain what you love, or don't love. Let us know what we can do better."
            messageTxtView.text = "Enter feedback here"
            messageTxtView.textColor = UIColor.lightGray
            messageTxtView.delegate = self
        }
        self.loadingView.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "Abuse")
        UserDefaults.standard.set(false, forKey: "Isn't")
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        if messageTxtView.text != ""
        {
            report_problem()
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter feedback", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- UITextViewDelegates method
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTxtView.text == "Enter feedback here" {
            messageTxtView.text = ""
            messageTxtView.textColor = UIColor.white
        }
        else if messageTxtView.text == "Enter issue here"
        {
            messageTxtView.text = ""
            messageTxtView.textColor = UIColor.white
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            messageTxtView.resignFirstResponder()
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTxtView.text == "" {
            if UserDefaults.standard.bool(forKey: "Isn't") == true
            {
                messageTxtView.text = "Enter issue here"
                messageTxtView.textColor = UIColor.lightGray
            }
            else if UserDefaults.standard.bool(forKey: "Abuse") == true
            {
                messageTxtView.text = "Enter feedback here"
                messageTxtView.textColor = UIColor.lightGray
            }
            else
            {
                messageTxtView.text = "Enter feedback here"
                messageTxtView.textColor = UIColor.lightGray
            }
            
        }
    }

    // MARK: - report_problem

    func report_problem()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        self.loadingView.isHidden = false

        Alamofire.request("https://stumbal.com/process.php?action=report_problem", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"subject":requestLbl.text!,"msg":messageTxtView.text!], encoding:  URLEncoding.httpBody).responseJSON
        { response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                
                print("Response: \(String(describing: json))")
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true

                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.report_problem()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        let result:String = json["result"] as! String
                        
                        if result == "success"
                        {
                            //  self.wishListCollectionView.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.loadingView.isHidden = true

                            
                            let alert = UIAlertController(title: "", message: "Feedback send successfully", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                
                                UserDefaults.standard.set(false, forKey: "Abuse")
                                UserDefaults.standard.set(false, forKey: "Isn't")
                                alert.dismiss(animated: false, completion: nil)
                             
                                self.dismiss(animated: false, completion: nil)
                                
                            }
                            
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        
                    }
                }
            }
        }
        
    }
}
