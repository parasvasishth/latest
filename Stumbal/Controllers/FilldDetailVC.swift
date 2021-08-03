//
//  FilldDetailVC.swift
//  Stumbal
//
//  Created by mac on 01/05/21.
//

import UIKit

class FilldDetailVC: UIViewController {

@IBOutlet var firstnameFiled: UITextField!
@IBOutlet var lastnameFiled: UITextField!
@IBOutlet var emailFiled: UITextField!
@IBOutlet var mobileFiled: UITextField!
@IBOutlet var passwordFiled: UITextField!
@IBOutlet var dateFiled: UITextField!
@IBOutlet var maleObj: UIButton!
@IBOutlet var femaleObj: UIButton!
var selectGender:Bool = Bool()
var gender:String = ""
var hud = MBProgressHUD()
override func viewDidLoad() {
    super.viewDidLoad()
    
    firstnameFiled.attributedPlaceholder =
        NSAttributedString(string: "Firstname", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    lastnameFiled.attributedPlaceholder =
        NSAttributedString(string: "Lastname", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    emailFiled.attributedPlaceholder =
        NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    passwordFiled.attributedPlaceholder =
        NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    dateFiled.attributedPlaceholder =
        NSAttributedString(string: "Date of birth", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    mobileFiled.attributedPlaceholder =
        NSAttributedString(string: "Contact", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
    
    firstnameFiled.setLeftPaddingPoints(10)
    lastnameFiled.setLeftPaddingPoints(10)
    emailFiled.setLeftPaddingPoints(10)
    passwordFiled.setLeftPaddingPoints(10)
    dateFiled.setLeftPaddingPoints(10)
    mobileFiled.setLeftPaddingPoints(10)
    
    emailFiled.text = UserDefaults.standard.value(forKey: "Regis_Email") as! String
    
    dateFiled.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
    // Do any additional setup after loading the view.
}

@IBAction func male(_ sender: UIButton) {
    self.maleObj.setImage(UIImage(named: "bfill"), for: .normal)
    self.femaleObj.setImage(UIImage(named: "bempty"), for: .normal)
    selectGender = true
    gender = "Male"
}

@IBAction func female(_ sender: UIButton) {
    self.femaleObj.setImage(UIImage(named: "bfill"), for: .normal)
    self.maleObj.setImage(UIImage(named: "bempty"), for: .normal)
    selectGender = true
    gender = "FeMale"
}

@IBAction func ContinueBtn(_ sender: UIButton) {
    if firstnameFiled.text != "" && lastnameFiled.text != "" && emailFiled.text != "" && passwordFiled.text != "" && dateFiled.text != "" && mobileFiled.text != ""
    {
        if selectGender == true
        {
            
            
            if isValidPassword(password: passwordFiled.text!)
            {
                
                UserDefaults.standard.setValue(self.firstnameFiled.text!, forKey: "S_fname")
                UserDefaults.standard.setValue(self.lastnameFiled.text!, forKey: "S_lname")
                UserDefaults.standard.setValue(self.emailFiled.text!, forKey: "S_email")
                UserDefaults.standard.setValue(self.passwordFiled.text!, forKey: "S_password")
                UserDefaults.standard.setValue(self.dateFiled.text!, forKey: "S_dob")
                UserDefaults.standard.setValue(self.mobileFiled.text!, forKey: "S_mobile")
                UserDefaults.standard.setValue(self.gender, forKey: "S_gender")
                
                
                var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                signuCon.modalPresentationStyle = .fullScreen
                self.present(signuCon, animated: false, completion:nil)
                
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
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "", message: "Please Select Gender", preferredStyle: UIAlertController.Style.alert)
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
@objc func doneButtonPressed() {
    if let  datePicker = self.dateFiled.inputView as? UIDatePicker {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dateFiled.text = dateFormatter.string(from: datePicker.date)
    }
    self.dateFiled.resignFirstResponder()
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

}
