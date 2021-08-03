//
//  UserFollowingVC.swift
//  Stumbal
//
//  Created by mac on 15/04/21.
//

import UIKit
import Alamofire
import Kingfisher
class UserFollowingVC: UIViewController,UITableViewDataSource,UITableViewDelegate{

@IBOutlet var follwersTblView: UITableView!
@IBOutlet var statusLbl: UILabel!
var hud = MBProgressHUD()
var AppendArr:NSMutableArray = NSMutableArray()
var artistRating:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    
    follwersTblView.dataSource = self
    follwersTblView.delegate = self
    fetch_all_follow_artist()
    // Do any additional setup after loading the view.
}


@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}

//MARK: fetch_all_follow_artist ;
func fetch_all_follow_artist()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_all_follow_artist", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.fetch_all_follow_artist()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.AppendArr = NSMutableArray()
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.AppendArr.count != 0 {
                        
                        self.statusLbl.isHidden = true
                        self.follwersTblView.isHidden = false
                        self.follwersTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.follwersTblView.isHidden = true
                        self.statusLbl.isHidden = false
                        //  self.selectcardLbl.isHidden = true
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

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AppendArr.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  follwersTblView.dequeueReusableCell(withIdentifier: "FollwersTblCell", for: indexPath) as! FollwersTblCell
    
    cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
    cell.profileView.layer.masksToBounds = false
    cell.profileView.clipsToBounds = true
    
    cell.nameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
    cell.codeLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "stumbal_id")as! String
    
    let eimg:String = (self.AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
    
    if eimg == ""
    {
        cell.profileImg.image = UIImage(named: "adefault")
        
    }
    else
    {
        let url = URL(string: eimg)
        let processor = DownsamplingImageProcessor(size: cell.profileImg.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        cell.profileImg.kf.indicatorType = .activity
        cell.profileImg.kf.setImage(
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
                cell.profileImg.image = UIImage(named: "adefault")
            }
        }
        
    }
    
    return cell
}


func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let scn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String
    
    let n = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
    
    let cn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
    
    let ai = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String
    
    let aimg = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
    
    UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
    UserDefaults.standard.setValue(n, forKey: "Event_name")
    UserDefaults.standard.setValue(cn, forKey: "Event_cat")
    UserDefaults.standard.setValue(ai, forKey: "Event_artid")
    UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
    
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
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistUserProfileVC") as! ArtistUserProfileVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}
}
