//
//  SendOtpVC.swift
//  24 Hours Services
//
//  Created by mac on 23/04/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import Alamofire
class SendOtpVC: UIViewController {
    @IBOutlet var emaillbl: UILabel!
    @IBOutlet var otpFiled: UITextField!
    @IBOutlet var resendobj: UIButton!
    @IBOutlet var verifyObj: UIButton!
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        resendobj.layer.cornerRadius = 8;
        resendobj.clipsToBounds = true
        verifyObj.layer.cornerRadius = 8;
        verifyObj.clipsToBounds = true
        emaillbl.text = UserDefaults.standard.value(forKey: "Email") as! String
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resend(_ sender: UIButton) {
        
        send_Otp()
    }
    
    @IBAction func verify(_ sender: UIButton) {
        var otp = UserDefaults.standard.value(forKey: "OTP") as! String
        if otpFiled.text == otp
        {
            var passwordCon=self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
            passwordCon.modalPresentationStyle = .fullScreen
            self.present(passwordCon, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Please Enter Valid Otp", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    func send_Otp()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=user_send_email_otp", method: .post, parameters: ["email":UserDefaults.standard.value(forKey: "Email") as! String],encoding:  URLEncoding.httpBody).responseJSON{ response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                print("22222222222222")
                //print(response.result.value as Any)
                
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                        self.send_Otp()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        print("JSON: \(json)")
                        print("66666666666")
                        
                        if  json["result"] as! String == "success"
                        {
                            
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let otp :String = (json["otp"] as! NSNumber).stringValue
                            
                            UserDefaults.standard.setValue(otp, forKey: "OTP")
                            let alert = UIAlertController(title: "", message: "OTP Sent Successfully", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            // change to desired number of seconds (in this case 5 seconds)
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                
                                alert.dismiss(animated: true, completion: nil)
                                
                                //  self.dismiss(animated: true, completion: nil)
                                
                            }
                            
                        
                        }
                        
                        else {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "", message: "Invalid Email Id", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                    
                }
                
            }
        }
        
        
    }
 
    
}
