//
//  HistoryVC.swift
//  Stumbal
//
//  Created by mac on 23/03/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class HistoryVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

@IBOutlet var historyTblView: UITableView!
@IBOutlet var upcomingLbl: UILabel!
@IBOutlet var pastLbl: UILabel!
@IBOutlet var statusLbl: UILabel!
@IBOutlet var upcomingObj: UIButton!
@IBOutlet var pastEventObj: UIButton!
var historyArray:[historyList] = []
var hud = MBProgressHUD()
    var eventId:String = ""
var AppendArr:NSMutableArray = NSMutableArray()
override func viewDidLoad() {
    super.viewDidLoad()
    historyTblView.dataSource = self
    historyTblView.delegate = self
    upcomingObj.roundedButton1()
    DispatchQueue.main.async { [self] in
        pastEventObj.roundCorners(corners: [.topRight , .bottomRight], radius: 20)
    }
    
    upcomingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    pastEventObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    upcomingObj.setTitleColor(.white, for: .normal)
    pastEventObj.setTitleColor(.white, for: .normal)
    UserDefaults.standard.set(true, forKey: "upcoming_event")
    UserDefaults.standard.set(false, forKey: "past_event")
    fetch_upcoming_events()
    
    // Do any additional setup after loading the view.
}

    @IBAction func refund(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        //  print(charityNameArray)
        eventId = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "event_id")as! String
        
        user_refund_request()
    }
    @IBAction func upcomingEvent(_ sender: UIButton) {
    UserDefaults.standard.set(true, forKey: "upcoming_event")
    UserDefaults.standard.set(false, forKey: "past_event")
    upcomingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    pastEventObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    upcomingObj.setTitleColor(.white, for: .normal)
    pastEventObj.setTitleColor(.white, for: .normal)
    fetch_upcoming_events()
    
}

@IBAction func qrCode(_ sender: UIButton) {
    let tagVal : Int = sender.tag
    //  print(charityNameArray)
    let c = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "qr_image")as! String
    
    UserDefaults.standard.setValue(c, forKey: "h_qrcode")
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeVC") as! QRCodeVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
    
}

@IBAction func pastEvent(_ sender: UIButton) {
    UserDefaults.standard.set(false, forKey: "upcoming_event")
    UserDefaults.standard.set(true, forKey: "past_event")
    pastEventObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    upcomingObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
    pastEventObj.setTitleColor(.white, for: .normal)
    upcomingObj.setTitleColor(.white, for: .normal)
    fetch_past_events()
    
}

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}

    // MARK: - user_refund_request
    func user_refund_request()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=user_refund_request", method: .post,parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":eventId],encoding:  URLEncoding.httpBody).responseJSON{ response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                print("22222222222222")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                        self.user_refund_request()
                    }))
                    self.present(alert, animated: false, completion: nil)
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        print("JSON: \(json)")
                        let result : String = json["result"]! as! String
                        if  result == "success"
                        {
                            let alert = UIAlertController(title: "", message: "Request Refund Sent Successfully", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            // change to desired number of seconds (in this case 5 seconds)
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                               
                                alert.dismiss(animated: false, completion: nil)
                                
                            }
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else {
                            
                            MBProgressHUD.hide(for: self.view, animated: false)
                            let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: false, completion: nil)
                            
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
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
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
                    
                    if self.AppendArr.count != 0 {
                        
                        self.statusLbl.isHidden = true
                        self.historyTblView.isHidden = false
                        self.historyTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.historyTblView.isHidden = true
                        self.statusLbl.isHidden = false
                        self.statusLbl.text = "No upcoming events"
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
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_past_events", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.AppendArr = NSMutableArray()
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.AppendArr.count != 0 {
                        
                        self.statusLbl.isHidden = true
                        self.historyTblView.isHidden = false
                        self.historyTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.historyTblView.isHidden = true
                        self.statusLbl.isHidden = false
                        self.statusLbl.text = "No past events"
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
    let cell = historyTblView.dequeueReusableCell(withIdentifier: "EventTblCell", for: indexPath) as! EventTblCell
    
    
    
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
        cell.qrstackObj.isHidden = false
        cell.qrheight.constant = 40
       cell.qrtopHeight.constant = 20
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
        cell.qrstackObj.isHidden = true
        cell.qrheight.constant = 0
        cell.qrtopHeight.constant = 0
    }
    cell.qrObj.tag = indexPath.row
    cell.refundObj.tag = indexPath.row
    return cell
}
    var artistRating:String = ""
    var providerRating:String = ""
    
    
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
