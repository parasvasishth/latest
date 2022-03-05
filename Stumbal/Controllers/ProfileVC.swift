//
//  ProfileVC.swift
//  Stumbal
//
//  Created by mac on 24/03/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class ProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

@IBOutlet var menu: UIButton!
@IBOutlet var profileImg: UIImageView!
@IBOutlet var nameLbl: UILabel!
@IBOutlet var emaillbl: UILabel!
@IBOutlet var contactLbl: UILabel!
@IBOutlet var profileView: UIView!
@IBOutlet var pastObj: UIButton!
@IBOutlet var eventTblView: UITableView!
@IBOutlet var tblHeight: NSLayoutConstraint!
var pickerOne : UIImagePickerController?
@IBOutlet var upcomingobj: UIButton!
@IBOutlet var statusLbl: UILabel!
@IBOutlet var changePasswordobj: UIButton!
@IBOutlet weak var upcomingCollView: UICollectionView!
@IBOutlet weak var pastCollView: UICollectionView!
@IBOutlet weak var categoryCollView: UICollectionView!
@IBOutlet weak var upcominglbl: UILabel!
@IBOutlet weak var upcomingLblHeight: NSLayoutConstraint!
@IBOutlet weak var upcomingCollHeight: NSLayoutConstraint!
@IBOutlet weak var upcomingLineHeight: NSLayoutConstraint!
@IBOutlet weak var pastLbl: UILabel!
@IBOutlet weak var patsLblHeight: NSLayoutConstraint!
@IBOutlet weak var pastCollHeight: NSLayoutConstraint!
@IBOutlet weak var categoryLbl: UILabel!
@IBOutlet weak var categoryLblHeight: NSLayoutConstraint!
@IBOutlet weak var categoryCollHeight: NSLayoutConstraint!
@IBOutlet weak var categoryLineLblHeight: NSLayoutConstraint!
@IBOutlet weak var catetoproHeight: NSLayoutConstraint!
@IBOutlet weak var loadingView: UIView!
@IBOutlet weak var hideView: UIView!
@IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var pastnHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingnheight: NSLayoutConstraint!
    @IBOutlet weak var switchObj: UIButton!
    var imgName:String = ""
@IBOutlet weak var cancelObj: UIButton!
@IBOutlet weak var eventCountlbl: UILabel!
@IBOutlet weak var friendCountLbl: UILabel!
@IBOutlet weak var categoryCountlbl: UILabel!
    @IBOutlet weak var pastToupcomingHeight: NSLayoutConstraint!
    @IBOutlet weak var eventHeight: NSLayoutConstraint!
    @IBOutlet weak var pastcollTopasteventHeight: NSLayoutConstraint!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
    var str1:String = ""
var AppendArr:NSMutableArray = NSMutableArray()
var pastArr:NSMutableArray = NSMutableArray()
var cateArr:NSMutableArray = NSMutableArray()
var hud = MBProgressHUD()
private let spacing:CGFloat = 10.0
private let spacing1:CGFloat = 15.0
private let spacing2:CGFloat = 10.0
var session = URLSession()
    var providerRating:String = ""
    var artistRating:String = ""
override func viewDidLoad() {
super.viewDidLoad()
    
   
    self.loadingView.isHidden = false
//    menu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
tabBarController?.tabBar.isHidden = true

profileView.layer.cornerRadius = profileView.frame.height / 2
profileView.layer.masksToBounds = false
profileView.clipsToBounds = true

//

//    DispatchQueue.main.async { [self] in
//        pastObj.roundCorners(corners: [.topRight , .bottomRight], radius: 20)
//
//    }
 //  profileView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
//    // upcomingObj.addRightBorder(borderColor: UIColor.white, borderWidth: 2.0)
//     upcomingobj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
//     pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
//
//
//     upcomingobj.setTitleColor(.white, for: .normal)
//     pastObj.setTitleColor(.white, for: .normal)
//
//
//    upcomingobj.roundedButton1()
//  pastObj.roundedButton()
//    eventTblView.dataSource = self
//    eventTblView.delegate = self
//  tblHeight.constant = 0
// UserDefaults.standard.set(false, forKey: "past_event")
//  UserDefaults.standard.set(true, forKey: "upcoming_event")


let layout = UICollectionViewFlowLayout()
layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
layout.minimumLineSpacing = spacing
layout.minimumInteritemSpacing = spacing
layout.scrollDirection = .horizontal
self.upcomingCollView?.collectionViewLayout = layout

let layout1 = UICollectionViewFlowLayout()
layout1.sectionInset = UIEdgeInsets(top: 5, left: spacing1, bottom: spacing1, right: spacing1)
layout1.minimumLineSpacing = spacing1
layout1.minimumInteritemSpacing = spacing1
layout1.scrollDirection = .horizontal
self.pastCollView?.collectionViewLayout = layout1

let layout2 = UICollectionViewFlowLayout()
layout2.sectionInset = UIEdgeInsets(top: spacing2, left: spacing2, bottom: spacing2, right: spacing2)
layout2.minimumLineSpacing = spacing2
layout2.minimumInteritemSpacing = spacing2
layout2.scrollDirection = .horizontal
self.categoryCollView?.collectionViewLayout = layout2

upcomingCollView.dataSource=self
upcomingCollView.delegate=self
pastCollView.dataSource=self
pastCollView.delegate=self
categoryCollView.dataSource=self
categoryCollView.delegate=self

let configuration = URLSessionConfiguration.default
session = URLSession(configuration: configuration)
    
    
// fecth_Profile()
//fetch_upcoming_events()

// Do any additional setup after loading the view.
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    friendCountLbl.isUserInteractionEnabled = true
    friendCountLbl.addGestureRecognizer(tapGestureRecognizer)
    
   
}

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVC
//        nextViewController.modalPresentationStyle = .fullScreen
//        self.present(nextViewController, animated:false, completion:nil)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewFriendListVC") as! NewFriendListVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
        
        
        
    }
    
   
// MARK: - Table Height Method
//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()
//      //  self.tableHeight?.constant = self.cardTableView.contentSize.height
//
//        self.tblHeight?.constant = CGFloat(126 * self.AppendArr.count)
//
//       //   self.addMoreTableheight?.constant = CGFloat(230 * self.extraRow)
//    }

//    override func viewWillLayoutSubviews() {
//            super.updateViewConstraints()
//            self.tblHeight?.constant = self.eventTblView.contentSize.height
//        }


override func viewWillAppear(_ animated: Bool) {
    self.loadingView.isHidden = false
//  UserDefaults.standard.set(true, forKey: "upcoming_event")
// UserDefaults.standard.set(false, forKey: "past_event")
// upcomingobj.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
// pastObj.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
//    if self.revealViewController() != nil {
//
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
//        }
    if UserDefaults.standard.bool(forKey: "ArtistLogin") == true
    {
        switchObj.setTitle("Switch to User", for: .normal)
    }
    else
    {
        
        
        if UserDefaults.standard.value(forKey: "checkuser") as! String == "artist"
        {
            switchObj.setTitle("Switch to Artist Account", for: .normal)
        }
        else
        {
            switchObj.setTitle("Create an Artist", for: .normal)
        }

    }
        
    fecth_Profile()
//fetch_upcoming_events()
}

    @IBAction func editProfile(_ sender: UIButton) {
        hideView.isHidden = true
        logoutView.isHidden = true
        cancelObj.isHidden = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditUserProfileVC") as! EditUserProfileVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
       
        hideView.isHidden = true
        logoutView.isHidden = true
        cancelObj.isHidden = true
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.backgroundColor = UIColor.black
    }
    
    @IBAction func selectBtn(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = true
        hideView.isHidden = false
        logoutView.isHidden = false
        cancelObj.isHidden = false
      //  tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let refreshAlert = UIAlertController(title: "Exit ", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok login here")
            UserDefaults.standard.set(false, forKey: "login")
            UserDefaults.standard.set(false, forKey: "ArtistLogin")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
            print("Success")
        }))
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Login here")
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func artist(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "ArtistLogin") == true
        {
            UserDefaults.standard.set(false, forKey: "ArtistLogin")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            nextViewController.modalPresentationStyle = .fullScreen
           self.present(nextViewController, animated:false, completion:nil)
        }
        else
        {
            UserDefaults.standard.set(true, forKey: "ArtistLogin")
            
            if UserDefaults.standard.value(forKey: "checkuser") as! String == "artist"
            {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                 let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                nextViewController.modalPresentationStyle = .fullScreen
               self.present(nextViewController, animated:false, completion:nil)
            }
            else
            {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                 let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ArtistRegisterVC") as! ArtistRegisterVC
                nextViewController.modalPresentationStyle = .fullScreen
               self.present(nextViewController, animated:false, completion:nil)
            }
            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            nextViewController.modalPresentationStyle = .fullScreen
//           self.present(nextViewController, animated:false, completion:nil)
        }
    }
    
    @IBAction func viewCategory(_ sender: UIButton) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UpdateCategoryVC") as! UpdateCategoryVC
    nextViewController.modalPresentationStyle = .fullScreen
    self.present(nextViewController, animated:false, completion:nil)
}
@IBAction func changePassword(_ sender: UIButton) {

let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
nextViewController.modalPresentationStyle = .fullScreen
self.present(nextViewController, animated:false, completion:nil)
}

@IBAction func following(_ sender: UIButton) {
var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "UserFollowingVC") as! UserFollowingVC
signuCon.modalPresentationStyle = .fullScreen
self.present(signuCon, animated: false, completion:nil)
}

@IBAction func editPicture(_ sender: UIButton) {

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
//    extension UIImage {
//        var jpeg: Data? { jpegData(compressionQuality: 1) }  // QUALITY min = 0 / max = 1
//        var png: Data? { pngData() }
//    }


func resize1(_ image: UIImage) -> UIImage {
    var actualHeight = Float(200)
    var actualWidth = Float(400)
    let maxHeight: Float = 200.0
    let maxWidth: Float = 400.0
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    let compressionQuality: Float = 1.0
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
// let selectedImg=info[UIImagePickerController.InfoKey.originalImage] as! UIImage

let selectedImg=info[UIImagePickerController.InfoKey.originalImage] as! UIImage
// let image1 : UIImage = resize1(selectedImg)

 let image1 : UIImage = selectedImg.resize(400)

let imageData = image1.jpegData(compressionQuality: 0.75)
str1 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
// str1 = ConvertImageToBase64String(img: image1)

// driverLicenceImageFiled.text = imagePath
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
return img.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
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



// MARK: - fecth_Profile
func fecth_Profile()
{

//hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//hud.mode = MBProgressHUDMode.indeterminate
//hud.self.bezelView.color = UIColor.black
//hud.label.text = "Loading...."
    
Alamofire.request("https://stumbal.com/process.php?action=fetch_user_profile", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                self.fecth_Profile()
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
            self.nameLbl.text = json["name"] as! String
              //  self.emaillbl.text = json["email"] as! String
              //  self.contactLbl.text = json["contact"] as! String
                //  user_image
              
                UserDefaults.standard.setValue(json["cat_name"] as! String, forKey: "Pro_Cat")
                
                self.categoryCountlbl.text = json["category_count"] as! String
                self.friendCountLbl.text = json["friend_count"] as! String
          //  self.profileImg.sd_setImage(with: URL(string:json["user_image"] as! String), placeholderImage: UIImage(named: "udefault"))
                
                
                
//                    self.profileImg?.sd_setImage(with: URL(string:json["user_image"] as! String )) { (image, error, cache, urls) in
//                                if (error != nil) {
//                                    self.profileImg.image = UIImage(named: "udefault")
//                                } else {
//                                    self.profileImg.image = image
//                                }
//                    }
                
                let uimg:String = json["user_image"] as! String
                
                
//                    let imageUrl = URL(string: "your image url")
//                     //Size refer to the size which you want to resize your original image
//                     let size = CGSize(width: 60, height: 60)
//                    let processImage = ResizingImageProcessor(targetSize: size, contentMode: .aspectFill)
//                     cell.courseTitleImage.kf.setImage(with: imageUrl! , placeholder: UIImage(named: "placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processImage)], progressBlock: nil, completionHandler: nil)
                
                
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
                self.loadingView.isHidden = true

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
        
        
        if json == ""
        {
            MBProgressHUD.hide(for: self.view, animated: true);
            let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                print("Action")
                self.update_profile_image()
            }))
            self.present(alert, animated: false, completion: nil)
            
            
        }
        else
        {
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
                 self.loadingView.isHidden = true
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
//                         self.upcomingLblHeight.constant = 21
//                         self.upcominglbl.isHidden = false
//                         self.upcomingCollHeight.constant = 100
//                         self.upcomingLineHeight.constant = 2
                        self.upcomingCollView.isHidden = false
                         self.firstView.isHidden = false
                         self.firstViewHeight.constant = 157
                        self.upcomingCollView.reloadData()
                         self.fetch_past_events()
                      //  self.tblHeight.constant = 400
                    
                         MBProgressHUD.hide(for: self.view, animated: true)
                     }
                         
                     else  {
                        

//                         self.upcomingLblHeight.constant = 0
//                         self.upcominglbl.isHidden = true
//                         self.upcomingCollHeight.constant = 0
//                         self.upcomingLineHeight.constant = 0
                        self.upcomingnheight.constant = 0
                         self.firstView.isHidden = true
                         self.firstViewHeight.constant = 0
                          self.upcomingCollView.isHidden = false
                       // self.statusLbl.isHidden = false
                       // self.statusLbl.text = "No upcoming events"
                        //  self.tblHeight.constant = 100
                      //  self.upcomingCollView.reloadData()
                         self.fetch_past_events()
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
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_past_events", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                     self.fetch_past_events()
                 }))
                 self.present(alert, animated: false, completion: nil)
                 
             }
             else
             {
                 do  {
                    self.pastArr = NSMutableArray()
                     self.pastArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
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
                     
                     
                     if self.pastArr.count != 0 {
                         
                        
//                            let contentOffset = self.eventTblView.contentOffset
//
//                            self.eventTblView.layoutIfNeeded()
//                            self.eventTblView.setContentOffset(contentOffset, animated: false)
//                            self.tblHeight.constant =  CGFloat(126 * self.AppendArr.count)
//
                       // self.statusLbl.isHidden = true
//                         self.patsLblHeight.constant = 21
//                         self.pastLbl.isHidden = false
//                         self.pastCollHeight.constant = 290
                         self.secondView.isHidden = false
                         self.secondViewHeight.constant = 260
                        self.pastCollView.isHidden = false
                        //self.tblHeight.constant = 400
                        self.pastCollView.reloadData()
                         self.eventCountlbl.text = String(self.pastArr.count)
                        self.fetch_user_category()
                        
                         MBProgressHUD.hide(for: self.view, animated: true)
                     }
                         
                     else  {
                         self.pastnHeight.constant = 0
                         self.eventCountlbl.text = String(self.pastArr.count)
//                         self.patsLblHeight.constant = 0
//                         self.pastLbl.isHidden = true
//                         self.pastCollHeight.constant = 0
                         self.secondView.isHidden = false
                         self.secondViewHeight.constant = 0
                          self.pastCollView.isHidden = false
                     //   self.statusLbl.isHidden = false
                       // self.statusLbl.text = "No past events"
                        //self.tblHeight.constant = 100
                     //  self.pastCollView.reloadData()
                         self.fetch_user_category()
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

//MARK: fetch_user_category ;
    func fetch_user_category()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_user_category", method: .post, parameters: ["user_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                     self.fetch_user_category()
                 }))
                 self.present(alert, animated: false, completion: nil)
                 
             }
             else
             {
                 do  {
                    self.cateArr = NSMutableArray()
                     self.cateArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
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
                     
                     
                     if self.cateArr.count != 0 {
                         
                        
//                            let contentOffset = self.eventTblView.contentOffset
//
//                            self.eventTblView.layoutIfNeeded()
//                            self.eventTblView.setContentOffset(contentOffset, animated: false)
//                            self.tblHeight.constant =  CGFloat(126 * self.AppendArr.count)
//
                       // self.statusLbl.isHidden = true
                        // self.catetoproHeight.constant = 20
//                         self.upcomingLblHeight.constant = 0
//                         self.upcomingCollHeight.constant = 0
//                         self.upcomingLblHeight.constant = 0
                       //  self.pastToupcomingHeight.constant = 10
                      //   self.pastcollTopasteventHeight.constant = 10
//                         self.categoryLblHeight.constant = 21
//                         self.categoryLbl.isHidden = false
//                         self.categoryCollHeight.constant = 80
//                         self.categoryLineLblHeight.constant = 2
                       
                      
                         self.thirdView.isHidden = false
                         self.thirdViewHeight.constant = 137
                         self.categoryCollView.isHidden = false

                        //self.tblHeight.constant = 400
                         self.categoryCollView.reloadData()
                         self.loadingView.isHidden = true
                     //    self.pastToupcomingHeight.constant = 10
                        // self.eventHeight.constant = 200
                         self.tabBarController?.tabBar.isHidden = false
                         self.tabBarController?.tabBar.backgroundColor = UIColor.black
                         MBProgressHUD.hide(for: self.view, animated: true)
                     }
                         
                     else  {
//                         self.categoryLblHeight.constant = 0
//                         self.categoryLbl.isHidden = true
//                         self.categoryCollHeight.constant = 0
//                         self.categoryLineLblHeight.constant = 0
                       
                         self.categoryLblHeight.constant = 0
                         self.thirdView.isHidden = true
                         self.thirdViewHeight.constant = 0
                          self.categoryCollView.isHidden = true
                         //self.pastToupcomingHeight.constant = 10
                         //self.eventHeight.constant = 200
                     //   self.statusLbl.isHidden = false
                       // self.statusLbl.text = "No past events"
                        //self.tblHeight.constant = 100
                       self.categoryCollView.reloadData()
                         self.loadingView.isHidden = true
                         self.tabBarController?.tabBar.isHidden = false
                         self.tabBarController?.tabBar.backgroundColor = UIColor.black
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
        
//            let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
//
//            if eimg == ""
//            {
//               cell.eventImg.image = UIImage(named: "edefault")
//
//            }
//               else
//            {
//               let url = URL(string: eimg)
//               let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
//                            |> RoundCornerImageProcessor(cornerRadius: 0)
//               cell.eventImg.kf.indicatorType = .activity
//               cell.eventImg.kf.setImage(
//                   with: url,
//                   placeholder: nil,
//                   options: [
//                       .processor(processor),
//                       .scaleFactor(UIScreen.main.scale),
//                       .transition(.fade(1)),
//                       .cacheOriginalImage
//                   ])
//               {
//                   result in
//                   switch result {
//                   case .success(let value):
//                       print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                   case .failure(let error):
//                       print("Job failed: \(error.localizedDescription)")
//                    cell.eventImg.image = UIImage(named: "edefault")
//                   }
//               }
//
//            }
        
        
        
        
        cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
        cell.eventAddressLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
        
        cell.vendorNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String

        cell.categorylbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
        
        let od = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
        let cd = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
        let ot = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
        let ct = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
     //   cell.eventTimelbl.text = od + " to " + cd + " timing " + ot + " to " + ct
        
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
//            let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
//
//            if eimg == ""
//            {
//               cell.eventImg.image = UIImage(named: "edefault")
//
//            }
//               else
//            {
//               let url = URL(string: eimg)
//               let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
//                            |> RoundCornerImageProcessor(cornerRadius: 0)
//               cell.eventImg.kf.indicatorType = .activity
//               cell.eventImg.kf.setImage(
//                   with: url,
//                   placeholder: nil,
//                   options: [
//                       .processor(processor),
//                       .scaleFactor(UIScreen.main.scale),
//                       .transition(.fade(1)),
//                       .cacheOriginalImage
//                   ])
//               {
//                   result in
//                   switch result {
//                   case .success(let value):
//                       print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                   case .failure(let error):
//                       print("Job failed: \(error.localizedDescription)")
//                    cell.eventImg.image = UIImage(named: "edefault")
//                   }
//               }
//
//            }
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
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

//    func numberOfSections(in collectionView: UICollectionView) -> Int
//    {
//        if collectionView == upcomingCollView
//        {
//            return 1
//        }
//        else
//        {
//            return 1
//        }
//    }
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
{
    if collectionView == upcomingCollView
    {
        return AppendArr.count
    }
    else if collectionView == pastCollView
    {
        return pastArr.count
    }
    else
    {
        return cateArr.count
    }
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    
    if collectionView == upcomingCollView
    {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 10
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.upcomingCollView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: 188, height: 90)
            //188 ,90
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    else  if collectionView == pastCollView
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
        
        let totalSpacing = (2 * self.spacing2) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.categoryCollView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: 188, height: 90)
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
        let cell = upcomingCollView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCollectionViewCell", for: indexPath) as! UpcomingEventsCollectionViewCell
        
        cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
        let r:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "remain_days")as! String
        
        cell.remainingLbl.text = "In " + r + " days"
        
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
        let cell = categoryCollView.dequeueReusableCell(withReuseIdentifier: "ProfileCategoriesCollectionViewCell", for: indexPath) as! ProfileCategoriesCollectionViewCell
        
        cell.cateLbl.text = (cateArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
        

        return cell
    }

}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == upcomingCollView
        {
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
            let edesc = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_desc")as! String
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
            UserDefaults.standard.setValue(edesc, forKey: "Event_desc")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewUpcomingEventDetailVC") as! NewUpcomingEventDetailVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
//            let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
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
            let ec = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
            let pid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String

            let spr = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
            let edesc = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_desc")as! String
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
            UserDefaults.standard.setValue(edesc, forKey: "Event_desc")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewRefundEventDetailVC") as! NewRefundEventDetailVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
//            let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
    }

}
extension UITableView {

func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = .white
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.font = UIFont(name: "Gilroy", size: 21)
    messageLabel.sizeToFit()

    self.backgroundView = messageLabel
    self.separatorStyle = .none
}

func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
}
}

extension UIImage {
func resize12(_ width: CGFloat, _ height:CGFloat) -> UIImage? {
    let widthRatio  = width / size.width
    let heightRatio = height / size.height
    let ratio = widthRatio > heightRatio ? heightRatio : widthRatio
    let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}
}
extension UIImage {
func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
    // Determine the scale factor that preserves aspect ratio
    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height
    
    let scaleFactor = min(widthRatio, heightRatio)
    
    // Compute the new image size that preserves aspect ratio
    let scaledImageSize = CGSize(
        width: size.width * scaleFactor,
        height: size.height * scaleFactor
    )

    // Draw and return the resized UIImage
    let renderer = UIGraphicsImageRenderer(
        size: scaledImageSize
    )

    let scaledImage = renderer.image { _ in
        self.draw(in: CGRect(
            origin: .zero,
            size: scaledImageSize
        ))
    }
    
    return scaledImage
}
}
extension UIImage {
func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
        _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
}
func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
        _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
}
}

