//
//  NewNotificationVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 27/01/22.
//

import UIKit
import Alamofire
import Alamofire
class NewNotificationVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var requestLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var addImg: UIImageView!
    @IBOutlet weak var upcomingTblView: UITableView!
    @IBOutlet weak var inviteTblView: UITableView!
    @IBOutlet weak var upcomingTblHeight: NSLayoutConstraint!
    @IBOutlet weak var inviteTblHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingHeight: NSLayoutConstraint!
    @IBOutlet weak var inviteLblHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingLbl: UILabel!
    @IBOutlet weak var inviteLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    var AppendArr:NSMutableArray = NSMutableArray()
    var requestArr:NSMutableArray = NSMutableArray()
    var InviteArr:NSMutableArray = NSMutableArray()
    var hud = MBProgressHUD()
    var providerRating:String = ""
    var artistRating:String = ""
    
    var autoId:String = ""
    var inviteId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
        countLbl.isUserInteractionEnabled = true
        countLbl.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        addImg.isUserInteractionEnabled = true
        addImg.addGestureRecognizer(tapGestureRecognizer2)
        
        upcomingTblView.dataSource = self
        upcomingTblView.delegate = self
        
        inviteTblView.dataSource = self
        inviteTblView.delegate = self
       
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func accept(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BuyTicketVC") as! BuyTicketVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func decline(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        
        inviteId = (InviteArr.object(at: tagVal) as AnyObject).value(forKey: "user_id")as! String
        autoId = (InviteArr.object(at: tagVal) as AnyObject).value(forKey: "auto_id")as! String
        delete_friend_invitation_event()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch_friend_request()
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
    
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewFriendRequestListVC") as! NewFriendRequestListVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer){
    
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewFriendRequestListVC") as! NewFriendRequestListVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    // MARK: - delete_friend_invitation_event
    func delete_friend_invitation_event()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=delete_friend_invitation_event", method: .post,parameters: ["auto_id":autoId,"user_id":inviteId],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        self.delete_friend_invitation_event()
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
                            self.fetch_friend_invitation_event()
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
    
  
    //MARK: fetch_friend_request ;
    func fetch_friend_request()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
     //   https://stumbal.com/process.php?action=get_last_msg
       // https://stumbal.com/process.php?action=fetch_friend_list

        Alamofire.request("https://stumbal.com/process.php?action=fetch_friend_request", method: .post, parameters: ["user_id":uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                        self.fetch_friend_request()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.requestArr = NSMutableArray()
                        self.requestArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        self.countLbl.text = String(self.requestArr.count)
                        self.fetch_upcoming_events()
                        MBProgressHUD.hide(for: self.view, animated: true);
                    }
                    catch
                    {
                        print("error")
                    }
                    
                }
                
                
            }
        }
        
    }
    // MARK: - Table Height Method
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.upcomingTblHeight?.constant = self.upcomingTblView.contentSize.height
    }
    
    //MARK: fetch_upcoming_events ;
    func fetch_upcoming_events()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
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
                            
                       //     self.statusLbl.isHidden = true
                            self.upcomingTblView.isHidden = false
                            self.upcomingTblView.reloadData()
                            self.upcomingHeight.constant = 30
                            self.upcomingTblView.layoutIfNeeded()
                            let contentOffset = self.upcomingTblView.contentOffset
                            self.upcomingTblView.setContentOffset(contentOffset, animated: false)
                            self.upcomingTblHeight.constant = CGFloat(84 * self.AppendArr.count)
                          //  self.upcomingLbl.isHidden = false
                           // self.cartOrderTableView.isHidden = false
                            self.fetch_friend_invitation_event()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.upcomingTblView.isHidden = true
                            self.upcomingTblHeight.constant = 0
                            self.upcomingHeight.constant = 30
                         //   self.upcomingLbl.isHidden = false
                            self.fetch_friend_invitation_event()
                           // self.statusLbl.isHidden = false
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
    
    //MARK: fetch_friend_invitation_event ;
    func fetch_friend_invitation_event()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_friend_invitation_event", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.InviteArr = NSMutableArray()
                        self.InviteArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        
                        if self.InviteArr.count != 0 {
                            
                       //     self.statusLbl.isHidden = true
                            self.inviteTblView.isHidden = false
                            self.inviteTblView.reloadData()
                            self.inviteLblHeight.constant = 30
                            self.inviteTblView.layoutIfNeeded()
                            let contentOffset = self.inviteTblView.contentOffset
                            self.inviteTblView.setContentOffset(contentOffset, animated: false)
                            self.inviteTblHeight.constant = CGFloat(84 * self.InviteArr.count)
                           // self.cartOrderTableView.isHidden = false
                            self.loadingView.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.inviteTblView.isHidden = true
                            self.inviteTblHeight.constant = 0
                            self.inviteLblHeight.constant = 30
                            self.loadingView.isHidden = true
                           // self.statusLbl.isHidden = false
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
        if tableView == upcomingTblView
        {
            return AppendArr.count
        }
        else
        {
            return InviteArr.count
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == upcomingTblView
        {
            let cell =  upcomingTblView.dequeueReusableCell(withIdentifier: "NewUpcomingEventTableViewCell", for: indexPath) as! NewUpcomingEventTableViewCell
           
            
            cell.eventNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
            
            var r:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "remain_days")as! String
            if Int(r) == 0
            {
                cell.remainingLbl.text = "In " + r + " day"
            }
            else if Int(r) == 1
            {
                cell.remainingLbl.text = "In " + r + " day"
            }
            else
            {
                cell.remainingLbl.text = "In " + r + " days"
            }
        
           
            
            return cell
        }
        else
        {
            let cell =  inviteTblView.dequeueReusableCell(withIdentifier: "NewUpcomingEventTableViewCell", for: indexPath) as! NewUpcomingEventTableViewCell
           
            
            cell.eventnLbl.text = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
            
            let n:String = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
            cell.nameLbl.text = n + " Invites you to"
            cell.declineObj.tag = indexPath.row
            cell.acceptObj.tag = indexPath.row
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == upcomingTblView
        {
        }
        else
        {
            let pn = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
            let add = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
            let od = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
            let cd = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
            let ot = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
            let ct = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
            let ai = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img") as! String
            let en = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
            let aid = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id") as! String
            let eid = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_id") as! String
            let tp = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "ticket_price") as! String

            let lat = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "lat") as! String

            let long = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "lng") as! String

            let scn = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String

            let n = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist")as! String

            let cn = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String

            let ai1 = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String

            let aimg = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
            let ec = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
            let pid = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String
            let edesc = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_desc")as! String
            let spr = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
            if spr == ""
            {
                providerRating = "0" + "/5"
            }
            else
            {
                providerRating = spr + "/5"
            }

            let ar = (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_avg_rating")as! String
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
            UserDefaults.standard.setValue( (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String, forKey: "Event_username")
            UserDefaults.standard.setValue( (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "auto_id")as! String, forKey: "Event_autoid")
            UserDefaults.standard.setValue( (InviteArr.object(at: indexPath.row) as AnyObject).value(forKey: "user_id")as! String, forKey: "Event_usernameid")
            
            

            let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InviteEventDetailVC") as! InviteEventDetailVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
    //        let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
    //        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    //        self.present(alert, animated: true, completion: nil)
        }
        
      
    }

}
