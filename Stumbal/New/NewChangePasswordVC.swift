//
//  NewChangePasswordVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 20/01/22.
//

import UIKit
import Alamofire
class NewChangePasswordVC: UIViewController {
    @IBOutlet weak var oldFeild: UITextField!
    @IBOutlet weak var newField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var checkObj: UIButton!
    @IBOutlet weak var privacyLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false

        oldFeild.attributedPlaceholder =
            NSAttributedString(string: "Old password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        newField.attributedPlaceholder =
            NSAttributedString(string: "New password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmField.attributedPlaceholder =
            NSAttributedString(string: "Confirm new password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        oldFeild.setLeftPaddingPoints(10)
        newField.setLeftPaddingPoints(10)
        confirmField.setLeftPaddingPoints(10)
        
        UserDefaults.standard.set(false, forKey: "pcheck")
        
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
        self.loadingView.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        let text = (privacyLbl.text)!
        let termsRange = (text as NSString).range(of: "Privacy Policy")
       
        
        if gesture.didTapAttributedTextInLabel(label: privacyLbl, inRange: termsRange) {
            print("Tapped terms")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else {
            UserDefaults.standard.set(false, forKey: "Terms")
            UserDefaults.standard.set(false, forKey: "Privacy")
            print("Tapped none")
        }
    }

    
    @IBAction func checkBtn(_ sender: UIButton) {
        if sender.tag == 1
        {
            sender.tag = 0
            checkObj.setImage(UIImage(named: "checkw"), for: .normal)
            UserDefaults.standard.set(true, forKey: "pcheck")
        }
        else
        {
            sender.tag = 1
            checkObj.setImage(UIImage(named: "uncheckw"), for: .normal)
            UserDefaults.standard.set(false, forKey: "pcheck")
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "pcheck")
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        if oldFeild.text != ""
        {
            if newField.text != ""
            {
                if confirmField.text != ""
                {
                    if newField.text! == confirmField.text!
                    {
                        if UserDefaults.standard.bool(forKey: "pcheck") == true
                        {
                            change_password()
                        }
                        else
                        {
                            let alert = UIAlertController(title: "", message: "Check privacy policy", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        let alert = UIAlertController(title: "", message: "New password not match with confirm password", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                   
                }
                else
                {
                    let alert = UIAlertController(title: "", message: "Enter confirm password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                let alert = UIAlertController(title: "", message: "Enter new password", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter old password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    // MARK: - change_password

    func change_password()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        self.loadingView.isHidden = false

        Alamofire.request("https://stumbal.com/process.php?action=change_password", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"old_password":oldFeild.text!,"new_password":newField.text!], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.change_password()
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

                            
                            let alert = UIAlertController(title: "", message: "Password Changed Successfully", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                
                                
                                alert.dismiss(animated: false, completion: nil)
                                UserDefaults.standard.set(false, forKey: "pcheck")
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
