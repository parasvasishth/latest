//
//  CategoryVC.swift
//  Stumbal
//
//  Created by mac on 17/03/21.
//

import UIKit
import Alamofire
import AlignedCollectionViewFlowLayout
class CategoryVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

@IBOutlet var categoryCollectionView: UICollectionView!
@IBOutlet var collHeight: NSLayoutConstraint!
var hud = MBProgressHUD()
var categoryArray:NSMutableArray = NSMutableArray()
    
var IdArr = NSMutableArray()
override func viewDidLoad() {
    super.viewDidLoad()
    
    categoryCollectionView.dataSource = self
    categoryCollectionView.delegate = self
    
    
    let layout = UICollectionViewCenterLayout()
    layout.estimatedItemSize = CGSize(width: 140, height: 40)
    categoryCollectionView.collectionViewLayout = layout
    
    //  https://www.stumbal.zithera.com.au/Stumbal/process.php?action=fetch_metatags
    
    fetch_metatags()
}


// MARK: - Collection height Method
override func viewWillLayoutSubviews() {
    super.updateViewConstraints()
    self.collHeight?.constant = self.categoryCollectionView.contentSize.height
}

@IBAction func continueRegis(_ sender: UIButton) {
    
    
    if IdArr.count != 0
    {
        update_category()
    }
    else
    {
        let alert = UIAlertController(title: "", message: "Select At Least One Category", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
        
    }
}


@IBAction func login(_ sender: UIButton) {
    UserDefaults.standard.removeObject(forKey: "S_fname")
    UserDefaults.standard.removeObject(forKey: "S_lname")
    UserDefaults.standard.removeObject(forKey: "S_email")
    UserDefaults.standard.removeObject(forKey: "S_password")
    UserDefaults.standard.removeObject(forKey: "S_dob")
    UserDefaults.standard.removeObject(forKey: "S_mobile")
    UserDefaults.standard.removeObject(forKey: "S_gender")
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

@IBAction func back(_ sender: UIButton) {
    //        print("111",arrSelectedData)
    UserDefaults.standard.removeObject(forKey: "S_fname")
    UserDefaults.standard.removeObject(forKey: "S_lname")
    UserDefaults.standard.removeObject(forKey: "S_email")
    UserDefaults.standard.removeObject(forKey: "S_password")
    UserDefaults.standard.removeObject(forKey: "S_dob")
    UserDefaults.standard.removeObject(forKey: "S_mobile")
    UserDefaults.standard.removeObject(forKey: "S_gender")
    
    
    self.dismiss(animated: false, completion: nil)
}


//MARK: update_category ;
func update_category()
{
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    let finalcat:String = IdArr.componentsJoined(by: ",")
    
    Alamofire.request("https://stumbal.com/process.php?action=update_category", method: .post, parameters: ["user_id":uID,"cat_id":finalcat], encoding:  URLEncoding.httpBody).responseJSON
    { response in
        if let data = response.data
        {
            let json = String(data: data, encoding: String.Encoding.utf8)
            print("=====1======")
            print("Response: \(String(describing: json))")
            print("22222222222222")
            //print(response.result.value as Any)
            
            
            if let json: NSDictionary = response.result.value as? NSDictionary
            
            {
                print("JSON: \(json)")
                print("66666666666")
                
                if  json["result"] as! String == "success"
                {
                    
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "", message: "Signup Successful", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 2
                    
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        alert.dismiss(animated: false, completion: nil)
                        
                        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        signuCon.modalPresentationStyle = .fullScreen
                        self.present(signuCon, animated: false, completion:nil)
                        //  self.fecth_Profile()
                    }
                }
            }
        }
    }
    
}

// MARK: - registration
func registration()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    
    let finalcat:String = IdArr.componentsJoined(by: ",")
    
    print(finalcat) // prints: "BobDanBryan"
    
    Alamofire.request("https://stumbal.com/process.php?action=user_registration", method: .post, parameters:["log_type":"Signup","fb_id":"","google_id":"","fname": UserDefaults.standard.value(forKey: "S_fname") as! String,"lname":UserDefaults.standard.value(forKey: "S_lname") as! String,"gender":UserDefaults.standard.value(forKey: "S_gender") as! String,"email":UserDefaults.standard.value(forKey: "S_email") as! String,"password":UserDefaults.standard.value(forKey: "S_password") as! String,"dob":UserDefaults.standard.value(forKey: "S_dob") as! String,"meta_tags":finalcat,"contact":UserDefaults.standard.value(forKey: "S_mobile") as! String],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                    self.registration()
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
                        print("hello")
                        
                        
                        let alert = UIAlertController(title: "", message: "Signup Successfully", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        
                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 2
                        
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            
                            alert.dismiss(animated: false, completion: nil)
                            
                            
                            UserDefaults.standard.removeObject(forKey: "S_fname")
                            UserDefaults.standard.removeObject(forKey: "S_lname")
                            UserDefaults.standard.removeObject(forKey: "S_email")
                            UserDefaults.standard.removeObject(forKey: "S_password")
                            UserDefaults.standard.removeObject(forKey: "S_dob")
                            UserDefaults.standard.removeObject(forKey: "S_mobile")
                            UserDefaults.standard.removeObject(forKey: "S_gender")
                            
                            UserDefaults.standard.set(true, forKey: "login")
                            
                            
                            let id :String = json["insert_id"] as! String
                            
                            UserDefaults.standard.setValue(id, forKey: "u_Id")
                            
                            
                            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                            signuCon.modalPresentationStyle = .fullScreen
                            self.present(signuCon, animated: false, completion:nil)
                            
                        }
                        
                        
                        
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

//MARK: fetch_metatags ;

func fetch_metatags()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_metatags", method: .post, parameters: nil, encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.fetch_metatags()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.categoryArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    
                    
                    if self.categoryArray.count != 0 {
                        
                        self.categoryCollectionView.isHidden = false
                        self.categoryCollectionView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.categoryCollectionView.isHidden = true
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


func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return  categoryArray.count
}

func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
{
    self.viewWillLayoutSubviews()
}


func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    
    guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "titleCell",
                                                                for: indexPath) as? RoundedCollectionViewCell else {
        return RoundedCollectionViewCell()
    }
    
    
    
    let n = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
    
    let id = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_id")as! String
    
    
    if IdArr.count != 0
    {
        for i  in 0...IdArr.count-1 {
            let name : String = IdArr[i] as! String
            if name == id {
                cell.roundedView.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
                UserDefaults.standard.set(true, forKey: String(format: "Selected%d", indexPath.row))
                break
            }else{
               // cell.textLabel.backgroundColor = UIColor.darkGray
                cell.roundedView.backgroundColor = UIColor.darkGray

                UserDefaults.standard.set(false, forKey: String(format: "Selected%d", indexPath.row))
            }
        }
    }
    else
    {
        UserDefaults.standard.set(false, forKey: String(format: "Selected%d", indexPath.row))
    }
    
    cell.textLabel.text = n
    
    return cell
    
}
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    
    let selectedCell:RoundedCollectionViewCell = categoryCollectionView.cellForItem(at: indexPath)! as! RoundedCollectionViewCell
    let id = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_id")as! String
    
    if !UserDefaults.standard.bool(forKey: String(format: "Selected%d", indexPath.row)) {
        selectedCell.roundedView.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        UserDefaults.standard.set(true, forKey: String(format: "Selected%d", indexPath.row))
        IdArr.add(id)
        
    }else{
        selectedCell.roundedView.backgroundColor = UIColor.darkGray
        UserDefaults.standard.set(false, forKey: String(format: "Selected%d", indexPath.row))
        let val : String = id
        if IdArr.count != 0
        {
            for i in 0...IdArr.count - 1 {
                if IdArr[i] as! String == val {
                    //  IdArr.remove(activityArr[indexPath.row])
                    //  IdArr.remove(categoryArray[indexPath.row])
                    IdArr.remove(id)
                    break
                }else{
                    
                }
            }
        }
        else
        {
            
        }
        
        
    }
    
}

}

public extension UIView {

private static let kLayerNameGradientBorder = "GradientBorderLayer"

func setGradientBorder(
    width: CGFloat,
    colors: [UIColor],
    startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
    endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
) {
    let existedBorder = gradientBorderLayer()
    let border = existedBorder ?? CAGradientLayer()
    border.frame = bounds
    border.colors = colors.map { return $0.cgColor }
    border.startPoint = startPoint
    border.endPoint = endPoint
    
    let mask = CAShapeLayer()
    mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: 0).cgPath
    mask.fillColor = UIColor.clear.cgColor
    mask.strokeColor = UIColor.white.cgColor
    mask.lineWidth = width
    
    border.mask = mask
    
    let exists = existedBorder != nil
    if !exists {
        layer.addSublayer(border)
    }
}


private func gradientBorderLayer() -> CAGradientLayer? {
    let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
    if borderLayers?.count ?? 0 > 1 {
        fatalError()
    }
    return borderLayers?.first as? CAGradientLayer
}

}
