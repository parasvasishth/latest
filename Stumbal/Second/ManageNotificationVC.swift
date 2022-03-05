//
//  ManageNotificationVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 22/01/22.
//

import UIKit
import Alamofire
class ManageNotificationVC: UIViewController {

    @IBOutlet weak var pauseObj: UIButton!
    @IBOutlet weak var upcomingObj: UIButton!
    @IBOutlet weak var smsObj: UIButton!
    @IBOutlet weak var friendObj: UIButton!
    @IBOutlet weak var loadingView: UIView!
    var pauseall:String = ""
    var upcoming:String = ""
    var email:String = ""
    var friend:String = ""
    var upcomingStatus:String = ""
    var emailStatus:String = ""
    var friendStatus:String = ""
    var pauseStatus:String = ""
    var finalType:String = ""
    var finalStatus:String = ""
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = false
        UserDefaults.standard.set(false, forKey: "nFriend")
        UserDefaults.standard.set(false, forKey: "nEmail")
        UserDefaults.standard.set(false, forKey: "nUpcoming")
        //UserDefaults.standard.set(false, forKey: "nPause")
        fetch_notification_status()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func friend(_ sender: UIButton) {
        
        if friendStatus == "no"
        {
            friend = "Friend requests"
            friendStatus = "yes"
            UserDefaults.standard.set(true, forKey: "nFriend")
            UserDefaults.standard.set(false, forKey: "nEmail")
            UserDefaults.standard.set(false, forKey: "nUpcoming")
            //UserDefaults.standard.set(false, forKey: "nPause")
            friendObj.setImage(UIImage(named: "switchon"), for: .normal)
            
            update_notification_status()
        }
        else
        {
            friend = "Friend requests"
            friendStatus = "no"
            UserDefaults.standard.set(true, forKey: "nFriend")
            UserDefaults.standard.set(false, forKey: "nEmail")
            UserDefaults.standard.set(false, forKey: "nUpcoming")
           // UserDefaults.standard.set(false, forKey: "nPause")
            friendObj.setImage(UIImage(named: "switchoff"), for: .normal)
            update_notification_status()
        }
        
       
    }
    
    @IBAction func pause(_ sender: UIButton) {
        
        if pauseStatus == "no"
        {
            pauseall = "All"
            pauseStatus = "yes"
            UserDefaults.standard.set(false, forKey: "nFriend")
            UserDefaults.standard.set(false, forKey: "nEmail")
            UserDefaults.standard.set(false, forKey: "nUpcoming")
           // UserDefaults.standard.set(true, forKey: "nPause")
            pauseObj.setImage(UIImage(named: "switchon"), for: .normal)
            update_notification_status()
        }
        else
        {
            pauseall = "All"
            pauseStatus = "no"
            UserDefaults.standard.set(false, forKey: "nFriend")
            UserDefaults.standard.set(false, forKey: "nEmail")
            UserDefaults.standard.set(false, forKey: "nUpcoming")
            UserDefaults.standard.set(true, forKey: "nPause")
            pauseObj.setImage(UIImage(named: "switchoff"), for: .normal)
            update_notification_status()
        }
        
    }
    
    @IBAction func sms(_ sender: UIButton) {
        
        if emailStatus == "no"
        {
            email = "Email event remainder"
            emailStatus = "yes"
            UserDefaults.standard.set(false, forKey: "nFriend")
            UserDefaults.standard.set(true, forKey: "nEmail")
            UserDefaults.standard.set(false, forKey: "nUpcoming")
            //UserDefaults.standard.set(false, forKey: "nPause")
            smsObj.setImage(UIImage(named: "switchon"), for: .normal)
            update_notification_status()
        }
        else
        {
            
                email = "Email event remainder"
                emailStatus = "no"
                UserDefaults.standard.set(false, forKey: "nFriend")
                UserDefaults.standard.set(true, forKey: "nEmail")
                UserDefaults.standard.set(false, forKey: "nUpcoming")
               // UserDefaults.standard.set(false, forKey: "nPause")
                smsObj.setImage(UIImage(named: "switchoff"), for: .normal)
                update_notification_status()
        }
        
       
    }
  
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func upcoming(_ sender: UIButton) {
        
        if upcomingStatus == "no"
        {
            upcoming = "Upcoming events"
            upcomingStatus = "yes"
            UserDefaults.standard.set(false, forKey: "nFriend")
            UserDefaults.standard.set(false, forKey: "nEmail")
            UserDefaults.standard.set(true, forKey: "nUpcoming")
          //  UserDefaults.standard.set(false, forKey: "nPause")
            upcomingObj.setImage(UIImage(named: "switchon"), for: .normal)
            update_notification_status()
        }
        else
        {
            upcoming = "Upcoming events"
            upcomingStatus = "no"
            UserDefaults.standard.set(false, forKey: "nFriend")
            UserDefaults.standard.set(false, forKey: "nEmail")
            UserDefaults.standard.set(true, forKey: "nUpcoming")
          //  UserDefaults.standard.set(false, forKey: "nPause")
            upcomingObj.setImage(UIImage(named: "switchoff"), for: .normal)
            update_notification_status()
        }
        
      
    }
    
    // MARK: - contact_us
    func fetch_notification_status()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_notification_status", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
        { response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                
                print("Response: \(String(describing: json))")
                if json == ""
                {
                    self.loadingView.isHidden = true
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.fetch_notification_status()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                      
                            //  self.wishListCollectionView.reloadData()
                        self.loadingView.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.upcomingStatus = json["notification_upcoming_events"] as! String
                            self.emailStatus = json["notification_email_event_remainder"] as! String
                            self.friendStatus = json["notification_friend_request"] as! String
                            self.friend = "Friend requests"
                            self.email = "Email event remainder"
                            self.upcoming = "Upcoming events"
                            if json["notification_upcoming_events"] as! String == "no"
                            {
                                self.upcomingObj.setImage(UIImage(named: "switchoff"), for: .normal)
                                
                            }
                            else
                            {
                                self.upcomingObj.setImage(UIImage(named: "switchon"), for: .normal)
                            }
                            if json["notification_email_event_remainder"] as! String == "no"
                            {
                                self.smsObj.setImage(UIImage(named: "switchoff"), for: .normal)
                            }
                            else
                            {
                                self.smsObj.setImage(UIImage(named: "switchon"), for: .normal)
                            }
                            if json["notification_friend_request"] as! String == "no"
                            {
                                self.friendObj.setImage(UIImage(named: "switchoff"), for: .normal)
                            }
                            else
                            {
                                self.friendObj.setImage(UIImage(named: "switchon"), for: .normal)
                            }
                          
//                        if json["status"] as! String == "Disable"
//                        {
//                            self.pauseObj.setImage(UIImage(named: "switchoff"), for: .normal)
//                            self.pauseStatus = "no"
//                        }
//                        else
//                        {
//                            self.pauseStatus = "yes"
//                            self.pauseObj.setImage(UIImage(named: "switchon"), for: .normal)
//                        }
                    
                    }
                }
            }
        }
        
    }

    
    // MARK: - update_notification_status
    func update_notification_status()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
    
        if UserDefaults.standard.bool(forKey: "nFriend") == true
        {
            finalType = friend
            finalStatus = friendStatus
        }
        else if UserDefaults.standard.bool(forKey: "nEmail") == true
        {
            finalType = email
            finalStatus = emailStatus
        }
        else if UserDefaults.standard.bool(forKey: "nUpcoming") == true
        {
            finalType = upcoming
            finalStatus = upcomingStatus
        }
        print("111",finalStatus,finalType)
        
        Alamofire.request("https://stumbal.com/process.php?action=update_notification_status", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"status":finalStatus,"notification_type":finalType], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.update_notification_status()
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
                            
                            
                            self.fetch_notification_status()
                            
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
