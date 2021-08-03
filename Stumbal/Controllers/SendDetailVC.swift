//
//  SendDetailVC.swift
//  Stumbal
//
//  Created by mac on 16/06/21.
//

import UIKit
import Alamofire
class SendDetailVC: UIViewController {

    @IBOutlet var banknameField: UITextField!
    @IBOutlet var bsbField: UITextField!
    @IBOutlet var accountNumberField: UITextField!
    @IBOutlet var paypalFiedl: UITextField!
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
            fetch_artist_detail()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        if banknameField.text != "" && accountNumberField.text != "" && bsbField.text != "" && paypalFiedl.text != ""
        {
            add_artist_detail()
        }
        else
        {
            let alert = UIAlertController(title: "", message: "All Field Required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
        
    }
    // MARK: - insert_user_distance
    func add_artist_detail()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=add_artist_detail", method: .post, parameters: ["artist_id" : UserDefaults.standard.value(forKey: "ap_artId") as! String,"account_no":accountNumberField.text!, "bsb":bsbField.text!,"account_name":banknameField.text!,"paypal_id":paypalFiedl.text!], encoding:  URLEncoding.httpBody).responseJSON
        { [self] response in
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
                        self.add_artist_detail()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        if json["result"] as! String == "success"
                        {
                            
                            self.dismiss(animated: false, completion: nil)
                            MBProgressHUD.hide(for: self.view, animated: true)

                         
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                       //
                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
        
    }
    
    // MARK: - fetch_artist_detail
    func fetch_artist_detail()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_detail", method: .post, parameters: ["artist_id" : UserDefaults.standard.value(forKey: "ap_artId") as! String], encoding:  URLEncoding.httpBody).responseJSON
        { [self] response in
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
                        self.add_artist_detail()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                       
                            
                            self.accountNumberField.text = json["account_no"] as! String
                            self.bsbField.text = json["bsb"] as! String
                            self.banknameField.text = json["account_name"] as! String
                            self.paypalFiedl.text = json["paypal_id"] as! String
                            
                         
                            MBProgressHUD.hide(for: self.view, animated: true)

                         
                       
                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
        
    }
    
    
    
}
