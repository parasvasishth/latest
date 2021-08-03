//
//  ArtistVC.swift
//  Stumbal
//
//  Created by mac on 18/03/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class ArtistVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SWRevealViewControllerDelegate{

@IBOutlet var artistTblView: UITableView!
@IBOutlet var searchBar: UISearchBar!
@IBOutlet var menu: UIButton!
@IBOutlet var statusLbl: UILabel!
var hud = MBProgressHUD()
var AppendArr:NSMutableArray = NSMutableArray()
var pastArray:NSMutableArray = NSMutableArray()
var artistRating:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    
    artistTblView.dataSource = self
    artistTblView.delegate = self
    menu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    searchBar.delegate = self
    
    self.revealViewController().delegate = self
    
}

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
}

override func viewWillAppear(_ animated: Bool) {
    
    if self.revealViewController() != nil {
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    fetch_all_artist()
}

func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
    
    switch position {
    
    case FrontViewPosition.leftSideMostRemoved:
        print("LeftSideMostRemoved")
    // UserDefaults.standard.set(true, forKey: "homesw")
    // Left most position, front view is presented left-offseted by rightViewRevealWidth+rigthViewRevealOverdraw
    
    case FrontViewPosition.leftSideMost:
        print("LeftSideMost")
    // Left position, front view is presented left-offseted by rightViewRevealWidth
    
    case FrontViewPosition.leftSide:
        print("LeftSide")
        
    // Center position, rear view is hidden behind front controller
    case FrontViewPosition.left:
        print("Left")
        //Closed
        //0 rotation
        UserDefaults.standard.set(false, forKey: "homesw")
        
        
    // Right possition, front view is presented right-offseted by rearViewRevealWidth
    case FrontViewPosition.right:
        print("Right")
        UserDefaults.standard.set(true, forKey: "homesw")
    //Opened
    //rotated
    
    // Right most possition, front view is presented right-offseted by rearViewRevealWidth+rearViewRevealOverdraw
    
    case FrontViewPosition.rightMost:
        print("RightMost")
        
    // Front controller is removed from view. Animated transitioning from this state will cause the sam
    // effect than animating from FrontViewPositionRightMost. Use this instead of FrontViewPositionRightMost when
    // you intent to remove the front controller view from the view hierarchy.
    
    case FrontViewPosition.rightMostRemoved:
        print("RightMostRemoved")
        
    }
    
}


//MARK: fetch_all_artist ;
func fetch_all_artist()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_all_artist", method: .post, parameters: ["user_id":uID], encoding:  URLEncoding.httpBody).responseJSON { response in
        if let data = response.data {
            let json = String(data: data, encoding: String.Encoding.utf8)
            print("=====1======")
            print("Response: \(String(describing: json))")
            
            if json == ""
            {
                MBProgressHUD.hide(for: self.view, animated: true);
                let alert = UIAlertController(title: "", message: "Loading...", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                    self.fetch_all_artist()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.AppendArr.count != 0 {
                        
                        self.statusLbl.isHidden = true
                        self.artistTblView.isHidden = false
                        self.artistTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.artistTblView.isHidden = true
                        self.statusLbl.isHidden = false
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

// MARK: - fetch_app_user
func fetch_app_user()
{
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    self.pastArray = NSMutableArray()
    
    let u_id = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_all_artist", method: .post, parameters:["search":searchBar.text!,"user_id":u_id], encoding:  URLEncoding.httpBody).responseJSON { response in
        if let data = response.data {
            let json = String(data: data, encoding: String.Encoding.utf8)
            print("=====1======")
            print("Response: \(String(describing: json))")
            
            self.pastArray = NSMutableArray()
            do  {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.pastArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                
                self.AppendArr = NSMutableArray()
                if self.pastArray.count != 0
                {
                    
                    for i in 0...self.pastArray.count-1
                    {
                        if (self.pastArray.object(at: i) as AnyObject).value(forKey: "name") is NSNull {
                        } else {
                            print((self.pastArray.object(at:i) as AnyObject).value(forKey: "name"),i)
                            self.AppendArr.add(self.pastArray[i])
                        }
                    }
                    if self.AppendArr.count != 0 {
                        
                        self.artistTblView.isHidden = false
                        self.artistTblView.reloadData()
                        self.statusLbl.isHidden = true
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else  {
                        
                        self.artistTblView.isHidden = true
                        self.statusLbl.isHidden = false
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
                else
                {
                    self.artistTblView.isHidden = true
                    self.statusLbl.isHidden = false
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

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    fetch_app_user()
}

//MARK: tableView Methode
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
//      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//          self.viewWillLayoutSubviews()
//      }
//
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AppendArr.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  artistTblView.dequeueReusableCell(withIdentifier: "ArtistTblCell", for: indexPath) as! ArtistTblCell
    
    cell.namelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
    cell.categoryLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
    
    let ai:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
    
    if ai == ""
    {
        cell.eventImg.image = UIImage(named: "adefault")
        
    }
    else
    {
        let url = URL(string: ai)
        let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        cell.eventImg.kf.indicatorType = .activity
        cell.eventImg.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                cell.eventImg.image = UIImage(named: "adefault")
            }
        }
        
    }
    
    let ar = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "avg_rating")as! String
    if ar == ""
    {
        cell.ratinglbl.text = "0" + "/5"
    }
    else
    {
        cell.ratinglbl.text = ar + "/5"
    }
    
    return cell
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let scn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String
    
    let n = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
    let cn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
    
    let ai = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String
    
    let aimg = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
    
    let ar = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "avg_rating")as! String
    if ar == ""
    {
        artistRating = "0" + "/5"
    }
    else
    {
        artistRating = ar + "/5"
    }
    
    UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
    UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
    UserDefaults.standard.setValue(n, forKey: "Event_name")
    UserDefaults.standard.setValue(cn, forKey: "Event_cat")
    UserDefaults.standard.setValue(ai, forKey: "Event_artid")
    UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistUserProfileVC") as! ArtistUserProfileVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

}
