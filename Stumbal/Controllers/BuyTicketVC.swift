//
//  BuyTicketVC.swift
//  Stumbal
//
//  Created by mac on 19/03/21.
//

import UIKit
import Alamofire
import Kingfisher
class BuyTicketVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

@IBOutlet var priceObj: UIButton!
@IBOutlet var amountObj: UIButton!
@IBOutlet var ticketTblView: UITableView!
@IBOutlet var tblHeight: NSLayoutConstraint!
@IBOutlet var sendHeight: NSLayoutConstraint!
@IBOutlet var stumbalIdField: UITextField!
@IBOutlet var emailIdFeild: UITextField!
@IBOutlet var publicobj: UIButton!
@IBOutlet var privateObj: UIButton!
    @IBOutlet var promoField: UITextField!
    @IBOutlet var promocodeLbl: UILabel!
    @IBOutlet var finalLbl: UILabel!
    @IBOutlet var otheremailTblView: UITableView!
    var ticketArray:[String] = []
    var reqArray:[String] = []
var hud = MBProgressHUD()
var ticketid:String = ""
var ticketString:String = ""
var reqidString:String = ""
var otherartistArray:[String] = []
var IdArr = NSMutableArray()
var servicenameArr = [[String: String]]()
var artistArray:NSMutableArray = NSMutableArray()
var string1:String = ""
var status:String = ""
    var ticket_status:String = ""
    var friendStatus:String = ""
    var promocodeId:String = ""
    var dict:NSMutableDictionary = NSMutableDictionary()
override func viewDidLoad() {
    super.viewDidLoad()
    priceObj.roundedButton1()
    amountObj.roundedButton()
    ticketTblView.dataSource = self
    ticketTblView.delegate = self
    


    
    let p = UserDefaults.standard.value(forKey: "Event_ticketprice") as! String
    let tpu2 =  Float(p)!.currencyUS
   
    amountObj.setTitle(tpu2, for: .normal)
    UserDefaults.standard.set(false, forKey: "emailother")
    
    //ticketTblView.dataSource = self
    // ticketTblView.delegate = self
    // tblHeight.constant = 0
    sendHeight.constant = 0
    UserDefaults.standard.removeObject(forKey: "userarray")
    status = "Public"
    emailIdFeild.setLeftPaddingPoints(15)
    promoField.setLeftPaddingPoints(15)
    promoField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    
    DispatchQueue.main.async { [self] in
        amountObj.roundCorners(corners: [.topRight , .bottomRight], radius: 20)
        
    }
    check_ticket_book()
    // Do any additional setup after loading the view.
}
    
    @objc func textFieldDidChange(textField: UITextField){
        
        if UserDefaults.standard.bool(forKey: "coupon") == true
        {
            finalLbl.text = ""
          UserDefaults.standard.set(false, forKey: "coupon")

            remove_code1()
            
        }
        else
        {
            
        }
        promocodeLbl.text = ""
    }
    
override func viewWillAppear(_ animated: Bool) {
    if UserDefaults.standard.value(forKey: "userarray") == nil
    {
        tblHeight.constant = 0
        
    }
    else
    {
        UserDefaults.standard.set(false, forKey: "emailother")
        servicenameArr = UserDefaults.standard.value(forKey: "userarray") as! [[String: String]]
        print("11",servicenameArr)
        if servicenameArr.count == 1
        {
            tblHeight.constant = 125
        }
        else
        {
            tblHeight.constant = 250
        }
     //   tblHeight.constant = 250
        sendHeight.constant = 45
        artistArray = NSMutableArray(array:servicenameArr)
        ticketTblView.isHidden = false
        ticketTblView.reloadData()
    }
}
//// MARK: - Table Height Method
//override func viewWillLayoutSubviews() {
//    super.updateViewConstraints()
//    //  self.tableHeight?.constant = self.cardTableView.contentSize.height
//
//    self.tblHeight?.constant = CGFloat(60 * self.ticketArray.count)
//
//    //   self.addMoreTableheight?.constant = CGFloat(230 * self.extraRow)
//}
//

    @IBAction func addpromo(_ sender: UIButton) {
        if promoField.text != ""
        {
            if UserDefaults.standard.bool(forKey: "coupon") == true
            {
                
            }
            else
            {
                check_loyalty_code()
            }
          
            
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter Promocode", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func addEmail(_ sender: UIButton) {
    if emailIdFeild.text != ""
    {
        
        if isValidEmail(emailIdFeild.text!)
        {
            ticketString = emailIdFeild.text!
            friendStatus = ""
            
            if UserDefaults.standard.bool(forKey: "emailother") == true
            {
                
            }
            else
            {
                self.ticketTblView.isHidden = true
               // self.ticketTblView.reloadData()
                self.tblHeight.constant = 0
                self.sendHeight.constant = 0
                self.servicenameArr = []
                self.artistArray = NSMutableArray()
                UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
            }
    //
    //        self.dict.setValue(emailIdFeild.text!, forKey: "name")
    //        self.dict.setValue("", forKey: "user_img")
    //        self.dict.setValue("", forKey: "email")
    //        self.dict.setValue("", forKey: "req_Id")
    //
    //      //  otherArtistArray.append(n)
    //        self.servicenameArr.append(self.dict as! [String : String])
    //
    //        if servicenameArr.count == 1
    //        {
    //            tblHeight.constant = 125
    //        }
    //        else
    //        {
    //            tblHeight.constant = 250
    //        }
    //     //   tblHeight.constant = 250
    //        sendHeight.constant = 0
    //
    //
    //        UserDefaults.standard.set(true, forKey: "emailother")
    //
    //        artistArray = NSMutableArray(array:servicenameArr)
    //        ticketTblView.isHidden = false
    //        ticketTblView.reloadData()
    //
    //        UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
            
            
            block_tkt()
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter valid Email Address", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
      
    }
    else
    {
        let alert = UIAlertController(title: "", message: "Enter Email", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

@IBAction func sendTicket(_ sender: UIButton) {
    
    
    if artistArray.count != 0
    {
        ticketArray = []
        for i in 0...self.artistArray.count-1
        {
         
                print((self.artistArray.object(at:i) as AnyObject).value(forKey: "email"),i)
            
            let d:String = ((self.artistArray.object(at:i) as AnyObject).value(forKey: "email") as! String)
            let rid:String = ((self.artistArray.object(at:i) as AnyObject).value(forKey: "req_Id") as! String)
            
            self.ticketArray.append(d)
            
            self.reqArray.append(rid)
            
            ticketString = ticketArray.joined(separator: ",")
            reqidString = reqArray.joined(separator: ",")
        }
        
        friendStatus = "Friend"
          block_tkt()
    }
    else
    {
        let alert = UIAlertController(title: "", message: "Add Friend", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    // ticketString = ticketArray.joined(separator: ",")
    
    //   block_tkt()
    
}

@IBAction func addFriend(_ sender: UIButton) {
    if UserDefaults.standard.bool(forKey: "emailother") == true
    {
        UserDefaults.standard.set(false, forKey: "emailother")
        self.ticketTblView.isHidden = true
       // self.ticketTblView.reloadData()
        self.tblHeight.constant = 0
        self.sendHeight.constant = 0
        self.servicenameArr = []
        self.artistArray = NSMutableArray()
        self.emailIdFeild.text = ""
        UserDefaults.standard.setValue(self.servicenameArr, forKey: "userarray")
    }
    else
    {
        
    }
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}
@IBAction func deleteticket(_ sender: UIButton) {
    let tagVal : Int = sender.tag
    
    
    ticketArray.remove(at: tagVal)
    if ticketArray.count != 0
    {
        
        let contentOffset = self.ticketTblView.contentOffset
        
        self.ticketTblView.layoutIfNeeded()
        self.ticketTblView.setContentOffset(contentOffset, animated: false)
        self.tblHeight.constant =  CGFloat(60 * self.ticketArray.count)
        ticketTblView.isHidden = false
        ticketTblView.reloadData()
        sendHeight.constant = 45
    }
    else
    {
        ticketTblView.isHidden = true
        sendHeight.constant = 0
        tblHeight.constant  = 0
    }
    
    
}

@IBAction func addTicket(_ sender: UIButton) {
    
    if ticketArray.count > 9
    {
        let alert = UIAlertController(title: "", message: "You can block only 9 Ticket", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    else
    {
        if stumbalIdField.text != "" || emailIdFeild.text != ""
        {
            
            if stumbalIdField.text != ""
            {
                ticketid = stumbalIdField.text!
            }
            else
            {
                ticketid = emailIdFeild.text!
            }
            
            ticketArray.append(ticketid)
            stumbalIdField.text = ""
            emailIdFeild.text = ""
            
            ticketTblView.isHidden = false
            ticketTblView.reloadData()
            sendHeight.constant = 45
            
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter Stumbal Id Or Email Id to block ticket", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
}

@IBAction func back(_ sender: UIButton) {
    
    if promocodeId == ""
    {
        self.dismiss(animated: false, completion: nil)
    }
    else
    {
        remove_code()
        
    }
   
}
@IBAction func deleteuser(_ sender: UIButton) {
//    let tagVal : Int = sender.tag
//    // UserDefaults.standard.set(true, forKey: "Added")
//    artistArray.remove(at: tagVal)
//
//
//    if artistArray.count != 0
//    {
//        servicenameArr.remove(at: tagVal)
//        artistArray.remove(tagVal)
//        UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
//        ticketTblView.reloadData()
//    }
//    else
//    {
//        ticketTblView.isHidden = true
//        ticketTblView.reloadData()
//        tblHeight.constant = 0
//        UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
//
//    }
//
    
    let tagVal : Int = sender.tag

    if artistArray.count != 0
    {
        servicenameArr.remove(at: tagVal)
        //artistArray.remove(tagVal)
        artistArray.removeObject(at: tagVal)
        UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
        if artistArray.count != 0
        {
            if artistArray.count == 1
            {
                tblHeight.constant = 125
            }
            else
            {
                tblHeight.constant = 250
            }
            
            ticketTblView.reloadData()
            sendHeight.constant = 45
        }
        else
        {
            ticketTblView.isHidden = true
           // ticketTblView.reloadData()
          tblHeight.constant = 0
            sendHeight.constant = 0
        }
    }
    else
    {
        ticketTblView.isHidden = true
        ticketTblView.reloadData()
      tblHeight.constant = 0
        sendHeight.constant = 0
        UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
       
    }
    
    
}
@IBAction func publicBtn(_ sender: UIButton) {
    self.publicobj.setImage(UIImage(named: "bfill"), for: .normal)
    self.privateObj.setImage(UIImage(named: "bempty"), for: .normal)
    
    status = "Public"
}

@IBAction func privateBtn(_ sender: UIButton) {
    self.publicobj.setImage(UIImage(named: "bempty"), for: .normal)
    self.privateObj.setImage(UIImage(named: "bfill"), for: .normal)
    
    status = "Private"
}

@IBAction func payNow(_ sender: UIButton) {
    
    //  buy_tickets()
    
    
    
    if ticket_status == "Ticket Not Booked"
    {
        UserDefaults.standard.setValue(status, forKey: "eventprivacy")
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "CardListVC") as! CardListVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    else
    {
        let alert = UIAlertController(title: "", message: "You have already booked ticket", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
   
}

    // MARK: - Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    // MARK: - check_loyalty_code
    func check_loyalty_code()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=check_loyalty_code", method: .post,parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"code":promoField.text!],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        self.check_loyalty_code()
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
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.promocodeLbl.text = "Promo code applied successfully"
                            self.promocodeId = json["id"] as! String
                            
                            let op:String = json["offer_percent"] as! String
                            
                            let p:String = UserDefaults.standard.value(forKey: "Event_ticketprice") as! String
                            
                            let discount:Float = Float(p)! * Float(op)! / 100
                            
                            let discountcurrency =  discount.currencyUS
                            
                            let tp:Float = Float(p)!
                         let ttlprice : Float = tp - discount
                
                            print("1111",ttlprice)
                            
                            let finalprice =  ttlprice.currencyUS
                            
                            let tpu2 =  Float(p)!.currencyUS
                            let f:String = tpu2 + " less " + op + "%" + " discount " + discountcurrency + " = " + finalprice
                            print("111",tpu2)
                            self.finalLbl.text = f
                            
                            let parsed = finalprice.replacingOccurrences(of: "$", with: "")
                            UserDefaults.standard.set(true, forKey: "coupon")
                            UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")
                        }
                        
                        else {
                            
                            MBProgressHUD.hide(for: self.view, animated: false)
                            
                            self.promocodeLbl.text = result
//                            let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: false, completion: nil)
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    // MARK: - remove_code
    func remove_code()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=remove_code", method: .post,parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"promo_id":promocodeId],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        self.remove_code()
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
//                            if UserDefaults.standard.bool(forKey: "coupon") == true
//                            {
//                                UserDefaults.standard.set(false, forKey: "coupon")
//                                self.promocodeId = ""
//                            }
//                            else
//                            {
                                self.dismiss(animated: false, completion: nil)
                           // }
                            
                          
                            if let text = self.amountObj.titleLabel?.text {
                                let parsed = text.replacingOccurrences(of: "$", with: "")
                                UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")

                            }
                           
                           
                         //   MBProgressHUD.hide(for: self.view, animated: true)
                           
                            
                        }
                        
                        else {
                            
                        //    MBProgressHUD.hide(for: self.view, animated: false)
                            
                         
//                            let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: false, completion: nil)
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    // MARK: - remove_code1
    func remove_code1()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=remove_code", method: .post,parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"promo_id":promocodeId],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        self.remove_code1()
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
//                            if UserDefaults.standard.bool(forKey: "coupon") == true
//                            {
//                                UserDefaults.standard.set(false, forKey: "coupon")
//                                self.promocodeId = ""
//                            }
//                            else
//                            {
//                                self.dismiss(animated: false, completion: nil)
//                            }
                            self.promocodeId = ""
                          
                            if let text = self.amountObj.titleLabel?.text {
                                let parsed = text.replacingOccurrences(of: "$", with: "")
                                UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")

                            }
                           
                           
                         //   MBProgressHUD.hide(for: self.view, animated: true)
                           
                            
                        }
                        
                        else {
                            
                        //    MBProgressHUD.hide(for: self.view, animated: false)
                            
                         
//                            let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: false, completion: nil)
                            
                        }
                    }
                    
                }
            }
        }
    }
    
   
    func check_ticket_book()
    {
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=check_ticket_book", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String], encoding:  URLEncoding.httpBody).responseJSON
        { response in
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
                        self.check_ticket_book()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        print("JSON: \(json)")
                        print("66666666666")
                
                        self.ticket_status = json["result"] as! String
                        
//                        if  json["result"] as! String == "success"
//                        {
//                            MBProgressHUD.hide(for: self.view, animated: true);
//                            self.fetchCardDetail()
//                        }
//                        else
//                        {
//                            MBProgressHUD.hide(for: self.view, animated: true);
//                        }
//
                    }
                    
                }
            }
        }
        
    }
    
// MARK: - block_tkt
func block_tkt()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    Alamofire.request("https://stumbal.com/process.php?action=block_tkt", method: .post,parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String,"email_stumbalid":ticketString,"status":friendStatus,"send_user_id":reqidString],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                    self.block_tkt()
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
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let alert = UIAlertController(title: "", message: "Ticket Block Request Sent Successfully", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        
                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 2
                        
                        DispatchQueue.main.asyncAfter(deadline: when){ [self] in
                            // your code with delay
                            
                            if self.emailIdFeild.text != ""
                            {
                               
                                
                                self.dict.setValue(self.emailIdFeild.text!, forKey: "name")
                                self.dict.setValue("", forKey: "user_img")
                                self.dict.setValue("", forKey: "email")
                                self.dict.setValue("", forKey: "req_Id")
                                
                              //  otherArtistArray.append(n)
                                self.servicenameArr.append(self.dict as! [String : String])
                                
                                if self.servicenameArr.count == 1
                                {
                                    self.tblHeight.constant = 125
                                }
                                else
                                {
                                    self.tblHeight.constant = 250
                                }
                             //   tblHeight.constant = 250
                                self.sendHeight.constant = 0
                                
                           
                                UserDefaults.standard.set(true, forKey: "emailother")
                                
                                self.artistArray = NSMutableArray(array:self.servicenameArr)
                                self.ticketTblView.isHidden = false
                                self.ticketTblView.reloadData()
                                
                                UserDefaults.standard.setValue(self.servicenameArr, forKey: "userarray")
                                self.emailIdFeild.text = ""
                            }
                            else
                            {
                                self.ticketTblView.isHidden = true
                               // self.ticketTblView.reloadData()
                                self.tblHeight.constant = 0
                                self.sendHeight.constant = 0
                                self.servicenameArr = []
                                self.artistArray = NSMutableArray()
                                self.emailIdFeild.text = ""
                                UserDefaults.standard.setValue(self.servicenameArr, forKey: "userarray")
                            
                            }
                           
                            
                            alert.dismiss(animated: false, completion: nil)
                        }
                    
                    }
                    else {
                        self.emailIdFeild.text = ""
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

//MARK:  TableView Method
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return artistArray.count
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ticketTblView.dequeueReusableCell(withIdentifier: "SearchArtistTblCell", for: indexPath) as! SearchArtistTblCell
    
    let eimg:String = (artistArray.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String
    
    
    if eimg == ""
    {
        cell.profileImg.image = UIImage(named: "udefault")
        
    }
    else
    {
        let url = URL(string: eimg)
        let processor = DownsamplingImageProcessor(size: cell.profileImg.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        cell.profileImg.kf.indicatorType = .activity
        cell.profileImg.kf.setImage(
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
                cell.profileImg.image = UIImage(named: "udefault")
            }
        }
        
    }
    
  
    if UserDefaults.standard.bool(forKey: "emailother") == true
    {
        cell.addObj.isHidden = true
    }
    else
    {
        cell.addObj.isHidden = false
    }
    
    cell.artistNameLbl.text! = (artistArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
    
    
    cell.addObj.tag = indexPath.row
    return cell
}


}

extension Numeric {
    func formatted(with groupingSeparator: String? = nil, style: NumberFormatter.Style, locale: Locale = .current) -> String {
        Formatter.number.locale = locale
        Formatter.number.numberStyle = style
        if let groupingSeparator = groupingSeparator {
            Formatter.number.groupingSeparator = groupingSeparator
        }
        return Formatter.number.string(for: self) ?? ""
    }
    // Localized
    var currency:   String { formatted(style: .currency) }
    // Fixed locales
    var currencyUS: String { formatted(style: .currency, locale: .englishUS) }
    var currencyFR: String { formatted(style: .currency, locale: .frenchFR) }
    var currencyBR: String { formatted(style: .currency, locale: .portugueseBR) }
    // ... and so on
   // var calculator: String { formatted(groupingSeparator: " ", style: .decimal) }
}
extension Formatter {
    static let number = NumberFormatter()
}
extension Locale {
    static let englishUS: Locale = .init(identifier: "en_US")
    static let frenchFR: Locale = .init(identifier: "fr_FR")
    static let portugueseBR: Locale = .init(identifier: "pt_BR")
    // ... and so on
}
extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
extension Float {
    func decimalCount() -> Int {
        if self == Float(Int(self)) {
            return 0
        }

        let integerString = String(Int(self))
        let doubleString = String(Float(self))
        let decimalCount = doubleString.count - integerString.count - 1

        return decimalCount
    }
}
