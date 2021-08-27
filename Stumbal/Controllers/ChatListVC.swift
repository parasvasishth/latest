//
//  ChatListVC.swift
//  Stumbal
//
//  Created by mac on 19/03/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class ChatListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
@IBOutlet var searchBar: UISearchBar!
@IBOutlet var chatListTblView: UITableView!
    @IBOutlet var statusLbl: UILabel!
    var AppendArr:NSMutableArray = NSMutableArray()
var hud = MBProgressHUD()
var messageArray:NSMutableArray = NSMutableArray()
    var req_Id:String = ""
    var status:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    chatListTblView.dataSource = self
    chatListTblView.delegate = self
    if #available(iOS 13.0, *) {
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
       } else {
           // Fallback on earlier versions
       }
    
    searchBar.setImage(UIImage(named: "search1"), for: .search, state: .normal)
    searchBar.delegate = self
   // UserDefaults.standard.set(true, forKey: "lastmessage")
 //  fetch_friend_list()
    // Do any additional setup after loading the view.
}

    override func viewDidLayoutSubviews() {

        setupSearchBar(searchBar: searchBar)

    }

        func setupSearchBar(searchBar : UISearchBar) {

        searchBar.setPlaceholderTextColorTo(color: #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1))

       }

    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(true, forKey: "lastmessage")
       fetch_friend_list()
    }

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}
    @IBAction func addfriend(_ sender: UIButton) {
        
        let tagVal : Int = sender.tag

        
        req_Id = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "user_id")as! String
       // friend_request()
    }
    
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    //backObj.isHidden = false#imageLiteral(resourceName: "simulator_screenshot_82E70EC8-22E8-4010-8787-A227DB1201B6.png")
}
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    UserDefaults.standard.set(false, forKey: "lastmessage")
    search_user()
    
}

//MARK: search_user ;
func search_user()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=search_user", method: .post, parameters: ["search":searchBar.text!,"user_id":uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.search_user()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.AppendArr = NSMutableArray()
                 self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.AppendArr.count != 0 {
                        
                          self.statusLbl.isHidden = true
                        self.statusLbl.text = "No Data Found"
                        self.chatListTblView.isHidden = false
                        self.chatListTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.chatListTblView.isHidden = true
                         self.statusLbl.isHidden = false
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
   
    
////MARK: get_last_msg ;
//func get_last_msg()
//{
//    // UserDefaults.standard.set(self.userId, forKey: "User id")
//    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//    hud.mode = MBProgressHUDMode.indeterminate
//    hud.self.bezelView.color = UIColor.black
//    hud.label.text = "Loading...."
//    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
//
//    print("123",uID)
// //   https://stumbal.com/process.php?action=get_last_msg
//   // https://stumbal.com/process.php?action=fetch_friend_list
//
//    Alamofire.request("https://stumbal.com/process.php?action=fetch_friend_list", method: .post, parameters: ["user_id":uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
//        if let data = response.data {
//            let json = String(data: data, encoding: String.Encoding.utf8)
//            print("=====1======")
//            print("Response: \(String(describing: json))")
//
//            if json == ""
//            {
//                MBProgressHUD.hide(for: self.view, animated: true);
//                let alert = UIAlertController(title: “Loading…”, message: "", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
//                    print("Action")
//                    self.get_last_msg()
//                }))
//                self.present(alert, animated: false, completion: nil)
//
//            }
//            else
//            {
//                do  {
//                    self.messageArray = NSMutableArray()
//                    self.messageArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
//                    print("1111",self.messageArray)
//
//
//                    if self.messageArray.count != 0 {
//
//                        //  self.statusLbl.isHidden = true
//                        self.chatListTblView.isHidden = false
//                        self.chatListTblView.reloadData()
//
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                    }
//
//                    else  {
//                        self.chatListTblView.isHidden = true
//                        // self.statusLbl.isHidden = false
//                        //  self.selectcardLbl.isHidden = true
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                    }
//
//                }
//                catch
//                {
//                    print("error")
//                }
//
//            }
//
//
//        }
//    }
//
//}
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
                            
                              self.statusLbl.isHidden = true
                            self.statusLbl.text = "You have no friend"
                            self.chatListTblView.isHidden = false
                            self.chatListTblView.reloadData()
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.chatListTblView.isHidden = true
                            self.statusLbl.isHidden = false
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
    
    if UserDefaults.standard.bool(forKey: "lastmessage") == true
    {
        return messageArray.count
    }
    else
    {
        return AppendArr.count
    }
    
    
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  chatListTblView.dequeueReusableCell(withIdentifier: "ArtistTblCell", for: indexPath) as! ArtistTblCell
    
    
//    cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
//    cell.profileView.layer.masksToBounds = false
//    cell.profileView.clipsToBounds = true
    
//
    if UserDefaults.standard.bool(forKey: "lastmessage") == true
    {
        cell.namelbl.text = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String


        let pimg:String = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String

        if pimg == ""
        {
            cell.eventImg.image = UIImage(named: "udefault")

        }
        else
        {
            let url = URL(string: pimg)
            let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 0)
            cell.eventImg.kf.indicatorType = .activity
            cell.eventImg.kf.setImage(
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
                    cell.eventImg.image = UIImage(named: "udefault")
                }
            }

        }


     
        //cell.messagelbl.isHidden = false
    }
    else
    {
        cell.namelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
      
        
        if (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "status")as! String  == ""
        {
           // cell.addfriendObj.isHidden = false
        }
      

        let pimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "user_image")as! String

        if pimg == ""
        {
            cell.eventImg.image = UIImage(named: "udefault")

        }
        else
        {
            let url = URL(string: pimg)
            let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 0)
            cell.eventImg.kf.indicatorType = .activity
            cell.eventImg.kf.setImage(
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
                    cell.eventImg.image = UIImage(named: "udefault")
                }
            }

        }

        //cell.messagelbl.isHidden = true
    }

    return cell
}


func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if UserDefaults.standard.bool(forKey: "lastmessage") == true
    {
        
        
            UserDefaults.standard.setValue((messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "user_id")as! String, forKey: "friend_rid")
        UserDefaults.standard.setValue((messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String, forKey: "friend_img")
        UserDefaults.standard.setValue((messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String, forKey: "friend_name")
        
        UserDefaults.standard.setValue((messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "status")as! String, forKey: "friend_status")
        
        
//        let uid = UserDefaults.standard.value(forKey: "u_Id") as! String
//        if (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "sender_id") as! String == uid
//        {
//            let oid = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "receiver") as! String
//
//            UserDefaults.standard.setValue(oid, forKey: "Receiver_id")
//
//        }
//        else if (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "receiver") as! String == uid
//        {
//            let oid = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "sender_id") as! String
//
//            UserDefaults.standard.setValue(oid, forKey: "Receiver_id")
//        }
//
//        let n = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
//
//
//        let aimg = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "profile_image")as! String
//        UserDefaults.standard.setValue(n, forKey: "Receiver_name")
//        UserDefaults.standard.setValue(aimg, forKey: "Receiver_img")
    }
    else
    {
        
        UserDefaults.standard.setValue((AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "user_id")as! String, forKey: "friend_rid")
    UserDefaults.standard.setValue((AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "user_image")as! String, forKey: "friend_img")
    UserDefaults.standard.setValue((AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String, forKey: "friend_name")
    
    UserDefaults.standard.setValue((AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "status")as! String, forKey: "friend_status")
    }
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}


}
