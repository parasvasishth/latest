//
//  ArtistReviewVC.swift
//  Stumbal
//
//  Created by mac on 14/04/21.
//

import UIKit
import Alamofire
import Kingfisher
class ArtistReviewVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var artistTableView: UITableView!
    @IBOutlet var statusLbl: UILabel!
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    var artId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistTableView.dataSource = self
        artistTableView.delegate = self
        fetch_artist_review_rating()
    }
    

    @IBAction func back(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "artistsidereview")
        self.dismiss(animated: false, completion: nil)
    }
   
    //MARK: fetch_artist_review_rating ;
        func fetch_artist_review_rating()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.self.bezelView.color = UIColor.black
            hud.label.text = "Loading...."
            
            if UserDefaults.standard.bool(forKey: "artistsidereview") == true
            {
                artId = UserDefaults.standard.value(forKey: "ap_artId") as! String
            }
            else
            {
                artId = UserDefaults.standard.value(forKey: "Event_artid") as! String
            }
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_review_rating", method: .post, parameters: ["artist_id" :artId], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                         self.fetch_artist_review_rating()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                     do  {
                         self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                         
                         if self.AppendArr.count != 0 {
                             
                            self.statusLbl.isHidden = true
                             self.artistTableView.isHidden = false
                             self.artistTableView.reloadData()
                            
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                              self.artistTableView.isHidden = true
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
           let cell =  artistTableView.dequeueReusableCell(withIdentifier: "ReviewsTblCell", for: indexPath) as! ReviewsTblCell
       
      
         cell.nameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
        cell.messageLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "review")as! String
        let d = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
       let t = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "time")as! String
        
        cell.dateLbl.text = d + " , " + t
        

        let eimg:String = (self.AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "user_image")as! String
        
        
        if eimg == ""
        {
            cell.profileImg.image = UIImage(named: "udefault")
           
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
                cell.profileImg.image = UIImage(named: "udefault")
               }
           }
           
        }
        
        
       cell.ratingObj.rating = ((AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "rating")as! NSString).doubleValue
        
          return cell
       }
}
