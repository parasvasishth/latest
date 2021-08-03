//
//  SendEmailVC.swift
//  Stumbal
//
//  Created by mac on 19/03/21.
//

import UIKit
import Alamofire
class SendEmailVC: UIViewController {
@IBOutlet var emailField: UITextField!
var hud = MBProgressHUD()
override func viewDidLoad() {
    super.viewDidLoad()
    
    emailField.attributedPlaceholder =
        NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    // Do any additional setup after loading the view.
}

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}
@IBAction func login(_ sender: UIButton) {
    send_Otp()
}

func send_Otp()
{
    if  emailField.text != ""
    { hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=user_send_email_otp", method: .post, parameters: ["email":emailField.text!],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        let result:String = json["result"] as! String
                        if result == "success"
                        {
                            
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let otp :String = (json["otp"] as! NSNumber).stringValue
                            
                            UserDefaults.standard.setValue(otp, forKey: "OTP")
                            UserDefaults.standard.setValue(self.emailField.text!, forKey: "Email")
                            
                            let alert = UIAlertController(title: "", message: "OTP Sent Successfully", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            // change to desired number of seconds (in this case 5 seconds)
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                
                                alert.dismiss(animated: true, completion: nil)
                                
                                //   self.dismiss(animated: true, completion: nil)
                                
                                var OtpCon=self.storyboard?.instantiateViewController(withIdentifier: "SendOtpVC") as! SendOtpVC
                                OtpCon.modalPresentationStyle = .fullScreen
                                self.present(OtpCon, animated: true, completion: nil)
                            }
                            
                            
                        }
                        
                        else {
                            
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
    
    else{
        let alert = UIAlertController(title: "", message: "Please Enter Email Id", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

}
