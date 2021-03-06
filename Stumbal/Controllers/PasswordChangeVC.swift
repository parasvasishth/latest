//
//  PasswordChangeVC.swift
//  24 Hours Services
//
//  Created by mac on 23/04/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftUI
class PasswordChangeVC: UIViewController {

@IBOutlet var newpasswordFiled: UITextField!
@IBOutlet var confirmPasswordFiled: UITextField!
@IBOutlet var restObj: UIButton!
@IBOutlet var newImg: UIImageView!
@IBOutlet var confirmimg: UIImageView!
@IBOutlet weak var checkobj: UIButton!
@IBOutlet weak var privacyLbl: UILabel!
@IBOutlet weak var loadingView: UIView!
var old:Bool = Bool()
var new:Bool = Bool()
var hud = MBProgressHUD()
override func viewDidLoad() {
    super.viewDidLoad()
    loadingView.isHidden = false
    restObj.layer.cornerRadius = 20;
    restObj.clipsToBounds = true
    //checkobj.setTitle("", for: .normal)
    newpasswordFiled.attributedPlaceholder =
    NSAttributedString(string: "New password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4823529412, green: 0.4823529412, blue: 0.4823529412, alpha: 1)])
    confirmPasswordFiled.attributedPlaceholder =
    NSAttributedString(string: "Confirm new password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4823529412, green: 0.4823529412, blue: 0.4823529412, alpha: 1)])
    
    
    // Do any additional setup after loading the view.
    newpasswordFiled.setLeftPaddingPoints(15)
    confirmPasswordFiled.setLeftPaddingPoints(15)
    
    
    self.privacyLbl.isUserInteractionEnabled = true
    let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
    tapgesture.numberOfTapsRequired = 1
    self.privacyLbl.addGestureRecognizer(tapgesture)
    privacyLbl.text = "I have reviewed and agreed  to Stumbal's Privacy Policy."
    let text = (privacyLbl.text)!
    let underlineAttriString = NSMutableAttributedString(string: text)
    let range1 = (text as NSString).range(of: "Privacy Policy")
    
    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
    attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: range1)
    privacyLbl.attributedText = attributeString
    
    loadingView.isHidden = true
    
}

@objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
    let text = (privacyLbl.text)!
    let termsRange = (text as NSString).range(of: "Privacy Policy")
    
    
    if gesture.didTapAttributedTextInLabel(label: privacyLbl, inRange: termsRange) {
        print("Tapped terms")
        
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    else {
        UserDefaults.standard.set(false, forKey: "Terms")
        UserDefaults.standard.set(false, forKey: "Privacy")
        print("Tapped none")
    }
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
                //                hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                //                hud.mode = MBProgressHUDMode.indeterminate
                //                hud.self.bezelView.color = UIColor.black
                //                hud.label.text = "Loading...."
                loadingView.isHidden = false
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
                                    self.loadingView.isHidden = true
                                    
                                    
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
                                    self.loadingView.isHidden = true
                                    
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
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
}

}
