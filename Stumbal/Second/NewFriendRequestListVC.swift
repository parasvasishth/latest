//
//  NewFriendRequestListVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 29/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewFriendRequestListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var friendRequestTblView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    var hud = MBProgressHUD()
    var requestArr:NSMutableArray = NSMutableArray()
    var reqId:String = ""
    var status:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false
        friendRequestTblView.dataSource = self
        friendRequestTblView.delegate = self
        // Do any additional setup after loading the view.
        fetch_friend_request()
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        reqId = (requestArr.object(at: tagVal) as AnyObject).value(forKey: "user_id")as! String
        status = "Reject"
        
        friend_accept_reject()
    }
    
    @IBAction func name(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        UserDefaults.standard.set(true, forKey: "Friendaccept")
       UserDefaults.standard.setValue((requestArr.object(at: tagVal) as AnyObject).value(forKey: "user_id")as! String, forKey: "friend_rid")
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewFriendAcceptProfileVC") as! NewFriendAcceptProfileVC
//        nextViewController.modalPresentationStyle = .fullScreen
//        self.present(nextViewController, animated:false, completion:nil)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyFriendProfileVC") as! MyFriendProfileVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
        
        
    }
    @IBAction func confirm(_ sender: UIButton) {
        let tagVal : Int = sender.tag
       
        reqId = (requestArr.object(at: tagVal) as AnyObject).value(forKey: "user_id")as! String
        status = "Accept"
        friend_accept_reject()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func friend_accept_reject()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        print("111",reqId , status)
        
      //  UserDefaults.standard.value(forKey: "f_rid") as! String
        Alamofire.request("https://stumbal.com/process.php?action=friend_accept_reject", method: .post, parameters: ["user_id":reqId,"req_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"status":status],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                                    
                                    self.fetch_friend_request()
                                    
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
                                    
                                    self.fetch_friend_request()
                                    
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
    
    //MARK: fetch_friend_request ;
    func fetch_friend_request()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
     //   https://stumbal.com/process.php?action=get_last_msg
       // https://stumbal.com/process.php?action=fetch_friend_list

        Alamofire.request("https://stumbal.com/process.php?action=fetch_friend_request", method: .post, parameters: ["user_id":uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                        self.fetch_friend_request()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.requestArr = NSMutableArray()
                        self.requestArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        print("1111",self.requestArr)
                        
                        
                        if self.requestArr.count != 0 {
                            
                             //self.statusLbl.isHidden = true
                            self.friendRequestTblView.isHidden = false
                            self.friendRequestTblView.reloadData()
                            self.loadingView.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.friendRequestTblView.isHidden = true
                          //   self.statusLbl.isHidden = false
                            //  self.selectcardLbl.isHidden = true
                            self.loadingView.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                    }
                    catch
                    {
                        print("error")
                    }
                    
                }
                
                
            }
        }
        
    }



//MARK: tableView Methode
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestArr.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  friendRequestTblView.dequeueReusableCell(withIdentifier: "NewFriendRequestListTableViewCell", for: indexPath) as! NewFriendRequestListTableViewCell
    
    cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
    cell.profileView.layer.masksToBounds = false
    cell.profileView.clipsToBounds = true

        cell.nameLbl.text = (requestArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String


        let pimg:String = (requestArr.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String

        if pimg == ""
        {
            cell.profileImg.image = UIImage(named: "udefault")

        }
        else
        {
            let url = URL(string: pimg)
            let processor = DownsamplingImageProcessor(size: cell.profileImg.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 0)
            cell.profileImg.kf.indicatorType = .activity
            cell.profileImg.kf.setImage(
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
                    cell.profileImg.image = UIImage(named: "udefault")
                }
            }

        }

    cell.confirmObj.tag = indexPath.row
    cell.deleteObj.tag = indexPath.row
    cell.nameObj.tag = indexPath.row
     return cell
    }
    


}
