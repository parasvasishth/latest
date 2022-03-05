//
//  ChangePasswordVC.swift
//  Stumbal
//
//  Created by mac on 13/04/21.
//

import UIKit
import Alamofire
class ChangePasswordVC: UIViewController {

@IBOutlet var oldFiled: UITextField!
@IBOutlet var newFiled: UITextField!
var hud = MBProgressHUD()
override func viewDidLoad() {
    super.viewDidLoad()
    
    oldFiled.attributedPlaceholder =
        NSAttributedString(string: "Old Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    newFiled.attributedPlaceholder =
        NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    // Do any additional setup after loading the view.
}


@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
    
}

@IBAction func changePassword(_ sender: UIButton) {
    if oldFiled.text != "" && newFiled.text != ""
    {
        change_password()
    }
    else
    {
        let alert = UIAlertController(title: "", message: "All Field Required", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
}

// MARK: - change_password

func change_password()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    Alamofire.request("https://stumbal.com/process.php?action=change_password", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"old_password":oldFiled.text!,"new_password":newFiled.text!], encoding:  URLEncoding.httpBody).responseJSON
    { response in
        if let data = response.data
        {
            let json = String(data: data, encoding: String.Encoding.utf8)
            
            print("Response: \(String(describing: json))")
            if json == ""
            {
                MBProgressHUD.hide(for: self.view, animated: true);
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
                        
                        
                        let alert = UIAlertController(title: "", message: "Password Changed Successfully", preferredStyle: .alert)
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
