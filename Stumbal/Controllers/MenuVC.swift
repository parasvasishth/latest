//
//  MenuVC.swift
//  Stumbal
//
//  Created by mac on 18/03/21.
//

import UIKit
import Alamofire
class MenuVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
@IBOutlet var menuTblView: UITableView!
var hud = MBProgressHUD()
var menuArray:[Menu]=[]
var artistArray:[artistList] = []
var checkUser:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    let m1=Menu(list: "Profile", image: "profile")
    let m2=Menu(list: "Friends", image: "chat")
    let m3=Menu(list: "Venue", image: "venue")
    let m4=Menu(list: "Events", image: "event")
    let m5=Menu(list: "Artist Profile", image: "artist")
    let m6=Menu(list: "Friend request", image: "request")
    let m7=Menu(list: "Event History", image: "eventhistory")
    let m8=Menu(list: "Proposal History", image: "proposal")
    let m9=Menu(list: "Invite friends", image: "invite")
    let m10=Menu(list: "Settings", image: "setting")
    let m11=Menu(list: "Contact Stumbal", image: "contact")
    let m12=Menu(list: "Logout", image: "logout")

    menuArray=[m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12]
    menuTblView.dataSource=self
    menuTblView.delegate=self
   // check_artist_user()
    // Do any additional setup after loading the view.
}
    override func viewWillAppear(_ animated: Bool) {
      //  check_artist_user()
        
      checkUser = UserDefaults.standard.value(forKey: "checkuser") as! String
    }
    
// MARK: - check_artist_user
func check_artist_user()
{
    
    //        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //              hud.mode = MBProgressHUDMode.indeterminate
    //              hud.self.bezelView.color = UIColor.black
    //              hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=check_artist_user", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.check_artist_user()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    let result:String = json["result"] as! String
                    
                    if result == "artist"
                    {
                        self.checkUser = json["result"] as! String
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else
                    {
                        self.checkUser = json["result"] as! String
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
}

// MARK: - TableView Methods
func numberOfSections(in tableView: UITableView) -> Int
{
    return 1
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    return menuArray.count
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    let cell=menuTblView.dequeueReusableCell(withIdentifier:"MenuTblCell", for: indexPath) as! MenuTblCell
    
    let menuData=menuArray[indexPath.row]
    cell.menuNamelbl.text="\(menuData.list)"
    cell.menuImg.image=UIImage(named: "\(menuData.image)")
    
//    cell.menuImg.image = cell.menuImg.image?.withRenderingMode(.alwaysTemplate)
//    cell.menuImg.tintColor = UIColor.red
    
    return cell
}
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
{
    if indexPath.row == 0
    {
        
        var venueCon = self.storyboard?.instantiateViewController(withIdentifier: "MenuUserProfileVC") as! MenuUserProfileVC
        venueCon.modalPresentationStyle = .fullScreen
        self.present(venueCon, animated: false, completion:nil)
    }
    else if indexPath.row == 1
    {
        var chatCon = self.storyboard?.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
        chatCon.modalPresentationStyle = .fullScreen
        self.present(chatCon, animated: false, completion:nil)
    }
    else if indexPath.row == 2
    {
        var venueCon = self.storyboard?.instantiateViewController(withIdentifier: "VenueVC") as! VenueVC
        venueCon.modalPresentationStyle = .fullScreen
        self.present(venueCon, animated: false, completion:nil)
    }
    else if indexPath.row == 3
    {
        var eventCon = self.storyboard?.instantiateViewController(withIdentifier: "MenuEventVC") as! MenuEventVC
        eventCon.modalPresentationStyle = .fullScreen
        self.present(eventCon, animated: false, completion:nil)
    }
    else if indexPath.row == 4
    {
        if checkUser == ""
        {
            var eventCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistRegisterVC") as! ArtistRegisterVC
            eventCon.modalPresentationStyle = .fullScreen
            self.present(eventCon, animated: false, completion:nil)
        }
        else
        {
            var eventCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistProfileVC") as! ArtistProfileVC
            eventCon.modalPresentationStyle = .fullScreen
            self.present(eventCon, animated: false, completion:nil)
        }
    }
    
    else if indexPath.row == 5
    {
        var eventCon = self.storyboard?.instantiateViewController(withIdentifier: "FriendRequestVC") as! FriendRequestVC
        eventCon.modalPresentationStyle = .fullScreen
        self.present(eventCon, animated: false, completion:nil)
    }
    else if indexPath.row == 6
    {
        var historyCon = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        historyCon.modalPresentationStyle = .fullScreen
        self.present(historyCon, animated: false, completion:nil)
    }
    else if indexPath.row == 7
    {
        var proposalCon = self.storyboard?.instantiateViewController(withIdentifier: "ProposalVC") as! ProposalVC
        proposalCon.modalPresentationStyle = .fullScreen
        self.present(proposalCon, animated: false, completion:nil)
    }
    else if indexPath.row == 8
    {
//        let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: false, completion: nil)
        
                var inviteCon = self.storyboard?.instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
                inviteCon.modalPresentationStyle = .fullScreen
                self.present(inviteCon, animated: false, completion:nil)
    }
    else if indexPath.row == 9
    {
        var venueCon = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        venueCon.modalPresentationStyle = .fullScreen
        self.present(venueCon, animated: false, completion:nil)
    }
    else if indexPath.row == 10
    {
        var inviteCon = self.storyboard?.instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
        inviteCon.modalPresentationStyle = .fullScreen
        self.present(inviteCon, animated: false, completion:nil)
    }
    if indexPath.row == 11
    {
        let defaults = UserDefaults.standard
        let refreshAlert = UIAlertController(title: "Exit ", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok login here")
            UserDefaults.standard.set(false, forKey: "login")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
            print("Success")
        }))
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Login here")
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
}

}
