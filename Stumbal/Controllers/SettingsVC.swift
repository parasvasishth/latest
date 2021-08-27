//
//  SettingsVC.swift
//  Stumbal
//
//  Created by mac on 26/05/21.
//

import UIKit
import Alamofire
class SettingsVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {

@IBOutlet var distanceLbl: UILabel!
@IBOutlet var sistanceslider: UISlider!
    @IBOutlet var dayFiled: UITextField!
    var dist  = Int()
var minprice  = Int()
var maxprice  = Int()
var myPicker2Data1 = [String]()
let thePicker = UIPickerView()

var hud = MBProgressHUD()
var distance:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    dayFiled.setLeftPaddingPoints(15)
    dayFiled.attributedPlaceholder =
        NSAttributedString(string: "Select Days", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    myPicker2Data1 = ["1 Day" , "2 Days" , "3 Days", "4 Days" , "5 Days" ,"6 Days" , "7 Days"]
    fetch_user_distance()
    thePicker.isHidden = true
    thePicker.delegate = self
    thePicker.dataSource = self
    dayFiled.inputView = thePicker
    dayFiled.delegate = self
}

@IBAction func slideraction(_ sender: UISlider) {
    var currentValue = Int(sender.value)
    distanceLbl.text = String(format: "%dKm", currentValue)
    dist = currentValue
    distance = String(currentValue)
}

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}

@IBAction func apply(_ sender: UIButton) {
    insert_user_distance()
}
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dayFiled
        {
            DispatchQueue.main.async(execute: {
                
                self.thePicker.isHidden = false
                self.thePicker.reloadAllComponents()
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }

// MARK: - fetch_user_distance
func fetch_user_distance()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=fetch_user_distance", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
    { [self] response in
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
                    self.fetch_user_distance()
                }))
                self.present(alert, animated: false, completion: nil)
            }
            else
            {
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    if json["distance"] as! String == ""
                    {
                        self.distance = "5"
                        self.dist = Int(self.distance)!
                        self.distanceLbl.text = self.distance
                        self.sistanceslider.minimumValue = Float(self.dist)
                    }
                    else
                    {
                        self.distance = json["distance"] as! String
                        self.dist = Int(self.distance)!
                        self.distanceLbl.text = self.distance
                        self.sistanceslider.value = Float(self.dist)
                    }
                    
                    self.distanceLbl.isHidden = false
                    self.sistanceslider.isHidden = false
                    self.fetch_remainder_day()
                    
                   // MBProgressHUD.hide(for: self.view, animated: true)
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
}

// MARK: - insert_user_distance
func insert_user_distance()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=insert_user_distance", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"distance":distance], encoding:  URLEncoding.httpBody).responseJSON
    { [self] response in
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
                    self.fetch_user_distance()
                }))
                self.present(alert, animated: false, completion: nil)
            }
            else
            {
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    if json["result"] as! String == "success"
                    {
                        
                        self.set_event_remainder_day()
                     
                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                   //
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
}
    // MARK: - fetch_remainder_day
    func fetch_remainder_day()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=fetch_remainder_day", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
        { [self] response in
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
                        self.fetch_remainder_day()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        let d:String =  json["day"] as! String
                        if d == ""
                        {
                            
                        }
                        else
                        {
                            self.dayFiled.text = d
                        }
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
        
    }
    // MARK: - set_event_remainder_day
    func set_event_remainder_day()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=set_event_remainder_day", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"day":dayFiled.text!], encoding:  URLEncoding.httpBody).responseJSON
        { [self] response in
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
                        self.fetch_user_distance()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        if json["result"] as! String == "success"
                        {
                            self.dismiss(animated: false, completion: nil)
                        }
                        else
                        {
                             self.dismiss(animated: false, completion: nil)
                        }
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
        
    }
    
    // MARK: - Picker Method
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int
        
    {
        
      
            return myPicker2Data1.count
      
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
            return myPicker2Data1[row]
       
        
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
       
            dayFiled.text = myPicker2Data1[row]
      
    }
}
