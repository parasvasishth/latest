//
//  RequestAcceptVC.swift
//  Stumbal
//
//  Created by mac on 16/06/21.
//

import UIKit
import Kingfisher
import Alamofire
class RequestAcceptVC: UIViewController {

    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var namelbl: UILabel!
    var status:String = ""
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()


        profileView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
        // upcomingObj.addRightBorder(borderColor: UIColor.white, borderWidth: 2.0)
        
       
        namelbl.text = UserDefaults.standard.value(forKey: "f_name") as! String
        
        let uimg:String = UserDefaults.standard.value(forKey: "f_img") as! String
        
        
        if uimg == ""
        {
            self.profileImg.image = UIImage(named: "udefault")
           
        }
        else
        {
           let url = URL(string: uimg)
           let processor = DownsamplingImageProcessor(size: self.profileImg.bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: 0)
           self.profileImg.kf.indicatorType = .activity
           self.profileImg.kf.setImage(
               with: url,
               placeholder: nil,
               options: [
                   .processor(processor),
                   .scaleFactor(UIScreen.main.scale),
                   .transition(.fade(1)),
                   .cacheOriginalImage
               ])
           {
               result in
               switch result {
               case .success(let value):
                   print("Task done for: \(value.source.url?.absoluteString ?? "")")
               case .failure(let error):
                   print("Job failed: \(error.localizedDescription)")
                self.profileImg.image = UIImage(named: "udefault")
               }
           }
           
        }
    }
    

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func reject(_ sender: UIButton) {
        status = "Reject"
        friend_accept_reject()
    }
    
    @IBAction func accept(_ sender: UIButton) {
        status = "Accept"
        friend_accept_reject()
    }
    
    
    func friend_accept_reject()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
      //  UserDefaults.standard.value(forKey: "f_rid") as! String
        Alamofire.request("https://stumbal.com/process.php?action=friend_accept_reject", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey: "f_rid") as! String,"req_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"status":status],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        self.friend_accept_reject()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        print("JSON: \(json)")
                        print("66666666666")
                        
                        if  json["result"] as! String == "success"
                        {
                            
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                           

                            if self.status == "Accept"
                            {
                                let alert = UIAlertController(title: "", message: "Friend Request Accepted Successfully", preferredStyle: .alert)
                                self.present(alert, animated: true, completion: nil)
                                
                                // change to desired number of seconds (in this case 5 seconds)
                                let when = DispatchTime.now() + 2
                                
                                DispatchQueue.main.asyncAfter(deadline: when){
                                    // your code with delay
                                    
                                    alert.dismiss(animated: true, completion: nil)
                                    
                                      self.dismiss(animated: false, completion: nil)
                                    
                                }
                            }
                            else
                            {
                                let alert = UIAlertController(title: "", message: "Friend Request Rejected Successfully", preferredStyle: .alert)
                                self.present(alert, animated: true, completion: nil)
                                
                                // change to desired number of seconds (in this case 5 seconds)
                                let when = DispatchTime.now() + 2
                                
                                DispatchQueue.main.asyncAfter(deadline: when){
                                    // your code with delay
                                    
                                    alert.dismiss(animated: true, completion: nil)
                                    
                                     self.dismiss(animated: false, completion: nil)
                                    
                                }
                            }
                            
                          
                            
                        
                        }
                        
                        else {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "", message: "Unsuccess", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                    
                }
                
            }
        }
        
        
    }
}
