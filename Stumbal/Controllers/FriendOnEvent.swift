//
//  FriendOnEvent.swift
//  Stumbal
//
//  Created by mac on 30/06/21.
//

import UIKit
import Alamofire
import Kingfisher
class FriendOnEvent: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var friendTblView: UITableView!
    var hud = MBProgressHUD()
    var messageArray:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTblView.dataSource = self
        friendTblView.delegate = self
        fetch_friend_request()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func back(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: fetch_friend_request ;
    func fetch_friend_request()
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

        Alamofire.request("https://stumbal.com/process.php?action=event_friend", method: .post, parameters: ["user_id":uID,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                        self.fetch_friend_request()
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
    let cell =  friendTblView.dequeueReusableCell(withIdentifier: "ArtistTblCell", for: indexPath) as! ArtistTblCell
    
    

        cell.namelbl.text = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String


        let pimg:String = (messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String

        if pimg == ""
        {
            cell.eventImg.image = UIImage(named: "udefault")

        }
        else
        {
            let url = URL(string: pimg)
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
                    cell.eventImg.image = UIImage(named: "udefault")
                }
            }

        }


     return cell
    }
    


//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    
// 
//        
//        
//            UserDefaults.standard.setValue((messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "user_id")as! String, forKey: "f_rid")
//        UserDefaults.standard.setValue((messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "user_img")as! String, forKey: "f_img")
//        UserDefaults.standard.setValue((messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String, forKey: "f_name")
//        
//        UserDefaults.standard.setValue((messageArray.object(at: indexPath.row) as AnyObject).value(forKey: "status")as! String, forKey: "f_status")
//        
//        
//
//    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "RequestAcceptVC") as! RequestAcceptVC
//    signuCon.modalPresentationStyle = .fullScreen
//    self.present(signuCon, animated: false, completion:nil)
//}
}
