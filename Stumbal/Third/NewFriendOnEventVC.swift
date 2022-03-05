//
//  NewFriendOnEventVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 29/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewFriendOnEventVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    var hud = MBProgressHUD()
    var friendArr:NSMutableArray = NSMutableArray()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendTblView: UITableView!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = true
        friendTblView.dataSource = self
        friendTblView.delegate = self
        
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
        show_event_friend()
        
        // Do any additional setup after loading the view.
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
    @IBAction func yourFriend(_ sender: UIButton) {
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        show_event_friend()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        //backObj.isHidden = false
    }

    
    //MARK: show_event_friend ;
    func show_event_friend()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
     //   https://stumbal.com/process.php?action=get_last_msg
       // https://stumbal.com/process.php?action=fetch_friend_list

        Alamofire.request("https://stumbal.com/process.php?action=show_event_friend", method: .post, parameters: ["user_id":uID,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String,"search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                        self.show_event_friend()
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
                            self.friendTblView.isHidden = false
                            self.friendTblView.reloadData()
                            self.loadingView.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.friendTblView.isHidden = true
                            self.loadingView.isHidden = true
                          //   self.statusLbl.isHidden = false
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
    let cell =  friendTblView.dequeueReusableCell(withIdentifier: "NewFriendOnEventTableViewCell", for: indexPath) as! NewFriendOnEventTableViewCell

    cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
    cell.profileView.layer.masksToBounds = false
    cell.profileView.clipsToBounds = true
        cell.nameLbl.text = (friendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
    if (friendArr.object(at: indexPath.row) as AnyObject).value(forKey: "status")as! String == "Accept"
    {
        cell.friendObj.isHidden = false
    }
    else
    {
        cell.friendObj.isHidden = true
    }


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
    cell.userprofileObj.tag = indexPath.row
    
     return cell
    }
    
 
}
