//
//  FriendProfileVC.swift
//  Stumbal
//
//  Created by mac on 15/06/21.
//

import UIKit
import Alamofire
import Kingfisher
class FriendProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

@IBOutlet var profileImg: UIImageView!
@IBOutlet var addFriendObj: UIButton!
@IBOutlet var profileView: UIView!
@IBOutlet var namelbl: UILabel!
@IBOutlet var chatStack: UIStackView!
@IBOutlet var pastStack: UIStackView!
@IBOutlet var upcomingObj: UIButton!
@IBOutlet var pastObj: UIButton!
@IBOutlet var eventTblView: UITableView!
@IBOutlet var tblHeight: NSLayoutConstraint!
var AppendArr:NSMutableArray = NSMutableArray()
var pastArray:NSMutableArray = NSMutableArray()
var type:String = ""
var hud = MBProgressHUD()
var status:String = ""
override func viewDidLoad() {
super.viewDidLoad()

DispatchQueue.main.async { [self] in
    pastObj.roundCorners(corners: [.topRight , .bottomRight], radius: 20)
   
}
profileView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
// upcomingObj.addRightBorder(borderColor: UIColor.white, borderWidth: 2.0)
 upcomingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
 pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
 
 
 upcomingObj.setTitleColor(.white, for: .normal)
 pastObj.setTitleColor(.white, for: .normal)


upcomingObj.roundedButton1()
//  pastObj.roundedButton()
eventTblView.dataSource = self
eventTblView.delegate = self

namelbl.text = UserDefaults.standard.value(forKey: "friend_name") as! String

let uimg:String = UserDefaults.standard.value(forKey: "friend_img") as! String


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


if UserDefaults.standard.value(forKey: "friend_status")as! String == "Accept"
       {
           UserDefaults.standard.set(true, forKey: "upcoming_event")
           UserDefaults.standard.set(false, forKey: "past_event")
           addFriendObj.isHidden = true
           chatStack.isHidden = false
           pastStack.isHidden = false
          fetch_upcoming_events()
}
else if UserDefaults.standard.value(forKey: "friend_status")as! String == "Pending"
{
    addFriendObj.isHidden = false
    addFriendObj.setTitle("Request Pending", for: .normal)
    chatStack.isHidden = true
    pastStack.isHidden = true
}
else
{
    addFriendObj.isHidden = false
    chatStack.isHidden = true
    pastStack.isHidden = true
    addFriendObj.setTitle("Add as Friend", for: .normal)
}

}

@IBAction func past(_ sender: UIButton) {
UserDefaults.standard.set(false, forKey: "upcoming_event")
UserDefaults.standard.set(true, forKey: "past_event")
pastObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
upcomingObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)


pastObj.setTitleColor(.white, for: .normal)
upcomingObj.setTitleColor(.white, for: .normal)
fetch_past_events()
}

@IBAction func upcoming(_ sender: UIButton) {
UserDefaults.standard.set(true, forKey: "upcoming_event")
UserDefaults.standard.set(false, forKey: "past_event")
upcomingObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)


upcomingObj.setTitleColor(.white, for: .normal)
pastObj.setTitleColor(.white, for: .normal)
fetch_upcoming_events()
}

@IBAction func chat(_ sender: UIButton) {
var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
signuCon.modalPresentationStyle = .fullScreen
self.present(signuCon, animated: false, completion:nil)
}

@IBAction func unfriend(_ sender: UIButton) {
status = ""
type = "Unfriend"
friend_accept_reject()
}

@IBAction func back(_ sender: UIButton) {
self.dismiss(animated: false, completion: nil)
}

@IBAction func addfriend(_ sender: UIButton) {
if sender.currentTitle == "Add as Friend"
{
    status = "Pending"
    friend_request()
}
else
{
    let defaults = UserDefaults.standard
    let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to Cancel Request?", preferredStyle: UIAlertController.Style.alert)
    refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action: UIAlertAction!) in
        print("Handle Ok login here")
        self.status = ""
        type = "Cancel"
        self.friend_accept_reject()
       
    }))
    refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        print("Handle Cancel Login here")
    }))
    present(refreshAlert, animated: true, completion: nil)
    
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
                    
                  self.dismiss(animated: false, completion: nil)

                    
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
                
                if  json["result"] as! String == "success"
                {
                    
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let alert = UIAlertController(title: "", message: "Friend Request Sent Successfully", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 2
                    
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                          self.dismiss(animated: false, completion: nil)
                        
                    }
                    
                    
                
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


//MARK: fetch_upcoming_events ;
func fetch_upcoming_events()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
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
                self.pastArray = NSMutableArray()
                 self.pastArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                
                
                
                self.AppendArr = NSMutableArray()
                if self.pastArray.count != 0
                {
                    
                    for i in 0...self.pastArray.count-1
                    {
                        if (self.pastArray.object(at: i) as AnyObject).value(forKey: "type") as! String == "Private" {
                        } else {
                            print((self.pastArray.object(at:i) as AnyObject).value(forKey: "type"),i)
                            self.AppendArr.add(self.pastArray[i])
                        }
                        
                    }
                    
                    if self.AppendArr.count != 0 {
                        
                        self.eventTblView.isHidden = false
                        self.eventTblView.reloadData()
                        self.tblHeight.constant = 350
                        
                         MBProgressHUD.hide(for: self.view, animated: true)
                        
                    }
                    
                    else  {
                        
                        
                        self.eventTblView.isHidden = false
                     // self.statusLbl.isHidden = false
                     // self.statusLbl.text = "No upcoming events"
                        self.tblHeight.constant = 100
                      self.eventTblView.reloadData()
                    //  self.tblHeight.constant = 0
                       //  self.selectcardLbl.isHidden = true
                       MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    
                }
                else
                {
                    self.eventTblView.isHidden = false
                 // self.statusLbl.isHidden = false
                 // self.statusLbl.text = "No upcoming events"
                    self.tblHeight.constant = 100
                  self.eventTblView.reloadData()
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
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "friend_rid") as! String
    
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
                self.pastArray = NSMutableArray()
                 self.pastArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                
                
                
                
                
                self.AppendArr = NSMutableArray()
                if self.pastArray.count != 0
                {
                    
                    for i in 0...self.pastArray.count-1
                    {
                        if (self.pastArray.object(at: i) as AnyObject).value(forKey: "type") as! String == "Private" {
                        } else {
                            print((self.pastArray.object(at:i) as AnyObject).value(forKey: "type"),i)
                            self.AppendArr.add(self.pastArray[i])
                        }
                        
                    }
                    
                    if self.AppendArr.count != 0 {
                        
                        
//                            let contentOffset = self.eventTblView.contentOffset
//
//                            self.eventTblView.layoutIfNeeded()
//                            self.eventTblView.setContentOffset(contentOffset, animated: false)
//                            self.tblHeight.constant =  CGFloat(126 * self.AppendArr.count)
//
                       // self.statusLbl.isHidden = true
                        self.eventTblView.isHidden = false
                        self.tblHeight.constant = 350
                        self.eventTblView.reloadData()
                        
                         MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        
                        
                        self.eventTblView.isHidden = false
                   //   self.statusLbl.isHidden = false
                     // self.statusLbl.text = "No past events"
                      self.tblHeight.constant = 100
                     self.eventTblView.reloadData()
                       //  self.selectcardLbl.isHidden = true
                       MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    
                }
                else
                {
                    self.eventTblView.isHidden = false
               //   self.statusLbl.isHidden = false
                 // self.statusLbl.text = "No past events"
                  self.tblHeight.constant = 100
                 self.eventTblView.reloadData()
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
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
   self.viewWillLayoutSubviews()
}



func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 return UITableView.automaticDimension
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  // return AppendArr.count

if AppendArr.count == 0 {
    if UserDefaults.standard.bool(forKey: "upcoming_event") == true
    {
        self.eventTblView.setEmptyMessage("No upcoming events")
    }
    else
    {
        self.eventTblView.setEmptyMessage("No past events")
    }
    
    
} else {
    self.eventTblView.restore()
}

return AppendArr.count

}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
let cell = eventTblView.dequeueReusableCell(withIdentifier: "EventTblCell", for: indexPath) as! EventTblCell



if UserDefaults.standard.bool(forKey: "upcoming_event") == true
{
   // cell.profileImg.sd_setImage(with: URL(string: (self.AppendArr[indexPath.row] as AnyObject).value(forKey:"event_img") as! String), placeholderImage: UIImage(named: "edefault"))
    
    
//            cell.eventImg?.sd_setImage(with: URL(string: (self.AppendArr[indexPath.row] as AnyObject).value(forKey:"event_img") as! String)) { (image, error, cache, urls) in
//                        if (error != nil) {
//                            cell.eventImg.image = UIImage(named: "edefault")
//                        } else {
//                            cell.eventImg.image = image
//                        }
//            }
    
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
   // cell.profileImg.sd_setImage(with: URL(string: (self.AppendArr[indexPath.row] as AnyObject).value(forKey:"event_img") as! String), placeholderImage: UIImage(named: "edefault"))
    
//            cell.eventImg?.sd_setImage(with: URL(string: (self.AppendArr[indexPath.row] as AnyObject).value(forKey:"event_img") as! String)) { (image, error, cache, urls) in
//                        if (error != nil) {
//                            cell.eventImg.image = UIImage(named: "edefault")
//                        } else {
//                            cell.eventImg.image = image
//                        }
//            }
//
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




let spr = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_avg_rating")as! String
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
