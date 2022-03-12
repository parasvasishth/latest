//
//  NewArtistUserProfileVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 03/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewArtistUserProfileVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var eventcountlbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var categoryCountLbl: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var upcomingCollView: UICollectionView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var pastCollView: UICollectionView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
    @IBOutlet weak var historyLblHeight: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var cancelObj: UIButton!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var switchObj: UIButton!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var unfollowobj: UIButton!
    @IBOutlet weak var blockObj: UIButton!
    @IBOutlet weak var reportObj: UIButton!
    @IBOutlet weak var ratinglbl: UILabel!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var followLbl: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var userBlockedObj: UIButton!
    @IBOutlet weak var spotifyObj: UIButton!
    @IBOutlet weak var instaobj: UIButton!
    @IBOutlet weak var twitterobj: UIButton!
    @IBOutlet weak var pentaobj: UIButton!
    @IBOutlet weak var cloudobj: UIButton!
    var catArray:NSArray = NSArray()
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    var pastArr:NSMutableArray = NSMutableArray()
    private let spacing:CGFloat = 10.0
    private let spacing1:CGFloat = 10.0
    private let spacing2:CGFloat = 10.0
    var followStatus:String = ""
    var blockStatus:String = ""
    var spotify:String = ""
    var twitter:String = ""
    var cloud:String = ""
    var insta:String = ""
    var penta:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.isHidden = false
        upcomingCollView.delegate = self
        upcomingCollView.dataSource = self
        pastCollView.delegate = self
        pastCollView.dataSource = self
      //  categoryCollView.delegate = self
      //  categoryCollView.dataSource = self

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

      //  let layout2 = UICollectionViewFlowLayout()
        //layout2.sectionInset = UIEdgeInsets(top: spacing2, left: spacing2, bottom: spacing2, right: spacing2)
      //  layout2.minimumLineSpacing = spacing2
        //layout2.minimumInteritemSpacing = spacing2
       // layout2.scrollDirection = .horizontal
       // self.categoryCollView?.collectionViewLayout = layout2

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        ratinglbl.isUserInteractionEnabled = true
        ratinglbl.addGestureRecognizer(tapGestureRecognizer)
        
        fetch_artist_register()

        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewArtistRatingVC") as! NewArtistRatingVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func ratingBtn(_ sender: UIButton) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VendorReviewsVC") as! VendorReviewsVC
//        nextViewController.modalPresentationStyle = .fullScreen
//        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func unfollow(_ sender: UIButton) {
        
        if followStatus == "follow"
        {
            followStatus = "unfollow"
            follow_artist()
        
        }
        else
        {
            followStatus = "follow"
            follow_artist()
        }
        
    }
    @IBAction func dismissBtn(_ sender: UIButton) {
        self.logoutView.isHidden = true
        self.blockView.isHidden = true
        self.hideView.isHidden = true
    }
    @IBAction func logout(_ sender: UIButton) {
        
    }
    
    @IBAction func followBtn(_ sender: UIButton) {
        if followStatus == "follow"
        {
            followStatus = "unfollow"
            follow_artist()
        
        }
        else
        {
            followStatus = "follow"
            follow_artist()
        }
    }
    
    @IBAction func report(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func block(_ sender: UIButton) {
        if blockStatus == "block"
        {
            blockStatus = "unblock"
            logoutView.isHidden = true
            cancelObj.isHidden = true
            blockView.isHidden = false
            userBlockedObj.setTitle("User Unblocked", for: .normal)
            block_unblock_artist()
        }
        else
        {
            blockStatus = "block"
            logoutView.isHidden = true
            cancelObj.isHidden = true
            blockView.isHidden = false
            userBlockedObj.setTitle("User Blocked", for: .normal)
            block_unblock_artist()
        }
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        self.hideView.isHidden = false
        self.logoutView.isHidden = false
        self.cancelObj.isHidden = false
    }
    @IBAction func switchBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        
    }
    
    @IBAction func spotify(_ sender: UIButton) {
    }
    @IBAction func insta(_ sender: UIButton) {
    }
    @IBAction func twitter(_ sender: UIButton) {
    }
    @IBAction func penta(_ sender: UIButton) {
    }
    @IBAction func cloud(_ sender: UIButton) {
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.hideView.isHidden = true
        self.logoutView.isHidden = true
        self.cancelObj.isHidden = true
    }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - fetch_follow_detail
    func fetch_follow_detail()
    {
        
 
        Alamofire.request("https://stumbal.com/process.php?action=fetch_follow_detail", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"artist_id":UserDefaults.standard.value(forKey: "Event_artid") as! String], encoding:  URLEncoding.httpBody).responseJSON
        { response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                
                print("Response: \(String(describing: json))")
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.fetch_follow_detail()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        
                        self.followStatus = json["status"] as! String
                        
                        
                        if self.followStatus == "follow"
                        {
                            
                            self.unfollowobj.setTitle("Unfollow", for: .normal)
                            self.followLbl.text = "Following"
                        }
                        else
                        {
                            self.unfollowobj.setTitle("Follow", for: .normal)
                            self.followLbl.text = "Follow"
                        }
                      
                        // MBProgressHUD.hide(for: self.view, animated: true)
                        self.fetch_block_unblock_artist()
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

    
    // MARK: - fetch_block_unblock_artist
    func fetch_block_unblock_artist()
    {
        
        //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //    hud.mode = MBProgressHUDMode.indeterminate
        //    hud.self.bezelView.color = UIColor.black
        //    hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=fetch_block_unblock_artist", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"artist_id":UserDefaults.standard.value(forKey: "Event_artid") as! String], encoding:  URLEncoding.httpBody).responseJSON
        { response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                
                print("Response: \(String(describing: json))")
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.fetch_block_unblock_artist()
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
                        self.loadingView.isHidden = true
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
        
    }

    func block_unblock_artist()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=block_unblock_artist", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"artist_id":UserDefaults.standard.value(forKey: "Event_artid") as! String,"status":blockStatus],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        self.block_unblock_artist()
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

    
    func follow_artist()
    {
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=follow_artist", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"artist_id":UserDefaults.standard.value(forKey: "Event_artid") as! String,"status":followStatus],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        self.follow_artist()
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
                            
                            self.followStatus = json["status"] as! String
//                            if self.followStatus == ""
//                            {
//
//                            }
                           if self.followStatus == "follow"
                            {
                                self.unfollowobj.setTitle("Unfollow", for: .normal)
                               self.followLbl.text = "Following"
                            }
                            else
                            {
                                
                                self.unfollowobj.setTitle("Follow", for: .normal)
                                self.followLbl.text = "Follow"
                            }
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                        
                        else {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "", message: "Invalid Email Id", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    // MARK: - fetch_artist_register
    func fetch_artist_register()
    {

    //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //hud.mode = MBProgressHUDMode.indeterminate
    //hud.self.bezelView.color = UIColor.black
    //hud.label.text = "Loading...."
    //    self.loadingView.isHidden = false
    Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_register", method: .post, parameters: ["artist_id" : UserDefaults.standard.value(forKey: "Event_artid") as! String], encoding:  URLEncoding.httpBody).responseJSON
    { response in
        if let data = response.data
        {
            let json = String(data: data, encoding: String.Encoding.utf8)

            print("Response: \(String(describing: json))")
            if json == ""
            {
                MBProgressHUD.hide(for: self.view, animated: true);
                self.loadingView.isHidden = true
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

                    //                                let result:String = json["result"] as! String
                    //
                    //                                if result == "success"
                    //                                {
                self.nameLbl.text = json["name"] as! String
                 

                   // self.catArray = json["category_detail"] as! NSArray
                    self.categoryCountLbl.text = String(self.catArray.count)
                    self.followersCountLbl.text = json["total_artist_follow"] as! String
                    self.ratinglbl.text = json["avg_rating"] as! String
                   
                    
                    if json["bio"] as! String == ""
                    {
                        self.bioLbl.isHidden = true
                        self.bioLbl.text = json["bio"] as! String
                    }
                    else
                    {
                        self.bioLbl.isHidden = false
                        self.bioLbl.text = json["bio"] as! String
                    }
                    
                    if json["avg_rating"] as! String == ""
                    {
                        self.ratinglbl.text = "0.0"
                    }
                    else
                    {
                        self.ratinglbl.text = json["avg_rating"] as! String
                    }
                    
                    if json["spotify"] as! String == ""
                    {
                        self.spotifyObj.setImage(UIImage(named: "bspotify"), for: .normal)
                        self.spotify = json["spotify"] as! String
                    }
                    else
                    {
                        self.spotifyObj.setImage(UIImage(named: "spotify"), for: .normal)
                        self.spotify = json["spotify"] as! String
                    }
                     if json["instagram"] as! String == ""
                    {
                         self.instaobj.setImage(UIImage(named: "binsta"), for: .normal)
                         self.insta = json["instagram"] as! String
                    }
                    else
                    {
                        self.instaobj.setImage(UIImage(named: "i"), for: .normal)
                        self.insta = json["instagram"] as! String
                    }
                    
                    if json["twitter"] as! String == ""
                    {
                        self.twitterobj.setImage(UIImage(named: "btwitter"), for: .normal)
                        self.twitter = json["twitter"] as! String
                    }
                    else
                    {
                        self.twitterobj.setImage(UIImage(named: "twitter"), for: .normal)
                        self.twitter = json["twitter"] as! String
                    }
                     if json["band_camp"] as! String == ""
                    {
                         self.pentaobj.setImage(UIImage(named: "bpenta"), for: .normal)
                         self.penta = json["band_camp"] as! String
                    }
                    else
                    {
                        self.pentaobj.setImage(UIImage(named: "penta"), for: .normal)
                        self.penta = json["band_camp"] as! String
                    }
                    if json["sound_cloud"] as! String == ""
                   {
                        self.cloudobj.setImage(UIImage(named: "bcloud"), for: .normal)
                        self.cloud = json["sound_cloud"] as! String
                   }
                   else
                   {
                       self.cloudobj.setImage(UIImage(named: "cloud"), for: .normal)
                       self.cloud = json["sound_cloud"] as! String
                   }
                    
                    
//                    if self.catArray.count != 0
//                    {
//                        self.thirdView.isHidden = false
//                        self.thirdViewHeight.constant = 137
//                        self.categoryCollView.isHidden = false
//
//                       //self.tblHeight.constant = 400
//                        self.categoryCollView.reloadData()
//                    }
//                    else
//                    {
//                        //self.categoryLblHeight.constant = 0
//                        self.thirdView.isHidden = true
//                        self.thirdViewHeight.constant = 0
//                         self.categoryCollView.isHidden = true
//                    }
                    
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



    

    //MARK: fetch_upcoming_events ;
        func fetch_upcoming_events()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
    //            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //            hud.mode = MBProgressHUDMode.indeterminate
    //            hud.self.bezelView.color = UIColor.black
    //            hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "Event_artid") as! String

            print("123",uID)

            Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_upcomingevent", method: .post, parameters: ["artist_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                             self.firstViewHeight.constant = 182
                            self.upcomingCollView.reloadData()
                             self.fetch_past_events()
                          //  self.tblHeight.constant = 400

                             MBProgressHUD.hide(for: self.view, animated: true)
                         }

                         else  {

                          //   self.loadingView.isHidden = true
    //                         self.upcomingLblHeight.constant = 0
    //                         self.upcominglbl.isHidden = true
    //                         self.upcomingCollHeight.constant = 0
    //                         self.upcomingLineHeight.constant = 0
                          //  self.upcomingnheight.constant = 0
                             self.firstView.isHidden = true
                             self.firstViewHeight.constant = 0
                              self.upcomingCollView.isHidden = true
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
            let uID = UserDefaults.standard.value(forKey: "Event_artid") as! String

            print("123",uID)

            Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_pastevent", method: .post, parameters: ["artist_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                             self.historyLblHeight.constant = 30
                            //self.tblHeight.constant = 400
                            self.pastCollView.reloadData()
                            //self.eventCountlbl.text = String(self.pastArr.count)
                         //   self.fetch_user_category()
                             
                             fetch_follow_detail()
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }

                         else  {
                            // self.pastnHeight.constant = 0
                            // self.eventCountlbl.text = String(self.pastArr.count)
    //                         self.patsLblHeight.constant = 0
    //                         self.pastLbl.isHidden = true
    //                         self.pastCollHeight.constant = 0
                             self.historyLblHeight.constant = 0

                             self.secondView.isHidden = true
                             self.secondViewHeight.constant = 0
                              self.pastCollView.isHidden = true
                         //   self.statusLbl.isHidden = false
                           // self.statusLbl.text = "No past events"
                            //self.tblHeight.constant = 100
                         //  self.pastCollView.reloadData()
                        //  self.selectcardLbl.isHidden = true
                           //  self.loadingView.isHidden = true
                             fetch_follow_detail()
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
        else
        {
            return pastArr.count
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
                return CGSize(width: 188, height: 110)
                //188 ,90
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 10
            
            let totalSpacing = (2 * self.spacing1) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.pastCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
              //  220,250
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
            cell.venueNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
            let r:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "remain_days")as! String
            
            cell.remainingLbl.text = "In " + r + " days"
            
            return cell
        }
       else
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
       
    }
    var providerRating:String = ""
    var artistRating:String = ""
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
                let edesc = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_desc")as! String
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
                UserDefaults.standard.setValue(edesc, forKey: "Event_desc")
                

                let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewUpcomingEventDetailVC") as! NewUpcomingEventDetailVC
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:false, completion:nil)
//                let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
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
                let eid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_id") as! String
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
                let edesc = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_desc")as! String
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
                UserDefaults.standard.setValue(edesc, forKey: "Event_desc")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewPastEventDetailVC") as! NewPastEventDetailVC
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:false, completion:nil)
                
//                let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
            }
        }

}
