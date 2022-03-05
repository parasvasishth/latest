//
//  CreditCardVC.swift
//  Stumbal
//
//  Created by mac on 23/04/21.
//

import UIKit
import CreditCardForm
import Stripe
import Alamofire
class CreditCardVC: UIViewController,STPPaymentCardTextFieldDelegate {

@IBOutlet var creditcardView: CreditCardFormView!
@IBOutlet var nameFiled: UITextField!
var card_Type = String()
var hud = MBProgressHUD()
var cardParams = STPCardParams()
var responseArray : NSArray = NSArray()
let paymentTextField = STPPaymentCardTextField()
    @IBOutlet weak var loadingView: UIView!
    var cardId:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    paymentTextField.isHidden = false
    paymentTextField.postalCodeEntryEnabled = false
    nameFiled.setLeftPaddingPoints(10)
    
    nameFiled.attributedPlaceholder =
        NSAttributedString(string: "Card Holder Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    // Do any additional setup after loading the view.
    createCardTextField()
    // Do any additional setup after loading the view.
}

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}

@IBAction func submit(_ sender: UIButton) {
    insertCardDetail()
}

func insertCardDetail()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    if paymentTextField.cardNumber != nil && paymentTextField.expirationMonth != nil && paymentTextField.expirationYear != nil && paymentTextField.cvc != nil && nameFiled.text != "" {
        
        cardParams.number = paymentTextField.cardNumber!
        cardParams.expMonth = UInt(paymentTextField.expirationMonth)
        cardParams.expYear = UInt(paymentTextField.expirationYear)
        cardParams.cvc = paymentTextField.cvc!
        
        if (self.validateCustomerInfo()) {
            var cn = paymentTextField.cardNumber!
            var em =  paymentTextField.expirationMonth
            var ey =  paymentTextField.expirationYear
            var cvV =  paymentTextField.cvc!
            var n   = nameFiled.text!
            print("145",cn,em,ey,cvV,card_Type,n)
            
            let stryr : String = String(ey)
            let ey1 =  String(format: "20%@", stryr)
            var em1:String = String(em)
            
            if em1.count == 1 {
                em1 = String(format: "0%@",em1)
            }
            
            let id = UserDefaults.standard.value(forKey: "u_Id") as! String
            Alamofire.request("https://stumbal.com/process.php?action=user_card_detail", method: .post, parameters: ["user_id" : id,"card_holder_name":n,"card_number":cn,"expiry_month":em1,"expiry_year":ey1,"cvv":cvV], encoding:  URLEncoding.httpBody).responseJSON
            { [self] response in
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
                            self.insertCardDetail()
                        }))
                        self.present(alert, animated: false, completion: nil)
                        
                    }
                    else
                    {
                        
                        if let json: NSDictionary = response.result.value as? NSDictionary
                        
                        {
                            print("JSON: \(json)")
                            print("66666666666")
                            
                            let result : String = json["result"]! as! String
                            if  result == "success"
                            
                            {
                                
                                self.cardId = json["card_id"] as! String
                                self.buy_tickets()
                            }
                            
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: false)
                                let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: false, completion: nil)
                            }
                            
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: false)
                        }
                        
                    }
                    
                }
                
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
            }
        }
        
        else{
            let alert = UIAlertController(title: "Alert", message: "Payment details are invalid", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        
    }
    else {
        let alert = UIAlertController(title: "", message: "All fileds are required", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        MBProgressHUD.hide(for: self.view, animated: true)
        
    }
}

// MARK: - buy_tickets
func buy_tickets()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=buy_tickets", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String,"price":UserDefaults.standard.value(forKey: "Event_ticketprice") as! String, "card_id":cardId,"type":UserDefaults.standard.value(forKey: "eventprivacy") as! String,"payment_type":"Paypal","quantity":UserDefaults.standard.value(forKey: "qty") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.buy_tickets()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    
                    let result:String = json["result"] as! String
                    
                    if result == "success"
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print("hello")
                        
                        
                        let alert = UIAlertController(title: "", message: "Ticket Booked Successfully", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        
                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 2
                        
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            
                            alert.dismiss(animated: false, completion: nil)
                            
                            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                            signuCon.modalPresentationStyle = .fullScreen
                            self.present(signuCon, animated: false, completion:nil)
                            
                        }
                    }
                    else
                    {
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

func createCardTextField()
{
    paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
    paymentTextField.translatesAutoresizingMaskIntoConstraints = false
    paymentTextField.borderWidth = 0
    
    let border = CALayer()
    let width = CGFloat(1.0)
    border.borderColor = UIColor.darkGray.cgColor
    border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
    border.borderWidth = width
    paymentTextField.layer.addSublayer(border)
    paymentTextField.layer.masksToBounds = true
    
    view.addSubview(paymentTextField)
    
    NSLayoutConstraint.activate([
        paymentTextField.topAnchor.constraint(equalTo: creditcardView.bottomAnchor, constant: 20),
        paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
        paymentTextField.heightAnchor.constraint(equalToConstant: 44)
    ])
    
    paymentTextField.delegate = self
    
}


func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
    
    if textField.cardNumber == nil
    {
       
    }
    else
    {
        let amex = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.amex
        let visa = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.visa
        // let master = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.masterCard
        let jcb = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.JCB
        let discover = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.discover
        let union = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.unionPay
        if amex {
            card_Type = "Amex"
        }else if visa{
            card_Type = "Visa"
        }else if discover{
            card_Type = "Discover"
        }else if jcb{
            card_Type = "JCB"
        }else if union{
            card_Type = "UnionPay"
        }
        creditcardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
    }
    
//    let amex = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.amex
//    let visa = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.visa
//    // let master = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.masterCard
//    let jcb = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.JCB
//    let discover = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.discover
//    let union = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.unionPay
//    if amex {
//        card_Type = "Amex"
//    }else if visa{
//        card_Type = "Visa"
//    }else if discover{
//        card_Type = "Discover"
//    }else if jcb{
//        card_Type = "JCB"
//    }else if union{
//        card_Type = "UnionPay"
//    }
//    creditcardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
}

func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
    creditcardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
}
func validateCustomerInfo() -> Bool {
    // Validate card number, CVC, expMonth, expYear+
    return STPCardValidator.validationState(forCard: cardParams) == .valid
    
}

func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
    
    if textField.cardNumber == nil
    {
        
    }
    else
    {
        let amex = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.amex
        let visa = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.visa
        //  let master = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.masterCard
        let jcb = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.JCB
        let discover = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.discover
        let union = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.unionPay
        if amex {
            card_Type = "Amex"
        }else if visa{
            card_Type = "Visa"
        }else if discover{
            card_Type = "Discover"
        }else if jcb{
            card_Type = "JCB"
        }else if union{
            card_Type = "UnionPay"
        }
        creditcardView.paymentCardTextFieldDidBeginEditingCVC()
    }
   
}

func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
    if textField.cardNumber == nil
    {
      
    }
    else{
        let amex = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.amex
        let visa = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.visa
        // let master = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.masterCard
        let jcb = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.JCB
        let discover = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.discover
        let union = STPCardValidator.brand(forNumber: textField.cardNumber!) == STPCardBrand.unionPay
        if amex {
            card_Type = "Amex"
        }else if visa{
            card_Type = "Visa"
        }else if discover{
            card_Type = "Discover"
        }else if jcb{
            card_Type = "JCB"
        }else if union{
            card_Type = "UnionPay"
        }
        creditcardView.paymentCardTextFieldDidEndEditingCVC()
    }
}
}
