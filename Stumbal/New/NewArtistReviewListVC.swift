//
//  NewArtistReviewListVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 22/01/22.
//

import UIKit
import Kingfisher
import Alamofire
class NewArtistReviewListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var artistImg: UIImageView!
    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var reviewTblView: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIView!
    var ratvalue  = String()
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = true

        reviewTblView.dataSource = self
        reviewTblView.delegate = self
        
     
        fetch_artist_register()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Table Height Method
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblHeight?.constant = self.reviewTblView.contentSize.height
    }
    
    // MARK: - fetch_artist_register
    func fetch_artist_register()
    {

    //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //hud.mode = MBProgressHUDMode.indeterminate
    //hud.self.bezelView.color = UIColor.black
    //hud.label.text = "Loading...."
    //    self.loadingView.isHidden = false
    Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_register", method: .post, parameters: ["artist_id" : UserDefaults.standard.value(forKey: "ap_artId") as! String], encoding:  URLEncoding.httpBody).responseJSON
    { response in
        if let data = response.data
        {
            let json = String(data: data, encoding: String.Encoding.utf8)

            print("Response: \(String(describing: json))")
            if json == ""
            {
                MBProgressHUD.hide(for: self.view, animated: true);
                self.loadingView.isHidden = true

              //  self.loadingView.isHidden = true
                let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                    self.fetch_artist_register()
                }))
                self.present(alert, animated: false, completion: nil)


            }
            else
            {


                if let json: NSDictionary = response.result.value as? NSDictionary

                {

                    //                                let result:String = json["result"] as! String
                    //
                    //                                if result == "success"
                    //                                {
                self.artistNameLbl.text = json["name"] as! String
                 

                   
                    self.ratingLbl.text = json["avg_rating"] as! String
                    
                    if json["avg_rating"] as! String == ""
                    {
                        self.ratingLbl.text = "0.0"
                    }
                    else
                    {
                        self.ratingLbl.text = json["avg_rating"] as! String
                    }
                    
                  
                
                    let uimg:String = json["artist_img"] as! String


                    if uimg == ""
                    {
                        self.artistImg.image = UIImage(named: "adefault")

                    }
                    else
                    {
                       let url = URL(string: uimg)
                        let processor = DownsamplingImageProcessor(size: self.artistImg.bounds.size)
                            |> RoundCornerImageProcessor(cornerRadius: 0)
                       self.artistImg.kf.indicatorType = .activity
                       self.artistImg.kf.setImage(
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
                            self.artistImg.image = UIImage(named: "adefault")
                           }
                       }

                    }

                    
                    self.fetch_artist_review_rating()
                   // MBProgressHUD.hide(for: self.view, animated: true)


                }
                else
                {
                    self.loadingView.isHidden = true

                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }

    }

    
  

    //MARK: fetch_artist_review_rating ;
        func fetch_artist_review_rating()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
//            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.mode = MBProgressHUDMode.indeterminate
//            hud.self.bezelView.color = UIColor.black
//            hud.label.text = "Loading...."
            
//            if UserDefaults.standard.bool(forKey: "artistsidereview") == true
//            {
//                artId = UserDefaults.standard.value(forKey: "ap_artId") as! String
//            }
//            else
//            {
//                artId = UserDefaults.standard.value(forKey: "Event_artid") as! String
//            }
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_review_rating", method: .post, parameters: ["artist_id" :UserDefaults.standard.value(forKey: "ap_artId") as! String], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                         self.fetch_artist_review_rating()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                     do  {
                         self.AppendArr = NSMutableArray()
                         self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                         
                         if self.AppendArr.count != 0 {
                             
                          //  self.statusLbl.isHidden = true
                             self.reviewTblView.isHidden = false
                             self.reviewTblView.reloadData()
                             
                             self.reviewTblView.layoutIfNeeded()
                             let contentOffset = self.reviewTblView.contentOffset
                             self.reviewTblView.setContentOffset(contentOffset, animated: false)
                             self.tblHeight.constant = CGFloat(125 * self.AppendArr.count)
                             self.loadingView.isHidden = true

                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                              self.reviewTblView.isHidden = true
                             self.tblHeight.constant = 0
                             self.loadingView.isHidden = true

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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
       }
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return AppendArr.count
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell =  reviewTblView.dequeueReusableCell(withIdentifier: "NewArtistRatingTableViewCell", for: indexPath) as! NewArtistRatingTableViewCell
       
           cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
           cell.profileView.layer.masksToBounds = false
           cell.profileView.clipsToBounds = true
         cell.nameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
           
           let result:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "review")as! String
          // createHtmlLabel(with: cell.messageLbl)
           var string1 = result
           cell.messageLbl.text! = string1.replacingOccurrences(of: "<br />", with: "\n")
           
     //   cell.messageLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "review")as! String
        let d = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
       let t = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "time")as! String
        
        cell.dateLbl.text = d
           //+ " , " + t
        

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
        
        
       cell.ratingLbl.text = ((AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "rating")as! String)
        
          return cell
       }
}
