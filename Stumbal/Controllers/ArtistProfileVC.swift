//
//  ArtistProfileVC.swift
//  Stumbal
//
//  Created by mac on 24/03/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class ArtistProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate {


@IBOutlet var artistTblView: UITableView!
@IBOutlet var artistImg: UIImageView!
@IBOutlet var nameLbl: UILabel!
@IBOutlet var subcategoryLbl: UILabel!
@IBOutlet var categoryLbl: UILabel!
@IBOutlet var likeLbl: UILabel!
@IBOutlet var followersLbl: UILabel!
@IBOutlet var reviewLbl: UILabel!
@IBOutlet var upcomingLbl: UILabel!
@IBOutlet var pastLbl: UILabel!
@IBOutlet var statusLbl: UILabel!
@IBOutlet var upcomingObj: UIButton!
@IBOutlet var pastObj: UIButton!
@IBOutlet var profileView: UIView!
@IBOutlet var tbleHeight: NSLayoutConstraint!
var AppendArr:NSMutableArray = NSMutableArray()
var artistArray:[historyList] = []
var hud = MBProgressHUD()
var artistId:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    UserDefaults.standard.set(false, forKey: "past_event")
    UserDefaults.standard.set(true, forKey: "upcoming_event")
    //UserDefaults.standard.set(true, forKey: "ArtistUpcoming_Event")
    
    //    profileView.layer.cornerRadius = profileView.frame.height / 2
    //    profileView.layer.masksToBounds = false
    //    profileView.clipsToBounds = true
    
    UserDefaults.standard.set(false, forKey: "artistsidereview")
    
    artistTblView.dataSource = self
    artistTblView.delegate = self
    
    
    upcomingObj.roundedButton1()
    
    DispatchQueue.main.async { [self] in
        pastObj.roundCorners(corners: [.topRight , .bottomRight], radius: 20)
    }
    
    profileView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    reviewLbl.isUserInteractionEnabled = true
    reviewLbl.addGestureRecognizer(tapGestureRecognizer)
    
    
    let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
    followersLbl.isUserInteractionEnabled = true
    followersLbl.addGestureRecognizer(tapGestureRecognizer1)
    
    
    let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
    likeLbl.isUserInteractionEnabled = true
    likeLbl.addGestureRecognizer(tapGestureRecognizer2)
    
    upcomingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    
    
    upcomingObj.setTitleColor(.white, for: .normal)
    pastObj.setTitleColor(.white, for: .normal)
    
    
    
    //  tbleHeight.constant = 0
    //  middleButton.addLeftBorder(borderColor: UIColor.white, borderWidth: 1.0)
    
}


override func viewWillAppear(_ animated: Bool) {
    UserDefaults.standard.set(false, forKey: "past_event")
    UserDefaults.standard.set(true, forKey: "upcoming_event")
    upcomingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    
    check_artist_user()
}

@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
    UserDefaults.standard.set(true, forKey: "artistsidereview")
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ArtistReviewVC") as! ArtistReviewVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
}

@objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ArtistFollwersVC") as! ArtistFollwersVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
}

@objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer){
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ArtistLikeVC") as! ArtistLikeVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
}
    @IBAction func addDetail(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SendDetailVC") as! SendDetailVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    @IBAction func EditProfile(_ sender: UIButton) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UpdateArtistProfileVC") as! UpdateArtistProfileVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
    artistImg.image = UIImage(named: "e1")
}

@IBAction func upcomingEvent(_ sender: UIButton) {
    UserDefaults.standard.set(false, forKey: "past_event")
    UserDefaults.standard.set(true, forKey: "upcoming_event")
    
//    UserDefaults.standard.set(true, forKey: "ArtistUpcoming_Event")
//    UserDefaults.standard.set(false, forKey: "ArtistPast_Event")
    
    upcomingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    upcomingObj.setTitleColor(.white, for: .normal)
    pastObj.setTitleColor(.white, for: .normal)
    
    fetch_artist_upcomingevent()
}

@IBAction func pastEvent(_ sender: UIButton) {
//    UserDefaults.standard.set(false, forKey: "ArtistUpcoming_Event")
//    UserDefaults.standard.set(true, forKey: "ArtistPast_Event")
    
    UserDefaults.standard.set(true, forKey: "past_event")
    UserDefaults.standard.set(false, forKey: "upcoming_event")
    
    pastObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    upcomingObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    pastObj.setTitleColor(.white, for: .normal)
    upcomingObj.setTitleColor(.white, for: .normal)
    
    fetch_artist_pastevent()
}
@IBAction func sendProposal(_ sender: UIButton) {
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SendProposalVC") as! SendProposalVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
    
}

// MARK: - check_artist_user
func check_artist_user()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
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
                        
                        self.artistId = json["artist_id"] as! String
                        
                        self.fetch_artist_register()
                        //  MBProgressHUD.hide(for: self.view, animated: true)
                        
                    }
                    else
                    {
                        
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

// MARK: - fetch_artist_register
func fetch_artist_register()
{
    
    //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //    hud.mode = MBProgressHUDMode.indeterminate
    //    hud.self.bezelView.color = UIColor.black
    //    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_register", method: .post, parameters: ["artist_id" : artistId], encoding:  URLEncoding.httpBody).responseJSON
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
                    
                    self.nameLbl.text = json["name"] as! String
                    let c = json["category_name"] as! String
                    self.categoryLbl.text = "Category : " + c
                    //self.subcategoryLbl.text = json["sub_cat_name"] as! String
                    self.followersLbl.text = json["total_artist_follow"] as! String
                    self.likeLbl.text = json["total_artist_like"] as! String
                    self.reviewLbl.text = json["rating_count"] as! String
                    
                    UserDefaults.standard.setValue(json["artist_id"] as! String, forKey: "ap_artId")
                    
                    let eimg:String = json["artist_img"] as! String
                    
                    if eimg == ""
                    {
                        self.artistImg.image = UIImage(named: "adefault")
                        
                    }
                    else
                    {
                        let url = URL(string: eimg)
                        let processor = DownsamplingImageProcessor(size: self.artistImg.bounds.size)
                            |> RoundCornerImageProcessor(cornerRadius: 0)
                        self.artistImg.kf.indicatorType = .activity
                        self.artistImg.kf.setImage(
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
                                self.artistImg.image = UIImage(named: "adefault")
                            }
                        }
                        
                    }
                    self.fetch_artist_upcomingevent()
                    
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
}

//MARK: fetch_artist_upcomingevent ;
func fetch_artist_upcomingevent()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //    hud.mode = MBProgressHUDMode.indeterminate
    //    hud.self.bezelView.color = UIColor.black
    //    hud.label.text = "Loading...."
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
                        
                        //                        let contentOffset = self.artistTblView.contentOffset
                        //
                        //                        self.artistTblView.layoutIfNeeded()
                        //                        self.artistTblView.setContentOffset(contentOffset, animated: false)
                        //                        self.tbleHeight.constant =  CGFloat(126 * self.AppendArr.count)
                        //
                        //self.statusLbl.isHidden = true
                        self.tbleHeight.constant = 337
                        self.artistTblView.isHidden = false
                        self.artistTblView.reloadData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.artistTblView.isHidden = false
                        // self.statusLbl.isHidden = false
                        //  self.statusLbl.text = "No upcoming events"
                        self.tbleHeight.constant = 100
                        self.artistTblView.reloadData()
                        //  self.selectcardLbl.isHidden = true
                        
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

//MARK: fetch_artist_pastevent ;
func fetch_artist_pastevent()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "ap_artId") as! String
    
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
                do  {
                    self.AppendArr = NSMutableArray()
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    
                    if self.AppendArr.count != 0 {
                        //                        let contentOffset = self.artistTblView.contentOffset
                        //
                        //                        self.artistTblView.layoutIfNeeded()
                        //                        self.artistTblView.setContentOffset(contentOffset, animated: false)
                        //                        self.tbleHeight.constant =  CGFloat(126 * self.AppendArr.count)
                        //self.statusLbl.isHidden = true
                        self.tbleHeight.constant = 337
                        self.artistTblView.isHidden = false
                        self.artistTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.artistTblView.isHidden = false
                        self.artistTblView.reloadData()
                        //self.statusLbl.isHidden = false
                        // self.statusLbl.text = "No past events"
                        self.tbleHeight.constant = 100
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

var providerRating:String = ""
var artistRating:String = ""

//MARK: tableView Methode
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    self.viewWillLayoutSubviews()
}
//
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
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
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = artistTblView.dequeueReusableCell(withIdentifier: "EventTblCell", for: indexPath) as! EventTblCell
    
    
    
    if UserDefaults.standard.bool(forKey: "upcoming_event") == true
    {
        
        
        let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
        
        if eimg == ""
        {
            cell.eventImg.image = UIImage(named: "edefault")
            
        }
        else
        {
            let url = URL(string: eimg)
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
                    cell.eventImg.image = UIImage(named: "edefault")
                }
            }
            
        }
        
        cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
        cell.eventAddressLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
        
        cell.vendorNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
        
        cell.categorylbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
        
        let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
        let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
        let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
        let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
        cell.eventTimelbl.text = od + " to " + cd + " timing " + ot + " to " + ct
        
    }
    else
    {
        
        let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
        
        if eimg == ""
        {
            cell.eventImg.image = UIImage(named: "edefault")
            
        }
        else
        {
            let url = URL(string: eimg)
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
                    cell.eventImg.image = UIImage(named: "edefault")
                }
            }
            
        }
        
        
        cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
        cell.eventAddressLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
        
        cell.vendorNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
        
        cell.categorylbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
        
        let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
        let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
        let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
        let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
        cell.eventTimelbl.text = od + " to " + cd + " timing " + ot + " to " + ct
        
    }
    return cell
}

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
extension UIImageView {
var contentClippingRect: CGRect {
    guard let image = image else { return bounds }
    guard contentMode == .scaleAspectFit else { return bounds }
    guard image.size.width > 0 && image.size.height > 0 else { return bounds }
    
    let scale: CGFloat
    if image.size.width > image.size.height {
        scale = bounds.width / image.size.width
    } else {
        scale = bounds.height / image.size.height
    }
    
    let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
    let x = (bounds.width - size.width) / 2.0
    let y = (bounds.height - size.height) / 2.0
    
    return CGRect(x: x, y: y, width: size.width, height: size.height)
}
}

extension UIImageView {

var imageSizeAfterAspectFit: CGSize {
    var newWidth: CGFloat
    var newHeight: CGFloat
    
    guard let image = image else { return frame.size }
    
    if image.size.height >= image.size.width {
        newHeight = frame.size.height
        newWidth = ((image.size.width / (image.size.height)) * newHeight)
        
        if CGFloat(newWidth) > (frame.size.width) {
            let diff = (frame.size.width) - newWidth
            newHeight = newHeight + CGFloat(diff) / newHeight * newHeight
            newWidth = frame.size.width
        }
    } else {
        newWidth = frame.size.width
        newHeight = (image.size.height / image.size.width) * newWidth
        
        if newHeight > frame.size.height {
            let diff = Float((frame.size.height) - newHeight)
            newWidth = newWidth + CGFloat(diff) / newWidth * newWidth
            newHeight = frame.size.height
        }
    }
    return .init(width: newWidth, height: newHeight)
}
}

extension UIView {

func roundCorners(corners:UIRectCorner, radius: CGFloat) {
    
    DispatchQueue.main.async {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
}
