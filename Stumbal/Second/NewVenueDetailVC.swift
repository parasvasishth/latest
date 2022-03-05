//
//  NewVenueDetailVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 24/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewVenueDetailVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var venueImg: UIImageView!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var callLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var upcomingCollView: UICollectionView!
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    @IBOutlet weak var seconView: UIView!
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pastCollView: UICollectionView!
    @IBOutlet weak var upcomingLblHeight: NSLayoutConstraint!
    @IBOutlet weak var pastLblHeight: NSLayoutConstraint!
    @IBOutlet weak var timeCollView: UICollectionView!
    @IBOutlet weak var venueView: UIView!
    @IBOutlet weak var loadingView: UIView!
    var hud = MBProgressHUD()
    var upcomingArr:NSMutableArray = NSMutableArray()
    var pastArr:NSMutableArray = NSMutableArray()
    var timeArr:NSMutableArray = NSMutableArray()
    private let spacing1:CGFloat = 15.0
    private let spacing:CGFloat = 10.0
    var providerRating:String = ""
    var artistRating:String = ""
    var call:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        callLbl.isUserInteractionEnabled = true
        callLbl.addGestureRecognizer(tapGestureRecognizer)
        
        venueView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        
        timeCollView.dataSource = self
        timeCollView.delegate = self
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        callLbl.isUserInteractionEnabled = true
//        callLbl.addGestureRecognizer(tapGestureRecognizer)
        
            
        upcomingCollView.dataSource = self
        upcomingCollView.delegate = self
        
        pastCollView.dataSource = self
        pastCollView.delegate = self
     
        let layout1 = UICollectionViewFlowLayout()
        layout1.sectionInset = UIEdgeInsets(top: 5, left: spacing1, bottom: spacing1, right: spacing1)
        layout1.minimumLineSpacing = spacing1
        layout1.minimumInteritemSpacing = spacing1
        layout1.scrollDirection = .horizontal
        self.upcomingCollView?.collectionViewLayout = layout1
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.sectionInset = UIEdgeInsets(top: 5, left: spacing1, bottom: spacing1, right: spacing1)
        layout2.minimumLineSpacing = spacing1
        layout2.minimumInteritemSpacing = spacing1
        layout2.scrollDirection = .horizontal
        self.pastCollView?.collectionViewLayout = layout2
        
        
        let layout3 = UICollectionViewFlowLayout()
        layout3.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout3.minimumLineSpacing = spacing
        layout3.minimumInteritemSpacing = spacing
        layout3.scrollDirection = .horizontal
        self.timeCollView?.collectionViewLayout = layout3
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        reviewLbl.isUserInteractionEnabled = true
        reviewLbl.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
        ratingLbl.isUserInteractionEnabled = true
        ratingLbl.addGestureRecognizer(tapGestureRecognizer3)
        
        fetch_venue_detail()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func direction(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DirectionVC") as! DirectionVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
  
    // MARK: - cart Method
      @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
          
        let phoneNum : String =  call
              if let url = URL(string: "tel://\(phoneNum)") {
                  if #available(iOS 10, *) {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  } else {
                      UIApplication.shared.openURL(url as URL)
                  }
              }
      }

    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewVenueRatingVC") as! NewVenueRatingVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
     
    }
    
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewVenueRatingVC") as! NewVenueRatingVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    
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
                    self.loadingView.isHidden = true
                    MBProgressHUD.hide(for: self.view, animated: true);
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
                        self.addressLbl.text = json["address"] as! String
                        self.callLbl.text = json["contact"] as! String
                        self.call = json["contact"] as! String
                        let avg:String = json["avg_rating"] as! String
                        
                        if avg == ""
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

                        self.fetch_vendor_store_timing()
                        MBProgressHUD.hide(for: self.view, animated: true)


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
    
    //MARK: fetch_provider_upcomingevent ;
        func fetch_provider_upcomingevent()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
//            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.mode = MBProgressHUDMode.indeterminate
//            hud.self.bezelView.color = UIColor.black
//            hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "V_id") as! String
            
            print("123",uID)
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_provider_event", method: .post, parameters: ["provider_id" :uID,"user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"status":"Future"], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                         self.fetch_provider_upcomingevent()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                     do  {
                         self.upcomingArr = NSMutableArray()
                         self.upcomingArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
         
                         
                         if self.upcomingArr.count != 0 {
                             
                         //   let contentOffset = self.serviceTblView.contentOffset
                            
                        //    self.serviceTblView.layoutIfNeeded()
                          //  self.serviceTblView.setContentOffset(contentOffset, animated: false)
                       //     self.tblHeight!.constant =  CGFloat(125 * self.AppendArr.count)
                        
                           // self.tableHeight.contentSize.height = CGFloat(80 * self.AppendArr.count)
                           // self.tableHeight.constant = CGFloat(88 * self.AppendArr.count)
                            //self.statusLbl.isHidden = true
                          
                            self.upcomingCollView.isHidden = false
                             self.upcomingLblHeight.constant = 30
                            self.firstViewHeight.constant = 260
                            self.upcomingCollView.reloadData()
                             self.fetch_provider_pastevent()
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                              self.upcomingCollView.isHidden = true
                             self.firstViewHeight.constant = 0
                             self.upcomingLblHeight.constant = 0
                             self.fetch_provider_pastevent()
                             //
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
    
    //MARK: fetch_provider_pastevent ;
        func fetch_provider_pastevent()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
//            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.mode = MBProgressHUDMode.indeterminate
//            hud.self.bezelView.color = UIColor.black
//            hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "V_id") as! String
            
            print("123",uID)
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_provider_event", method: .post, parameters: ["provider_id" :uID,"user_id":UserDefaults.standard.value(forKey: "u_Id") as! String,"status":"Past"], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                         self.fetch_provider_pastevent()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                     do  {
                         self.pastArr = NSMutableArray()
                         self.pastArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
         
                         
                         if self.pastArr.count != 0 {
                             
                       
                            self.pastCollView.isHidden = false
                            self.secondViewHeight.constant = 260
                             self.pastLblHeight.constant = 30
                            self.pastCollView.reloadData()
                             self.loadingView.isHidden = true
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                              self.pastCollView.isHidden = true
                             self.pastLblHeight.constant = 0
                          self.secondViewHeight.constant = 0
                         
                             self.loadingView.isHidden = true
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
    
    
    //MARK: fetch_vendor_store_timing ;
    func fetch_vendor_store_timing()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "V_id") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_store_timing", method: .post, parameters: ["provider_id":uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_vendor_store_timing()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                do  {
                    self.timeArr = NSMutableArray()
                    self.timeArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.timeArr.count != 0 {
                        self.timeCollView.isHidden = false
                        self.timeCollView.reloadData()
                        self.fetch_provider_upcomingevent()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                        
                    else  {
                        self.timeCollView.isHidden = true
                        self.fetch_provider_upcomingevent()
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
    
    //MARK: tableView Methode
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

   
        
       
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == upcomingCollView
        {
            return upcomingArr.count
        }
        else if  collectionView == pastCollView
        {
            return pastArr.count
        }
        else
        {
            return timeArr.count
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == upcomingCollView
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 15
            
            let totalSpacing = (2 * self.spacing1) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.upcomingCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
                print("5555",width)
              //  220,250
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else if collectionView == pastCollView
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 15
            
            let totalSpacing = (2 * self.spacing1) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.pastCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
              //  220,250
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 10
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.timeCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: 188, height: 70)
                //188 ,90
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
  
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == upcomingCollView
        {
            let cell = upcomingCollView.dequeueReusableCell(withReuseIdentifier: "PastEventsCollectionViewCell", for: indexPath) as! PastEventsCollectionViewCell
                        let eimg:String = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
            
                        if eimg == ""
                        {
                           cell.eventImgLbl.image = UIImage(named: "edefault")
            
                        }
                           else
                        {
                           let url = URL(string: eimg)
                           let processor = DownsamplingImageProcessor(size: cell.eventImgLbl.bounds.size)
                                        |> RoundCornerImageProcessor(cornerRadius: 0)
                           cell.eventImgLbl.kf.indicatorType = .activity
                           cell.eventImgLbl.kf.setImage(
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
                                cell.eventImgLbl.image = UIImage(named: "edefault")
                               }
                           }
            
                        }
            
                        
                        cell.eventNameLbl.text = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
            return cell
        }
        else if collectionView == pastCollView
        {
            let cell = pastCollView.dequeueReusableCell(withReuseIdentifier: "PastEventsCollectionViewCell", for: indexPath) as! PastEventsCollectionViewCell
                        let eimg:String = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
            
                        if eimg == ""
                        {
                           cell.eventImgLbl.image = UIImage(named: "edefault")
            
                        }
                           else
                        {
                           let url = URL(string: eimg)
                           let processor = DownsamplingImageProcessor(size: cell.eventImgLbl.bounds.size)
                                        |> RoundCornerImageProcessor(cornerRadius: 0)
                           cell.eventImgLbl.kf.indicatorType = .activity
                           cell.eventImgLbl.kf.setImage(
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
                                cell.eventImgLbl.image = UIImage(named: "edefault")
                               }
                           }
            
                        }
            
                        
                        cell.eventNameLbl.text = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
            return cell
        }
        else
        {
            let cell = timeCollView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCollectionViewCell", for: indexPath) as! UpcomingEventsCollectionViewCell
            
            cell.eventNamelbl.text = (timeArr.object(at: indexPath.row) as AnyObject).value(forKey: "day")as! String
            let st = (timeArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
            let et = (timeArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
            
            cell.remainingLbl.text =  st + " - " + et
            
            return cell
        }
       
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == upcomingCollView
        {
            let pn = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
        let add = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
        let od = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
        let cd = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
        let ot = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
        let ct = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
        let ai = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img") as! String
        let en = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
        let aid = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id") as! String
        let eid = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_id") as! String
        let tp = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "ticket_price") as! String
        
        let lat = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "lat") as! String
        
        let long = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "lng") as! String
        
        
        
        let scn = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String
        
        let n = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist")as! String
        
        let cn = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
        
        let ai1 = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String
        
        let aimg = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
       
        
        let spr = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
        
        let ec = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
        let pid = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String
        
        if spr == ""
        {
            providerRating = "0" + "/5"
        }
        else
        {
            providerRating = spr + "/5"
        }
        
        let ar = (upcomingArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_avg_rating")as! String
        if ar == ""
        {
            artistRating = "0" + "/5"
        }
        else
        {
            artistRating = ar + "/5"
        }
        
        UserDefaults.standard.setValue(od, forKey: "e_opend")
        UserDefaults.standard.setValue(ot, forKey: "e_opent")
        UserDefaults.standard.setValue(cd, forKey: "e_closed")
        UserDefaults.standard.setValue(ct, forKey: "e_closet")
        
        UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
        UserDefaults.standard.setValue(n, forKey: "Event_name")
        UserDefaults.standard.setValue(cn, forKey: "Event_cat")
        UserDefaults.standard.setValue(ai1, forKey: "Event_artid")
        UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
        UserDefaults.standard.setValue(providerRating, forKey: "Event_providerrating")
        UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
        
        UserDefaults.standard.setValue(pid, forKey: "V_id")
        
        
        let f = od + " to " + cd + " timing " + ot + " to " + ct
        UserDefaults.standard.setValue(pn, forKey: "e_providername")
        UserDefaults.standard.setValue(add, forKey: "e_provideradd")
        UserDefaults.standard.setValue(f, forKey: "e_time")
        UserDefaults.standard.setValue(ai, forKey: "e_profile")
        UserDefaults.standard.setValue(en, forKey: "e_name")
        UserDefaults.standard.setValue(aid, forKey: "Event_artid")
        UserDefaults.standard.setValue(eid, forKey: "Event_id")
        UserDefaults.standard.setValue(tp, forKey: "Event_ticketprice")
        UserDefaults.standard.setValue(lat, forKey: "Event_lat")
        UserDefaults.standard.setValue(long, forKey: "Event_long")
        UserDefaults.standard.setValue(ec, forKey: "Event_categoryname")

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
    }
        else if collectionView == pastCollView
        {
            let pn = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
           let add = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
           let od = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
           let cd = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
           let ot = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
           let ct = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
           let ai = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img") as! String
           let en = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
           let aid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id") as! String
           let eid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_id") as! String
           let tp = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "ticket_price") as! String
           
           let lat = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "lat") as! String
           
           let long = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "lng") as! String
           
           
           
           let scn = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String
           
           let n = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist")as! String
           
           let cn = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
           
           let ai1 = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String
           
           let aimg = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
          
           
           let spr = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
           
           let ec = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
           let pid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String
           
           if spr == ""
           {
               providerRating = "0" + "/5"
           }
           else
           {
               providerRating = spr + "/5"
           }
           
           let ar = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_avg_rating")as! String
           if ar == ""
           {
               artistRating = "0" + "/5"
           }
           else
           {
               artistRating = ar + "/5"
           }
           
           UserDefaults.standard.setValue(od, forKey: "e_opend")
           UserDefaults.standard.setValue(ot, forKey: "e_opent")
           UserDefaults.standard.setValue(cd, forKey: "e_closed")
           UserDefaults.standard.setValue(ct, forKey: "e_closet")
           
           UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
           UserDefaults.standard.setValue(n, forKey: "Event_name")
           UserDefaults.standard.setValue(cn, forKey: "Event_cat")
           UserDefaults.standard.setValue(ai1, forKey: "Event_artid")
           UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
           UserDefaults.standard.setValue(providerRating, forKey: "Event_providerrating")
           UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
           
           UserDefaults.standard.setValue(pid, forKey: "V_id")
           
           
           let f = od + " to " + cd + " timing " + ot + " to " + ct
           UserDefaults.standard.setValue(pn, forKey: "e_providername")
           UserDefaults.standard.setValue(add, forKey: "e_provideradd")
           UserDefaults.standard.setValue(f, forKey: "e_time")
           UserDefaults.standard.setValue(ai, forKey: "e_profile")
           UserDefaults.standard.setValue(en, forKey: "e_name")
           UserDefaults.standard.setValue(aid, forKey: "Event_artid")
           UserDefaults.standard.setValue(eid, forKey: "Event_id")
           UserDefaults.standard.setValue(tp, forKey: "Event_ticketprice")
           UserDefaults.standard.setValue(lat, forKey: "Event_lat")
           UserDefaults.standard.setValue(long, forKey: "Event_long")
           UserDefaults.standard.setValue(ec, forKey: "Event_categoryname")

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else
        {
            
        }
}
}
