//
//  NewInviteFriendOnEventVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 04/02/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewInviteFriendOnEventVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var tapLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var inviteTblView: UITableView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    var hud = MBProgressHUD()
    var friendArr:NSMutableArray = NSMutableArray()
    var email:String = ""
    var status:String = ""
    var id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false
        inviteTblView.dataSource = self
        inviteTblView.delegate = self
        
        searchBar.delegate = self
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftViewMode = .never
        searchBar.delegate = self
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
           } else {
               // Fallback on earlier versions
           }
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {

            //textfield.backgroundColor = UIColor.yellow
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search bar", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            textfield.setLeftPaddingPoints(5)
            textfield.clearButtonMode = .never
           // textfield.textColor = UIColor.green

    //        if let leftView = textfield.leftView as? UIImageView {
    //            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
    //            leftView.tintColor = UIColor.red
    //        }
        }
        fetch_invited_friendlist()
        // Do any additional setup after loading the view.
    }
    @IBAction func userProfile(_ sender: UIButton) {
        let tagVal : Int = sender.tag
     
        UserDefaults.standard.set((friendArr.object(at: tagVal) as AnyObject).value(forKey: "user_id")as! String, forKey: "friend_rid")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyFriendProfileVC") as! MyFriendProfileVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func invited(_ sender: UIButton) {
        let tagVal : Int = sender.tag

//        if (friendArr.object(at: tagVal) as AnyObject).value(forKey: "status")as! String == "Invited"
//        {
//
//        }
//        else
//        {
            email = (friendArr.object(at: tagVal) as AnyObject).value(forKey: "email")as! String
             status = "Friend"
             friend_invitation_event()
      //  }
  
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetch_invited_friendlist()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        //backObj.isHidden = false
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
                                
                                alert.dismiss(animated: false, completion: nil)
                                self.fetch_invited_friendlist()
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
    
  

    
    //MARK: fetch_invited_friendlist ;
    func fetch_invited_friendlist()
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
    //    ,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String,"search":searchBar.text!
        Alamofire.request("https://stumbal.com/process.php?action=fetch_invited_friendlist", method: .post, parameters: ["user_id":uID,"search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                        self.fetch_invited_friendlist()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.friendArr = NSMutableArray()
                        self.friendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        print("1111",self.friendArr)
                        
                        
                        if self.friendArr.count != 0 {
                            
                             self.statusLbl.isHidden = true
                            self.inviteTblView.isHidden = false
                            self.tapLbl.isHidden = false
                            self.searchBar.isHidden = false
                            self.searchImg.isHidden = false
                            self.inviteTblView.reloadData()
                            self.loadingView.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.inviteTblView.isHidden = true
                            self.statusLbl.isHidden = false
                            self.loadingView.isHidden = true
                            //self.tapLbl.isHidden = true
                            //self.searchBar.isHidden = true
                           // self.searchImg.isHidden = true
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
    
  
        return friendArr.count

}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  inviteTblView.dequeueReusableCell(withIdentifier: "NewFriendOnEventTableViewCell", for: indexPath) as! NewFriendOnEventTableViewCell

    cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
    cell.profileView.layer.masksToBounds = false
    cell.profileView.clipsToBounds = true
        cell.nameLbl.text = (friendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
    if (friendArr.object(at: indexPath.row) as AnyObject).value(forKey: "status")as! String == "Invited"
    {
        cell.friendObj.isHidden = false
        //cell.friendObj.setImage(UIImage(named: "correct"), for: .normal)
        cell.friendObj.setImage(UIImage(named: "plusb"), for: .normal)
    }
    else
    {
        cell.friendObj.isHidden = false
       // cell.friendObj.setImage("", for: .normal)
        cell.friendObj.setImage(UIImage(named: "plusb"), for: .normal)
    }


        let pimg:String = (friendArr.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String

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
    cell.userprofileObj.tag = indexPath.row
    cell.friendObj.tag = indexPath.row
     return cell
    }
    

}
