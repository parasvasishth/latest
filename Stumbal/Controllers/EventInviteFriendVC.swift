//
//  EventInviteFriendVC.swift
//  Stumbal
//
//  Created by mac on 18/06/21.
//

import UIKit
import Alamofire
import Kingfisher
class EventInviteFriendVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet var searchField: UISearchBar!
    @IBOutlet var friendTblView: UITableView!
    @IBOutlet var statuslbl: UILabel!
    @IBOutlet var stumbalFriendobj: UIButton!
    @IBOutlet var otherFriendObj: UIButton!
    @IBOutlet var otherView: UIView!
    @IBOutlet var emailField: UITextField!
    var status:String = ""
    var email:String = ""
    var hud = MBProgressHUD()
    var messageArray:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTblView.dataSource = self
        friendTblView.dataSource = self
          fetch_friend_list()
        stumbalFriendobj.backgroundColor = #colorLiteral(red: 0.337254902, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
        otherFriendObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        
        if #available(iOS 13.0, *) {
            searchField.searchTextField.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
           } else {
               // Fallback on earlier versions
           }
        
        searchField.setImage(UIImage(named: "search1"), for: .search, state: .normal)
        
        DispatchQueue.main.async { [self] in
            otherFriendObj.roundCorners(corners: [.topRight , .bottomRight], radius: 20)
           
        }
         stumbalFriendobj.setTitleColor(.white, for: .normal)
         otherFriendObj.setTitleColor(.white, for: .normal)
        emailField.setLeftPaddingPoints(15)
        stumbalFriendobj.roundedButton1()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {

        setupSearchBar(searchBar: searchField)

    }

        func setupSearchBar(searchBar : UISearchBar) {

        searchField.setPlaceholderTextColorTo(color: #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1))

       }
    
    // MARK: - Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func invite(_ sender: UIButton) {
        if emailField.text != ""
        {
            if isValidEmail(emailField.text!)
            {
                email = emailField.text!
                friend_invitation_event()
            }
            else
            {
                let alert = UIAlertController(title: "", message: "Enter Valid Email", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: false, completion: nil)
            }
           
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter Email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }
    @IBAction func stumbalFriend(_ sender: UIButton) {
        stumbalFriendobj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        otherFriendObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        otherView.isHidden = true
        searchField.isHidden = false
        fetch_friend_list()
        
        stumbalFriendobj.setTitleColor(.white, for: .normal)
        otherFriendObj.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func otherFriend(_ sender: UIButton) {
        otherView.isHidden = false
        friendTblView.isHidden = true
        searchField.isHidden = true
        statuslbl.isHidden = true
        otherFriendObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        stumbalFriendobj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        otherFriendObj.setTitleColor(.white, for: .normal)
        stumbalFriendobj.setTitleColor(.white, for: .normal)
    }
    @IBAction func inviteemail(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        
       email = (messageArray.object(at: tagVal) as AnyObject).value(forKey: "email")as! String
        status = "Friend"
        friend_invitation_event()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        search_friend()
        
    }
    
    // MARK: - friend_invitation_event
    func friend_invitation_event()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=friend_invitation_event", method: .post,parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String,"venue_id":UserDefaults.standard.value(forKey: "V_id") as! String,"email":email,"status":status],encoding:  URLEncoding.httpBody).responseJSON{ response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                print("22222222222222")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                        self.friend_invitation_event()
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
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "", message: "Event Invitation Sent Successfully", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            // change to desired number of seconds (in this case 5 seconds)
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                self.emailField.text = ""
                                alert.dismiss(animated: false, completion: nil)
                                
                            }
                            
                        }
                        
                        else {
                            
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
    
    
    //MARK: search_friend ;
    func search_friend()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
     //   https://stumbal.com/process.php?action=get_last_msg
       // https://stumbal.com/process.php?action=fetch_friend_list

        Alamofire.request("https://stumbal.com/process.php?action=search_friend", method: .post, parameters: ["user_id":uID,"search":searchField.text!], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                        self.search_friend()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.messageArray = NSMutableArray()
                        self.messageArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        print("1111",self.messageArray)
                        
                        
                        if self.messageArray.count != 0 {
                            
                              self.statuslbl.isHidden = true
                            //self.statusLbl.text = "You have no friend"
                            self.friendTblView.isHidden = false
                            self.friendTblView.reloadData()
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.friendTblView.isHidden = true
                            self.statuslbl.isHidden = false
                            //  self.selectcardLbl.isHidden = true
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

    
    //MARK: fetch_friend_list ;
    func fetch_friend_list()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
     //   https://stumbal.com/process.php?action=get_last_msg
       // https://stumbal.com/process.php?action=fetch_friend_list

        Alamofire.request("https://stumbal.com/process.php?action=fetch_friend_list", method: .post, parameters: ["user_id":uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                        self.fetch_friend_list()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.messageArray = NSMutableArray()
                        self.messageArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        print("1111",self.messageArray)
                        
                        
                        if self.messageArray.count != 0 {
                            
                              self.statuslbl.isHidden = true
                            //self.statusLbl.text = "You have no friend"
                            self.friendTblView.isHidden = false
                            self.friendTblView.reloadData()
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.friendTblView.isHidden = true
                            self.statuslbl.isHidden = false
                            //  self.selectcardLbl.isHidden = true
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
    
        return messageArray.count
   
    
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  friendTblView.dequeueReusableCell(withIdentifier: "SearchArtistTblCell", for: indexPath) as! SearchArtistTblCell
    

        cell.artistNameLbl.text = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String


        let pimg:String = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String

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

    cell.inviteObj.tag = indexPath.row
    return cell
        //cell.messagelbl.isHidden = false
    }
   
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
  
   
    
}
