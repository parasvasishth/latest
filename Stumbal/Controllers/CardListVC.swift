//
//  CardListVC.swift
//  Stumbal
//
//  Created by mac on 23/04/21.
//

import UIKit
import Alamofire
import PassKit
import Stripe
class CardListVC: UIViewController,UITableViewDataSource,UITableViewDelegate, STPAuthenticationContext,STPPaymentCardTextFieldDelegate {
   
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
//    STPApplePayContextDelegate
@IBOutlet var cardListTableview: UITableView!
@IBOutlet var orHeight: NSLayoutConstraint!
@IBOutlet var payHeight: NSLayoutConstraint!
@IBOutlet var submitHeight: NSLayoutConstraint!
@IBOutlet var submitobj: UIButton!
    @IBOutlet weak var loadingView: UIView!
    var Arr: NSMutableArray = NSMutableArray()
var AppendArr: NSMutableArray = NSMutableArray()
var hud = MBProgressHUD()
var cardId:String = ""
var lastfour:String = ""
    var payment_Type:String = ""
    var cardParams = STPCardParams()
    let paymentTextField = STPPaymentCardTextField()
    var paymentIntentClientSecret: String?

        lazy var cardTextField: STPPaymentCardTextField = {
            let cardTextField = STPPaymentCardTextField()
            return cardTextField
        }()
    let applePayButton: PKPaymentButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)

    //MARK:- LOCAL PROPERTIES
        private var paymentRequest : PKPaymentRequest = {
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.com.offside.stumbal"
            request.supportedNetworks = [.quicPay, .masterCard, .visa ,.JCB ]
            request.supportedCountries = ["AU"]
            request.merchantCapabilities = [.capability3DS , .capabilityCredit , .capabilityEMV , .capabilityDebit ]
            request.countryCode = "AU"
            request.currencyCode = "AUD"
            
          //  request.paymentSummaryItems = [PKPaymentSummaryItem(label: "iPhone XR 128 GB", amount: 123000)]
            
            return request
        }()
override func viewDidLoad() {
    super.viewDidLoad()
    STPPaymentConfiguration.shared.publishableKey = "pk_live_51JDjTWCfug4mSnmVSmsfUoY5CyxETAiY0yn2FNimY04EJnOkKAhiie4JfM4rjPkEeW9rJXrqSE7aqipkQ22l9gG200JxiTktSS"

    cardListTableview.dataSource = self
    cardListTableview.delegate = self
    fetchCardDetail()
  //  applePayButton.isHidden = !StripeAPI.deviceSupportsApplePay()
          //  applePayButton.addTarget(self, action: #selector(handleApplePayButtonTapped), for: .touchUpInside)
    print("111",PKPaymentAuthorizationController.canMakePayments(usingNetworks: [.visa]))
    
   // STPAPIClient.shared.publishableKey = "pk_test_51JDjTWCfug4mSnmV87J6mXngAm278Uq1QG7tSEodiI0PALykovu8FqlPSNvPpj2n1XCnqhSSeulzZVk6PCHigzA600mdPu507G"

  //  STPPaymentConfiguration.sharedConfiguration().publishableKey = "pk_test_1234rtyhudjjfjjs"
    
   // check_ticket_book()

    // Do any additional setup after loading the view.
}
    @objc func handleApplePayButtonTapped() {
        let merchantIdentifier = "merchant.com.your_app_name"
        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")

        // Configure the line items on the payment request
        paymentRequest.paymentSummaryItems = [
            // The final line should represent your company;
            // it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
            PKPaymentSummaryItem(label: "iHats, Inc", amount: 50.00),
        ]
        // ...continued in next step
    }
    
//    func handleApplePayButtonTapped() {
//        // ...continued from previous step
//
//        // Initialize an STPApplePayContext instance
//        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
//            // Present Apple Pay payment sheet
//            applePayContext.presentApplePay(on: self)
//        } else {
//            // There is a problem with your Apple Pay configuration
//        }
//    }
@IBAction func deletecard(_ sender: UIButton) {
    
    let tagVal : Int = sender.tag
    cardId = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "card_id")as! String
    
    let defaults = UserDefaults.standard
    let refreshAlert = UIAlertController(title: "Delete Card", message: "", preferredStyle: UIAlertController.Style.alert)
    
    refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
        print("Handle Ok login here")
        self.delete_user_card()
        
    }))
    refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        print("Handle Cancel Login here")
    }))
    present(refreshAlert, animated: true, completion: nil)
    
}

@IBAction func back(_ sender: UIButton) {
    UserDefaults.standard.set(false, forKey: "card")
    
    self.dismiss(animated: false, completion: nil)
}

@IBAction func addCard(_ sender: UIButton) {
    
    var cardCon = self.storyboard?.instantiateViewController(withIdentifier: "CreditCardVC") as! CreditCardVC
    cardCon.modalPresentationStyle = .fullScreen
    self.present(cardCon, animated: false, completion:nil)
}

@IBAction func selectcard(_ sender: UIButton) {
    
    
    let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
    let cell = self.cardListTableview.cellForRow(at: indexPath) as! SelectCardTableViewCell
    cell.selectcardObj.isSelected = true
    fetchCardDetail()
    //  let tagVal : Int = sender.tag
    cardId = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "card_id")as! String
    //  englishObj.setImage( UIImage(named:"fill"), for: .normal)
    UserDefaults.standard.setValue(cardId, forKey: "C_id")
    
    let cardno = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "card_number")as! String
    
    
    let last4 = String(cardno.suffix(4))
    
    lastfour = "XXXX XXXX XXXX "+last4
    UserDefaults.standard.set(true, forKey: "card")
    
}

    @IBAction func applePay(_ sender: UIButton) {
        
        payment_Type = "Apple"
        paymentRequest.merchantIdentifier = "merchant.com.offside.stumbal"
        paymentRequest.supportedNetworks = [.JCB,.amex,.visa,.masterCard,.quicPay,.discover,.idCredit,.electron,.vPay,.suica]
        paymentRequest.supportedCountries = ["AU"]
        paymentRequest.merchantCapabilities = [.capability3DS]
        paymentRequest.countryCode = "AU"
        paymentRequest.currencyCode = "AUD"
        
                   paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label:  UserDefaults.standard.value(forKey: "e_providername") as! String, amount: NSDecimalNumber(string:  UserDefaults.standard.value(forKey: "Event_ticketprice") as! String))]
        

                   let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
                   if controller != nil {
                       controller!.delegate = self
                       present(controller!, animated: true, completion: nil)
                   }

        
       // / ...continued from previous step

            // Initialize an STPApplePayContext instance
//            if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
//                // Present Apple Pay payment sheet
//                applePayContext.presentApplePay(on: self)
//            } else {
//                // There is a problem with your Apple Pay configuration
//            }
        
//        let merchantIdentifier = "merchant.com.offside.stumbal"
//        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "AU", currency: "AUD")

        
//                paymentRequest.merchantIdentifier = "merchant.com.offside.stumbal"
        //paymentRequest.supportedNetworks = [.quicPay, .masterCard, .visa ,.JCB ]
//                paymentRequest.supportedCountries = ["AU"]
//                paymentRequest.merchantCapabilities = .capability3DS
//                paymentRequest.countryCode = "AU"
//                paymentRequest.currencyCode = "AUD"
//                           paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label:  UserDefaults.standard.value(forKey: "e_providername") as! String, amount: NSDecimalNumber(string:  UserDefaults.standard.value(forKey: "Event_ticketprice") as! String))]
        
//        // Configure the line items on the payment request
//        paymentRequest.paymentSummaryItems = [
//            // The final line should represent your company;
//            // it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
//
//            PKPaymentSummaryItem(label: UserDefaults.standard.value(forKey: "e_providername") as! String, amount: 1.00),
//        ]
//
//        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
//               // Present Apple Pay payment sheet
//               applePayContext.presentApplePay(on: self)
//          //  pay()
//           } else {
//               // There is a problem with your Apple Pay configuration
//            print(454544)
//           }
       
    }
    @IBAction func submit(_ sender: UIButton) {
    
    if UserDefaults.standard.bool(forKey: "card") == true
    {
        payment_Type = "Paypal"
        buy_tickets()
    }
    else
    {
        let alert = UIAlertController(title: "", message: "Select Card", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
}
 
    
// MARK: - buy_tickets
func buy_tickets()
{
    
//    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//    hud.mode = MBProgressHUDMode.indeterminate
//    hud.self.bezelView.color = UIColor.black
//    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=buy_tickets", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String,"price":UserDefaults.standard.value(forKey: "Event_ticketprice") as! String, "card_id":cardId,"type":UserDefaults.standard.value(forKey: "eventprivacy") as! String ,"payment_type":payment_Type,"quantity":UserDefaults.standard.value(forKey: "qty") as! String], encoding:  URLEncoding.httpBody).responseJSON
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

//MARK: Delete Card ;
func delete_user_card()
{
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    Alamofire.request("https://stumbal.com/process.php?action=remove_card", method: .post, parameters: ["user_id" : uID,"card_id":cardId], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.delete_user_card()
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
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.fetchCardDetail()
                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true);
                    }
                    
                }
                
            }
        }
    }
    
}
//    func check_ticket_book()
//    {
////        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
////        hud.mode = MBProgressHUDMode.indeterminate
////        hud.self.bezelView.color = UIColor.black
////        hud.label.text = "Loading...."
//        Alamofire.request("https://stumbal.com/process.php?action=check_ticket_book", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String], encoding:  URLEncoding.httpBody).responseJSON
//        { response in
//            if let data = response.data
//            {
//                let json = String(data: data, encoding: String.Encoding.utf8)
//                print("=====1======")
//                print("Response: \(String(describing: json))")
//                print("22222222222222")
//                //print(response.result.value as Any)
//
//                if json == ""
//                {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
//                        print("Action")
//                        self.apple_token_url()
//                    }))
//                    self.present(alert, animated: false, completion: nil)
//
//                }
//                else
//                {
//                    if let json: NSDictionary = response.result.value as? NSDictionary
//
//                    {
//                        print("JSON: \(json)")
//                        print("66666666666")
//
//
//
////                        if  json["result"] as! String == "success"
////                        {
////                            MBProgressHUD.hide(for: self.view, animated: true);
////                            self.fetchCardDetail()
////                        }
////                        else
////                        {
////                            MBProgressHUD.hide(for: self.view, animated: true);
////                        }
////
//                    }
//
//                }
//            }
//        }
//
//    }
    var urlString:String = ""
    var tokenId:String = ""
    //MARK: apple_token_url ;
    func apple_token_url()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=apple_token_url", method: .post, parameters: ["stripeToken" : tokenId,"amount":UserDefaults.standard.value(forKey: "Event_ticketprice") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.apple_token_url()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        print("JSON: \(json)")
                        print("66666666666")
                        
                        self.urlString = json["url"] as! String
                        self.payment()
                        
                        
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
    
    // MARK: - Payment
    func payment()
    {
//        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
       // print("144",cardId,cardstatus,actualprice,urlString)
        
        
        Alamofire.request(urlString, method: .post, parameters:nil, encoding:  URLEncoding.httpBody).responseJSON
            { response in
                if let data = response.data
                {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    
                    print("Response: \(String(describing: json))")
                    if json == ""
                    {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        let alert = UIAlertController(title: "Network Error: Could not connect to server.", message: "Oops! Network was failed to process your request. Do you want to try again?", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                            print("Action")
                            self.payment()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        if let json: NSDictionary = response.result.value as? NSDictionary
                            
                        {
                            let result : String = json["result"]! as! String
                            if  result == "success"
                            {
                                
                               // MBProgressHUD.hide(for: self.view, animated: true);
                                UserDefaults.standard.set(false, forKey: "card")
                                self.buy_tickets()
                                
                            }
                            else
                            {
                             //   self.buy_tickets()
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: false, completion: nil)
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

//MARK: Fetch Card ;

func fetchCardDetail()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_card_list", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.fetchCardDetail()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                self.Arr = NSMutableArray()
                do  {
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    
                    if self.AppendArr.count != 0 {
                        
                        self.cardListTableview.isHidden = false
                        self.orHeight.constant = 21
                        self.submitHeight.constant = 45
                        self.payHeight.constant = 21
                        self.cardListTableview.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.cardListTableview.isHidden = true
                        self.orHeight.constant = 0
                        self.submitHeight.constant = 0
                        self.payHeight.constant = 0
                        
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
    return AppendArr.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  cardListTableview.dequeueReusableCell(withIdentifier: "SelectCardTableViewCell", for: indexPath) as! SelectCardTableViewCell
    
    cell.cardView.layer.masksToBounds = false
    cell.cardView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    cell.cardView.layer.shadowOpacity = 0.50
    cell.cardView.layer.shadowRadius = 4
    cell.cardView.layer.cornerRadius = 4;
    
    let cardno = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "card_number")as! String
    cell.nameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "card_holder_name")as! String
    
    let last4 = String(cardno.suffix(4))
    
    cell.cardNumberLbl.text = "XXXX XXXX XXXX "+last4
    //  cell.sewlectCardObj.tag = indexPath.row
    cell.deleteObj.tag = indexPath.row
    
    cell.selectcardObj.tag = indexPath.row
    cell.selectcardObj.setImage(UIImage(named:(cell.selectcardObj.isSelected ? "fill1" : "bcircle")), for:.normal)
    cell.selectcardObj.isSelected = false
    return cell
}

    func pay()
    {
//        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
//                return;
//            }
            // Collect card details
            let cardParams = cardTextField.cardParams
            let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
         //   let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
           // paymentIntentParams.paymentMethodParams = paymentMethodParams

            // Submit the payment
//            let paymentHandler = STPPaymentHandler.shared()
//            paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
//                switch (status) {
//                case .failed:
//
//                    break
//                case .canceled:
//                    
//                    break
//                case .succeeded:
//                    break
//                @unknown default:
//                    fatalError()
//                    break
//                }
//            }
        }
    
}
extension CardListVC : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: false, completion: nil)
      
    }
    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        payment.billingContact?.name
//        print("1111",payment.billingContact?.name)
//        cardId = ""
//       // buy_tickets()
//
//      //  Stripe.createTokenWithPayment(payment) { (token, error) -> Void in
//         //   let tokenValue = token?.tokenId
//
//        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//    }
        
func paymentAuthorizationViewController(_ controller:
                                            PKPaymentAuthorizationViewController, didAuthorizePayment payment:
                                                PKPayment, handler completion: @escaping(PKPaymentAuthorizationResult) -> Void) {
                STPAPIClient.shared.createToken(with: payment) { [self] token, error in
                         guard let token = token else {
                             // Handle the error
                            let alert = UIAlertController(title: "", message: "error", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: false, completion: nil)
                             return
                         }

                    self.tokenId = token.tokenId
                   
    
    do {
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        apple_token_url()
    }
    catch let error
    {
        print(error)
        completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
        
    }
}
}
}
//        func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
//               // Convert the PKPayment into a Token
//
//
//
////            STPAPIClient.shared.createToken(with: payment) { [self] token, error in
////                     guard let token = token else {
////                         // Handle the error
////                        let alert = UIAlertController(title: "", message: "error", preferredStyle: UIAlertController.Style.alert)
////                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
////                        self.present(alert, animated: false, completion: nil)
////                         return
////                     }
////
////
////                self.tokenId = token.tokenId
////                apple_token_url()
//                   // Send the token identifier to your server to create a Charge...
//                   // If the server responds successfully, set self.paymentSucceeded to YES
////                let alert = UIAlertController(title: "", message: tokenID, preferredStyle: UIAlertController.Style.alert)
////                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
////                self.present(alert, animated: false, completion: nil)
//
////               }
//           }
//
//    }

//extension CardListVC {
//
////    func paymentAuthorizationViewController(_ controller:
////    PKPaymentAuthorizationViewController, didAuthorizePayment payment:
////    PKPayment, handler completion: @escaping
////    (PKPaymentAuthorizationResult) -> Void) {
//// //   If the payment data are nil or not check for simulator always its nil :
////
////    do {
////
////                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
////
////            }
////            catch let error
////            {
////                print(error)
////                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
////
////            }
////    }
////    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
////        //apple_token_url()
////
//////        do {
//////                    let jsonResponse = try JSONSerialization.jsonObject(with: paymentStatus.paymentData, options: .mutableContainers)
//////                    print(jsonResponse as! NSDictionary)
//////                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//////
//////                }
//////                catch let error
//////                {
//////                    print(error)
//////                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
//////
//////                }
//////
////
////       // pay()
////
//////        cardParams.number = paymentTextField.cardNumber!
//////        cardParams.expMonth = UInt(paymentTextField.expirationMonth)
//////        cardParams.expYear = UInt(paymentTextField.expirationYear)
//////        cardParams.cvc = paymentTextField.cvc!
////
////
//////            var cn = paymentTextField.cardNumber!
//////            var em =  paymentTextField.expirationMonth
//////            var ey =  paymentTextField.expirationYear
//////            var cvV =  paymentTextField.cvc!
////
////
////       // let clientSecret = ... // Retrieve the PaymentIntent client secret from your backend (see Server-side step above)
////        // Call the completion block with the client secret or an error
////       // completion(clientSecret, error);
////    }
////
////    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
////          switch status {
////        case .success:
////            // Payment succeeded, show a receipt view
////            print("done pay")
////            break
////        case .error:
////            // Payment failed, show the error
////            print(error)
////            break
////        case .userCancellation:
////            // User cancelled the payment
////            print("144")
////            break
////        @unknown default:
////            fatalError()
////            print("unknown")
////        }
////    }
//}
