//
//  CheckOutVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 12/02/22.
//

import UIKit
import Alamofire
class CheckOutVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var nameFiled: UITextField!
    @IBOutlet weak var emailFiled: UITextField!
    @IBOutlet weak var ticketPriceLbl: UILabel!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var promoFiled: UITextField!
    @IBOutlet weak var everyOneLbl: UILabel!
    @IBOutlet weak var friendLbl: UILabel!
    @IBOutlet weak var onlyLbl: UILabel!
    @IBOutlet weak var emailInviteField: UITextField!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var finalPricelbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var promoLbl: UILabel!
    @IBOutlet weak var promoHeight: NSLayoutConstraint!
    @IBOutlet weak var discountLnl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    var privacyStr:String = ""
    let thePicker2 = UIPickerView()
    var genderPickerData = [String]()
    var hud = MBProgressHUD()
    var promocodeId:String = ""
    var ticket_status:String = ""
    var eventpriceString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = false
        quantityLbl.layer.cornerRadius =  quantityLbl.frame.width/2
        quantityLbl.layer.masksToBounds = true

        //promoLbl.isHidden = true
        //promoHeight.constant = 0
        promoFiled.delegate = self
        emailFiled.setLeftPaddingPoints(15)
        nameFiled.setLeftPaddingPoints(15)
        emailInviteField.setLeftPaddingPoints(15)
        promoFiled.setLeftPaddingPoints(15)
        quantityField.setLeftPaddingPoints(5)
        quantityField.text = "1"
        quantityLbl.text = "1"
         
        promoFiled.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
//        DispatchQueue.main.async { [self] in
//            cartView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
//          informationView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
//            
//        }
        
        self.cartView.roundCorners([.topLeft, .topRight], radius: 15.0)
        self.informationView.roundCorners([.topLeft, .topRight], radius: 15.0)
        
        emailFiled.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        nameFiled.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        emailInviteField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        
            emailFiled.attributedPlaceholder =
                NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        nameFiled.attributedPlaceholder =
            NSAttributedString(string: "Full name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        promoFiled.attributedPlaceholder =
            NSAttributedString(string: "Enter code", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        emailInviteField.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.everyOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.everyOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.friendLbl.backgroundColor = UIColor.black
        self.friendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.onlyLbl.backgroundColor = UIColor.black
        self.onlyLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        self.privacyStr = "Everyone"
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
        everyOneLbl.isUserInteractionEnabled = true
        everyOneLbl.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        friendLbl.isUserInteractionEnabled = true
        friendLbl.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
        onlyLbl.isUserInteractionEnabled = true
        onlyLbl.addGestureRecognizer(tapGestureRecognizer3)
        // Do any additional setup after loading the view.
        
        let p = UserDefaults.standard.value(forKey: "Event_ticketprice") as! String
        let tpu2 =  Float(p)!.currencyUS
        finalPricelbl.text = "A" + tpu2
        ticketPriceLbl.text = "A" + tpu2
        
        eventpriceString = UserDefaults.standard.value(forKey: "Event_ticketprice") as! String
        
        UserDefaults.standard.set(p, forKey: "actualprice")
        
        thePicker2.isHidden = true
        thePicker2.delegate = self
        thePicker2.dataSource = self
        quantityField.inputView = thePicker2
        quantityField.delegate = self
        
        UserDefaults.standard.set(false, forKey: "coupon")
        genderPickerData = ["1","2","3","4","5","6","7","8","9"]
        check_ticket_book()
    }
    override func viewWillAppear(_ animated: Bool) {
        eventpriceString = UserDefaults.standard.value(forKey: "actualprice") as! String
    }
    @objc func textFieldDidChange(textField: UITextField){
        
        if UserDefaults.standard.bool(forKey: "coupon") == true
        {
            discountLnl.text = ""
          UserDefaults.standard.set(false, forKey: "coupon")

            remove_code1()
            
        }
        else
        {
            
        }
        promoLbl.text = ""
    }
    
    @IBAction func Invite(_ sender: UIButton) {
        if emailInviteField.text != ""
        {
            
            if isValidEmail(emailInviteField.text!)
            {
               
                
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
    @IBAction func apply(_ sender: UIButton) {
        if promoFiled.text != ""
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
    
    @IBAction func back(_ sender: UIButton) {
        if promocodeId == ""
        {
            self.dismiss(animated: false, completion: nil)
        }
        else
        {
            remove_code()
        }
        let parsed = ticketPriceLbl.text!.replacingOccurrences(of: "A$", with: "")
       
        UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")
    }
    @IBAction func payNow(_ sender: UIButton) {
        if nameFiled.text != ""
        {
            if emailFiled.text != ""
            {
                if isValidEmail(emailFiled.text!)
                {
                    if ticket_status == "Ticket Not Booked"
                    {
                        UserDefaults.standard.setValue(privacyStr, forKey: "eventprivacy")
                        UserDefaults.standard.set(quantityLbl.text!, forKey: "qty")
                        
                        let parsed = self.finalPricelbl.text!.replacingOccurrences(of: "A$", with: "")
                        UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentCheckoutVC") as! PaymentCheckoutVC
                        nextViewController.modalPresentationStyle = .fullScreen
                        self.present(nextViewController, animated:false, completion:nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "", message: "You have already booked ticket", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: false, completion: nil)
                    }
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
                let alert = UIAlertController(title: "", message: "Enter email", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: false, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }
    var offP:String = ""
    // MARK: - check_loyalty_code
    func check_loyalty_code()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=check_loyalty_code", method: .post,parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"code":promoFiled.text!],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                            self.promoLbl.text = "Promo code applied successfully"
                            self.promocodeId = json["id"] as! String
                            
                            self.offP = json["offer_percent"] as! String
                            
                           
                            
                          
                            let discount:Float = Float(self.eventpriceString)! * Float(self.quantityLbl.text!)!
                            let discountcurrency =  discount.currencyUS
                          
                            
                            
                            let discount1:Float = discount * Float(self.offP)! / 100
                            
                            let discountcurrency1 =  discount1.currencyUS
                            
                            let tp:Float = discount
                         let ttlprice : Float = tp - discount1
                
                            print("1111",ttlprice)
                            
                            var finalprice =  ttlprice.currencyUS
                            
                            var tpu2 =  discount.currencyUS
                            let f:String = "A" + tpu2 + " less " + self.offP + "%" + " discount "
                            //+ "A" + discountcurrency1 + " = " + "A" + finalprice
                            print("111",tpu2)
                            self.discountLnl.text = f
                           self.finalPricelbl.text =  "A" + finalprice
                            //let parsed = finalprice.replacingOccurrences(of: "$", with: "")
                            UserDefaults.standard.set(true, forKey: "coupon")
                           // UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")
                        }
                        
                        else {
                            
                            MBProgressHUD.hide(for: self.view, animated: false)
                         print("111",result)
                            self.promoLbl.text = result
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
                            let discount:Float = Float(self.eventpriceString)! * Float(self.quantityLbl.text!)!
                            let discountcurrency =  discount.currencyUS
                            self.finalPricelbl.text = "A" + discountcurrency
                          
                          //  let parsed = self.finalPricelbl.text!.replacingOccurrences(of: "A$", with: "")
                        //    UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")
                            
//                            if let text = self.amountObj.titleLabel?.text {
//                                let parsed = text.replacingOccurrences(of: "$", with: "")
//                                UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")
//
//                            }
                           
                           
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
                            //let parsed = self.finalPricelbl.text!.replacingOccurrences(of: "A$", with: "")
                         //   UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")
                            
                            let discount:Float = Float(self.eventpriceString)! * Float(self.quantityLbl.text!)!
                            let discountcurrency =  discount.currencyUS
                            self.finalPricelbl.text = "A" + discountcurrency
//                            if let text = self..titleLabel?.text {
//                                let parsed = text.replacingOccurrences(of: "$", with: "")
//                                UserDefaults.standard.setValue(parsed, forKey: "Event_ticketprice")
//
//                            }
                           
                           
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
                        self.loadingView.isHidden = true
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
      
        
        Alamofire.request("https://stumbal.com/process.php?action=block_tkt", method: .post,parameters: ["user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String,"email_stumbalid":emailInviteField.text!,"status":"","send_user_id":""],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                            let alert = UIAlertController(title: "", message: "Invite has been sent successfully", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            // change to desired number of seconds (in this case 5 seconds)
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){ [self] in
                                // your code with delay
                                
                                alert.dismiss(animated: false, completion: nil)
                            }
                            self.emailInviteField.text = ""
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
    
    // MARK: - Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
        self.everyOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.everyOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.friendLbl.backgroundColor = UIColor.black
        self.friendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.onlyLbl.backgroundColor = UIColor.black
        self.onlyLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        self.privacyStr = "Everyone"
    }
    
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer){
        self.friendLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.friendLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.everyOneLbl.backgroundColor = UIColor.black
        self.everyOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.onlyLbl.backgroundColor = UIColor.black
        self.onlyLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        self.privacyStr = "Friend"
    }
    
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer){
        privacyStr = "Only Me"
        self.onlyLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.onlyLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.everyOneLbl.backgroundColor = UIColor.black
        self.everyOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.friendLbl.backgroundColor = UIColor.black
        self.friendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField){
     if textField == quantityField
        {
           
            self.thePicker2.isHidden = false
            self.thePicker2.reloadAllComponents()
        }

    }
    
    // MARK: - Picker Method
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int
    {
            return genderPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     
            return genderPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            quantityField.text = genderPickerData[row]
        quantityLbl.text = genderPickerData[row]
      
        if UserDefaults.standard.bool(forKey: "coupon") == true
        {
            let discount:Float = Float(self.eventpriceString)! * Float(self.quantityLbl.text!)!
            let discountcurrency =  discount.currencyUS
          
            let discount1:Float = discount * Float(self.offP)! / 100
            
            let discountcurrency1 =  discount1.currencyUS
            
            let tp:Float = discount
         let ttlprice : Float = tp - discount1

            print("1111",ttlprice)
            
            var finalprice =  ttlprice.currencyUS
            
            var tpu2 =  discount.currencyUS
            let f:String = "A" + tpu2 + " less " + self.offP + "%" + " discount "
            //+ "A" + discountcurrency1 + " = " + "A" + finalprice
            print("111",tpu2)
            self.discountLnl.text = f
           self.finalPricelbl.text =  "A" + finalprice
        }
        else
        {
           // let p:String = UserDefaults.standard.value(forKey: "Event_ticketprice") as! String
            let discount:Float = Float(eventpriceString)! * Float(quantityLbl.text!)!
            let discountcurrency =  discount.currencyUS
            finalPricelbl.text = "A" + discountcurrency
        }
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
