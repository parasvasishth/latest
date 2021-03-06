//
//  EventVC.swift
//  Stumbal
//
//  Created by mac on 19/03/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
import CoreLocation
class EventVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate {

@IBOutlet var menu: UIButton!
@IBOutlet var statusLbl: UILabel!
@IBOutlet var eventTblView: UITableView!
@IBOutlet var mapImg: UIImageView!
@IBOutlet weak var searchBar: UISearchBar!
@IBOutlet weak var loadingView: UIView!
var AppendArr:NSMutableArray = NSMutableArray()
var hud = MBProgressHUD()
var locationManager = CLLocationManager()
var lat:Float = 0
var long:Float = 0
var distance:String = ""
var catstring:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.tabBar.isHidden = true
    loadingView.isHidden = false
}
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    top_events_cat()
    
}
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    //backObj.isHidden = false
}
override func viewDidAppear(_ animated: Bool)
{
    print("111555")
}

override func viewDidDisappear(_: Bool)
{
    
}

// MARK: - cart Method
@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
    
    let tappedImage = tapGestureRecognizer.view as! UIImageView
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
}

override func viewWillAppear(_ animated: Bool) {
    tabBarController?.tabBar.isHidden = true
    loadingView.isHidden = false
    
    eventTblView.dataSource = self
    eventTblView.delegate = self
    
    let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
    textFieldInsideSearchBar?.textColor = UIColor.white
    
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftViewMode = .never
    searchBar.delegate = self
    if #available(iOS 13.0, *) {
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
    } else {
        // Fallback on earlier versions
    }
    if self.revealViewController() != nil {
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    
    if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
        
        //textfield.backgroundColor = UIColor.yellow
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search bar", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        textfield.setLeftPaddingPoints(5)
        textfield.clearButtonMode = .never
        
    }
    
    fecth_Profile()
    
}

// https://www.stumbal.zithera.com.au/Stumbal/process.php?action=fetch_events
@IBAction func ticket(_ sender: UIButton) {
    let tagVal : Int = sender.tag
    let eid = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "event_id")as! String
    let tp = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "ticket_price") as! String
    
    UserDefaults.standard.setValue(eid, forKey: "Event_id")
    UserDefaults.standard.setValue(tp, forKey: "Event_ticketprice")
//    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "BuyTicketVC") as! BuyTicketVC
//    signuCon.modalPresentationStyle = .fullScreen
//    self.present(signuCon, animated: false, completion:nil)
}

@IBAction func artist(_ sender: UIButton) {
    let tagVal : Int = sender.tag
    //  print(charityNameArray)
    
    let scn = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "sub_cat_name")as! String
    
    let n = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "artist")as! String
    
    let cn = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "category_name")as! String
    
    let ai = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "artist_id")as! String
    
    let aimg = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "artist_img")as! String
    
    UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
    UserDefaults.standard.setValue(n, forKey: "Event_name")
    UserDefaults.standard.setValue(cn, forKey: "Event_cat")
    UserDefaults.standard.setValue(ai, forKey: "Event_artid")
    UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
    
    let ar = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "artist_avg_rating")as! String
    if ar == ""
    {
        artistRating = "0" + "/5"
    }
    else
    {
        artistRating = ar + "/5"
    }
    
    UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
    
    if ai == ""
    {
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "BlankArtistProfileVC") as! BlankArtistProfileVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    else
    {
//        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistUserProfileVC") as! ArtistUserProfileVC
//        signuCon.modalPresentationStyle = .fullScreen
//        self.present(signuCon, animated: false, completion:nil)
        
    }
    
    
}
// MARK: - Current location Function
func  getCurrentlocationofUser(){
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
}


func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    
    let location = locations.last! as CLLocation
    var center  = CLLocationCoordinate2D()
    
    lat = Float(locValue.latitude)
    long = Float(locValue.longitude)
    
    self.fetch_events()
    locationManager.stopUpdatingLocation()
}

//MARK: top_events_cat ;
func top_events_cat()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //    hud.mode = MBProgressHUDMode.indeterminate
    //    hud.self.bezelView.color = UIColor.black
    //    hud.label.text = "Loading...."
    
    print("11",catstring)
    //  loadingView.isHidden = true
    Alamofire.request("https://stumbal.com/process.php?action=top_events_cat_multiple", method: .post, parameters: ["cat_id" :catstring,"search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.top_events_cat()
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
                        self.eventTblView.isHidden = false
                        self.eventTblView.reloadData()
                        self.loadingView.isHidden = true
                        self.tabBarController?.tabBar.isHidden = false
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.eventTblView.isHidden = true
                        self.statusLbl.isHidden = false
                        self.loadingView.isHidden = true
                        //  self.selectcardLbl.isHidden = true
                        self.tabBarController?.tabBar.isHidden = false
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

// MARK: - fecth_Profile
func fecth_Profile()
{
    
    //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //hud.mode = MBProgressHUDMode.indeterminate
    //hud.self.bezelView.color = UIColor.black
    //hud.label.text = "Loading...."
    self.loadingView.isHidden = false
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
                    self.catstring = json["category_id"] as! String
                    
                    self.top_events_cat()
                    
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


// MARK: - fetch_user_distance
func fetch_user_distance()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=fetch_user_distance", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.fetch_user_distance()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                if let json: NSDictionary = response.result.value as? NSDictionary
                    
                {
                    if json["distance"] as! String == ""
                    {
                        self.distance = "5"
                    }
                    else
                    {
                        self.distance = json["distance"] as! String
                    }
                    self.getCurrentlocationofUser()
                    
                    //  self.fetch_venue_nearby()
                    
                    //  MBProgressHUD.hide(for: self.view, animated: true)
                    
                    
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
}

//MARK: fetch_events ;
func fetch_events()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //    hud.mode = MBProgressHUDMode.indeterminate
    //    hud.self.bezelView.color = UIColor.black
    //    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_events", method: .post, parameters: ["user_id" :uID ,"distance":distance,"lat":lat,"lng":long], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.fetch_events()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.AppendArr.count != 0 {
                        
                        self.statusLbl.isHidden = true
                        self.eventTblView.isHidden = false
                        self.eventTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.eventTblView.isHidden = true
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
    return AppendArr.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  eventTblView.dequeueReusableCell(withIdentifier: "HomeEventListTableViewCell", for: indexPath) as! HomeEventListTableViewCell
   // cell.newImg.isHidden = true
    
    cell.eventimg.roundCorners5([.topLeft, .topRight], radius: 10)
    
    //    cell.eventNamelbl.layer.masksToBounds = false
    //    cell.eventNamelbl.layer.shadowColor = #colorLiteral(red: 0.1058823529, green: 0.003921568627, blue: 0.1529411765, alpha: 1)
    //    cell.eventNamelbl.layer.shadowOpacity = 0.50
    //    cell.eventNamelbl.layer.shadowRadius = 4
    //    cell.eventNamelbl.layer.cornerRadius = 2
    //
    cell.eventNameLbl.layer.masksToBounds = false
    cell.eventNameLbl.layer.shadowColor = #colorLiteral(red: 0.1058823529, green: 0.003921568627, blue: 0.1529411765, alpha: 1)
    cell.eventNameLbl.layer.shadowRadius = 2
    //cell.eventNameLbl.layer.shadowOffset =
    cell.eventNameLbl.layer.shadowOpacity = 0.80
    let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
    if eimg == ""
    {
        cell.eventimg.image = UIImage(named: "edefault")
       // cell.newImg.isHidden = false
    }
    else
    {
        let url = URL(string: eimg)
        let processor = DownsamplingImageProcessor(size: cell.eventimg.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 0)
        cell.eventimg.kf.indicatorType = .activity
        cell.eventimg.kf.setImage(
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
              //  cell.newImg.isHidden = false
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                cell.eventimg.image = UIImage(named: "edefault")
              //  cell.newImg.isHidden = false
            }
        }
        
    }
    cell.eventNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
    let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
    let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
    let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
    let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
    //  cell.eventTimelbl.text = od + " to " + cd + " timing " + ot + " to " + ct
    //    cell.artistObj.tag = indexPath.row
    //    cell.ticketObj.tag = indexPath.row
    
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
    
    UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
    UserDefaults.standard.setValue(n, forKey: "Event_name")
    UserDefaults.standard.setValue(cn, forKey: "Event_cat")
    UserDefaults.standard.setValue(ai1, forKey: "Event_artid")
    UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
    UserDefaults.standard.setValue(providerRating, forKey: "Event_providerrating")
    UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
    UserDefaults.standard.setValue(pid, forKey: "V_id")
    
    let f = od + " to " + cd + " timing " + ot + " to " + ct
    
    
    UserDefaults.standard.setValue(od, forKey: "e_opend")
    UserDefaults.standard.setValue(ot, forKey: "e_opent")
    UserDefaults.standard.setValue(cd, forKey: "e_closed")
    UserDefaults.standard.setValue(ct, forKey: "e_closet")
    
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
    
}
}
