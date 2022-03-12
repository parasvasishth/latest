//
//  NewFriendProfileVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 24/01/22.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class NewFriendProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
  
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var profileView: UIView!
    var pickerOne : UIImagePickerController?
    @IBOutlet weak var upcomingCollView: UICollectionView!
    @IBOutlet weak var pastCollView: UICollectionView!
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet weak var upcominglbl: UILabel!
    @IBOutlet weak var upcomingCollHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingLineHeight: NSLayoutConstraint!
    @IBOutlet weak var pastLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryLblHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryCollHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryLineLblHeight: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var logoutView: UIView!
        @IBOutlet weak var pastnHeight: NSLayoutConstraint!
        @IBOutlet weak var upcomingnheight: NSLayoutConstraint!
        @IBOutlet weak var switchObj: UIButton!
        var imgName:String = ""
    @IBOutlet weak var addObj: UIButton!
    @IBOutlet weak var cancelObj: UIButton!
    @IBOutlet weak var eventCountlbl: UILabel!
    @IBOutlet weak var friendCountLbl: UILabel!
    @IBOutlet weak var categoryCountlbl: UILabel!
        @IBOutlet weak var firstView: UIView!
        @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
        @IBOutlet weak var secondView: UIView!
        @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
        @IBOutlet weak var thirdView: UIView!
        @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
    @IBOutlet weak var blockObj: UIButton!
    var str1:String = ""
    var AppendArr:NSMutableArray = NSMutableArray()
    var pastArr:NSMutableArray = NSMutableArray()
    var cateArr:NSMutableArray = NSMutableArray()
        
    var hud = MBProgressHUD()
    @IBOutlet weak var sendlbl: UILabel!
    @IBOutlet weak var blockView: UIView!
    private let spacing:CGFloat = 10.0
    private let spacing1:CGFloat = 15.0
    private let spacing2:CGFloat = 10.0
    @IBOutlet weak var userblockedObj: UIButton!
    var session = URLSession()
    var providerRating:String = ""
    var artistRating:String = ""
    var status:String = ""
    var finalStatus:String = ""
    var type:String = ""
    var blockStatus:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       // tabBarController?.tabBar.isHidden = true
        self.loadingView.isHidden = false
        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.layer.masksToBounds = false
        profileView.clipsToBounds = true

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        self.upcomingCollView?.collectionViewLayout = layout

        let layout1 = UICollectionViewFlowLayout()
        layout1.sectionInset = UIEdgeInsets(top: spacing1, left: spacing1, bottom: spacing1, right: spacing1)
        layout1.minimumLineSpacing = spacing1
        layout1.minimumInteritemSpacing = spacing1
        layout1.scrollDirection = .horizontal
        self.pastCollView?.collectionViewLayout = layout1

        let layout2 = UICollectionViewFlowLayout()
        layout2.sectionInset = UIEdgeInsets(top: spacing2, left: spacing2, bottom: spacing2, right: spacing2)
        layout2.minimumLineSpacing = spacing2
        layout2.minimumInteritemSpacing = spacing2
        layout2.scrollDirection = .horizontal
        self.categoryCollView?.collectionViewLayout = layout2

        upcomingCollView.dataSource=self
        upcomingCollView.delegate=self
        pastCollView.dataSource=self
        pastCollView.delegate=self
        categoryCollView.dataSource=self
        categoryCollView.delegate=self

        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
            
            
     
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            friendCountLbl.isUserInteractionEnabled = true
            friendCountLbl.addGestureRecognizer(tapGestureRecognizer)
       
        fetch_friend_status()
        // Do any additional setup after loading the view.
    }
    
    func friend_request()
    {
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."

    Alamofire.request("https://stumbal.com/process.php?action=friend_request", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"req_id":UserDefaults.standard.value(forKey: "friend_rid") as! String,"status":status],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                    self.friend_request()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    print("JSON: \(json)")
                    print("66666666666")
                    let result:String = json["result"] as! String
                    if result == "success"
                    {
                        
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        let alert = UIAlertController(title: "", message: "Friend Request Sent Successfully", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        
                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 2
                        
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            
                            alert.dismiss(animated: true, completion: nil)
                            self.fetch_friend_status()
                             // self.dismiss(animated: false, completion: nil)
                            
                        }
                        
                        
                    
                    }
                    
                    else {
                        
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

    func fetch_friend_status()
    {
//    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//    hud.mode = MBProgressHUDMode.indeterminate
//    hud.self.bezelView.color = UIColor.black
//    hud.label.text = "Loading...."

    Alamofire.request("https://stumbal.com/process.php?action=fetch_friend_status", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"req_id":UserDefaults.standard.value(forKey: "friend_rid") as! String],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                self.loadingView.isHidden = true
                let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                    self.fetch_friend_status()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    print("JSON: \(json)")
                    print("66666666666")
                    let result:String = json["status"] as! String
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.loadingView.isHidden = true
                    if json["status"] as! String == ""
                    {
                        self.sendlbl.text = "Send Friend Request"
                    
                        self.status = json["status"] as! String
                        self.addObj.setTitle("Add Friend", for: .normal)
                    }
                    else if json["status"] as! String == "Pending"
                    {
                        self.sendlbl.text = "Request Sent"
                        self.status = json["status"] as! String
                        self.addObj.setTitle("Friend request sent", for: .normal)
                    }
                    else if json["status"] as! String == "Accept"
                    {
                        self.sendlbl.text = "Friend"
                        self.status = json["status"] as! String
                        self.addObj.setTitle("Remove Friend", for: .normal)
                    }
                    
//                    if result == "success"
//                    {
//                     MBProgressHUD.hide(for: self.view, animated: true)
//                    }
//                    else {
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                        let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//
//                    }
                }
                
            }
            
        }
    }
    }
    
    func friend_accept_reject()
    {
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."

    Alamofire.request("https://stumbal.com/process.php?action=unfriend_cancel_request", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"req_id":UserDefaults.standard.value(forKey: "friend_rid") as! String,"status":status,"type":type],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                self.present(alert, animated: false, completion: nil)
                
                
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
                        
                    //  self.dismiss(animated: false, completion: nil)
                    self.fetch_friend_status()
                        
    //                            if self.status == "Accept"
    //                            {
    //                                let alert = UIAlertController(title: "", message: "Friend Request Accept Successfully", preferredStyle: .alert)
    //                                self.present(alert, animated: true, completion: nil)
    //
    //                                // change to desired number of seconds (in this case 5 seconds)
    //                                let when = DispatchTime.now() + 2
    //
    //                                DispatchQueue.main.asyncAfter(deadline: when){
    //                                    // your code with delay
    //
    //                                    alert.dismiss(animated: true, completion: nil)
    //
    //                                    //  self.dismiss(animated: true, completion: nil)
    //
    //                                }
    //                            }
    //                            else
    //                            {
    //                                let alert = UIAlertController(title: "", message: "Friend Request  Reject Successfully", preferredStyle: .alert)
    //                                self.present(alert, animated: true, completion: nil)
    //
    //                                // change to desired number of seconds (in this case 5 seconds)
    //                                let when = DispatchTime.now() + 2
    //
    //                                DispatchQueue.main.asyncAfter(deadline: when){
    //                                    // your code with delay
    //
    //                                    alert.dismiss(animated: true, completion: nil)
    //
    //                                    //  self.dismiss(animated: true, completion: nil)
    //
    //                                }
    //                            }
                        
                      
                        
                    
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVC
//        nextViewController.modalPresentationStyle = .fullScreen
//        self.present(nextViewController, animated:false, completion:nil)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewFriendListVC") as! NewFriendListVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
    //  UserDefaults.standard.set(true, forKey: "upcoming_event")
    // UserDefaults.standard.set(false, forKey: "past_event")
    // upcomingobj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    // pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    //    if self.revealViewController() != nil {
    //
    //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    //            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    //        }
        
        
//        if UserDefaults.standard.bool(forKey: "ArtistLogin") == true
//        {
//            switchObj.setTitle("Switch to User", for: .normal)
//        }
//        else
//        {
//
//
//            if UserDefaults.standard.value(forKey: "checkuser") as! String == "artist"
//            {
//                switchObj.setTitle("Switch to Artist Account", for: .normal)
//            }
//            else
//            {
//                switchObj.setTitle("Create an Artist", for: .normal)
//            }
//
//        }
            
        fecth_Profile()
    //fetch_upcoming_events()
    }

    @IBAction func blockDismiss(_ sender: UIButton) {
        self.logoutView.isHidden = true
        self.blockView.isHidden = true
        self.hideView.isHidden = true
    }
    @IBAction func addFriend(_ sender: UIButton) {
        if status == "Pending"
        {
            
            self.status = ""
            type = "Cancel"
            friend_accept_reject()
        }
        else
        {
            status = "Pending"
            friend_request()
        }
    }
    
    @IBAction func block(_ sender: UIButton) {
        if blockStatus == "block"
        {
            blockStatus = "unblock"
            logoutView.isHidden = true
            cancelObj.isHidden = true
            blockView.isHidden = false
            userblockedObj.setTitle("User Unblocked", for: .normal)
            block_unblock_user()
        }
        else
        {
            blockStatus = "block"
            logoutView.isHidden = true
            cancelObj.isHidden = true
            blockView.isHidden = false
            userblockedObj.setTitle("User Blocked", for: .normal)
            block_unblock_user()
        }
    }
    
    @IBAction func report(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
 
        
    @IBAction func sendRequest(_ sender: UIButton) {
        if status == "Pending"
        {
            self.status = ""
            type = "Cancel"
            friend_accept_reject()
        }
        else
        {
            status = "Pending"
            friend_request()
        }
        
       
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
           
            hideView.isHidden = true
            logoutView.isHidden = true
            cancelObj.isHidden = true
            //tabBarController?.tabBar.isHidden = false
          //  tabBarController?.tabBar.backgroundColor = UIColor.black
        }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
        @IBAction func selectBtn(_ sender: UIButton) {
           // tabBarController?.tabBar.isHidden = true
            hideView.isHidden = false
            logoutView.isHidden = false
            cancelObj.isHidden = false
          //  tabBarController?.tabBar.isHidden = false
        }
        
        @IBAction func logout(_ sender: UIButton) {
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
        
        @IBAction func artist(_ sender: UIButton) {
            if UserDefaults.standard.bool(forKey: "ArtistLogin") == true
            {
                UserDefaults.standard.set(false, forKey: "ArtistLogin")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                 let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                nextViewController.modalPresentationStyle = .fullScreen
               self.present(nextViewController, animated:false, completion:nil)
            }
            else
            {
                UserDefaults.standard.set(true, forKey: "ArtistLogin")
                
                if UserDefaults.standard.value(forKey: "checkuser") as! String == "artist"
                {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                     let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    nextViewController.modalPresentationStyle = .fullScreen
                   self.present(nextViewController, animated:false, completion:nil)
                }
                else
                {
                    
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                     let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ArtistRegisterVC") as! ArtistRegisterVC
//                    nextViewController.modalPresentationStyle = .fullScreen
//                   self.present(nextViewController, animated:false, completion:nil)
                }
                
    //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
    //            nextViewController.modalPresentationStyle = .fullScreen
    //           self.present(nextViewController, animated:false, completion:nil)
            }
        }
        
        @IBAction func viewCategory(_ sender: UIButton) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UpdateCategoryVC") as! UpdateCategoryVC
//        nextViewController.modalPresentationStyle = .fullScreen
//        self.present(nextViewController, animated:false, completion:nil)
    }
    @IBAction func changePassword(_ sender: UIButton) {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
    }

    @IBAction func following(_ sender: UIButton) {
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "UserFollowingVC") as! UserFollowingVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
    }

    @IBAction func editPicture(_ sender: UIButton) {

    pickerOne = UIImagePickerController()

    let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) in
                                    self.pickerOne!.sourceType = UIImagePickerController.SourceType.photoLibrary
                                    self.pickerOne!.allowsEditing=true
                                    self.pickerOne!.delegate=self
                                    self.present(self.pickerOne!, animated: true, completion: nil)            }))
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
        self.pickerOne!.sourceType=UIImagePickerController.SourceType.camera
        self.pickerOne!.allowsEditing=true
        self.pickerOne!.delegate=self
        self.present(self.pickerOne!, animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    }

    // MARK: - fetch_block_unblock_user
    func fetch_block_unblock_user()
    {
        
        //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //    hud.mode = MBProgressHUDMode.indeterminate
        //    hud.self.bezelView.color = UIColor.black
        //    hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=fetch_block_unblock_user", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"block_user_id":UserDefaults.standard.value(forKey: "friend_rid") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.fetch_block_unblock_user()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        
                        self.blockStatus = json["status"] as! String
                        
                        
                        if self.blockStatus == "block"
                        {
                            self.blockObj.setTitle("Unblock", for: .normal)
                          
                            
                        }
                        else
                        {
                            self.blockObj.setTitle("Block", for: .normal)
                          
                        }
                        // MBProgressHUD.hide(for: self.view, animated: true)
                        self.loadingView.isHidden = true
                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
        
    }
    
    func block_unblock_user()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=block_unblock_user", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"block_user_id":UserDefaults.standard.value(forKey: "friend_rid") as! String,"status":blockStatus],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        self.block_unblock_user()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        print("JSON: \(json)")
                        print("66666666666")
                        let result:String = json["result"] as! String
                        if  result == "success"
                        {
                            
                            self.blockStatus = json["status"] as! String
                            
                            if self.blockStatus == "block"
                            {
                                self.blockObj.setTitle("Unblock", for: .normal)
                            }
                            else
                            {
                                
                                self.blockObj.setTitle("Block", for: .normal)
                            }
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                        
                        else {
                            
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
    
    func camera()
    {
    if UIImagePickerController.isSourceTypeAvailable(.camera){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .camera
        myPickerController.modalPresentationStyle = .fullScreen
        self.present(myPickerController, animated: true, completion: nil)
    }
    }

    func photoLibrary()
    {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .photoLibrary
        myPickerController.modalPresentationStyle = .fullScreen
        self.present(myPickerController, animated: true, completion: nil)
    }
    }
    //    extension UIImage {
    //        var jpeg: Data? { jpegData(compressionQuality: 1) }  // QUALITY min = 0 / max = 1
    //        var png: Data? { pngData() }
    //    }


    func resize1(_ image: UIImage) -> UIImage {
        var actualHeight = Float(200)
        var actualWidth = Float(400)
        let maxHeight: Float = 200.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 1.0
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }



    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // let selectedImg=info[UIImagePickerController.InfoKey.originalImage] as! UIImage

    let selectedImg=info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    // let image1 : UIImage = resize1(selectedImg)

     let image1 : UIImage = selectedImg.resize(400)

    let imageData = image1.jpegData(compressionQuality: 0.75)
    str1 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
    // str1 = ConvertImageToBase64String(img: image1)

    // driverLicenceImageFiled.text = imagePath
    let date = Date()
    let formator = DateFormatter()
    formator.dateFormat = "HH:mm:ss"
    formator.locale = Locale.init(identifier: "en_US_POSIX")
    let strDate = formator.string(from: date)
    let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
    imgName = imagePath
    profileImg.image = image1
    update_profile_image()

    self.dismiss(animated: false, completion: nil)

    }


    func ConvertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
    }
 



    // MARK: - fecth_Profile
    func fecth_Profile()
    {

    //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //hud.mode = MBProgressHUDMode.indeterminate
    //hud.self.bezelView.color = UIColor.black
    //hud.label.text = "Loading...."
        self.loadingView.isHidden = false
    Alamofire.request("https://stumbal.com/process.php?action=fetch_user_profile", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "friend_rid") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                    
                    //                                let result:String = json["result"] as! String
                    //
                    //                                if result == "success"
                    //                                {
                self.nameLbl.text = json["name"] as! String
                    var name:String = json["fname"] as! String
                    
                    self.pastLbl.text = name + "'s " + "Event History"
                  //  self.emaillbl.text = json["email"] as! String
                  //  self.contactLbl.text = json["contact"] as! String
                    //  user_image
                  
                    UserDefaults.standard.setValue(json["cat_name"] as! String, forKey: "Pro_Cat")
                    
                    self.categoryCountlbl.text = json["category_count"] as! String
                    self.friendCountLbl.text = json["friend_count"] as! String
              //  self.profileImg.sd_setImage(with: URL(string:json["user_image"] as! String), placeholderImage: UIImage(named: "udefault"))
                    
                    
                    
    //                    self.profileImg?.sd_setImage(with: URL(string:json["user_image"] as! String )) { (image, error, cache, urls) in
    //                                if (error != nil) {
    //                                    self.profileImg.image = UIImage(named: "udefault")
    //                                } else {
    //                                    self.profileImg.image = image
    //                                }
    //                    }
                    
                    let uimg:String = json["user_image"] as! String
                    
                    
    //                    let imageUrl = URL(string: "your image url")
    //                     //Size refer to the size which you want to resize your original image
    //                     let size = CGSize(width: 60, height: 60)
    //                    let processImage = ResizingImageProcessor(targetSize: size, contentMode: .aspectFill)
    //                     cell.courseTitleImage.kf.setImage(with: imageUrl! , placeholder: UIImage(named: "placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processImage)], progressBlock: nil, completionHandler: nil)
                    
                    
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
                    
                    self.fetch_upcoming_events()
                    
                   // MBProgressHUD.hide(for: self.view, animated: true)
                    
                    
                }
                else
                {
                    self.loadingView.isHidden = true

                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }

    }



    //MARK: update_profile_image ;
    func update_profile_image()
    {
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."

    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String

    Alamofire.request("https://stumbal.com/process.php?action=update_profile_img", method: .post, parameters: ["user_id":uID,"profile_image":imgName,"profile_string":str1], encoding:  URLEncoding.httpBody).responseJSON
    { response in
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
                    self.update_profile_image()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    print("JSON: \(json)")
                    print("66666666666")
                    
                    if  json["result"] as! String == "success"
                    {
                        
                        MBProgressHUD.hide(for: self.view, animated: true);
    //                    let alert = UIAlertController(title: "", message: "Profile Picture updated Successfully", preferredStyle: .alert)
    //                    self.present(alert, animated: true, completion: nil)
    //
    //                    // change to desired number of seconds (in this case 5 seconds)
    //                    let when = DispatchTime.now() + 2
    //
    //                    DispatchQueue.main.asyncAfter(deadline: when){
    //                        // your code with delay
    //
    //                        alert.dismiss(animated: false, completion: nil)
    //
    //                        //  self.fecth_Profile()
    //                    }
                    }
                }
                
            }
       
        }
    }

    }


    //MARK: fetch_upcoming_events ;
        func fetch_upcoming_events()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
    //            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //            hud.mode = MBProgressHUDMode.indeterminate
    //            hud.self.bezelView.color = UIColor.black
    //            hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "friend_rid") as! String
            
            print("123",uID)
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_upcoming_events", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                         self.fetch_upcoming_events()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                     do  {
                        self.AppendArr = NSMutableArray()
                         self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                         //                    print(self.Arr.count)
                         //                    print(self.Arr)
                         //                    self.AppendArr = NSMutableArray()
                         //                    for i in 0...self.Arr.count-1
                         //                    {
                         //                        if (self.Arr.object(at: i) as AnyObject).value(forKey: "card_number") is NSNull {
                         //                        } else {
                         //                            print((self.Arr.object(at:i) as AnyObject).value(forKey: "name"),i)
                         //                            self.AppendArr.add(self.Arr[i])
                         //                        }
                         //
                         //                    }
                         //
                         //                    print(self.AppendArr)
                         
                         
                         if self.AppendArr.count != 0 {
                             
                            
    //                            let contentOffset = self.eventTblView.contentOffset
    //
    //                            self.eventTblView.layoutIfNeeded()
    //                            self.eventTblView.setContentOffset(contentOffset, animated: false)
    //                            self.tblHeight.constant =  CGFloat(126 * self.AppendArr.count)
    //
                           // self.statusLbl.isHidden = true
    //                         self.upcomingLblHeight.constant = 21
    //                         self.upcominglbl.isHidden = false
    //                         self.upcomingCollHeight.constant = 100
    //                         self.upcomingLineHeight.constant = 2
                            self.upcomingCollView.isHidden = false
                             self.firstView.isHidden = false
                             self.firstViewHeight.constant = 157
                            self.upcomingCollView.reloadData()
                             self.fetch_past_events()
                          //  self.tblHeight.constant = 400
                        
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                            

    //                         self.upcomingLblHeight.constant = 0
    //                         self.upcominglbl.isHidden = true
    //                         self.upcomingCollHeight.constant = 0
    //                         self.upcomingLineHeight.constant = 0
                            self.upcomingnheight.constant = 0
                             self.firstView.isHidden = true
                             self.firstViewHeight.constant = 0
                              self.upcomingCollView.isHidden = false
                           // self.statusLbl.isHidden = false
                           // self.statusLbl.text = "No upcoming events"
                            //  self.tblHeight.constant = 100
                          //  self.upcomingCollView.reloadData()
                             self.fetch_past_events()
                          //  self.tblHeight.constant = 0
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

    //MARK: fetch_past_events ;
        func fetch_past_events()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
    //        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //        hud.mode = MBProgressHUDMode.indeterminate
    //        hud.self.bezelView.color = UIColor.black
    //        hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "friend_rid") as! String
            
            print("123",uID)
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_past_events", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                         self.fetch_past_events()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                     do  {
                        self.pastArr = NSMutableArray()
                         self.pastArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                         //                    print(self.Arr.count)
                         //                    print(self.Arr)
                         //                    self.AppendArr = NSMutableArray()
                         //                    for i in 0...self.Arr.count-1
                         //                    {
                         //                        if (self.Arr.object(at: i) as AnyObject).value(forKey: "card_number") is NSNull {
                         //                        } else {
                         //                            print((self.Arr.object(at:i) as AnyObject).value(forKey: "name"),i)
                         //                            self.AppendArr.add(self.Arr[i])
                         //                        }
                         //
                         //                    }
                         //
                         //                    print(self.AppendArr)
                         
                         
                         if self.pastArr.count != 0 {
                             
                            
    //                            let contentOffset = self.eventTblView.contentOffset
    //
    //                            self.eventTblView.layoutIfNeeded()
    //                            self.eventTblView.setContentOffset(contentOffset, animated: false)
    //                            self.tblHeight.constant =  CGFloat(126 * self.AppendArr.count)
    //
                           // self.statusLbl.isHidden = true
    //                         self.patsLblHeight.constant = 21
    //                         self.pastLbl.isHidden = false
    //                         self.pastCollHeight.constant = 290
                             self.secondView.isHidden = false
                             self.secondViewHeight.constant = 299
                            self.pastCollView.isHidden = false
                            //self.tblHeight.constant = 400
                            self.pastCollView.reloadData()
                             self.eventCountlbl.text = String(self.pastArr.count)
                            self.fetch_user_category()
                            
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                             self.pastnHeight.constant = 0
                             self.eventCountlbl.text = String(self.pastArr.count)
    //                         self.patsLblHeight.constant = 0
    //                         self.pastLbl.isHidden = true
    //                         self.pastCollHeight.constant = 0
                             self.secondView.isHidden = false
                             self.secondViewHeight.constant = 0
                              self.pastCollView.isHidden = false
                         //   self.statusLbl.isHidden = false
                           // self.statusLbl.text = "No past events"
                            //self.tblHeight.constant = 100
                         //  self.pastCollView.reloadData()
                             self.fetch_user_category()
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

    //MARK: fetch_user_category ;
        func fetch_user_category()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
    //        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //        hud.mode = MBProgressHUDMode.indeterminate
    //        hud.self.bezelView.color = UIColor.black
    //        hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
            
            print("123",uID)
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_user_category", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                         self.fetch_user_category()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                     do  {
                        self.cateArr = NSMutableArray()
                         self.cateArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                         //                    print(self.Arr.count)
                         //                    print(self.Arr)
                         //                    self.AppendArr = NSMutableArray()
                         //                    for i in 0...self.Arr.count-1
                         //                    {
                         //                        if (self.Arr.object(at: i) as AnyObject).value(forKey: "card_number") is NSNull {
                         //                        } else {
                         //                            print((self.Arr.object(at:i) as AnyObject).value(forKey: "name"),i)
                         //                            self.AppendArr.add(self.Arr[i])
                         //                        }
                         //
                         //                    }
                         //
                         //                    print(self.AppendArr)
                         
                         
                         if self.cateArr.count != 0 {
                             
                            
    //                            let contentOffset = self.eventTblView.contentOffset
    //
    //                            self.eventTblView.layoutIfNeeded()
    //                            self.eventTblView.setContentOffset(contentOffset, animated: false)
    //                            self.tblHeight.constant =  CGFloat(126 * self.AppendArr.count)
    //
                           // self.statusLbl.isHidden = true
                            // self.catetoproHeight.constant = 20
    //                         self.upcomingLblHeight.constant = 0
    //                         self.upcomingCollHeight.constant = 0
    //                         self.upcomingLblHeight.constant = 0
                           //  self.pastToupcomingHeight.constant = 10
                          //   self.pastcollTopasteventHeight.constant = 10
    //                         self.categoryLblHeight.constant = 21
    //                         self.categoryLbl.isHidden = false
    //                         self.categoryCollHeight.constant = 80
    //                         self.categoryLineLblHeight.constant = 2
                           
                          
                             self.thirdView.isHidden = false
                             self.thirdViewHeight.constant = 137
                             self.categoryCollView.isHidden = false

                            //self.tblHeight.constant = 400
                             self.categoryCollView.reloadData()
                             self.loadingView.isHidden = true
                         //    self.pastToupcomingHeight.constant = 10
                            // self.eventHeight.constant = 200
                            // self.tabBarController?.tabBar.isHidden = false
                            // self.tabBarController?.tabBar.backgroundColor = UIColor.black
                             self.fetch_block_unblock_user()
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
    //                         self.categoryLblHeight.constant = 0
    //                         self.categoryLbl.isHidden = true
    //                         self.categoryCollHeight.constant = 0
    //                         self.categoryLineLblHeight.constant = 0
                           
                             self.categoryLblHeight.constant = 0
                             self.thirdView.isHidden = true
                             self.thirdViewHeight.constant = 0
                              self.categoryCollView.isHidden = true
                             //self.pastToupcomingHeight.constant = 10
                             //self.eventHeight.constant = 200
                         //   self.statusLbl.isHidden = false
                           // self.statusLbl.text = "No past events"
                            //self.tblHeight.constant = 100
                           self.categoryCollView.reloadData()
                             self.loadingView.isHidden = true
                             self.fetch_block_unblock_user()
                           //  self.tabBarController?.tabBar.isHidden = false
                            // self.tabBarController?.tabBar.backgroundColor = UIColor.black
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


   
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == upcomingCollView
        {
            return AppendArr.count
        }
        else if collectionView == pastCollView
        {
            return pastArr.count
        }
        else
        {
            return cateArr.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == upcomingCollView
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 10
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.upcomingCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: 188, height: 90)
                //188 ,90
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else  if collectionView == pastCollView
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 15
            
            let totalSpacing = (2 * self.spacing1) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.pastCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
              //  220,250
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 10
            
            let totalSpacing = (2 * self.spacing2) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.categoryCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: 188, height: 90)
                //188 ,90
            }else{
                return CGSize(width: 0, height: 0)
            }
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == upcomingCollView
        {
            let cell = upcomingCollView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCollectionViewCell", for: indexPath) as! UpcomingEventsCollectionViewCell
            
            cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
            let r:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "remain_days")as! String
            
            cell.remainingLbl.text = "In " + r + " days"
            
            return cell
        }
        else if collectionView == pastCollView
        {
            let cell = pastCollView.dequeueReusableCell(withReuseIdentifier: "PastEventsCollectionViewCell", for: indexPath) as! PastEventsCollectionViewCell
                        let eimg:String = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
            
                        if eimg == ""
                        {
                           cell.eventImgLbl.image = UIImage(named: "edefault")
            
                        }
                           else
                        {
                           let url = URL(string: eimg)
                           let processor = DownsamplingImageProcessor(size: cell.eventImgLbl.bounds.size)
                                        |> RoundCornerImageProcessor(cornerRadius: 0)
                           cell.eventImgLbl.kf.indicatorType = .activity
                           cell.eventImgLbl.kf.setImage(
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
                                cell.eventImgLbl.image = UIImage(named: "edefault")
                               }
                           }
            
                        }
            
                        
                        cell.eventNameLbl.text = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
            return cell
        }
        else
        {
            let cell = categoryCollView.dequeueReusableCell(withReuseIdentifier: "ProfileCategoriesCollectionViewCell", for: indexPath) as! ProfileCategoriesCollectionViewCell
            
            cell.cateLbl.text = (cateArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
            

            return cell
        }

    }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == upcomingCollView
            {
                let pn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
                let add = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
                let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
                let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
                let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
                let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
                let ai = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img") as! String
                let en = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
                let aid = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id") as! String
                let eid = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_id") as! String
                let tp = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "ticket_price") as! String

                let lat = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "lat") as! String

                let long = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "lng") as! String



                let scn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String

                let n = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist")as! String

                let cn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String

                let ai1 = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String

                let aimg = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
                let ec = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
                let pid = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String

                let spr = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
                if spr == ""
                {
                    providerRating = "0" + "/5"
                }
                else
                {
                    providerRating = spr + "/5"
                }

                let ar = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_avg_rating")as! String
                if ar == ""
                {
                    artistRating = "0" + "/5"
                }
                else
                {
                    artistRating = ar + "/5"
                }
                UserDefaults.standard.setValue(od, forKey: "e_opend")
                UserDefaults.standard.setValue(ot, forKey: "e_opent")
                UserDefaults.standard.setValue(cd, forKey: "e_closed")
                UserDefaults.standard.setValue(ct, forKey: "e_closet")

                UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
                UserDefaults.standard.setValue(n, forKey: "Event_name")
                UserDefaults.standard.setValue(cn, forKey: "Event_cat")
                UserDefaults.standard.setValue(ai1, forKey: "Event_artid")
                UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
                UserDefaults.standard.setValue(providerRating, forKey: "Event_providerrating")
                UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
                UserDefaults.standard.setValue(pid, forKey: "V_id")



                let f = od + " to " + cd + " timing " + ot + " to " + ct
                UserDefaults.standard.setValue(pn, forKey: "e_providername")
                UserDefaults.standard.setValue(add, forKey: "e_provideradd")
                UserDefaults.standard.setValue(f, forKey: "e_time")
                UserDefaults.standard.setValue(ai, forKey: "e_profile")
                UserDefaults.standard.setValue(en, forKey: "e_name")
                UserDefaults.standard.setValue(aid, forKey: "Event_artid")
                UserDefaults.standard.setValue(eid, forKey: "Event_id")
                UserDefaults.standard.setValue(tp, forKey: "Event_ticketprice")
                UserDefaults.standard.setValue(lat, forKey: "Event_lat")
                UserDefaults.standard.setValue(long, forKey: "Event_long")
                UserDefaults.standard.setValue(ec, forKey: "Event_categoryname")
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
//                nextViewController.modalPresentationStyle = .fullScreen
//                self.present(nextViewController, animated:false, completion:nil)
    //            let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
    //            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    //            self.present(alert, animated: true, completion: nil)
            }
            else if collectionView == pastCollView
            {
                let pn = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
                let add = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
                let od = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
                let cd = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
                let ot = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
                let ct = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
                let ai = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img") as! String
                let en = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
                let aid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id") as! String
                let eid = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_id") as! String
                let tp = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "ticket_price") as! String

                let lat = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "lat") as! String

                let long = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "lng") as! String



                let scn = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String

                let n = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist")as! String

                let cn = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String

                let ai1 = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String

                let aimg = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
                let ec = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
                let pid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String

                let spr = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
                if spr == ""
                {
                    providerRating = "0" + "/5"
                }
                else
                {
                    providerRating = spr + "/5"
                }

                let ar = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_avg_rating")as! String
                if ar == ""
                {
                    artistRating = "0" + "/5"
                }
                else
                {
                    artistRating = ar + "/5"
                }
                UserDefaults.standard.setValue(od, forKey: "e_opend")
                UserDefaults.standard.setValue(ot, forKey: "e_opent")
                UserDefaults.standard.setValue(cd, forKey: "e_closed")
                UserDefaults.standard.setValue(ct, forKey: "e_closet")

                UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
                UserDefaults.standard.setValue(n, forKey: "Event_name")
                UserDefaults.standard.setValue(cn, forKey: "Event_cat")
                UserDefaults.standard.setValue(ai1, forKey: "Event_artid")
                UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
                UserDefaults.standard.setValue(providerRating, forKey: "Event_providerrating")
                UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
                UserDefaults.standard.setValue(pid, forKey: "V_id")



                let f = od + " to " + cd + " timing " + ot + " to " + ct
                UserDefaults.standard.setValue(pn, forKey: "e_providername")
                UserDefaults.standard.setValue(add, forKey: "e_provideradd")
                UserDefaults.standard.setValue(f, forKey: "e_time")
                UserDefaults.standard.setValue(ai, forKey: "e_profile")
                UserDefaults.standard.setValue(en, forKey: "e_name")
                UserDefaults.standard.setValue(aid, forKey: "Event_artid")
                UserDefaults.standard.setValue(eid, forKey: "Event_id")
                UserDefaults.standard.setValue(tp, forKey: "Event_ticketprice")
                UserDefaults.standard.setValue(lat, forKey: "Event_lat")
                UserDefaults.standard.setValue(long, forKey: "Event_long")
                UserDefaults.standard.setValue(ec, forKey: "Event_categoryname")
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
//                nextViewController.modalPresentationStyle = .fullScreen
//                self.present(nextViewController, animated:false, completion:nil)
    //            let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
    //            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    //            self.present(alert, animated: true, completion: nil)
            }
        }

    }
   
