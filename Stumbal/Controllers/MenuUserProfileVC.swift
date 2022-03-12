//
//  MenuUserProfileVC.swift
//  Stumbal
//
//  Created by mac on 16/04/21.
//

import UIKit
import Alamofire
import Kingfisher
class MenuUserProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate {

@IBOutlet var profileImg: UIImageView!
@IBOutlet var nameLbl: UILabel!
@IBOutlet var emaillbl: UILabel!
@IBOutlet var contactLbl: UILabel!
@IBOutlet var profileView: UIView!
    @IBOutlet var eventTblView: UITableView!
    @IBOutlet var upcomingobj: UIButton!
    @IBOutlet var statusLbl: UILabel!
    var pickerOne : UIImagePickerController?
    @IBOutlet var tblHeight: NSLayoutConstraint!
    @IBOutlet var pastObj: UIButton!
    var imgName:String = ""
var str1:String = ""
var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
override func viewDidLoad() {
    super.viewDidLoad()
    
//    profileView.layer.cornerRadius = profileView.frame.height / 2
//    profileView.layer.masksToBounds = false
//    profileView.clipsToBounds = true
    eventTblView.dataSource = self
    eventTblView.delegate = self
    
    DispatchQueue.main.async { [self] in
        pastObj.roundCorners(corners: [.topRight , .bottomRight], radius: 20)
       
    }
    profileView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    // upcomingObj.addRightBorder(borderColor: UIColor.white, borderWidth: 2.0)
     upcomingobj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
     pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
     
     
     upcomingobj.setTitleColor(.white, for: .normal)
     pastObj.setTitleColor(.white, for: .normal)

    
    upcomingobj.roundedButton1()
  
    UserDefaults.standard.set(false, forKey: "past_event")
    UserDefaults.standard.set(true, forKey: "upcoming_event")

    
    // Do any additional setup after loading the view.
}


    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(true, forKey: "upcoming_event")
        UserDefaults.standard.set(false, forKey: "past_event")
        upcomingobj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        fecth_Profile()
        //fetch_upcoming_events()
    }

@IBAction func viewCategory(_ sender: UIButton) {
//    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UpdateCategoryVC") as! UpdateCategoryVC
//    nextViewController.modalPresentationStyle = .fullScreen
//    self.present(nextViewController, animated:false, completion:nil)
}
@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}
@IBAction func editimage(_ sender: UIButton) {
    pickerOne = UIImagePickerController()
    
    let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) in
                                    self.pickerOne!.sourceType = UIImagePickerController.SourceType.photoLibrary
                                    self.pickerOne!.allowsEditing=true
                                    self.pickerOne!.delegate=self
                                    self.present(self.pickerOne!, animated: true, completion: nil)            }))
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
        self.pickerOne!.sourceType=UIImagePickerController.SourceType.camera
        self.pickerOne!.allowsEditing=true
        self.pickerOne!.delegate=self
        self.present(self.pickerOne!, animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
}
@IBAction func following(_ sender: UIButton) {
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "UserFollowingVC") as! UserFollowingVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

  
    @IBAction func changepassowrd(_ sender: UIButton) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
}
    @IBAction func upcoming(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "upcoming_event")
        UserDefaults.standard.set(false, forKey: "past_event")
        upcomingobj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        
        
        upcomingobj.setTitleColor(.white, for: .normal)
        pastObj.setTitleColor(.white, for: .normal)
        fetch_upcoming_events()
    }
    @IBAction func past(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "upcoming_event")
        UserDefaults.standard.set(true, forKey: "past_event")
        pastObj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        upcomingobj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        
        
        pastObj.setTitleColor(.white, for: .normal)
        upcomingobj.setTitleColor(.white, for: .normal)
        fetch_past_events()
    }
    
    func camera()
{
    if UIImagePickerController.isSourceTypeAvailable(.camera){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .camera
        myPickerController.modalPresentationStyle = .fullScreen
        self.present(myPickerController, animated: true, completion: nil)
    }
}

func photoLibrary()
{
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .photoLibrary
        myPickerController.modalPresentationStyle = .fullScreen
        self.present(myPickerController, animated: true, completion: nil)
    }
}

    func resize1(_ image: UIImage) -> UIImage {
        var actualHeight = Float(200)
        var actualWidth = Float(374)
        let maxHeight: Float = 200.0
        let maxWidth: Float = 374.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.1
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }

    
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let selectedImg=info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    
    let image1 : UIImage = selectedImg.resize(400)
    
    let imageData = image1.jpegData(compressionQuality: 0.75)
    str1 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
    
   // str1=ConvertImageToBase64String(img: image1)
    let date = Date()
    let formator = DateFormatter()
    formator.dateFormat = "HH:mm:ss"
    formator.locale = Locale.init(identifier: "en_US_POSIX")
    let strDate = formator.string(from: date)
    let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
    imgName = imagePath
    profileImg.image = image1
    update_profile_image()
    self.dismiss(animated: false, completion: nil)
}

func ConvertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 0.75)?.base64EncodedString() ?? ""
}

    // MARK: - fecth_Profile
    func fecth_Profile()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
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
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                else
                {
                    
                    
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        
                        //                                let result:String = json["result"] as! String
                        //
                        //                                if result == "success"
                        //                                {
                        self.nameLbl.text = json["name"] as! String
                        self.emaillbl.text = json["email"] as! String
                        self.contactLbl.text = json["contact"] as! String
                        //  user_image
                      
                        UserDefaults.standard.setValue(json["cat_name"] as! String, forKey: "Pro_Cat")
                  //  self.profileImg.sd_setImage(with: URL(string:json["user_image"] as! String), placeholderImage: UIImage(named: "udefault"))
                        
                        
                        
    //                    self.profileImg?.sd_setImage(with: URL(string:json["user_image"] as! String )) { (image, error, cache, urls) in
    //                                if (error != nil) {
    //                                    self.profileImg.image = UIImage(named: "udefault")
    //                                } else {
    //                                    self.profileImg.image = image
    //                                }
    //                    }
                        
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
                        
                        self.fetch_upcoming_events()
                        
                       // MBProgressHUD.hide(for: self.view, animated: true)
                        
                        
                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
        
    }



    //MARK: update_profile_image ;
    func update_profile_image()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        Alamofire.request("https://stumbal.com/process.php?action=update_profile_img", method: .post, parameters: ["user_id":uID,"profile_image":imgName,"profile_string":str1], encoding:  URLEncoding.httpBody).responseJSON
        { response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                print("22222222222222")
                //print(response.result.value as Any)
                
                
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    print("JSON: \(json)")
                    print("66666666666")
                    
                    if  json["result"] as! String == "success"
                    {
                        
                        MBProgressHUD.hide(for: self.view, animated: true);
    //                    let alert = UIAlertController(title: "", message: "Profile Picture updated Successfully", preferredStyle: .alert)
    //                    self.present(alert, animated: true, completion: nil)
    //
    //                    // change to desired number of seconds (in this case 5 seconds)
    //                    let when = DispatchTime.now() + 2
    //
    //                    DispatchQueue.main.asyncAfter(deadline: when){
    //                        // your code with delay
    //
    //                        alert.dismiss(animated: false, completion: nil)
    //
    //                        //  self.fecth_Profile()
    //                    }
                    }
                }
            }
        }
        
    }
        
        
        //MARK: fetch_upcoming_events ;
            func fetch_upcoming_events()
            {
                // UserDefaults.standard.set(self.userId, forKey: "User id")
    //            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //            hud.mode = MBProgressHUDMode.indeterminate
    //            hud.self.bezelView.color = UIColor.black
    //            hud.label.text = "Loading...."
                let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
                
                print("123",uID)
                
                Alamofire.request("https://stumbal.com/process.php?action=fetch_upcoming_events", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                            self.fetch_upcoming_events()
                        }))
                        self.present(alert, animated: false, completion: nil)
                         
                     }
                     else
                     {
                         do  {
                            self.AppendArr = NSMutableArray()
                             self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                             //                    print(self.Arr.count)
                             //                    print(self.Arr)
                             //                    self.AppendArr = NSMutableArray()
                             //                    for i in 0...self.Arr.count-1
                             //                    {
                             //                        if (self.Arr.object(at: i) as AnyObject).value(forKey: "card_number") is NSNull {
                             //                        } else {
                             //                            print((self.Arr.object(at:i) as AnyObject).value(forKey: "name"),i)
                             //                            self.AppendArr.add(self.Arr[i])
                             //                        }
                             //
                             //                    }
                             //
                             //                    print(self.AppendArr)
                             
                             
                             if self.AppendArr.count != 0 {
                                 
                                
    //                            let contentOffset = self.eventTblView.contentOffset
    //
    //                            self.eventTblView.layoutIfNeeded()
    //                            self.eventTblView.setContentOffset(contentOffset, animated: false)
    //                            self.tblHeight.constant =  CGFloat(126 * self.AppendArr.count)
    //
                               // self.statusLbl.isHidden = true
                                self.eventTblView.isHidden = false
                                self.eventTblView.reloadData()
                                self.tblHeight.constant = 400
                                
                                 MBProgressHUD.hide(for: self.view, animated: true)
                             }
                                 
                             else  {
                                

                                
                                  self.eventTblView.isHidden = false
                               // self.statusLbl.isHidden = false
                               // self.statusLbl.text = "No upcoming events"
                                  self.tblHeight.constant = 100
                                self.eventTblView.reloadData()
                              //  self.tblHeight.constant = 0
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
        
        //MARK: fetch_past_events ;
            func fetch_past_events()
            {
                // UserDefaults.standard.set(self.userId, forKey: "User id")
                hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.indeterminate
                hud.self.bezelView.color = UIColor.black
                hud.label.text = "Loading...."
                let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
                
                print("123",uID)
                
                Alamofire.request("https://stumbal.com/process.php?action=fetch_past_events", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                            self.fetch_past_events()
                        }))
                        self.present(alert, animated: false, completion: nil)
                         
                     }
                     else
                     {
                         do  {
                            self.AppendArr = NSMutableArray()
                             self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                             //                    print(self.Arr.count)
                             //                    print(self.Arr)
                             //                    self.AppendArr = NSMutableArray()
                             //                    for i in 0...self.Arr.count-1
                             //                    {
                             //                        if (self.Arr.object(at: i) as AnyObject).value(forKey: "card_number") is NSNull {
                             //                        } else {
                             //                            print((self.Arr.object(at:i) as AnyObject).value(forKey: "name"),i)
                             //                            self.AppendArr.add(self.Arr[i])
                             //                        }
                             //
                             //                    }
                             //
                             //                    print(self.AppendArr)
                             
                             
                             if self.AppendArr.count != 0 {
                                 
                                
    //                            let contentOffset = self.eventTblView.contentOffset
    //
    //                            self.eventTblView.layoutIfNeeded()
    //                            self.eventTblView.setContentOffset(contentOffset, animated: false)
    //                            self.tblHeight.constant =  CGFloat(126 * self.AppendArr.count)
    //
                                self.statusLbl.isHidden = true
                                self.eventTblView.isHidden = false
                                self.tblHeight.constant = 400
                                self.eventTblView.reloadData()
                                
                                 MBProgressHUD.hide(for: self.view, animated: true)
                             }
                                 
                             else  {
                                  self.eventTblView.isHidden = false
                             //   self.statusLbl.isHidden = false
                               // self.statusLbl.text = "No past events"
                                self.tblHeight.constant = 100
                               self.eventTblView.reloadData()
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
              // return AppendArr.count
            
            if AppendArr.count == 0 {
                if UserDefaults.standard.bool(forKey: "upcoming_event") == true
                {
                    self.eventTblView.setEmptyMessage("No upcoming events")
                }
                else
                {
                    self.eventTblView.setEmptyMessage("No past events")
                }
                
                
            } else {
                self.eventTblView.restore()
            }

            return AppendArr.count
            
           }
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = eventTblView.dequeueReusableCell(withIdentifier: "EventTblCell", for: indexPath) as! EventTblCell
            
            
            
            if UserDefaults.standard.bool(forKey: "upcoming_event") == true
            {
               // cell.profileImg.sd_setImage(with: URL(string: (self.AppendArr[indexPath.row] as AnyObject).value(forKey:"event_img") as! String), placeholderImage: UIImage(named: "edefault"))
                
                
    //            cell.eventImg?.sd_setImage(with: URL(string: (self.AppendArr[indexPath.row] as AnyObject).value(forKey:"event_img") as! String)) { (image, error, cache, urls) in
    //                        if (error != nil) {
    //                            cell.eventImg.image = UIImage(named: "edefault")
    //                        } else {
    //                            cell.eventImg.image = image
    //                        }
    //            }
                
//                let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
//
//                if eimg == ""
//                {
//                   cell.eventImg.image = UIImage(named: "edefault")
//
//                }
//                   else
//                {
//                   let url = URL(string: eimg)
//                   let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
//                                |> RoundCornerImageProcessor(cornerRadius: 0)
//                   cell.eventImg.kf.indicatorType = .activity
//                   cell.eventImg.kf.setImage(
//                       with: url,
//                       placeholder: nil,
//                       options: [
//                           .processor(processor),
//                           .scaleFactor(UIScreen.main.scale),
//                           .transition(.fade(1)),
//                           .cacheOriginalImage
//                       ])
//                   {
//                       result in
//                       switch result {
//                       case .success(let value):
//                           print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                       case .failure(let error):
//                           print("Job failed: \(error.localizedDescription)")
//                        cell.eventImg.image = UIImage(named: "edefault")
//                       }
//                   }
//
//                }
//
                
                
                
                cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
                cell.eventAddressLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
                
                cell.vendorNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
       
                cell.categorylbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
                
                let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
                let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
                let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
                let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
              //  cell.eventTimelbl.text = od + " to " + cd + " timing " + ot + " to " + ct
                
            }
            else
            {
               // cell.profileImg.sd_setImage(with: URL(string: (self.AppendArr[indexPath.row] as AnyObject).value(forKey:"event_img") as! String), placeholderImage: UIImage(named: "edefault"))
                
    //            cell.eventImg?.sd_setImage(with: URL(string: (self.AppendArr[indexPath.row] as AnyObject).value(forKey:"event_img") as! String)) { (image, error, cache, urls) in
    //                        if (error != nil) {
    //                            cell.eventImg.image = UIImage(named: "edefault")
    //                        } else {
    //                            cell.eventImg.image = image
    //                        }
    //            }
    //
//                let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
//
//                if eimg == ""
//                {
//                   cell.eventImg.image = UIImage(named: "edefault")
//
//                }
//                   else
//                {
//                   let url = URL(string: eimg)
//                   let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
//                                |> RoundCornerImageProcessor(cornerRadius: 0)
//                   cell.eventImg.kf.indicatorType = .activity
//                   cell.eventImg.kf.setImage(
//                       with: url,
//                       placeholder: nil,
//                       options: [
//                           .processor(processor),
//                           .scaleFactor(UIScreen.main.scale),
//                           .transition(.fade(1)),
//                           .cacheOriginalImage
//                       ])
//                   {
//                       result in
//                       switch result {
//                       case .success(let value):
//                           print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                       case .failure(let error):
//                           print("Job failed: \(error.localizedDescription)")
//                        cell.eventImg.image = UIImage(named: "edefault")
//                       }
//                   }
//
//                }
//
                
                cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
                cell.eventAddressLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
                
                cell.vendorNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
       
                cell.categorylbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
                
                let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
                let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
                let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
                let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
               // cell.eventTimelbl.text = od + " to " + cd + " timing " + ot + " to " + ct
                
            }
            return cell
           }
        
        
        var providerRating:String = ""
        var artistRating:String = ""
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            
            
            let pn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
            let add = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
            let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
            let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
            let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
            let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
            let ai = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img") as! String
            let en = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
            let aid = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id") as! String
            let eid = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_id") as! String
            let tp = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "ticket_price") as! String
            
            let lat = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "lat") as! String
            
            let long = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "lng") as! String
            
            
            
            let scn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String
            
            let n = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist")as! String
            
            let cn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
            
            let ai1 = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String
            
            let aimg = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
            let ec = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
            let pid = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String
            
            
            
            
            let spr = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
            if spr == ""
            {
                providerRating = "0" + "/5"
            }
            else
            {
                providerRating = spr + "/5"
            }
            
            let ar = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_avg_rating")as! String
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
            
//            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
//            signuCon.modalPresentationStyle = .fullScreen
//            self.present(signuCon, animated: false, completion:nil)
        }



}
