//
//  NewArtistRatingVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 22/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewArtistRatingVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,FloatRatingViewDelegate {

    @IBOutlet weak var artistImg: UIImageView!
    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var floatingView: FloatRatingView!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var reviewTblView: UITableView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    var ratvalue  = String()
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    var placeholderLabel : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false

        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.layer.masksToBounds = false
        profileView.clipsToBounds = true
        reviewTblView.dataSource = self
        reviewTblView.delegate = self
        
//        messageTxtView.text = "Write a review..."
//        messageTxtView.textColor = UIColor.white
        
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
        messageTxtView.delegate = self
        floatingView.delegate = self
        floatingView.type = .halfRatings
        fetch_artist_register()
        // Do any additional setup after loading the view.
    }
    func textViewDidChange(_ textView: UITextView) {
           placeholderLabel.isHidden = !textView.text.isEmpty
       }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        if messageTxtView.text != ""
        {
            artist_review_ratings()
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter Review", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    // MARK: - Table Height Method
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblHeight?.constant = self.reviewTblView.contentSize.height
    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            messageTxtView.resignFirstResponder()
//        }
//        return true
//    }
    
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
    
    // MARK: - fetch_artist_register
    func fetch_artist_register()
    {

    //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //hud.mode = MBProgressHUDMode.indeterminate
    //hud.self.bezelView.color = UIColor.black
    //hud.label.text = "Loading...."
    //    self.loadingView.isHidden = false
        self.loadingView.isHidden = false

    Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_register", method: .post, parameters: ["artist_id" : UserDefaults.standard.value(forKey: "Event_artid") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                 

                   
                    self.rateLbl.text = json["avg_rating"] as! String
                    
                    if json["avg_rating"] as! String == ""
                    {
                        self.rateLbl.text = "0.0"
                    }
                    else
                    {
                        self.rateLbl.text = json["avg_rating"] as! String
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

                    self.fecth_Profile()

                   // MBProgressHUD.hide(for: self.view, animated: true)


                }
                else
                {
                    //self.loadingView.isHidden = true
                    self.loadingView.isHidden = true

                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }

    }

    
    // MARK: - artist_review_ratings
    func artist_review_ratings()
    {
//
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        
        if ratvalue == ""
        {
            ratvalue = "0.0"
        }
        else
        {
            
        }
        print("221",ratvalue)
        Alamofire.request("https://stumbal.com/process.php?action=artist_review_ratings", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"artist_id":UserDefaults.standard.value(forKey: "Event_artid") as! String,"rating":ratvalue,"review":messageTxtView.text!], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.artist_review_ratings()
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
                            self.ratvalue = "0.0"
                            self.floatingView.rating = 0.0
                            MBProgressHUD.hide(for: self.view, animated: false)
                           // self.dismiss(animated: false, completion: nil)
                            self.fetch_artist_review_rating()
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

    //MARK: fetch_artist_review_rating ;
        func fetch_artist_review_rating()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
//            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.mode = MBProgressHUDMode.indeterminate
//            hud.self.bezelView.color = UIColor.black
//            hud.label.text = "Loading...."
//            
//            if UserDefaults.standard.bool(forKey: "artistsidereview") == true
//            {
//                artId = UserDefaults.standard.value(forKey: "ap_artId") as! String
//            }
//            else
//            {
//                artId = UserDefaults.standard.value(forKey: "Event_artid") as! String
//            }
            
            Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_review_rating", method: .post, parameters: ["artist_id" :UserDefaults.standard.value(forKey: "Event_artid") as! String], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                             self.loadingView.isHidden = true

                          //  self.statusLbl.isHidden = true
                             self.reviewTblView.isHidden = false
                             self.reviewTblView.reloadData()
                             
                             self.reviewTblView.layoutIfNeeded()
                             let contentOffset = self.reviewTblView.contentOffset
                             self.reviewTblView.setContentOffset(contentOffset, animated: false)
                             self.tblHeight.constant = CGFloat(125 * self.AppendArr.count)
                            
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                             self.loadingView.isHidden = true

                              self.reviewTblView.isHidden = true
                             self.tblHeight.constant = 0
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
           
//           var string = result
//           string = Array(arrayLiteral: string).reduce("") {$0 + ($1 == "<br>" ? "\n" : $1)}
//           cell.messageLbl.text = string
         
           
           
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

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
