//
//  ArtistUserProfileVC.swift
//  Stumbal
//
//  Created by mac on 24/03/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class ArtistUserProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

@IBOutlet var artistTblView: UITableView!
@IBOutlet var profileImg: UIImageView!
@IBOutlet var namelbl: UILabel!
@IBOutlet var subcategoryLbl: UILabel!
@IBOutlet var categoryLbl: UILabel!
@IBOutlet var likeobj: UIButton!
@IBOutlet var followObj: UIButton!
@IBOutlet var statusLbl: UILabel!
@IBOutlet var ratingLbl: UILabel!
@IBOutlet var ratingUsernamelbl: UILabel!
@IBOutlet var tblHeight: NSLayoutConstraint!
@IBOutlet var upcoimingObj: UIButton!
@IBOutlet var pastobj: UIButton!
@IBOutlet var ratingtxtlbl: UILabel!
@IBOutlet var ratingView: FloatRatingView!
@IBOutlet var ratingtxtHeight: NSLayoutConstraint!
@IBOutlet var rausernameHeight: NSLayoutConstraint!
@IBOutlet var reviewlbl: UILabel!
@IBOutlet var reviewHeight: NSLayoutConstraint!
@IBOutlet var viewAllobj: UIButton!
@IBOutlet var viewallHeight: NSLayoutConstraint!
@IBOutlet var lbl2: UILabel!
@IBOutlet var lbl2Height: NSLayoutConstraint!
@IBOutlet var trailHeight: NSLayoutConstraint!
@IBOutlet var ratingviewHeight: NSLayoutConstraint!
@IBOutlet var pastStack: UIStackView!
var hud = MBProgressHUD()
var likeStatus:String = ""
var followStatus:String = ""
var AppendArr:NSMutableArray = NSMutableArray()
var artistreviewArr:NSMutableArray = NSMutableArray()

var pastArray:NSMutableArray = NSMutableArray()
override func viewDidLoad() {
    super.viewDidLoad()
   // UserDefaults.standard.set(true, forKey: "ArtistUpcoming_Event")
    UserDefaults.standard.set(false, forKey: "past_event")
    UserDefaults.standard.set(true, forKey: "upcoming_event")
    artistTblView.dataSource = self
    artistTblView.delegate = self
    //  fetch_artist_register()
    //    tblHeight.constant = 0
    let c = UserDefaults.standard.value(forKey: "Event_cat") as! String
    namelbl.text = UserDefaults.standard.value(forKey: "Event_name") as! String
    ratingLbl.text = UserDefaults.standard.value(forKey: "Event_artrating") as! String

    
    
    let pimg:String = UserDefaults.standard.value(forKey: "Event_artimg") as! String
    
    if pimg == ""
    {
        self.profileImg.image = UIImage(named: "adefault")
    }
    else
    {
        let url = URL(string: pimg)
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
    self.categoryLbl.text = "Category : " + c
    
    upcoimingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    pastobj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    
    
    upcoimingObj.setTitleColor(.white, for: .normal)
    pastobj.setTitleColor(.white, for: .normal)
    
    upcoimingObj.roundedButton1()
    //pastobj.roundedButton()
    DispatchQueue.main.async { [self] in
        pastobj.roundCorners(corners: [.topRight , .bottomRight], radius: 20)
        
    }
    profileImg.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    
  //  fetch_like_detail()
    // Do any additional setup after loading the view.
}
    override func viewWillAppear(_ animated: Bool) {
        upcoimingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        pastobj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        fetch_like_detail()
    }

@IBAction func viewall(_ sender: UIButton) {
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistReviewVC") as! ArtistReviewVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}
@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}
@IBAction func upcoming(_ sender: UIButton) {
   // UserDefaults.standard.set(true, forKey: "ArtistUpcoming_Event")
    //UserDefaults.standard.set(false, forKey: "ArtistPast_Event")
    UserDefaults.standard.set(false, forKey: "past_event")
    UserDefaults.standard.set(true, forKey: "upcoming_event")
    upcoimingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    pastobj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    
    
    upcoimingObj.setTitleColor(.white, for: .normal)
    pastobj.setTitleColor(.white, for: .normal)
    
    fetch_artist_upcomingevent()
}

@IBAction func pastEvent(_ sender: UIButton) {
   // UserDefaults.standard.set(false, forKey: "ArtistUpcoming_Event")
   // UserDefaults.standard.set(true, forKey: "ArtistPast_Event")
    
    UserDefaults.standard.set(true, forKey: "past_event")
    UserDefaults.standard.set(false, forKey: "upcoming_event")
    pastobj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    upcoimingObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    pastobj.setTitleColor(.white, for: .normal)
    upcoimingObj.setTitleColor(.white, for: .normal)
    
    fetch_artist_pastevent()
}
@IBAction func reviews(_ sender: UIButton) {
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "VendorRatingVC") as! VendorRatingVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

@IBAction func follow(_ sender: UIButton) {
    if sender.tag == 0
    {
        
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
        sender.tag = 1
    }
    else
    {
        
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
        sender.tag = 0
    }
}

@IBAction func like(_ sender: UIButton) {
    if sender.tag == 0
    {
        
        if likeStatus == "like"
        {
            likeStatus = "unlike"
            like_artist()
        }
        else
        {
            likeStatus = "like"
            like_artist()
            
        }
        sender.tag = 1
    }
    else
    {
        
        if likeStatus == "like"
        {
            likeStatus = "unlike"
            like_artist()
        }
        else
        {
            likeStatus = "like"
            like_artist()
            
        }
        sender.tag = 0
    }
}


//MARK: fetch_artist_review_rating ;
func fetch_artist_review_rating()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "Event_artid") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_review_rating", method: .post, parameters: ["artist_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.fetch_artist_review_rating()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.artistreviewArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.artistreviewArr.count != 0 {
                        
                        let vendor = self.artistreviewArr[0] as! NSDictionary
                        self.ratingUsernamelbl.text = vendor["name"] as! String
                        self.reviewlbl.text = vendor["review"] as! String
                        self.ratingView.rating = (vendor["rating"] as! NSString).doubleValue
                        
                        self.ratingtxtHeight.constant = 21
                        self.ratingviewHeight.constant = 30
                        self.rausernameHeight.constant = 21
                        self.reviewHeight.constant = 21
                        self.viewallHeight.constant = 40
                        self.lbl2Height.constant = 1
                        
                        self.ratingView.isHidden = false
                        self.ratingtxtlbl.text = "Rating & Reviews"
                        self.viewAllobj.isHidden = false
                        self.pastStack.isHidden = false
                        self.lbl2.isHidden = false
                        
                        self.fetch_artist_upcomingevent()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.ratingtxtHeight.constant = 0
                        self.ratingviewHeight.constant = 0
                        self.rausernameHeight.constant = 0
                        self.reviewHeight.constant = 0
                        self.viewallHeight.constant = 0
                        self.lbl2Height.constant = 0
                        self.trailHeight.constant = 20
                        
                        self.ratingView.isHidden = true
                        self.viewAllobj.isHidden = true
                        
                        self.pastStack.isHidden = false
                        self.lbl2.isHidden = true
                        
                        self.fetch_artist_upcomingevent()
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

// MARK: - fetch_like_detail
func fetch_like_detail()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=fetch_like_detail", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"artist_id":UserDefaults.standard.value(forKey: "Event_artid") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.fetch_like_detail()
                }))
                self.present(alert, animated: false, completion: nil)
            }
            else
            {  if let json: NSDictionary = response.result.value as? NSDictionary
            
            {
                
                self.likeStatus = json["status"] as! String
                
                if self.likeStatus == "like"
                {
                    self.likeobj.setTitle("Liked", for: .normal)
                }
                else
                {
                    self.likeobj.setTitle("Like", for: .normal)
                }
                
                self.fetch_follow_detail()
                
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            }
        }
    }
    
}

// MARK: - fetch_follow_detail
func fetch_follow_detail()
{
    
    //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //    hud.mode = MBProgressHUDMode.indeterminate
    //    hud.self.bezelView.color = UIColor.black
    //    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=fetch_follow_detail", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"artist_id":UserDefaults.standard.value(forKey: "Event_artid") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.followObj.setTitle("Followed", for: .normal)
                    }
                    else
                    {
                        self.followObj.setTitle("Follow", for: .normal)
                    }
                    self.fetch_artist_review_rating()
                    // MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
}

func like_artist()
{
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    Alamofire.request("https://stumbal.com/process.php?action=like_artist", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"artist_id":UserDefaults.standard.value(forKey: "Event_artid") as! String,"status":likeStatus],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                    self.like_artist()
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
                        self.likeStatus = json["status"] as! String
                        
                        
                        if self.likeStatus == "like"
                        {
                            self.likeobj.setTitle("Liked", for: .normal)
                        }
                        else
                        {
                            
                            self.likeobj.setTitle("Like", for: .normal)
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

func follow_artist()
{
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
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
                        
                        if self.followStatus == "follow"
                        {
                            self.followObj.setTitle("Followed", for: .normal)
                        }
                        else
                        {
                            
                            self.followObj.setTitle("Follow", for: .normal)
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

//MARK: fetch_artist_upcomingevent ;
func fetch_artist_upcomingevent()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    //        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //        hud.mode = MBProgressHUDMode.indeterminate
    //        hud.self.bezelView.color = UIColor.black
    //        hud.label.text = "Loading...."
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
                let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                    self.fetch_artist_upcomingevent()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.AppendArr = NSMutableArray()
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    
                    if self.AppendArr.count != 0 {
                        
                        //                            let contentOffset = self.artistTblView.contentOffset
                        //
                        //                            self.artistTblView.layoutIfNeeded()
                        //                            self.artistTblView.setContentOffset(contentOffset, animated: false)
                        //                            self.tblHeight.constant =  CGFloat(139 * self.AppendArr.count)
                        //
                        // self.statusLbl.isHidden = true
                        self.artistTblView.isHidden = false
                        self.tblHeight.constant = 337
                        self.artistTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.artistTblView.isHidden = false
                        self.artistTblView.reloadData()
                        //self.statusLbl.isHidden = false
                        // self.statusLbl.text = "No upcoming events"
                        self.tblHeight.constant = 100
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

//MARK: fetch_artist_pastevent ;
func fetch_artist_pastevent()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "Event_artid") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_pastevent", method: .post, parameters: ["artist_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.fetch_artist_pastevent()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                self.pastArray = NSMutableArray()
                do  {
                    
                    self.pastArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    self.AppendArr = NSMutableArray()
                    if self.pastArray.count != 0
                    {
                        
                        for i in 0...self.pastArray.count-1
                        {
                            if (self.pastArray.object(at: i) as AnyObject).value(forKey: "provider_name") as! String == "" {
                            } else {
                                print((self.pastArray.object(at:i) as AnyObject).value(forKey: "provider_name"),i)
                                self.AppendArr.add(self.pastArray[i])
                            }
                            
                        }
                        
                        if self.AppendArr.count != 0 {
                            
                            // self.statusLbl.isHidden = true
                            
                            //                            let contentOffset = self.artistTblView.contentOffset
                            //
                            //                            self.artistTblView.layoutIfNeeded()
                            //                            self.artistTblView.setContentOffset(contentOffset, animated: false)
                            //                            self.tblHeight.constant =  CGFloat(139 * self.AppendArr.count)
                            //self.statusLbl.isHidden = true
                            self.artistTblView.isHidden = false
                            self.tblHeight.constant = 337
                            self.artistTblView.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                        
                        else  {
                            
                            
                            self.artistTblView.isHidden = false
                            //  self.statusLbl.text = "No past events"
                            self.tblHeight.constant = 100
                            //  self.statusLbl.isHidden = false
                            self.artistTblView.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        
                    }
                    else
                    {
                        self.artistTblView.isHidden = false
                        self.tblHeight.constant = 100
                        self.artistTblView.reloadData()
                        // self.tblHeight.constant = 0
                        // self.statusLbl.isHidden = false
                        //self.statusLbl.text = "No past events"
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    
                    
                }
                catch
                {
                    print("error")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
            }
            
            
        }
    }
    
}


//MARK: tableView Methode
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
//      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//          self.viewWillLayoutSubviews()
//      }
//

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // return AppendArr.count
  
    if AppendArr.count == 0 {
        if UserDefaults.standard.bool(forKey: "upcoming_event") == true
        {
            self.artistTblView.setEmptyMessage("No upcoming events")
        }
        else
        {
            self.artistTblView.setEmptyMessage("No past events")
        }
        
        
    } else {
        self.artistTblView.restore()
    }
    
    return AppendArr.count
    
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  artistTblView.dequeueReusableCell(withIdentifier: "EventTblCell", for: indexPath) as! EventTblCell
    
    
    cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
    
    cell.eventAddressLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
    
    cell.vendorNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
    
    cell.categorylbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
    
//    let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
//
//
//    if eimg == ""
//    {
//        cell.eventImg.image = UIImage(named: "edefault")
//
//    }
//    else
//    {
//        let url = URL(string: eimg)
//        let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
//            |> RoundCornerImageProcessor(cornerRadius: 0)
//        cell.eventImg.kf.indicatorType = .activity
//        cell.eventImg.kf.setImage(
//            with: url,
//            placeholder: nil,
//            options: [
//                .processor(processor),
//                .scaleFactor(UIScreen.main.scale),
//                .transition(.fade(1)),
//                .cacheOriginalImage
//            ])
//        {
//            result in
//            switch result {
//            case .success(let value):
//                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//                cell.eventImg.image = UIImage(named: "edefault")
//            }
//        }
//
//    }
    
    
    //
    // cell..addRightBorder(borderColor: UIColor.white, borderWidth: 1.0)
    
    
    
    let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
    let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
    let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
    let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
 //   cell.eventTimelbl.text = od + " to " + cd + " timing " + ot + " to " + ct
    
    return cell
}

var providerRating:String = ""
var artistRating:String = ""

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

}
extension UIButton {

func addRightBorder(borderColor: UIColor, borderWidth: CGFloat) {
    let border = CALayer()
    border.backgroundColor = borderColor.cgColor
    border.frame = CGRect(x: self.frame.size.width - borderWidth,y: 0, width:borderWidth, height:self.frame.size.height)
    self.layer.addSublayer(border)
}

func addLeftBorder(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
    self.layer.addSublayer(border)
}
}
