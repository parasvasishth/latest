//
//  LoginVC.swift
//  Stumbal
//
//  Created by mac on 17/03/21.
//

import UIKit
import Alamofire
import GoogleSignIn
import FBSDKLoginKit
import FacebookCore
import AuthenticationServices
import SwiftUI
//GIDSignInDelegate,GIDSignInUIDelegate

//GIDSignInDelegate,GIDSignInUIDelegate,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
class UnderlinedLabel: UILabel {

override var text: String? {
    didSet {
        guard let text = text else { return }
        let textRange = NSMakeRange(0, text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        // Add other attributes if needed
        self.attributedText = attributedText
    }
}
}

class LoginVC: UIViewController,GIDSignInDelegate{

@IBOutlet var userNameFiled: UITextField!
@IBOutlet var passwordField: UITextField!
@IBOutlet var termsLbl: UILabel!
@IBOutlet var rememberObj: UIButton!
@IBOutlet var scrollView: UIScrollView!
@IBOutlet var hideimg: UIImageView!
@IBOutlet var signuplbl: UnderlinedLabel!
@IBOutlet var forgotlbl: UnderlinedLabel!
@IBOutlet var loadingView: UIView!

var name:String = ""
var email:String = ""
var fbid:String = ""
var loginType:String = ""
var old:Bool = Bool()
var new:Bool = Bool()
var firstname:String = ""
var lastname:String = ""
var deviceId:String = ""
var hud = MBProgressHUD()
override func viewDidLoad() {
    super.viewDidLoad()
    loadingView.isHidden = false
    forgotlbl.text = "Forgot Password?"
    
    passwordField.isSecureTextEntry = true
    userNameFiled.setLeftPaddingPoints(15)
    passwordField.setLeftPaddingPoints(15)
    
    
    let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
    forgotlbl.isUserInteractionEnabled = true
    forgotlbl.addGestureRecognizer(tapGestureRecognizer3)
    
    let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped4(tapGestureRecognizer:)))
    signuplbl.isUserInteractionEnabled = true
    signuplbl.addGestureRecognizer(tapGestureRecognizer4)
    
    signuplbl.text = "Create one now"
    
    new = true
    loadingView.isHidden = true
    
}

@objc func imageTapped4(tapGestureRecognizer: UITapGestureRecognizer){
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
}


@objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer){
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SendEmailVC") as! SendEmailVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
    
}

@objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
    if new == true
    {
        new = false
        passwordField.isSecureTextEntry = false
        hideimg.image = UIImage(named: "eye")
    }
    else
    {
        new = true
        passwordField.isSecureTextEntry = true
        hideimg.image = UIImage(named: "ceye")
    }
    
}

//    @objc private func handleLogInWithAppleIDButtonPress() {
//
//      }
//
//      private func performExistingAccountSetupFlows() {
//          // Prepare requests for both Apple ID and password providers.
//          let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
//
//          // Create an authorization controller with the given requests.
//          let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//          authorizationController.delegate = self
//          authorizationController.presentationContextProvider = self
//          authorizationController.performRequests()
//      }
//
//      func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//          //Handle error here
//      }
//
//      // ASAuthorizationControllerDelegate function for successful authorization
//      func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//          if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//              // Create an account in your system.
//              let userIdentifier = appleIDCredential.user
//              let userFirstName = appleIDCredential.fullName?.givenName
//              let userLastName = appleIDCredential.fullName?.familyName
//              let userEmail = appleIDCredential.email
//              print(userEmail)
//            print("152",userFirstName!,userLastName!,userIdentifier)
//            name = userFirstName! + userLastName!
//            email = userEmail!
//
//             fblogin()
//              //Navigate to other view controller
//          } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
//              // Sign in using an existing iCloud Keychain credential.
//              let username = passwordCredential.user
//              let password = passwordCredential.password
//
//              //Navigate to other view controller
//          }
//      }
//
//      func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//          return self.view.window!
//      }




//MARK: Google
private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
    //myActivityIndicator.stopAnimating()
}

// Present a view that prompts the user to sign in with Google
func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
    viewController.modalPresentationStyle = .fullScreen
    self.present(viewController, animated: false, completion: nil)
}

// Dismiss the "Sign in with Google" view
func sign(_ signIn: GIDSignIn!,
          dismiss viewController: UIViewController!) {
    self.dismiss(animated: false, completion: nil)
}

func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
          withError error: Error!) {
    if let error = error {
        print("\(error.localizedDescription)")
    } else {
        // Perform any operations on signed in user here.
        self.name = String(format: "%@", user.profile.givenName,user.profile.familyName)
        self.firstname = String(format: "%@", user.profile.givenName)
        self.lastname = String(format: "%@",user.profile.familyName)
        
        
        self.email  = user.profile.email
        if user.profile.hasImage
        {
            let pic : URL = user.profile.imageURL(withDimension: 300)
            let url = pic
            if let data = try? Data(contentsOf: url)
            {
                let image: UIImage = UIImage(data: data)!
            }
        }
        self.fblogin()
    }
}

func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
          withError error: Error!) {
    // Perform any operations when the user disconnects from app here.
    // ...
}

// MARK: - updateDeviceId
func updateDeviceId()
{
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    if UserDefaults.standard.value(forKey: "devicetoken") == nil
    {
        deviceId = ""
    }
    else
    {
        deviceId = UserDefaults.standard.value(forKey: "devicetoken") as! String
    }
    print("111",deviceId)
    
    Alamofire.request("https://stumbal.com/process.php?action=update_ios_deviceid", method: .post, parameters: ["user_id" : uID, "device_id" : deviceId], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.updateDeviceId()
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
                        //MBProgressHUD.hide(for: self.view, animated: true);
                        self.loadingView.isHidden = true
                        let alert = UIAlertController(title: "", message: "Login Successful", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        
                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 2
                        
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            self.userNameFiled.text = ""
                            self.passwordField.text = ""
                            
                            alert.dismiss(animated: false, completion: nil)
                            
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                            nextViewController.modalPresentationStyle = .fullScreen
                            self.present(nextViewController, animated:false, completion:nil)
                        }
                        
                        
                    }
                    
                }
            }
            
        }
    }
    
}


func fblogin()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    if UserDefaults.standard.bool(forKey: "fblogin") == true
    {
        loginType = "Facebook"
    }
    else if UserDefaults.standard.bool(forKey: "gmaillogin") == true
                
    {
        loginType = "Google"
    }
    else
    {
        loginType = "Apple"
    }
    
    Alamofire.request("https://stumbal.com/process.php?action=user_registration", method: .post, parameters: ["log_type":loginType,"fb_id":fbid,"google_id":"","fname":firstname,"lname":lastname,"gender":"","email":email,"password":"","dob":"","meta_tags":"","contact":""],encoding:  URLEncoding.httpBody).responseJSON{ response in
        if let data = response.data
        {
            let json = String(data: data, encoding: String.Encoding.utf8)
            print("=====1======")
            print("Response: \(String(describing: json))")
            
            if json == ""
            {
                MBProgressHUD.hide(for: self.view, animated: true);
                let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                    self.fblogin()
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
                        
                        // MBProgressHUD.hide(for: self.view, animated: true)
                        print("hello")
                        UserDefaults.standard.set(self.email, forKey: "Regis_Email")
                        
                        UserDefaults.standard.set(true, forKey: "login")
                        let id :String = json["insert_id"] as! String
                        UserDefaults.standard.set(false, forKey: "fblogin")
                        UserDefaults.standard.setValue(id, forKey: "u_Id")
                        UserDefaults.standard.set(false, forKey: "gmaillogin")
                        
                        self.updateDeviceId()
                        
                    }
                    else if result == "Email Already Exits"
                    {
                        // MBProgressHUD.hide(for: self.view, animated: true)
                        
                        UserDefaults.standard.set(true, forKey: "login")
                        let id :String = json["insert_id"] as! String
                        UserDefaults.standard.set(false, forKey: "fblogin")
                        UserDefaults.standard.setValue(id, forKey: "u_Id")
                        UserDefaults.standard.set(false, forKey: "gmaillogin")
                        self.updateDeviceId()
                        
                    }
                    else if result == "Facebook Id Already Exits"
                    {
                        // MBProgressHUD.hide(for: self.view, animated: true)
                        UserDefaults.standard.set(true, forKey: "login")
                        let id :String = json["insert_id"] as! String
                        UserDefaults.standard.set(false, forKey: "fblogin")
                        UserDefaults.standard.setValue(id, forKey: "u_Id")
                        UserDefaults.standard.set(false, forKey: "gmaillogin")
                        self.updateDeviceId()
                    }
                    else if result == "Google Id Already Exits" {
                        //  MBProgressHUD.hide(for: self.view, animated: true)
                        UserDefaults.standard.set(true, forKey: "login")
                        let id :String = json["insert_id"] as! String
                        UserDefaults.standard.set(false, forKey: "fblogin")
                        UserDefaults.standard.setValue(id, forKey: "u_Id")
                        UserDefaults.standard.set(false, forKey: "gmaillogin")
                        self.updateDeviceId()
                    }
                    else if result == "Contact Number already exists"
                    {
                        // MBProgressHUD.hide(for: self.view, animated: true)
                        UserDefaults.standard.set(true, forKey: "login")
                        let id :String = json["insert_id"] as! String
                        UserDefaults.standard.set(false, forKey: "fblogin")
                        UserDefaults.standard.setValue(id, forKey: "u_Id")
                        UserDefaults.standard.set(false, forKey: "gmaillogin")
                        
                    }
                    else if result == "Contact Email already exists"
                    {
                        //  MBProgressHUD.hide(for: self.view, animated: true)
                        UserDefaults.standard.set(true, forKey: "login")
                        let id :String = json["insert_id"] as! String
                        UserDefaults.standard.set(false, forKey: "fblogin")
                        UserDefaults.standard.setValue(id, forKey: "u_Id")
                        UserDefaults.standard.set(false, forKey: "gmaillogin")
                        self.updateDeviceId()
                        
                    }
                    else if result == "Oops something went wrong please try again later or use other login types"
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let alert = UIAlertController(title: "", message: "Oops something went wrong please try again later or use other login types", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: false, completion: nil)
                    }
                    else
                    {
                        
                        UserDefaults.standard.set(true, forKey: "login")
                        let id :String = json["insert_id"] as! String
                        UserDefaults.standard.set(false, forKey: "fblogin")
                        UserDefaults.standard.setValue(id, forKey: "u_Id")
                        UserDefaults.standard.set(false, forKey: "gmaillogin")
                        self.updateDeviceId()
                    }
                }
            }
        }
    }
}

@objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
    let text = (termsLbl.text)!
    let termsRange = (text as NSString).range(of: "Terms of Service")
    let privacyRange = (text as NSString).range(of: "Privacy Policy")
    
    if gesture.didTapAttributedTextInLabel(label: termsLbl, inRange: termsRange) {
        print("Tapped terms")
        UserDefaults.standard.set(true, forKey: "Terms")
        UserDefaults.standard.set(false, forKey: "Privacy")
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    else if gesture.didTapAttributedTextInLabel(label: termsLbl, inRange: privacyRange) {
        UserDefaults.standard.set(true, forKey: "Privacy")
        UserDefaults.standard.set(false, forKey: "Terms")
        print("Tapped privacy")
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    else {
        UserDefaults.standard.set(false, forKey: "Terms")
        UserDefaults.standard.set(false, forKey: "Privacy")
        print("Tapped none")
    }
}

func getdetail() {
    
    if UserDefaults.standard.bool(forKey: "checked"){
        
        UserDefaults.standard.setValue(userNameFiled.text!, forKey: "EMail")
        UserDefaults.standard.setValue(passwordField.text!, forKey: "RememberPassword")
    }else{
        UserDefaults.standard.removeObject(forKey: "EMail")
        UserDefaults.standard.removeObject(forKey: "RememberPassword")
        
    }
}
// MARK: - Email Validation
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}



// MARK: - Action
@IBAction func forgot(_ sender: UIButton) {
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SendEmailVC") as! SendEmailVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

@IBAction func remember(_ sender: UIButton) {
    if sender.tag == 0{
        sender.tag = 1
        UserDefaults.standard.set(true, forKey: "checked")
        rememberObj.setImage(UIImage(named: "rightc"), for: .normal)
        getdetail()
        
    }else{
        rememberObj.setImage(UIImage(named: "box"), for: .normal)
        sender.tag = 0
        UserDefaults.standard.set(false, forKey: "checked")
        getdetail()
        
    }
}

@IBAction func login(_ sender: UIButton) {
    
    
    if userNameFiled.text != "" && passwordField.text != ""
    {
        if isValidEmail(userNameFiled.text!)
        {
            login()
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Invalid Email Id", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    else
    {
        let alert = UIAlertController(title: "", message: "All Field Required", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
}

@IBAction func google(_ sender: UIButton) {
    
    //   GIDSignIn.sharedInstance()?.presentingViewController = self
    
    // Automatically sign in the user.
    // GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    UserDefaults.standard.set(true, forKey: "gmaillogin")
    
    //   GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().presentingViewController = self
    GIDSignIn.sharedInstance()?.delegate = self
    GIDSignIn.sharedInstance()?.signIn()
    
    
}

@IBAction func facebook(_ sender: UIButton) {
    
    UserDefaults.standard.set(true, forKey: "fblogin")
    
    let fbLoginManager : LoginManager = LoginManager()
    fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
        if (error == nil){
            let fbloginresult : LoginManagerLoginResult = result!
            // if user cancel the login
            if (result?.isCancelled)!{
                return
            }
            if(fbloginresult.grantedPermissions.contains("email"))
            {
                self.getFBUserData()
            }
            else
            {
                
            }
        }
    }
}

@IBAction func apple(_ sender: UIButton) {
    //    let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
    //    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
    //    self.present(alert, animated: false, completion: nil)
    
    //
    
}

@IBAction func signup(_ sender: UIButton) {
    self.userNameFiled.text = ""
    self.passwordField.text = ""
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
}


//MARK: Facebook
func getFBUserData(){
    if((AccessToken.current) != nil){
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                //everything works print the user data
                var dict : NSDictionary = NSDictionary()
                var Imagdict : NSDictionary = NSDictionary()
                var datadict : NSDictionary = NSDictionary()
                print(result!)
                dict = result as! NSDictionary
                Imagdict =  dict.value(forKey: "picture") as! NSDictionary
                datadict =  Imagdict.value(forKey: "data") as! NSDictionary
                let url = URL(string:datadict.value(forKey: "url") as! String)
                if let data = try? Data(contentsOf: url!)
                {
                    let image: UIImage = UIImage(data: data)!
                }
                self.firstname = dict.value(forKey: "first_name") as! String
                self.lastname = dict.value(forKey: "last_name") as! String
                self.email = dict.value(forKey: "email") as! String
                self.fbid  = dict.value(forKey: "id") as! String
                
                self.fblogin()
            }
            else
            {
                print(error)
            }
        })
    }
}

// MARK: - login
func login()
{
    //
    //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //    hud.mode = MBProgressHUDMode.indeterminate
    //    hud.self.bezelView.color = UIColor.black
    //    hud.label.text = "Loading...."
    loadingView.isHidden = false
    
    getdetail()
    
    Alamofire.request("https://stumbal.com/process.php?action=user_login", method: .post,parameters: ["email":userNameFiled.text!,"password":passwordField.text!],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                    self.login()
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
                        
                        //  MBProgressHUD.hide(for: self.view, animated: true)
                        //  self.userNameFiled.text = ""
                        // self.passwordField.text = ""
                        
                        UserDefaults.standard.setValue(json["user_id"] as! String, forKey: "u_Id")
                        UserDefaults.standard.set(true, forKey: "login")
                        
                        self.updateDeviceId()
                        
                    }
                    
                    else {
                        self.loadingView.isHidden = true
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

}

extension UITapGestureRecognizer {

func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize.zero)
    let textStorage = NSTextStorage(attributedString: label.attributedText!)
    
    // Configure layoutManager and textStorage
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0
    textContainer.lineBreakMode = label.lineBreakMode
    textContainer.maximumNumberOfLines = label.numberOfLines
    let labelSize = label.bounds.size
    textContainer.size = labelSize
    
    // Find the tapped character location and compare it to the specified range
    let locationOfTouchInLabel = self.location(in: label)
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                      y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                 y: locationOfTouchInLabel.y - textContainerOffset.y);
    let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    
    return NSLocationInRange(indexOfCharacter, targetRange)
}
}
@IBDesignable
public class GradientView: UILabel {
public override class var layerClass: AnyClass         { CAGradientLayer.self }
private var gradientLayer: CAGradientLayer             { layer as! CAGradientLayer }

@IBInspectable public var startColor: UIColor = .white { didSet { updateColors1() } }
@IBInspectable public var endColor: UIColor = .red     { didSet { updateColors1() } }

// expose startPoint and endPoint to IB

@IBInspectable public var startPoint: CGPoint {
    get { gradientLayer.startPoint }
    set { gradientLayer.startPoint = newValue }
}

@IBInspectable public var endPoint: CGPoint {
    get { gradientLayer.endPoint }
    set { gradientLayer.endPoint = newValue }
}

// while we're at it, let's expose a few more layer properties so we can easily adjust them in IB

@IBInspectable public var cornerRadius: CGFloat {
    get { layer.cornerRadius }
    set { layer.cornerRadius = newValue }
}

@IBInspectable public var borderWidth: CGFloat {
    get { layer.borderWidth }
    set { layer.borderWidth = newValue }
}

@IBInspectable public var borderColor: UIColor? {
    get { layer.borderColor.flatMap { UIColor(cgColor: $0) } }
    set { layer.borderColor = newValue?.cgColor }
}

// init methods

public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    updateColors1()
}

required init?(coder: NSCoder) {
    super.init(coder: coder)
    updateColors1()
}


var cornerRadiusValue : CGFloat = 0
var corners : UIRectCorner = []



@IBInspectable public var topLeft : Bool {
    get {
        return corners.contains(.topLeft)
    }
    set {
        setCorner(newValue: newValue, for: .topLeft)
    }
}

@IBInspectable public var topRight : Bool {
    get {
        return corners.contains(.topRight)
    }
    set {
        setCorner(newValue: newValue, for: .topRight)
    }
}

@IBInspectable public var bottomLeft : Bool {
    get {
        return corners.contains(.bottomLeft)
    }
    set {
        setCorner(newValue: newValue, for: .bottomLeft)
    }
}

@IBInspectable public var bottomRight : Bool {
    get {
        return corners.contains(.bottomRight)
    }
    set {
        setCorner(newValue: newValue, for: .bottomRight)
    }
}

func setCorner(newValue: Bool, for corner: UIRectCorner) {
    if newValue {
        addRectCorner(corner: corner)
    } else {
        removeRectCorner(corner: corner)
    }
}

func addRectCorner(corner: UIRectCorner) {
    corners.insert(corner)
    updateCorners()
}

func removeRectCorner(corner: UIRectCorner) {
    if corners.contains(corner) {
        corners.remove(corner)
        updateCorners()
    }
}

func updateCorners() {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadiusValue, height: cornerRadiusValue))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
}



}

private extension GradientView {
func updateColors1() {
    gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
}
}


@IBDesignable
public class GradientView1: UIView {
public override class var layerClass: AnyClass         { CAGradientLayer.self }
private var gradientLayer: CAGradientLayer             { layer as! CAGradientLayer }

@IBInspectable public var startColor: UIColor = .white { didSet { updateColors2() } }
@IBInspectable public var endColor: UIColor = .red     { didSet { updateColors2() } }

// expose startPoint and endPoint to IB

@IBInspectable public var startPoint: CGPoint {
    get { gradientLayer.startPoint }
    set { gradientLayer.startPoint = newValue }
}

@IBInspectable public var endPoint: CGPoint {
    get { gradientLayer.endPoint }
    set { gradientLayer.endPoint = newValue }
}

// while we're at it, let's expose a few more layer properties so we can easily adjust them in IB

@IBInspectable public var cornerRadius: CGFloat {
    get { layer.cornerRadius }
    set { layer.cornerRadius = newValue }
}

@IBInspectable public var borderWidth: CGFloat {
    get { layer.borderWidth }
    set { layer.borderWidth = newValue }
}

@IBInspectable public var borderColor: UIColor? {
    get { layer.borderColor.flatMap { UIColor(cgColor: $0) } }
    set { layer.borderColor = newValue?.cgColor }
}

// init methods

public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    updateColors2()
}

required init?(coder: NSCoder) {
    super.init(coder: coder)
    updateColors2()
}


var cornerRadiusValue : CGFloat = 0
var corners : UIRectCorner = []



@IBInspectable public var topLeft : Bool {
    get {
        return corners.contains(.topLeft)
    }
    set {
        setCorner(newValue: newValue, for: .topLeft)
    }
}

@IBInspectable public var topRight : Bool {
    get {
        return corners.contains(.topRight)
    }
    set {
        setCorner(newValue: newValue, for: .topRight)
    }
}

@IBInspectable public var bottomLeft : Bool {
    get {
        return corners.contains(.bottomLeft)
    }
    set {
        setCorner(newValue: newValue, for: .bottomLeft)
    }
}

@IBInspectable public var bottomRight : Bool {
    get {
        return corners.contains(.bottomRight)
    }
    set {
        setCorner(newValue: newValue, for: .bottomRight)
    }
}

func setCorner(newValue: Bool, for corner: UIRectCorner) {
    if newValue {
        addRectCorner(corner: corner)
    } else {
        removeRectCorner(corner: corner)
    }
}

func addRectCorner(corner: UIRectCorner) {
    corners.insert(corner)
    updateCorners()
}

func removeRectCorner(corner: UIRectCorner) {
    if corners.contains(corner) {
        corners.remove(corner)
        updateCorners()
    }
}

func updateCorners() {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadiusValue, height: cornerRadiusValue))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
}

}

private extension GradientView1 {
func updateColors2() {
    gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
}
}
