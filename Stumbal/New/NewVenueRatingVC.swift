//
//  NewVenueRatingVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 22/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewVenueRatingVC: UIViewController,UITableViewDataSource,UITableViewDelegate,FloatRatingViewDelegate,UITextViewDelegate{

    @IBOutlet weak var venueImg: UIImageView!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var floatingView: FloatRatingView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var reviewtblView: UITableView!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIView!
    var placeholderLabel : UILabel!
    var ratvalue  = String()
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    var call:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false

        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.layer.masksToBounds = false
        profileView.clipsToBounds = true
        reviewtblView.dataSource = self
        reviewtblView.delegate = self
        
//        messageTxtView.text = "Write a review..."
//        messageTxtView.textColor = UIColor.white
       // messageTxtView.delegate = self
        floatingView.delegate = self
        floatingView.type = .halfRatings
        
    
        messageTxtView.delegate = self
               placeholderLabel = UILabel()
               placeholderLabel.text = "Write a review..."
             //  placeholderLabel.font = UIFont.italicSystemFont(ofSize: (messageTxtView.font?.pointSize)!)
             placeholderLabel.font = UIFont(name:"Poppins", size: 14.0)

               placeholderLabel.sizeToFit()
               messageTxtView.addSubview(placeholderLabel)
               placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTxtView.font?.pointSize)! / 2)
               placeholderLabel.textColor = UIColor.white
               placeholderLabel.isHidden = !messageTxtView.text.isEmpty
        
        fetch_venue_detail()
        // Do any additional setup after loading the view.
    }
    func textViewDidChange(_ textView: UITextView) {
           placeholderLabel.isHidden = !textView.text.isEmpty
       }
    @IBAction func sendBtn(_ sender: UIButton) {
        if messageTxtView.text != ""
        {
            provider_review_ratings()
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter Review", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table Height Method
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblHeight?.constant = self.reviewtblView.contentSize.height
    }

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        ratvalue = String(format: "%.1f", self.floatingView.rating)
    }

    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        ratvalue = String(format: "%.1f", self.floatingView.rating)
    }
    
//    //MARK:- UITextViewDelegates method
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if messageTxtView.text == "Write a review..." {
//            messageTxtView.text = ""
//            messageTxtView.textColor = UIColor.white
//        }
//
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            messageTxtView.resignFirstResponder()
//        }
//        return true
//    }
//
    // MARK: - fecth_Profile
    func fecth_Profile()
    {

    //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //hud.mode = MBProgressHUDMode.indeterminate
    //hud.self.bezelView.color = UIColor.black
    //hud.label.text = "Loading...."
      //  self.loadingView.isHidden = false
    Alamofire.request("https://stumbal.com/process.php?action=fetch_user_profile", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
    { response in
        if let data = response.data
        {
            let json = String(data: data, encoding: String.Encoding.utf8)
            
            print("Response: \(String(describing: json))")
            if json == ""
            {
                MBProgressHUD.hide(for: self.view, animated: true);
                let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                    self.fecth_Profile()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                
                
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    
                 
                    
                    
                    let uimg:String = json["user_image"] as! String
                    if uimg == ""
                    {
                        self.profileImg.image = UIImage(named: "udefault")
                       
                    }
                    else
                    {
                       let url = URL(string: uimg)
                        let processor = DownsamplingImageProcessor(size: self.profileImg.bounds.size)
                            |> RoundCornerImageProcessor(cornerRadius: 0)
                       self.profileImg.kf.indicatorType = .activity
                       self.profileImg.kf.setImage(
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
                            self.profileImg.image = UIImage(named: "udefault")
                           }
                       }
                       
                    }
                    
                    self.fetch_provider_review_rating()
                    
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
                        self.fecth_Profile()
                        
                       
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


    // MARK: - provider_review_ratings
    func provider_review_ratings()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        if ratvalue == ""
        {
            ratvalue = "0.0"
        }
        else
        {
            
        }
        
        Alamofire.request("https://stumbal.com/process.php?action=provider_review_ratings", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"provider_id":UserDefaults.standard.value(forKey: "V_id") as! String,"rating":ratvalue,"review":messageTxtView.text!], encoding:  URLEncoding.httpBody).responseJSON
        { response in
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
                        self.provider_review_ratings()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        let result:String = json["result"] as! String
                        
                        if result == "success"
                        {
                            
                            self.placeholderLabel = UILabel()
                            self.placeholderLabel.text = "Write a review..."
                            self.placeholderLabel.font = UIFont(name:"Poppins", size: 14.0)
                            self.placeholderLabel.sizeToFit()
                            self.messageTxtView.addSubview(self.placeholderLabel)
                            self.placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.messageTxtView.font?.pointSize)! / 2)
                            self.placeholderLabel.textColor = UIColor.white
                            self.placeholderLabel.isHidden = self.messageTxtView!.text.isEmpty
                            self.messageTxtView.text = ""
                         //   self.messageTxtView.textColor = UIColor.white
                            self.ratvalue = "0.0"
                            self.floatingView.rating = 0.0
                            //UserDefaults.standard.set(false, forKey: "VendorRating")
                            MBProgressHUD.hide(for: self.view, animated: false)
                           // self.dismiss(animated: false, completion: nil)
                            self.fetch_provider_review_rating()
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: false)
                            
                            let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: false, completion: nil)
                        }
                        
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
                    self.loadingView.isHidden = true

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
                        self.AppendArr = NSMutableArray()
                        self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        
                        if self.AppendArr.count != 0 {
                            
                       //     self.statusLbl.isHidden = true
                            self.reviewtblView.isHidden = false
                            self.reviewtblView.reloadData()
                            
                            self.reviewtblView.layoutIfNeeded()
                            let contentOffset = self.reviewtblView.contentOffset
                            self.reviewtblView.setContentOffset(contentOffset, animated: false)
                            self.tblHeight.constant = CGFloat(125 * self.AppendArr.count)
                           // self.cartOrderTableView.isHidden = false
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.loadingView.isHidden = true

                        }
                        
                        else  {
                            self.reviewtblView.isHidden = true
                            self.tblHeight.constant = 0
                           // self.statusLbl.isHidden = false
                            //  self.selectcardLbl.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.loadingView.isHidden = true

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
        let cell =  reviewtblView.dequeueReusableCell(withIdentifier: "NewArtistRatingTableViewCell", for: indexPath) as! NewArtistRatingTableViewCell
        cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
        cell.profileView.layer.masksToBounds = false
        cell.profileView.clipsToBounds = true
        
        cell.nameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
        let result:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "review")as! String
       // createHtmlLabel(with: cell.messageLbl)
        var string1 = result
        cell.messageLbl.text! = string1.replacingOccurrences(of: "<br />", with: "\n")
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
