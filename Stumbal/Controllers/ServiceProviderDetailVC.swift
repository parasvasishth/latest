//
//  ServiceProviderDetailVC.swift
//  Stumbal
//
//  Created by mac on 24/03/21.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit
import Kingfisher
class ServiceProviderDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var serviceTblView: UITableView!
    @IBOutlet var vendorImg: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var contactLbl: UILabel!
    @IBOutlet var ratingView: FloatRatingView!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var ratingLblHeight: NSLayoutConstraint!
    @IBOutlet var ratingViewHeight: NSLayoutConstraint!
    @IBOutlet var ratinguserLblHeight: NSLayoutConstraint!
    @IBOutlet var ratingmessageHeight: NSLayoutConstraint!
    @IBOutlet var viewallHeight: NSLayoutConstraint!
    @IBOutlet var linelblHeight: NSLayoutConstraint!
    @IBOutlet var ratingandreviewLbl: UILabel!
    @IBOutlet var viewallObj: UIButton!
    @IBOutlet var tblHeight: NSLayoutConstraint!
    @IBOutlet var hosttraill1: NSLayoutConstraint!
    @IBOutlet var upcomingObj: UIButton!
    @IBOutlet var pastobj: UIButton!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var pastStack: UIStackView!
    @IBOutlet var venueratinglbl: UILabel!
    
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    var vendorRatingArr:NSMutableArray = NSMutableArray()
    @IBOutlet var hosttril: NSLayoutConstraint!
    @IBOutlet var lbl2: UILabel!
    var status:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        contactLbl.isUserInteractionEnabled = true
        contactLbl.addGestureRecognizer(tapGestureRecognizer)
            
     
       
      //  tblHeight.constant = 0
        
          serviceTblView.dataSource = self
        serviceTblView.delegate = self
        
        upcomingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        pastobj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        
        status = "Future"
        upcomingObj.setTitleColor(.white, for: .normal)
        pastobj.setTitleColor(.white, for: .normal)
        upcomingObj.roundedButton1()
       // pastobj.roundedButton()
       
        DispatchQueue.main.async { [self] in
            self.pastobj.roundCorners(corners: [.topRight , .bottomRight], radius: 20)
        }
        vendorImg.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        fetch_venue_detail()
    }
    
    // MARK: - cart Method
      @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
          
        let phoneNum : String =  UserDefaults.standard.value(forKey: "V_contact") as! String
              if let url = URL(string: "tel://\(phoneNum)") {
                  if #available(iOS 10, *) {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  } else {
                      UIApplication.shared.openURL(url as URL)
                  }
              }
        
      }
    
    @IBAction func timing(_ sender: UIButton) {
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "TimingVC") as! TimingVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
        
    }
    @IBAction func upcoming(_ sender: UIButton) {
        upcomingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        pastobj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        status = "Future"
        upcomingObj.setTitleColor(.white, for: .normal)
        pastobj.setTitleColor(.white, for: .normal)
        fetch_provider_event()
    }
    @IBAction func past(_ sender: UIButton) {
        pastobj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        upcomingObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        status = "Past"
        pastobj.setTitleColor(.white, for: .normal)
        upcomingObj.setTitleColor(.white, for: .normal)
        fetch_provider_event()
    }
    @IBAction func viewAll(_ sender: UIButton) {
        
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "VendorReviewsVC") as! VendorReviewsVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    
    @IBAction func review(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "VendorRating")
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "VendorRatingVC") as! VendorRatingVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    
    @IBAction func back(_ sender: UIButton) {
        
            
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func direction(_ sender: UIButton) {
//        let la = (UserDefaults.standard.value(forKey: "V_lat") as! NSString).doubleValue
//        let lo = (UserDefaults.standard.value(forKey: "V_long") as! NSString).doubleValue
//        let add = UserDefaults.standard.value(forKey: "V_add") as! String
//        let coordinate = CLLocationCoordinate2DMake(la, lo)
//        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
//        mapItem.name = add
//        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
       // UserDefaults.standard.set(true, forKey: "eventdirection")
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "DirectionVC") as! DirectionVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    
    // MARK: - fetch_venue_detail
    func  fetch_venue_detail()
    {

        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=fetch_venue_detail", method: .post, parameters: ["venue_id" : UserDefaults.standard.value(forKey: "V_id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.fetch_venue_detail()
                    }))
                    self.present(alert, animated: true, completion: nil)


                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary

                    {   self.nameLbl.text = json["vname"] as! String
                        self.addressLbl.text = json["address"] as! String
                        self.contactLbl.text = json["contact"] as! String
                        let avg:String = json["avg_rating"] as! String
                        
                        if avg == "0"
                        {
                            self.venueratinglbl.text = "0" + "/5"
                        }
                        else
                        {
                            self.venueratinglbl.text = avg + "/5"
                        }
                        
                let pimg:String =  json["venue_img"] as! String
                        
                        if pimg == ""
                        {
                            self.vendorImg.image = UIImage(named: "vdefault")
                        }
                           else
                        {
                           let url = URL(string: pimg)
                           let processor = DownsamplingImageProcessor(size: self.vendorImg.bounds.size)
                                        |> RoundCornerImageProcessor(cornerRadius: 0)
                           self.vendorImg.kf.indicatorType = .activity
                           self.vendorImg.kf.setImage(
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
                                self.vendorImg.image = UIImage(named: "vdefault")
                               }
                           }
                           
                        }

                        self.fetch_provider_review_rating()
                       
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

    
    
    //MARK: fetch_provider_review_rating ;
    func fetch_provider_review_rating()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "V_id") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_provider_review_rating", method: .post, parameters: ["provider_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_provider_review_rating()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.vendorRatingArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                       
                        
                        
                        if self.vendorRatingArr.count != 0 {
                            
                           let vendor = self.vendorRatingArr[0] as! NSDictionary
                            self.usernameLbl.text = vendor["name"] as! String
                            self.messageLbl.text = vendor["review"] as! String
                            self.ratingView.rating = (vendor["rating"] as! NSString).doubleValue
                            
                            self.ratingLblHeight.constant = 21
                            self.ratingViewHeight.constant = 30
                            self.ratinguserLblHeight.constant = 21
                            self.ratingmessageHeight.constant = 21
                            self.viewallHeight.constant = 40
                            self.linelblHeight.constant = 1
                           
                            self.ratingView.isHidden = false
                            self.ratingandreviewLbl.text = "Rating & Reviews"
                            self.viewallObj.isHidden = false
                            self.pastStack.isHidden = false
                            self.lbl2.isHidden = false
                            
//                            if UserDefaults.standard.bool(forKey: "HomeEvent") == true
//                            {
//                                self.fetch_venue_events()
//                            }
//                            else
//                            {
                                self.fetch_provider_event()
                            //}
                            
                            
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                          
                            
                            self.ratingLblHeight.constant = 0
                            self.ratingViewHeight.constant = 0
                            self.ratinguserLblHeight.constant = 0
                            self.ratingmessageHeight.constant = 0
                            self.viewallHeight.constant = 0
                            self.linelblHeight.constant = 0
                            self.hosttraill1.constant = 20
                            
                            self.ratingView.isHidden = true
                            self.viewallObj.isHidden = true
                          
                            self.pastStack.isHidden = false
                            self.lbl2.isHidden = true
//                            if UserDefaults.standard.bool(forKey: "HomeEvent") == true
//                            {
//                                self.fetch_venue_events()
//                            }
//                            else
//                            {
                                self.fetch_provider_event()
                           // }
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
    
    
    //MARK: fetch_provider_event ;
        func fetch_provider_event()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.self.bezelView.color = UIColor.black
            hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "V_id") as! String
            
            print("123",uID)
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_provider_event", method: .post, parameters: ["provider_id" :uID,"user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"status":status], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                         self.fetch_provider_event()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                     do  {
                         self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
         
                         
                         if self.AppendArr.count != 0 {
                             
                         //   let contentOffset = self.serviceTblView.contentOffset
                            
                        //    self.serviceTblView.layoutIfNeeded()
                          //  self.serviceTblView.setContentOffset(contentOffset, animated: false)
                       //     self.tblHeight!.constant =  CGFloat(125 * self.AppendArr.count)
                        
                           // self.tableHeight.contentSize.height = CGFloat(80 * self.AppendArr.count)
                           // self.tableHeight.constant = CGFloat(88 * self.AppendArr.count)
                            //self.statusLbl.isHidden = true
                            
                            self.serviceTblView.isHidden = false
                            self.tblHeight.constant = 319
                            self.serviceTblView.reloadData()
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                              self.serviceTblView.isHidden = false
                          self.tblHeight.constant = 100
                           // self.statusLbl.isHidden = false
                            self.serviceTblView.reloadData()
                            
//                             if self.status == "Future"
//                             {
//                                 self.statusLbl.text = "No upcoming events"
//                             }
//                             else
//                             {
//                                 self.statusLbl.text = "No past events"
//                             }
                             
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
    
    
    //MARK: fetch_venue_events ;
        func fetch_venue_events()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.self.bezelView.color = UIColor.black
            hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "V_id") as! String
            
            print("123",uID)
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_venue_events", method: .post, parameters: ["provider_id" :uID,"user_id":UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                         self.fetch_venue_events()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                    self.AppendArr = NSMutableArray()
                    
                     do  {
                         self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
         
                         
                         if self.AppendArr.count != 0 {
                             
//                            let contentOffset = self.serviceTblView.contentOffset
//
//                            self.serviceTblView.layoutIfNeeded()
//                            self.serviceTblView.setContentOffset(contentOffset, animated: false)
//                            self.tblHeight.constant =  CGFloat(125 * self.AppendArr.count)
//
                            self.statusLbl.isHidden = true
                            
                            
                            self.serviceTblView.isHidden = false
                            self.serviceTblView.reloadData()
                            
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                              self.serviceTblView.isHidden = true
                           // self.tblHeight.constant = 0
                           self.statusLbl.isHidden = false
//                            if self.status == "Future"
//                            {
//                                self.statusLbl.text = "No upcoming events"
//                            }
//                            else
//                            {
//                                self.statusLbl.text = "No past events"
//                            }
                            
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
       // return AppendArr.count
     
     if AppendArr.count == 0 {
         if status == "Future"
         {
             self.serviceTblView.setEmptyMessage("No upcoming events")
         }
         else
         {
             self.serviceTblView.setEmptyMessage("No past events")
         }
         
         
     } else {
         self.serviceTblView.restore()
     }

     return AppendArr.count
     
    }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell =  serviceTblView.dequeueReusableCell(withIdentifier: "EventTblCell", for: indexPath) as! EventTblCell
       
      
         cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
        cell.eventAddressLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
    
        
        cell.vendorNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String

        cell.categorylbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String

//
//        let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
//
//
//        if eimg == ""
//        {
//            cell.eventImg.image = UIImage(named: "edefault")
//
//        }
//           else
//        {
//           let url = URL(string: eimg)
//           let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
//                        |> RoundCornerImageProcessor(cornerRadius: 0)
//           cell.eventImg.kf.indicatorType = .activity
//           cell.eventImg.kf.setImage(
//               with: url,
//               placeholder: nil,
//               options: [
//                   .processor(processor),
//                   .scaleFactor(UIScreen.main.scale),
//                   .transition(.fade(1)),
//                   .cacheOriginalImage
//               ])
//           {
//               result in
//               switch result {
//               case .success(let value):
//                   print("Task done for: \(value.source.url?.absoluteString ?? "")")
//               case .failure(let error):
//                   print("Job failed: \(error.localizedDescription)")
//                cell.eventImg.image = UIImage(named: "edefault")
//               }
//           }
//
//        }
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
       
        
        let spr = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
        
        let ec = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
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

//
//        if status == "Future"
//        {
            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
            signuCon.modalPresentationStyle = .fullScreen
            self.present(signuCon, animated: false, completion:nil)
//        }
//        else
//        {
//            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "PastEventDetailVC") as! PastEventDetailVC
//            signuCon.modalPresentationStyle = .fullScreen
//            self.present(signuCon, animated: false, completion:nil)
//        }
//
       
    }
}
