//
//  NewVenueReviewListVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 22/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewVenueReviewListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    @IBOutlet weak var venueImg: UIImageView!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var reviewTblView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    var ratvalue  = String()
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false

        reviewTblView.dataSource = self
        reviewTblView.delegate = self
        
     
        fetch_venue_detail()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - fetch_venue_detail
    func  fetch_venue_detail()
    {

//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=fetch_venue_detail", method: .post, parameters: ["venue_id" : UserDefaults.standard.value(forKey: "V_id") as! String], encoding:  URLEncoding.httpBody).responseJSON
        { [self] response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)

                print("Response: \(String(describing: json))")
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true

                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                        self.fetch_venue_detail()
                    }))
                    self.present(alert, animated: true, completion: nil)


                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary

                    {   self.venueNameLbl.text = json["vname"] as! String
                        
                        let avg:String = json["avg_rating"] as! String
                        
                        if avg == "0"
                        {
                            self.ratingLbl.text = "0.0"
                        }
                        else
                        {
                            self.ratingLbl.text = avg
                        }
                        
                let pimg:String =  json["venue_img"] as! String
                        
                        if pimg == ""
                        {
                            self.venueImg.image = UIImage(named: "vdefault")
                        }
                           else
                        {
                           let url = URL(string: pimg)
                           let processor = DownsamplingImageProcessor(size: self.venueImg.bounds.size)
                                        |> RoundCornerImageProcessor(cornerRadius: 0)
                           self.venueImg.kf.indicatorType = .activity
                           self.venueImg.kf.setImage(
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
                                self.venueImg.image = UIImage(named: "vdefault")
                               }
                           }
                           
                        }

                        self.fetch_provider_review_rating()
                       
                        MBProgressHUD.hide(for: self.view, animated: true)


                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.loadingView.isHidden = true

                    }
                }
            }
        }

    }


  

    
    //MARK: fetch_provider_review_rating ;
    func fetch_provider_review_rating()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "V_id") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_provider_review_rating", method: .post, parameters: ["provider_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_provider_review_rating()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        
                        if self.AppendArr.count != 0 {
                            
                       //     self.statusLbl.isHidden = true
                            self.reviewTblView.isHidden = false
                            self.reviewTblView.reloadData()
                            self.loadingView.isHidden = true

                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.reviewTblView.isHidden = true
                            self.loadingView.isHidden = true

                           // self.statusLbl.isHidden = false
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
        let cell =  reviewTblView.dequeueReusableCell(withIdentifier: "NewArtistRatingTableViewCell", for: indexPath) as! NewArtistRatingTableViewCell
        cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
        cell.profileView.layer.masksToBounds = false
        cell.profileView.clipsToBounds = true
        
        cell.nameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
        cell.messageLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "review")as! String
        let d = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
        let t = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "time")as! String
        cell.dateLbl.text = d
        
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
