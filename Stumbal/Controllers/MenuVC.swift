//
//  MenuVC.swift
//  Stumbal
//
//  Created by mac on 18/03/21.
//

import UIKit
import Alamofire
import Kingfisher
class MenuVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
@IBOutlet var menuTblView: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var switchObj: UIButton!
  
 
    @IBOutlet weak var artistLblHeight: NSLayoutConstraint!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var logoutLbl: UnderlinedLabel!
    var hud = MBProgressHUD()
var menuArray:[Menu]=[]
var artistArray:[artistList] = []
var checkUser:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
//    let m1=Menu(list: "Profile", image: "profile")
//    let m2=Menu(list: "Friends", image: "chat")
//    let m3=Menu(list: "Venue", image: "venue")
//    let m4=Menu(list: "Events", image: "event")
//    let m5=Menu(list: "Artist Profile", image: "artist")
//    let m6=Menu(list: "Friend request", image: "request")
//    let m7=Menu(list: "Event History", image: "eventhistory")
//    let m8=Menu(list: "Proposal History", image: "proposal")
//    let m9=Menu(list: "Invite friends", image: "invite")
//    let m10=Menu(list: "Settings", image: "setting")
//    let m11=Menu(list: "Contact Stumbal", image: "contact")
//    let m12=Menu(list: "Logout", image: "logout")
    
    
    

//    let m1=Menu(list: "Explore Categories", image: "searchw")
//    let m2=Menu(list: "Notifications", image: "flag")
//    let m3=Menu(list: "Refer & Earn", image: "dollar")
//    let m4=Menu(list: "Settings", image: "setting1")
    
    
    menuTblView.dataSource=self
    menuTblView.delegate=self
   // check_artist_user()
    // Do any additional setup after loading the view.
}
    override func viewWillAppear(_ animated: Bool) {
      //  check_artist_user()
//        UserDefaults.standard.setValue(json["result"] as! String, forKey: "checkuser")
//        UserDefaults.standard.setValue(json["artist_id"] as! String, forKey: "ap_artId")
//
        nameLbl.text = ""
        if UserDefaults.standard.bool(forKey: "ArtistLogin") == true
        {
            let m1=Menu(list: "Artist Profile", image: "searchw")
            let m2=Menu(list: "Financial Details", image: "fianicial")
            let m3=Menu(list: "Your Gigs", image: "gig")
            let m4=Menu(list: "Settings", image: "setting1")
            menuArray=[m1,m2,m3,m4]
            artistLbl.isHidden = false
            artistLblHeight.constant = 20
            switchObj.setTitle("Switch to User", for: .normal)
            fetch_artist_register()
        }
        else
        {
            let m1=Menu(list: "Explore Categories", image: "searchw")
            let m2=Menu(list: "Notifications", image: "flag")
            let m3=Menu(list: "Find a Friend", image: "addfriend")
            let m4=Menu(list: "Refer a Friend", image: "dollar")
            let m5=Menu(list: "Settings", image: "setting1")
            menuArray=[m1,m2,m3,m4,m5]
            artistLblHeight.constant = 0
            artistLbl.isHidden = true
            fecth_Profile()
            if UserDefaults.standard.value(forKey: "checkuser") as! String == "artist"
            {
                switchObj.setTitle("Switch to Artist", for: .normal)
            }
            else
            {
                switchObj.setTitle("Create an Artist", for: .normal)
            }

        }
        logoutLbl.text = "Log Out"
        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.layer.masksToBounds = false
        profileView.clipsToBounds = true
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
        logoutLbl.isUserInteractionEnabled = true
        logoutLbl.addGestureRecognizer(tapGestureRecognizer3)
       
      checkUser = UserDefaults.standard.value(forKey: "checkuser") as! String
        
        
        
    }
    
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer){
        let defaults = UserDefaults.standard
        let refreshAlert = UIAlertController(title: "Exit ", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok login here")
            UserDefaults.standard.set(false, forKey: "login")
            UserDefaults.standard.set(false, forKey: "ArtistLogin")
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
    
    @IBAction func switchBtn(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "ArtistLogin") == true
        {
            UserDefaults.standard.set(false, forKey: "ArtistLogin")
            
            
            let m1=Menu(list: "Explore Categories", image: "searchw")
            let m2=Menu(list: "Notifications", image: "flag")
            let m3=Menu(list: "Find a Friend", image: "addfriend")
            let m4=Menu(list: "Refer a Friend", image: "dollar")
            let m5=Menu(list: "Settings", image: "setting1")
            menuArray=[m1,m2,m3,m4,m5]
            artistLblHeight.constant = 0
            artistLbl.isHidden = true
            nameLbl.text = ""
            fecth_Profile()
            switchObj.setTitle("Switch to Artist", for: .normal)
            menuTblView.reloadData()
        }
        else
        {
           if UserDefaults.standard.value(forKey: "checkuser") as! String == "artist"
            {
               artistLbl.isHidden = false
               artistLblHeight.constant = 20
               UserDefaults.standard.set(true, forKey: "ArtistLogin")
               let m1=Menu(list: "Artist Profile", image: "searchw")
               let m2=Menu(list: "Financial Details", image: "fianicial")
               let m3=Menu(list: "Your Gigs", image: "gig")
               let m4=Menu(list: "Settings", image: "setting1")
               menuArray=[m1,m2,m3,m4]
               nameLbl.text = ""
               fetch_artist_register()
               switchObj.setTitle("Switch to User", for: .normal)
               menuTblView.reloadData()
           }
            else
            {
                
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewArtistRegisteredVC") as! NewArtistRegisteredVC
         nextViewController.modalPresentationStyle = .fullScreen
         self.present(nextViewController, animated:false, completion:nil)
            }
        }
    }
    
    // MARK: - fetch_artist_register
    func fetch_artist_register()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
//
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_register", method: .post, parameters: ["artist_id" : UserDefaults.standard.value(forKey: "ap_artId") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.fetch_artist_register()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                    
                }
                else
                {
                    
                    
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        self.artistLbl.text = json["name"] as! String
                        self.fecth_Profile()
                       
                        let uimg:String = json["artist_img"] as! String
                        
       
                        
                        if uimg == ""
                        {
                            self.profileImg.image = UIImage(named: "adefault")
                           
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
                                self.profileImg.image = UIImage(named: "adefault")
                               }
                           }
                           
                        }
                     
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
    
    // MARK: - fecth_Profile
    func fecth_Profile()
    {

    //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //hud.mode = MBProgressHUDMode.indeterminate
    //hud.self.bezelView.color = UIColor.black
    //hud.label.text = "Loading...."
     //   self.loadingView.isHidden = false
    Alamofire.request("https://stumbal.com/process.php?action=fetch_user_profile", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.fecth_Profile()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                
                
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    
                   
                self.nameLbl.text = json["name"] as! String
          
                    if UserDefaults.standard.bool(forKey: "ArtistLogin") == true
                    {
                        
                    }
                    else
                    {
                        let uimg:String = json["user_image"] as! String
                        
       
                        
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
    
    
    if UserDefaults.standard.bool(forKey: "ArtistLogin") == true
    {
        if indexPath.row == 0
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewArtistProfileVC") as! NewArtistProfileVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else if indexPath.row == 1
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SendDetailVC") as! SendDetailVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else if indexPath.row == 2
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewArtistProposalListVC") as! NewArtistProposalListVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else if indexPath.row == 3
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
    }
    else
    {
        if indexPath.row == 0
        {
            
//            let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//
//                            var selectCatCon = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//    //                           selectCatCon.tabBarController?.selectedViewController = tabBarController?.viewControllers![1] as! PowerVC
//                              selectCatCon.modalPresentationStyle = .fullScreen
//    //                     tabBarController!.selectedIndex = 2
//            selectCatCon.selectedIndex = 2
//            self.present(selectCatCon, animated: false, completion:nil)
            
//                                    var selectCatCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//                                    selectCatCon.tabBarController?.selectedViewController = tabBarController?.viewControllers![3] as! PowerVC
//                                    selectCatCon.modalPresentationStyle = .fullScreen
//                                    self.present(selectCatCon, animated: false, completion:nil)
                   
//            let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuPowerVC") as! MenuPowerVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
            
    }
       
        else if indexPath.row == 1
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewNotificationVC") as! NewNotificationVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else if indexPath.row == 2
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FindaFriendVC") as! FindaFriendVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else if indexPath.row == 3
        {
            //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            //            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
            //            nextViewController.modalPresentationStyle = .fullScreen
            //            self.present(nextViewController, animated:false, completion:nil)
                        
            //            if let name = URL(string: "https://apps.apple.com/us/app/stumbal/id1566360669"), !name.absoluteString.isEmpty {
            //              let objectsToShare = [name]
            //              let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            //              self.present(activityVC, animated: true, completion: nil)
            //            } else {
            //              // show alert for not available
            //            }
                        
                        let someText:String = "Never have nothing to do, with Stumbal.Discover,organise and book  events with ease using our app.Your friend is trying to share an event with you! Download our app to view it."
                          let objectsToShare:URL = URL(string: "https://apps.apple.com/us/app/stumbal/id1566360669")!
                          let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
                          let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
                          activityViewController.popoverPresentationController?.sourceView = self.view

                   //     activityViewController.excludedActivityTypes = [ UIActivity.ActivityTypeUIActivity.ActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]

                          self.present(activityViewController, animated: true, completion: nil)
            
         
        }
        else if indexPath.row == 4
        {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
    }
   
//    else if indexPath.row == 4
//    {
//        if checkUser == ""
//        {
//            var eventCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistRegisterVC") as! ArtistRegisterVC
//            eventCon.modalPresentationStyle = .fullScreen
//            self.present(eventCon, animated: false, completion:nil)
//        }
//        else
//        {
//            var eventCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistProfileVC") as! ArtistProfileVC
//            eventCon.modalPresentationStyle = .fullScreen
//            self.present(eventCon, animated: false, completion:nil)
//        }
//    }
//
//    else if indexPath.row == 5
//    {
//        var eventCon = self.storyboard?.instantiateViewController(withIdentifier: "FriendRequestVC") as! FriendRequestVC
//        eventCon.modalPresentationStyle = .fullScreen
//        self.present(eventCon, animated: false, completion:nil)
//    }
//    else if indexPath.row == 6
//    {
//        var historyCon = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
//        historyCon.modalPresentationStyle = .fullScreen
//        self.present(historyCon, animated: false, completion:nil)
//    }
//    else if indexPath.row == 7
//    {
//        var proposalCon = self.storyboard?.instantiateViewController(withIdentifier: "ProposalVC") as! ProposalVC
//        proposalCon.modalPresentationStyle = .fullScreen
//        self.present(proposalCon, animated: false, completion:nil)
//    }
//    else if indexPath.row == 8
//    {
////        let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
////        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
////        self.present(alert, animated: false, completion: nil)
//
//                var inviteCon = self.storyboard?.instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
//                inviteCon.modalPresentationStyle = .fullScreen
//                self.present(inviteCon, animated: false, completion:nil)
//    }
//    else if indexPath.row == 9
//    {
//        var venueCon = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
//        venueCon.modalPresentationStyle = .fullScreen
//        self.present(venueCon, animated: false, completion:nil)
//    }
//    else if indexPath.row == 10
//    {
//        var inviteCon = self.storyboard?.instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
//        inviteCon.modalPresentationStyle = .fullScreen
//        self.present(inviteCon, animated: false, completion:nil)
//    }
//    if indexPath.row == 11
//    {
//        let defaults = UserDefaults.standard
//        let refreshAlert = UIAlertController(title: "Exit ", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
//        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
//            print("Handle Ok login here")
//            UserDefaults.standard.set(false, forKey: "login")
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//            nextViewController.modalPresentationStyle = .fullScreen
//            self.present(nextViewController, animated:false, completion:nil)
//            print("Success")
//        }))
//        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
//            print("Handle Cancel Login here")
//        }))
//        present(refreshAlert, animated: true, completion: nil)
//    }
}

}
