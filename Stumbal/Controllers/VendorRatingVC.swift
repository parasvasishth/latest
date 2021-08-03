//
//  VendorRatingVC.swift
//  Stumbal
//
//  Created by mac on 10/04/21.
//

import UIKit
import Alamofire
class VendorRatingVC: UIViewController,UITextViewDelegate,FloatRatingViewDelegate{

@IBOutlet var ratingView: FloatRatingView!
@IBOutlet var reviewTxtView: UITextView!
var ratvalue  = String()
var hud = MBProgressHUD()
override func viewDidLoad() {
    super.viewDidLoad()
    
    reviewTxtView.text = "Write Your Feedback..."
    reviewTxtView.textColor = UIColor.lightGray
    reviewTxtView.delegate = self
    ratingView.delegate = self
    ratingView.type = .halfRatings
    
}

//MARK:- UITextViewDelegates method
func textViewDidBeginEditing(_ textView: UITextView) {
    if reviewTxtView.text == "Write Your Feedback..." {
        reviewTxtView.text = ""
        reviewTxtView.textColor = UIColor.black
    }
}

func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
        reviewTxtView.resignFirstResponder()
    }
    return true
}

func textViewDidEndEditing(_ textView: UITextView) {
    if reviewTxtView.text == "" {
        reviewTxtView.text = "Write Your Feedback..."
        reviewTxtView.textColor = UIColor.lightGray
    }
}


@IBAction func back(_ sender: UIButton) {
    UserDefaults.standard.set(false, forKey: "VendorRating")
    UserDefaults.standard.set(false, forKey: "EventRating")
    
    self.dismiss(animated: false, completion: nil)
}

@IBAction func submit(_ sender: UIButton) {
    
    if UserDefaults.standard.bool(forKey: "VendorRating") == true
    {
        provider_review_ratings()
    }
    else if UserDefaults.standard.bool(forKey: "EventRating") == true
    {
        event_review_ratings()
    }
    else
    {
        artist_review_ratings()
    }
    
}

func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
    ratvalue = String(format: "%.1f", self.ratingView.rating)
}

func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
    ratvalue = String(format: "%.1f", self.ratingView.rating)
}

// MARK: - provider_review_ratings
func provider_review_ratings()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    if ratvalue == ""
    {
        ratvalue = "0.0"
    }
    else
    {
        
    }
    
    Alamofire.request("https://stumbal.com/process.php?action=provider_review_ratings", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"provider_id":UserDefaults.standard.value(forKey: "V_id") as! String,"rating":ratvalue,"review":reviewTxtView.text!], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.provider_review_ratings()
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
                        
                        UserDefaults.standard.set(false, forKey: "VendorRating")
                        MBProgressHUD.hide(for: self.view, animated: false)
                        self.dismiss(animated: false, completion: nil)
                        
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

// MARK: - artist_review_ratings
func artist_review_ratings()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    if ratvalue == ""
    {
        ratvalue = "0.0"
    }
    else
    {
        
    }
    
    Alamofire.request("https://stumbal.com/process.php?action=artist_review_ratings", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"artist_id":UserDefaults.standard.value(forKey: "Event_artid") as! String,"rating":ratvalue,"review":reviewTxtView.text!], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.artist_review_ratings()
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
                        MBProgressHUD.hide(for: self.view, animated: false)
                        self.dismiss(animated: false, completion: nil)
                        
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

// MARK: - event_review_ratings
func event_review_ratings()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    if ratvalue == ""
    {
        ratvalue = "0.0"
    }
    else
    {
        
    }
    
    Alamofire.request("https://stumbal.com/process.php?action=event_review_ratings", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String,"rating":ratvalue,"review":reviewTxtView.text!], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.event_review_ratings()
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
                        MBProgressHUD.hide(for: self.view, animated: false)
                        UserDefaults.standard.set(false, forKey: "EventRating")
                        self.dismiss(animated: false, completion: nil)
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

}
