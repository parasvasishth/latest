//
//  SignUpVC.swift
//  Stumbal
//
//  Created by mac on 17/03/21.
//

import UIKit
import Alamofire
class SignUpVC: UIViewController {
    
    @IBOutlet var firstNameFiled: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emaiLField: UITextField!
    @IBOutlet var passwordFiled: UITextField!
    @IBOutlet var confirmpassowrdFiled: UITextField!
    @IBOutlet var loginlbl: UnderlinedLabel!
    @IBOutlet var hideView: UIView!
    var gender:String = ""
    var selectGender:Bool = Bool()
    var hud = MBProgressHUD()
    var old:Bool = Bool()
    var new:Bool = Bool()
    var deviceId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        hideView.isHidden = false
        loginlbl.text = "Log in now"
        firstNameFiled.attributedPlaceholder =
        NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        lastNameField.attributedPlaceholder =
        NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        emaiLField.attributedPlaceholder =
        NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordFiled.attributedPlaceholder =
        NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        confirmpassowrdFiled.attributedPlaceholder =
        NSAttributedString(string: "Re-enter Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        firstNameFiled.setLeftPaddingPoints(5)
        lastNameField.setLeftPaddingPoints(5)
        emaiLField.setLeftPaddingPoints(5)
        passwordFiled.setLeftPaddingPoints(5)
        confirmpassowrdFiled.setLeftPaddingPoints(5)
        hideView.isHidden = true
        
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        loginlbl.isUserInteractionEnabled = true
        loginlbl.addGestureRecognizer(tapGestureRecognizer2)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if old == true
        {
            old = false
            passwordFiled.isSecureTextEntry = false
        }
        else
        {
            old = true
            passwordFiled.isSecureTextEntry = true
        }
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
        if new == true
        {
            new = false
            confirmpassowrdFiled.isSecureTextEntry = false
        }
        else
        {
            new = true
            confirmpassowrdFiled.isSecureTextEntry = true
        }
    }
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    // MARK: - Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // MARK: - Password Validation
    func isValidPassword(password: String) -> Bool
    {
        let passwordRegEx = "^[A-Z0-9a-z].{5,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: password)
        return result
    }
    
    // MARK: - Action
    @IBAction func male(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func female(_ sender: UIButton) {
        
    }
    
    @IBAction func signup(_ sender: UIButton) {
        
        if firstNameFiled.text != "" && lastNameField.text != "" && emaiLField.text != "" && passwordFiled.text != ""  && confirmpassowrdFiled.text != ""
        {
            //        if selectGender == true
            //        {
            
            if isValidEmail(emaiLField.text!)
            {
                if isValidPassword(password: passwordFiled.text!)
                {
                    
                    if passwordFiled.text! == confirmpassowrdFiled.text!
                    {
                        self.registration()
                    }
                    
                    else
                    {
                        let alert = UIAlertController(title: "", message: "Password and Confirm Password must be match ", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "", message: "Password length at least 6 character", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                let alert = UIAlertController(title: "", message: "Invalid Email Id", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        else
        {
            let alert = UIAlertController(title: "", message: "All Field Required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        self.firstNameFiled.text = ""
        self.lastNameField.text = ""
        self.emaiLField.text = ""
        self.passwordFiled.text = ""
        self.gender = ""
        self.selectGender = false
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
        
    }
    // MARK: - updateDeviceId
    func updateDeviceId()
    {
        
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        if UserDefaults.standard.value(forKey: "devicetoken") == nil
        {
            deviceId = ""
        }
        else
        {
            deviceId = UserDefaults.standard.value(forKey: "devicetoken") as! String
        }
        print("111",deviceId)
        
        Alamofire.request("https://stumbal.com/process.php?action=update_ios_deviceid", method: .post, parameters: ["user_id" : uID, "device_id" : deviceId], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.updateDeviceId()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                        
                    {
                        print("JSON: \(json)")
                        print("66666666666")
                        
                        if  json["result"] as! String == "success"
                        {
                            MBProgressHUD.hide(for: self.view, animated: true);
                            self.firstNameFiled.text = ""
                            self.lastNameField.text = ""
                            self.emaiLField.text = ""
                            self.passwordFiled.text = ""
                            self.gender = ""
                            self.selectGender = false
                            self.hideView.isHidden = true
                            let alert = UIAlertController(title: "", message: "Signup Successful", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            // change to desired number of seconds (in this case 5 seconds)
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                alert.dismiss(animated: false, completion: nil)
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                                nextViewController.modalPresentationStyle = .fullScreen
                                self.present(nextViewController, animated:false, completion:nil)
                            }
                            
                            
                        }
                        
                    }
                }
                
            }
        }
        
    }
    // MARK: - registration
    func registration()
    {
        
        //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //    hud.mode = MBProgressHUDMode.indeterminate
        //    hud.self.bezelView.color = UIColor.black
        //    hud.label.text = "Loading...."
        
        hideView.isHidden = false
        
        
        Alamofire.request("https://stumbal.com/process.php?action=user_registration", method: .post, parameters:["log_type":"Signup","fb_id":"","google_id":"","fname": firstNameFiled.text!,"lname":lastNameField.text!,"gender":gender,"email":emaiLField.text!,"password":passwordFiled.text!,"dob":"","meta_tags":"","contact":""],encoding:  URLEncoding.httpBody).responseJSON{ response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.registration()
                    }))
                    self.present(alert, animated: false, completion: nil)
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                        
                    {
                        print("JSON: \(json)")
                        let result : String = json["result"]! as! String
                        if  result == "success"
                        {
                            
                            
                            // MBProgressHUD.hide(for: self.view, animated: true)
                            UserDefaults.standard.set(true, forKey: "login")
                            let id :String = json["insert_id"] as! String
                            UserDefaults.standard.setValue(id, forKey: "u_Id")
                            
                            self.updateDeviceId()
                            
                        }
                        else {
                            self.hideView.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: false)
                            let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: false, completion: nil)
                            
                        }
                    }
                    
                }
            }
        }
    }
    
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextField {
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
    
}
