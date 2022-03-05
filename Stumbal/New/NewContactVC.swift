//
//  NewContactVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 07/01/22.
//

import UIKit
import Alamofire
class NewContactVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false

        nameField.attributedPlaceholder =
            NSAttributedString(string: "Your name", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)])
        
        emailField.attributedPlaceholder =
            NSAttributedString(string: "Your email", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)])
        nameField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        emailField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        
        messageTxtView.text = "Your Message"
        messageTxtView.textColor = #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
        messageTxtView.delegate = self
       
        nameField.setLeftPaddingPoints(10)
        emailField.setLeftPaddingPoints(10)
        self.loadingView.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func callBtn(_ sender: UIButton) {
        // MARK: - cart Method
        
              
            let phoneNum : String =  "+61424472697"
                  if let url = URL(string: "tel://\(phoneNum)") {
                      if #available(iOS 10, *) {
                          UIApplication.shared.open(url, options: [:], completionHandler: nil)
                      } else {
                          UIApplication.shared.openURL(url as URL)
                      }
                  }
          
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        hideView.isHidden = true
        callView.isHidden = true
    }
    
    @IBAction func call(_ sender: UIButton) {
        hideView.isHidden = false
        callView.isHidden = false
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        if nameField.text != ""
        {
            if emailField.text != ""
            {
                if messageTxtView.text != ""
                {
                    contact_us()
                }
                else
                {
                    let alert = UIAlertController(title: "", message: "Enter feedback", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                let alert = UIAlertController(title: "", message: "Enter email", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
   
    //MARK:- UITextViewDelegates method
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTxtView.text == "Your Message" {
            messageTxtView.text = ""
            messageTxtView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
           
                messageTxtView.text = "Your Message"
                messageTxtView.textColor = #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
          
        }
    }

    // MARK: - contact_us

    func contact_us()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        self.loadingView.isHidden = false

        Alamofire.request("https://stumbal.com/process.php?action=contact_us", method: .post, parameters: ["msg" : messageTxtView.text!,"name":nameField.text!,"email":emailField.text!], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.contact_us()
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
