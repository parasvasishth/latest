//
//  NewArtistProfileVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 03/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewArtistProfileVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

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
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var spotifyObj: UIButton!
   
    @IBOutlet weak var instaObj: UIButton!
    @IBOutlet weak var twitterObj: UIButton!
    @IBOutlet weak var pentaObj: UIButton!
    @IBOutlet weak var cloudObj: UIButton!
    @IBOutlet weak var upcomingLbl: UILabel!
    @IBOutlet weak var pastlbl: UILabel!
    @IBOutlet weak var categorylbl: UILabel!
    @IBOutlet weak var categoryLineLbl: UILabel!
    var catArray:NSArray = NSArray()
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    var pastArr:NSMutableArray = NSMutableArray()
    private let spacing:CGFloat = 10.0
    private let spacing1:CGFloat = 15.0
    private let spacing2:CGFloat = 10.0
    var providerRating:String = ""
    var artistRating:String = ""
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
        categoryCollView.delegate = self
        categoryCollView.dataSource = self
        
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
        layout1.sectionInset = UIEdgeInsets(top: 5, left: spacing1, bottom: spacing1, right: spacing1)
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

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        ratingLbl.isUserInteractionEnabled = true
        ratingLbl.addGestureRecognizer(tapGestureRecognizer)
        
        fetch_artist_register()
        // Do any additional setup after loading the view.
    }
    
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
            let url = URL(string: urlString)
            else { return false }

        if !UIApplication.shared.canOpenURL(url) { return false }

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //UserDefaults.standard.set(true, forKey: "artistsidereview")
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewArtistReviewListVC") as! NewArtistReviewListVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
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
    
    @IBAction func rating(_ sender: UIButton) {
//        UserDefaults.standard.set(true, forKey: "artistsidereview")
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewArtistRatingVC") as! NewArtistRatingVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        self.hideView.isHidden = false
        self.logoutView.isHidden = false
        self.cancelObj.isHidden = false
    }
    
    @IBAction func switchBtn(_ sender: UIButton) {
//        DispatchQueue.main.async {
//           self.tabBarController?.selectedIndex = 1
//        }
        UserDefaults.standard.set(false, forKey: "ArtistLogin")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
    //    nextViewController.tabBarController?.selectedIndex = 3
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)

        
//        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//        signuCon.modalPresentationStyle = .fullScreen
//        self.tabBarController?.selectedIndex = 3
//        self.present(signuCon, animated: false, completion:nil)
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewArtistEditProfileVC") as! NewArtistEditProfileVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func spotify(_ sender: UIButton) {
        if spotify.isValidURL() == true
         {
            let appURL = URL(string: spotify)!
            let application = UIApplication.shared

            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                let webURL = URL(string: spotify)!
                application.open(webURL)
            }
        }
         else
         {
             let alert = UIAlertController(title: "", message: "Invalid Profile", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
    }
    @IBAction func insta(_ sender: UIButton) {
     //   let Username =  "ankushgupta646" // Your Instagram Username here
           
//        if let url = URL(string: "insta") {
//            UIApplication.shared.open(url)
//        }
     //   insta = "251411"
//        if canOpenURL(insta) {
//
//
//            if let url = URL(string: insta) {
//                UIApplication.shared.open(url)
//            }
//
//        } else {
//            print("invalid url.") // This line executes
//        }
        
      
 
       if insta.isValidURL() == true
        {
           let appURL = URL(string: insta)!
           let application = UIApplication.shared

           if application.canOpenURL(appURL) {
               application.open(appURL)
           } else {
               // if Instagram app is not installed, open URL inside Safari
               let webURL = URL(string: insta)!
               application.open(webURL)
           }
       }
        else
        {
            let alert = UIAlertController(title: "", message: "Invalid Profile", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
    }
    
   
    
    @IBAction func twitter(_ sender: UIButton) {
        if twitter.isValidURL() == true
         {
            let appURL = URL(string: twitter)!
            let application = UIApplication.shared

            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                let webURL = URL(string: twitter)!
                application.open(webURL)
            }
        }
         else
         {
             let alert = UIAlertController(title: "", message: "Invalid Profile", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
             
    }
    @IBAction func penta(_ sender: UIButton) {
        if penta.isValidURL() == true
         {
            let appURL = URL(string: penta)!
            let application = UIApplication.shared

            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                let webURL = URL(string: penta)!
                application.open(webURL)
            }
        }
         else
         {
             let alert = UIAlertController(title: "", message: "Invalid Profile", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
             
    }
    @IBAction func cloud(_ sender: UIButton) {
        if cloud.isValidURL() == true
         {
            let appURL = URL(string: cloud)!
            let application = UIApplication.shared

            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                let webURL = URL(string: cloud)!
                application.open(webURL)
            }
        }
         else
         {
             let alert = UIAlertController(title: "", message: "Invalid Profile", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.hideView.isHidden = true
        self.logoutView.isHidden = true
        self.cancelObj.isHidden = true
    }
    @IBAction func back(_ sender: UIButton) {
//        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//        signuCon.modalPresentationStyle = .fullScreen
//        self.present(signuCon, animated: false, completion:nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - fetch_artist_register
    func fetch_artist_register()
    {

    //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //hud.mode = MBProgressHUDMode.indeterminate
    //hud.self.bezelView.color = UIColor.black
    //hud.label.text = "Loading...."
    //    self.loadingView.isHidden = false
    Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_register", method: .post, parameters: ["artist_id" : UserDefaults.standard.value(forKey: "ap_artId") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                 
                    var n:String = json["name"] as! String
                    self.upcomingLbl.text = "Upcoming Event"
                    self.pastlbl.text = "Event History"
                    self.categorylbl.text = "Categories"
 
                    self.catArray = json["category_detail"] as! NSArray
                  
                    self.categoryCountLbl.text = String(self.catArray.count)
                  
                    
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
                         self.instaObj.setImage(UIImage(named: "binsta"), for: .normal)
                         self.insta = json["instagram"] as! String
                    }
                    else
                    {
                        self.instaObj.setImage(UIImage(named: "i"), for: .normal)
                        self.insta = json["instagram"] as! String
                    }
                    
                    if json["twitter"] as! String == ""
                    {
                        self.twitterObj.setImage(UIImage(named: "btwitter"), for: .normal)
                        self.twitter = json["twitter"] as! String
                    }
                    else
                    {
                        self.twitterObj.setImage(UIImage(named: "twitter"), for: .normal)
                        self.twitter = json["twitter"] as! String
                    }
                     if json["band_camp"] as! String == ""
                    {
                         self.pentaObj.setImage(UIImage(named: "bpenta"), for: .normal)
                         self.penta = json["band_camp"] as! String
                    }
                    else
                    {
                        self.pentaObj.setImage(UIImage(named: "penta"), for: .normal)
                        self.penta = json["band_camp"] as! String
                    }
                    if json["sound_cloud"] as! String == ""
                   {
                        self.cloudObj.setImage(UIImage(named: "bcloud"), for: .normal)
                        self.cloud = json["sound_cloud"] as! String
                   }
                   else
                   {
                       self.cloudObj.setImage(UIImage(named: "cloud"), for: .normal)
                       self.cloud = json["sound_cloud"] as! String
                   }
                    
                    
                    
                    self.followersCountLbl.text = json["total_artist_follow"] as! String
                    self.ratingLbl.text = json["avg_rating"] as! String
                    if self.catArray.count != 0
                    {
                        self.thirdView.isHidden = false
                        self.thirdViewHeight.constant = 137
                        self.categoryCollView.isHidden = false
                        self.categoryLineLbl.isHidden = false

                       //self.tblHeight.constant = 400
                        self.categoryCollView.reloadData()
                    }
                    else
                    {
                        //self.categoryLblHeight.constant = 0
                        self.thirdView.isHidden = false
                        self.thirdViewHeight.constant = 30
                         self.categoryCollView.isHidden = true
                        self.categoryLineLbl.isHidden = true
                    }
                    
                 
                    
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
            let uID = UserDefaults.standard.value(forKey: "ap_artId") as! String

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

                             self.loadingView.isHidden = true
    //                         self.upcomingLblHeight.constant = 0
    //                         self.upcominglbl.isHidden = true
    //                         self.upcomingCollHeight.constant = 0
    //                         self.upcomingLineHeight.constant = 0
                          //  self.upcomingnheight.constant = 0
                             self.firstView.isHidden = false
                             self.firstViewHeight.constant = 60
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
            let uID = UserDefaults.standard.value(forKey: "ap_artId") as! String

            print("123",uID)

            Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_pastevent", method: .post, parameters: ["artist_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("=====1======")
                    print("Response: \(String(describing: json))")

                 if json == ""
                 {
                     MBProgressHUD.hide(for: self.view, animated: true);
                     loadingView.isHidden = true
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
                         self.eventcountlbl.text = String(self.pastArr.count)
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
                             self.secondViewHeight.constant = 260
                            self.pastCollView.isHidden = false
                             self.historyLblHeight.constant = 30
                            //self.tblHeight.constant = 400
                            self.pastCollView.reloadData()
                            //self.eventCountlbl.text = String(self.pastArr.count)
                         //   self.fetch_user_category()
                             self.loadingView.isHidden = true
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }

                         else  {
                            // self.pastnHeight.constant = 0
                            // self.eventCountlbl.text = String(self.pastArr.count)
    //                         self.patsLblHeight.constant = 0
    //                         self.pastLbl.isHidden = true
    //                         self.pastCollHeight.constant = 0
                             self.historyLblHeight.constant = 30

                             self.secondView.isHidden = false
                             self.secondViewHeight.constant = 60
                              self.pastCollView.isHidden = true
                         //   self.statusLbl.isHidden = false
                           // self.statusLbl.text = "No past events"
                            //self.tblHeight.constant = 100
                         //  self.pastCollView.reloadData()
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
            return catArray.count
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
                return CGSize(width: 188, height: 120)
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
            
            cell.venueNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
            
            
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
            
            cell.cateLbl.text = (catArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
            

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
extension String {
    var validURL: Bool {
        get {
            let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
            return predicate.evaluate(with: self)
        }
    }
}
extension String {

    private func matches(pattern: String) -> Bool {
        let regex = try! NSRegularExpression(
            pattern: pattern,
            options: [.caseInsensitive])
        return regex.firstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: utf16.count)) != nil
    }

    func isValidURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        if !UIApplication.shared.canOpenURL(url) {
            return false
        }

        let urlPattern = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
        return self.matches(pattern: urlPattern)
    }
}
