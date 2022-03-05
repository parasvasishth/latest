//
//  FriendsVC.swift
//  Stumbal
//
//  Created by mac on 18/06/21.
//

import UIKit
import Alamofire
import Kingfisher
class FriendsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet var friendTblView: UITableView!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var searchFeild: UISearchBar!
    var hud = MBProgressHUD()
    var messageArray:NSMutableArray = NSMutableArray()
    var pastArray:NSMutableArray = NSMutableArray()
    var otherArtistArray:[String] = []
    var dict:NSMutableDictionary = NSMutableDictionary()
    var servicenameArr = [[String: String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTblView.dataSource = self
        friendTblView.delegate = self
        
        
        if #available(iOS 13.0, *) {
            searchFeild.searchTextField.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
           } else {
               // Fallback on earlier versions
           }
        
        searchFeild.setImage(UIImage(named: "search1"), for: .search, state: .normal)

        
        
        if UserDefaults.standard.value(forKey: "userarray") == nil
        {
            
        }
        else
        {
            servicenameArr = UserDefaults.standard.value(forKey: "userarray") as! [[String: String]]
            
        }
          fetch_friend_list()
        searchFeild.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {

        setupSearchBar(searchBar: searchFeild)

    }

        func setupSearchBar(searchBar : UISearchBar) {

        searchBar.setPlaceholderTextColorTo(color: #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1))

       }
    
    @IBAction func addFriend(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        let n  = (self.messageArray.object(at: tagVal) as AnyObject).value(forKey: "name")as! String
        let id  = (self.messageArray.object(at: tagVal) as AnyObject).value(forKey: "user_img")as! String
        let img = (self.messageArray.object(at: tagVal) as AnyObject).value(forKey: "email")as! String
        let rid = (self.messageArray.object(at: tagVal) as AnyObject).value(forKey: "user_id")as! String
        
        self.dict.setValue(n, forKey: "name")
        self.dict.setValue(id, forKey: "user_img")
        self.dict.setValue(img, forKey: "email")
        self.dict.setValue(rid, forKey: "req_Id")
        
        otherArtistArray.append(n)
        self.servicenameArr.append(self.dict as! [String : String])
        
        UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        search_friend()
        
    }

    
    //MARK: fetch_friend_list ;
    func fetch_friend_list()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
     //   https://stumbal.com/process.php?action=get_last_msg
       // https://stumbal.com/process.php?action=fetch_friend_list

        Alamofire.request("https://stumbal.com/process.php?action=fetch_friend_list", method: .post, parameters: ["user_id":uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                        self.fetch_friend_list()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.messageArray = NSMutableArray()
                        self.messageArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        print("1111",self.messageArray)
                        
                        
                        if self.messageArray.count != 0 {
                            
                              self.statusLbl.isHidden = true
                            //self.statusLbl.text = "You have no friend"
                            self.friendTblView.isHidden = false
                            self.friendTblView.reloadData()
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.friendTblView.isHidden = true
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
    
    //MARK: search_friend ;
    func search_friend()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
     //   https://stumbal.com/process.php?action=get_last_msg
       // https://stumbal.com/process.php?action=fetch_friend_list

        Alamofire.request("https://stumbal.com/process.php?action=search_friend", method: .post, parameters: ["user_id":uID,"search":searchFeild.text!], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                        self.search_friend()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.messageArray = NSMutableArray()
                        self.messageArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        print("1111",self.messageArray)
                        
                        
                        if self.messageArray.count != 0 {
                            
                              self.statusLbl.isHidden = true
                            //self.statusLbl.text = "You have no friend"
                            self.friendTblView.isHidden = false
                            self.friendTblView.reloadData()
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.friendTblView.isHidden = true
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
    
        return messageArray.count
   
    
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  friendTblView.dequeueReusableCell(withIdentifier: "SearchArtistTblCell", for: indexPath) as! SearchArtistTblCell
    

        cell.artistNameLbl.text = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String


        let pimg:String = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String

        if pimg == ""
        {
            cell.profileImg.image = UIImage(named: "udefault")

        }
        else
        {
            let url = URL(string: pimg)
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
                    cell.profileImg.image = UIImage(named: "udefault")
                }
            }

        }

    cell.addObj.tag = indexPath.row
    return cell
        //cell.messagelbl.isHidden = false
    }
   
   
}

