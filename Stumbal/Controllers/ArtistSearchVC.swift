//
//  ArtistSearchVC.swift
//  Stumbal
//
//  Created by mac on 03/04/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class ArtistSearchVC: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {

@IBOutlet var searchArtistTblView: UITableView!
@IBOutlet var searchBar: UISearchBar!
var hud = MBProgressHUD()
var pastArray:NSMutableArray = NSMutableArray()
var searchArray:NSMutableArray = NSMutableArray()
var otherArtistArray:[String] = []
var dict:NSMutableDictionary = NSMutableDictionary()
var servicenameArr = [[String: String]]()
override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    
    searchArtistTblView.dataSource = self
    searchArtistTblView.delegate = self
    if UserDefaults.standard.value(forKey: "userarray") == nil
    {
        
    }
    else
    {
        servicenameArr = UserDefaults.standard.value(forKey: "userarray") as! [[String: String]]
        
    }
    fetch_app_user()
}

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}

@IBAction func addFriend(_ sender: UIButton) {
    let tagVal : Int = sender.tag
    let n  = (self.searchArray.object(at: tagVal) as AnyObject).value(forKey: "name")as! String
    let id  = (self.searchArray.object(at: tagVal) as AnyObject).value(forKey: "stumbal_id")as! String
    let img = (self.searchArray.object(at: tagVal) as AnyObject).value(forKey: "artist_img")as! String
    
    self.dict.setValue(n, forKey: "name")
    self.dict.setValue(id, forKey: "stumbal_id")
    self.dict.setValue(img, forKey: "artist_img")
    
    otherArtistArray.append(n)
    self.servicenameArr.append(self.dict as! [String : String])
    
    UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
    self.dismiss(animated: false, completion: nil)
    
    
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
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_app_user", method: .post, parameters:["search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.fetch_app_user()
                }))
                self.present(alert, animated: false, completion: nil)
            }
            else
            {
                self.pastArray = NSMutableArray()
                do  {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.pastArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    self.searchArray = NSMutableArray()
                    if self.pastArray.count != 0
                    {
                        
                        for i in 0...self.pastArray.count-1
                        {
                            if (self.pastArray.object(at: i) as AnyObject).value(forKey: "user_name") is NSNull {
                            } else {
                                print((self.pastArray.object(at:i) as AnyObject).value(forKey: "user_name"),i)
                                self.searchArray.add(self.pastArray[i])
                            }
                        }
                        if self.searchArray.count != 0 {
                            
                            self.searchArtistTblView.isHidden = false
                            self.searchArtistTblView.reloadData()
                            // self.statusLbl.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else  {
                            
                            self.searchArtistTblView.isHidden = true
                            //   self.statusLbl.isHidden = false
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }
                    else
                    {
                        self.searchArtistTblView.isHidden = true
                        //  self.statusLbl.isHidden = false
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

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    fetch_app_user()
    
}
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    //backObj.isHidden = false
}

// MARK: - TableView Methods
func numberOfSections(in tableView: UITableView) -> Int  {
    return 1
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return searchArray.count
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    
    let cell = searchArtistTblView.dequeueReusableCell(withIdentifier: "SearchArtistTblCell", for: indexPath) as! SearchArtistTblCell
    
    let eimg:String = (self.searchArray.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
    
    
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
    
    cell.artistNameLbl.text! = (searchArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
    cell.artistIdLbl.text! = (searchArray.object(at: indexPath.row) as AnyObject).value(forKey: "stumbal_id")as! String
    
    cell.addObj.tag = indexPath.row
    //
    return cell
}

}
