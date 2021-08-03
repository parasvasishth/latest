//
//  CategoryEventVC.swift
//  Stumbal
//
//  Created by mac on 07/04/21.
//

import UIKit
import Alamofire
import Kingfisher
import CoreLocation
class CategoryEventVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet var eventTblView: UITableView!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var categoryLbl: UILabel!
    
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    var providerRating:String = ""
    var artistRating:String = ""
    var lat:Float = 0
    var long:Float = 0
    var distance:String = ""
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTblView.dataSource = self
        eventTblView.delegate = self
        UserDefaults.standard.set(true, forKey: "upcoming_event")
        fetch_user_distance()
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    
    @IBAction func butTicket(_ sender: UIButton) {
        
        let tagVal : Int = sender.tag
        let eid = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "event_id")as! String
        let tp = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "ticket_price") as! String
        
        UserDefaults.standard.setValue(eid, forKey: "Event_id")
        UserDefaults.standard.setValue(tp, forKey: "Event_ticketprice")
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "BuyTicketVC") as! BuyTicketVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    
    @IBAction func viewArtist(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        //  print(charityNameArray)
      
    let scn = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "sub_cat_name")as! String
        
       let n = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "name")as! String
        
        let cn = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "category_name")as! String
        
        let ai = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "artist_id")as! String
        
        let eid = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "event_id")as! String
      
        
        let aimg = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "artist_img")as! String
     
        
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
        UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
        UserDefaults.standard.setValue(n, forKey: "Event_name")
        UserDefaults.standard.setValue(cn, forKey: "Event_cat")
        UserDefaults.standard.setValue(ai, forKey: "Event_artid")
        UserDefaults.standard.setValue(eid, forKey: "Event_id")
        UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
        
        if ai == ""
        {
            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "BlankArtistProfileVC") as! BlankArtistProfileVC
            signuCon.modalPresentationStyle = .fullScreen
            self.present(signuCon, animated: false, completion:nil)
        }
        else
        {
            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistUserProfileVC") as! ArtistUserProfileVC
            signuCon.modalPresentationStyle = .fullScreen
            self.present(signuCon, animated: false, completion:nil)
            
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
                    self.present(alert, animated: true, completion: nil)
                    
                    
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
//            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.mode = MBProgressHUDMode.indeterminate
//            hud.self.bezelView.color = UIColor.black
//            hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "tab_Cat_id") as! String
            
            print("123",uID)
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_cat_event", method: .post, parameters: ["cat_id" :uID ,"lat":lat,"lng":long,"distance":distance], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                             
                            
                             self.eventTblView.isHidden = false
                            self.statusLbl.isHidden = true
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
           let cell =  eventTblView.dequeueReusableCell(withIdentifier: "EventTblCell", for: indexPath) as! EventTblCell
       
      
         cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
        cell.vendorNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
        cell.eventAddressLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
        
       cell.categorylbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String

    
        let eimg:String = (self.AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
        
        
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
                let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
           let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
        let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
        let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
         cell.eventTimelbl.text = od + " to " + cd + " timing " + ot + " to " + ct
           
      //  cell.artistObj.tag = indexPath.row
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
            
           let n = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
            
            let cn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
            
        let ai1 = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String
           
            let aimg = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
        let ec = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
        
        
        
        let spr = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
        let pid = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String
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
        UserDefaults.standard.setValue(providerRating, forKey: "Event_providerrating")
        UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
        
            UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
            UserDefaults.standard.setValue(n, forKey: "Event_name")
            UserDefaults.standard.setValue(cn, forKey: "Event_cat")
            UserDefaults.standard.setValue(ai1, forKey: "Event_artid")
            UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
        UserDefaults.standard.setValue(ec, forKey: "Event_categoryname")
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
         var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
         signuCon.modalPresentationStyle = .fullScreen
         self.present(signuCon, animated: false, completion:nil)
       
    }
}
