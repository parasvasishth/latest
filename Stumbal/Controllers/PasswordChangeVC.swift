//
//  PasswordChangeVC.swift
//  24 Hours Services
//
//  Created by mac on 23/04/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import Alamofire
class PasswordChangeVC: UIViewController {

@IBOutlet var newpasswordFiled: UITextField!
@IBOutlet var confirmPasswordFiled: UITextField!
@IBOutlet var restObj: UIButton!
@IBOutlet var newImg: UIImageView!
@IBOutlet var confirmimg: UIImageView!
var old:Bool = Bool()
var new:Bool = Bool()
var hud = MBProgressHUD()
override func viewDidLoad() {
    super.viewDidLoad()
    restObj.layer.cornerRadius = 25;
    restObj.clipsToBounds = true
    
    newpasswordFiled.attributedPlaceholder =
        NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    confirmPasswordFiled.attributedPlaceholder =
        NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    newImg.isUserInteractionEnabled = true
    newImg.addGestureRecognizer(tapGestureRecognizer)
    
    let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
    confirmimg.isUserInteractionEnabled = true
    confirmimg.addGestureRecognizer(tapGestureRecognizer1)
    old = true
    new = true
    // Do any additional setup after loading the view.
}

@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
    if old == true
    {
        old = false
        newpasswordFiled.isSecureTextEntry = false
        newImg.image = UIImage(named: "eye")
    }
    else
    {
        old = true
        newpasswordFiled.isSecureTextEntry = true
        newImg.image = UIImage(named: "ceye")
    }
}

@objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
    
    if new == true
    {
        new = false
        confirmPasswordFiled.isSecureTextEntry = false
        confirmimg.image = UIImage(named: "eye")
    }
    else
    {
        new = true
        confirmPasswordFiled.isSecureTextEntry = true
        confirmimg.image = UIImage(named: "ceye")
    }
    
}

func isValidPassword(password: String) -> Bool
{
    let passwordRegEx = "^[A-Z0-9a-z].{5,}$"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    let result = passwordTest.evaluate(with: password)
    return result
}

func password_Change()
{
    if (newpasswordFiled.text != "" && confirmPasswordFiled.text != "")
    {
        
        if isValidPassword(password: self.newpasswordFiled.text!)
        {
            
            if newpasswordFiled.text == confirmPasswordFiled.text
            {
                hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.indeterminate
                hud.self.bezelView.color = UIColor.black
                hud.label.text = "Loading...."
                Alamofire.request("https://stumbal.com/process.php?action=forget_password", method: .post, parameters: ["email" : UserDefaults.standard.value(forKey: "Email") as! String,"new_password" : newpasswordFiled.text!], encoding:  URLEncoding.httpBody).responseJSON
                { response in
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
                                self.password_Change()
                            }))
                            self.present(alert, animated: false, completion: nil)
                            
                        }
                        
                        else{
                            if let json: NSDictionary = response.result.value as? NSDictionary
                            {
                                print("JSON: \(json)")
                                
                                let result:String =  json["result"] as! String
                                if  result == "success"
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    
                                    
                                    let alert = UIAlertController(title: "", message: "Password Changed Successfully", preferredStyle: .alert)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    // change to desired number of seconds (in this case 5 seconds)
                                    let when = DispatchTime.now() + 2
                                    
                                    DispatchQueue.main.asyncAfter(deadline: when){
                                        // your code with delay
                                        
                                        alert.dismiss(animated: false, completion: nil)
                                        
                                        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                        signuCon.modalPresentationStyle = .fullScreen
                                        self.present(signuCon, animated: false, completion:nil)
                                        
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
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "", message: "password not match with confirm password", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        else{
            let alert = UIAlertController(title: "", message: "password length should be atleast 6 character", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    else{
        // print(cpvInternal.selectedCountry.phoneCode)
        let alert = UIAlertController(title: "", message: "All fileds are required", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}

@IBAction func reset(_ sender: UIButton) {
    password_Change()
    
}

@IBAction func ok(_ sender: UIButton) {
    
    var loginCon=self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    loginCon.modalPresentationStyle = .fullScreen
    self.present(loginCon, animated: true, completion: nil)
}

}
