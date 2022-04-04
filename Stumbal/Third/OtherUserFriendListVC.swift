//
//  OtherUserFriendListVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 12/03/22.
//

import UIKit
import Alamofire
import Kingfisher
class OtherUserFriendListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var friendListTblView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    var hud = MBProgressHUD()
    var friendArr:NSMutableArray = NSMutableArray()
    var Id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        friendListTblView.dataSource = self
        friendListTblView.delegate = self
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftViewMode = .never
        searchBar.delegate = self
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        } else {
            // Fallback on earlier versions
        }
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            //textfield.backgroundColor = UIColor.yellow
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search bar", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            textfield.setLeftPaddingPoints(5)
            textfield.clearButtonMode = .never
            // textfield.textColor = UIColor.green
            
            //        if let leftView = textfield.leftView as? UIImageView {
            //            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            //            leftView.tintColor = UIColor.red
            //        }
        }
        fetch_friend_list()
    }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func userProfile(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        
        UserDefaults.standard.set((friendArr.object(at: tagVal) as AnyObject).value(forKey: "user_id")as! String, forKey: "friend_rid")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyFriendProfileVC") as! MyFriendProfileVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
        
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
        //        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.indeterminate
        //        hud.self.bezelView.color = UIColor.black
        //        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "friend_rid") as! String
        
        print("123",uID)
        
        //        if UserDefaults.standard.bool(forKey: "FriendList") == true
        //        {
        //            Id = UserDefaults.standard.value(forKey: "friend_rid") as! String
        //        }
        //        else
        //        {
        Id = UserDefaults.standard.value(forKey: "u_Id") as! String
        //  }
        
        //   https://stumbal.com/process.php?action=get_last_msg
        // https://stumbal.com/process.php?action=fetch_friend_list
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_friend_list", method: .post, parameters: ["user_id":Id], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true
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
                        self.friendArr = NSMutableArray()
                        self.friendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        print("1111",self.friendArr)
                        
                        
                        if self.friendArr.count != 0 {
                            
                            self.statusLbl.isHidden = true
                            //self.statusLbl.text = "You have no friend"
                            self.searchBar.isHidden = false
                            self.searchImg.isHidden = false
                            self.friendListTblView.isHidden = false
                            self.friendListTblView.reloadData()
                            self.loadingView.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.friendListTblView.isHidden = true
                            self.statusLbl.isHidden = false
                            self.loadingView.isHidden = true
                            // self.searchBar.isHidden = true
                            //  self.searchImg.isHidden = true
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
        let uID = UserDefaults.standard.value(forKey: "friend_rid") as! String
        
        print("123",uID)
        //   https://stumbal.com/process.php?action=get_last_msg
        // https://stumbal.com/process.php?action=fetch_friend_list
        
        Alamofire.request("https://stumbal.com/process.php?action=search_friend", method: .post, parameters: ["user_id":uID,"search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                        self.friendArr = NSMutableArray()
                        self.friendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        print("1111",self.friendArr)
                        
                        
                        if self.friendArr.count != 0 {
                            
                            //  self.statusLbl.isHidden = true
                            //self.statusLbl.text = "You have no friend"
                            self.friendListTblView.isHidden = false
                            self.friendListTblView.reloadData()
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.friendListTblView.isHidden = true
                            //self.statusLbl.isHidden = false
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
        
        return friendArr.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  friendListTblView.dequeueReusableCell(withIdentifier: "NewFriendListTableViewCell", for: indexPath) as! NewFriendListTableViewCell
        
        cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
        cell.profileView.layer.masksToBounds = false
        cell.profileView.clipsToBounds = true
        
        cell.nameLbl.text = (friendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
        
        
        let pimg:String = (friendArr.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String
        
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
        
        cell.selectObj.tag = indexPath.row
        return cell
        //cell.messagelbl.isHidden = false
    }
    
}
