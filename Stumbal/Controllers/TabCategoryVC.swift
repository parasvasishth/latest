//
//  TabCategoryVC.swift
//  Stumbal
//
//  Created by mac on 25/03/21.
//

import UIKit
import Alamofire
class TabCategoryVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
@IBOutlet var categoryCollView: UICollectionView!
@IBOutlet var collHeight: NSLayoutConstraint!
private let spacing:CGFloat = 2.0
var categoryArray:NSMutableArray = NSMutableArray()
var hud = MBProgressHUD()

var arrData = [String]() // This is your data array
var arrSelectedIndex = [IndexPath]() // This is selected cell Index array
var arrSelectedData = [String]() // This is selected cell data array
var IdArr = NSMutableArray()
override func viewDidLoad() {
    super.viewDidLoad()
    
    categoryCollView.dataSource = self
    categoryCollView.delegate = self
    fetch_metatags()
    let layout = UICollectionViewCenterLayout()
    layout.estimatedItemSize = CGSize(width: 140, height: 100)
    categoryCollView.collectionViewLayout = layout
}

@IBAction func back(_ sender: UIButton) {
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

@IBAction func continuecategory(_ sender: UIButton) {
    UserDefaults.standard.set(true, forKey: "tabcategory")
    let finalcat:String = IdArr.componentsJoined(by: ",")
    UserDefaults.standard.setValue(finalcat, forKey: "tab_Cat_id")
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

// MARK: - Collection height Method
override func viewWillLayoutSubviews() {
    super.updateViewConstraints()
    self.collHeight?.constant = self.categoryCollView.contentSize.height
}

//MARK: fetch_metatags ;

func fetch_metatags()
{
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    print("123",uID)
    
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
        UserDefaults.standard.set(false, forKey: String(format: "Selected%d", indexPath.row))
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
