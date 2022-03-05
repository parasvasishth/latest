//
//  PaymentCheckoutVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 12/02/22.
//

import UIKit
import PassKit
import Stripe
import Alamofire
 
class PaymentCheckoutVC: UIViewController,STPAuthenticationContext,STPPaymentCardTextFieldDelegate {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var venuLbl: UILabel!
    @IBOutlet weak var eventLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var singleLbl: UILabel!
    @IBOutlet weak var checkpitView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var paymentStack: UIStackView!
    var hud = MBProgressHUD()
    @IBOutlet weak var loadingView: UIView!
    var payment_Type:String = ""
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
        loadingView.isHidden = false
        
        STPPaymentConfiguration.shared.publishableKey = "pk_live_51JDjTWCfug4mSnmVSmsfUoY5CyxETAiY0yn2FNimY04EJnOkKAhiie4JfM4rjPkEeW9rJXrqSE7aqipkQ22l9gG200JxiTktSS"
        
        quantityLbl.layer.cornerRadius =  quantityLbl.frame.width/2
        quantityLbl.layer.masksToBounds = true
       // checkpitView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
         //  paymentView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        let p = UserDefaults.standard.value(forKey: "Event_ticketprice") as! String
        let tpu2 =  Float(p)!.currencyUS
        priceLbl.text = "A" + tpu2
    
        let ap:String = UserDefaults.standard.value(forKey: "actualprice") as! String
        let tpu3 =  Float(ap)!.currencyUS
        singleLbl.text = "A" + tpu3
        quantityLbl.text = UserDefaults.standard.value(forKey: "qty") as! String
    
        venuLbl.text = UserDefaults.standard.value(forKey: "e_providername") as! String
        eventLbl.text = UserDefaults.standard.value(forKey: "e_name") as! String
        let q:String = UserDefaults.standard.value(forKey: "qty") as! String
       // venuLbl.text = "546556454354354545464454545345fhjsd4787878754121212121212-"
        //eventLbl.text = "Eveddgds6gdfg2f1dg212211112124545454545454545454545454545454545454540"
        qtyLbl.text = "ADULT ENTRY X" + q
        
        loadingView.isHidden = true
//        DispatchQueue.main.async { [self] in
//
//            self.checkpitView.roundCorners([.topLeft, .topRight], radius: 15.0)
//            self.paymentView.roundCorners([.topLeft, .topRight], radius: 15.0)
//
//        }
        
        DispatchQueue.main.async(execute: {
            self.paymentStack.backgroundColor = UIColor.white
               self.checkpitView.roundCorners([.topLeft, .topRight], radius: 15.0)
               self.paymentView.roundCorners([.topLeft, .topRight], radius: 15.0)
        })
        
      
        
    
      //  self.checkpitView.roundCorners([.topLeft, .topRight], radius: 15.0)
      //  self.paymentView.roundCorners([.topLeft, .topRight], radius: 15.0)
        // Do any additional setup after loading the view.
     //   self.checkpitView.roundCorners([.topLeft, .topRight], radius: 15.0)
      //  self.paymentView.roundCorners([.topLeft, .topRight], radius: 15.0)
        
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

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
        
    }
 
    @IBAction func crossBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func applepay(_ sender: UIButton) {
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

    }
    
    @IBAction func debitcard(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CardListVC") as! CardListVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    var urlString:String = ""
    var tokenId:String = ""
    //MARK: apple_token_url ;
    func apple_token_url()
    {
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        loadingView.isHidden = false
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
                    self.loadingView.isHidden = true
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
                        self.loadingView.isHidden = true
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
                                self.loadingView.isHidden = true
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
    // MARK: - buy_tickets
    func buy_tickets()
    {
        
    //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //    hud.mode = MBProgressHUDMode.indeterminate
    //    hud.self.bezelView.color = UIColor.black
    //    hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=buy_tickets", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String,"price":UserDefaults.standard.value(forKey: "Event_ticketprice") as! String, "card_id":"","type":UserDefaults.standard.value(forKey: "eventprivacy") as! String ,"payment_type":payment_Type,"quantity":UserDefaults.standard.value(forKey: "qty") as! String], encoding:  URLEncoding.httpBody).responseJSON
        { response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                
                print("Response: \(String(describing: json))")
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true
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
                            self.loadingView.isHidden = true
                            
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
                            self.loadingView.isHidden = true
                            let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: false, completion: nil)
                        }
                    }
                }
            }
            
        }
        
    }
}
extension PaymentCheckoutVC : PKPaymentAuthorizationViewControllerDelegate {
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
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.white
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
