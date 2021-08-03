//
//  UpdateCategoryVC.swift
//  Stumbal
//
//  Created by mac on 07/05/21.
//

import UIKit
import Alamofire
class UpdateCategoryVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
private let spacing:CGFloat = 2.0
var categoryArray:NSMutableArray = NSMutableArray()
@IBOutlet var categoryCollView: UICollectionView!
@IBOutlet var collheight: NSLayoutConstraint!
var hud = MBProgressHUD()
var arrData = [String]() // This is your data array
var arrSelectedIndex = [IndexPath]() // This is selected cell Index array
var arrSelectedData = [String]() // This is selected cell data array
var IdArr = NSMutableArray()
override func viewDidLoad() {
    super.viewDidLoad()
    let str:String = UserDefaults.standard.value(forKey: "Pro_Cat") as! String
    let addNsarray:NSArray = str.components(separatedBy: ",") as NSArray
    IdArr = NSMutableArray(array: addNsarray)
    
    categoryCollView.dataSource = self
    categoryCollView.delegate = self
    fetch_metatags()
    
    let layout1 = UICollectionViewCenterLayout()
    layout1.estimatedItemSize = CGSize(width: 140, height: 40)
    categoryCollView.collectionViewLayout = layout1
    // Do any additional setup after loading the view.
}

// MARK: - Collection height Method
override func viewWillLayoutSubviews() {
    super.updateViewConstraints()
    self.collheight?.constant = self.categoryCollView.contentSize.height
}

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}

@IBAction func updateCategory(_ sender: UIButton) {
    
    /// if IdArr.count
    print("111",IdArr)
    
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
                    let alert = UIAlertController(title: "", message: "Category Updated successfully", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 2
                    
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        alert.dismiss(animated: false, completion: nil)
                        
                        self.dismiss(animated: false, completion: nil)
                        
                        //  self.fecth_Profile()
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
                        
                        
                        self.categoryCollView.isHidden = false
                        self.categoryCollView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.categoryCollView.isHidden = true
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

//    // MARK: - Collection height Method
//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()
//        self.?.constant = self.categoryCollView.contentSize.height
//    }

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return  categoryArray.count
}

func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
{
    self.viewWillLayoutSubviews()
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = categoryCollView.dequeueReusableCell(withReuseIdentifier: "titleCell",
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
                cell.roundedView.backgroundColor = UIColor.darkGray
                UserDefaults.standard.set(false, forKey: String(format: "Selected%d", indexPath.row))
            }
        }
    }
    else
    {
        
    }
    
    cell.textLabel.text = n
    
    cell.layoutSubviews()
    return cell
}
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedCell:RoundedCollectionViewCell = categoryCollView.cellForItem(at: indexPath)! as! RoundedCollectionViewCell
    let id = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_id")as! String
    
    if !UserDefaults.standard.bool(forKey: String(format: "Selected%d", indexPath.row)) {
        selectedCell.roundedView.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        UserDefaults.standard.set(true, forKey: String(format: "Selected%d", indexPath.row))
        IdArr.add(id)
        
    }else{
        selectedCell.roundedView.backgroundColor = UIColor.darkGray
        UserDefaults.standard.set(false, forKey: String(format: "Selected%d", indexPath.row))
        let val : String = id
        for i in 0...IdArr.count - 1 {
            if IdArr[i] as! String == val {
                IdArr.remove(id)
                break
            }else{
                
            }
        }
        
    }
}

}
