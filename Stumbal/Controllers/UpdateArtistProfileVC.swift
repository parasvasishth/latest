//
//  UpdateArtistProfileVC.swift
//  Stumbal
//
//  Created by mac on 03/05/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class UpdateArtistProfileVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource{

@IBOutlet var nameFiled: UITextField!
@IBOutlet var categoryCollectionView: UICollectionView!
@IBOutlet var artistTbleView: UITableView!
@IBOutlet var tbleHeight: NSLayoutConstraint!
@IBOutlet var profileView: UIView!
@IBOutlet var profileImg: UIImageView!
var categoryArray:NSArray = NSArray()
var str1:String = ""

var hud = MBProgressHUD()
var cat_ID:String = ""
var subCat_ID:String = ""
var pickerOne : UIImagePickerController?
var otherartistArray:[String] = []
var string1:String = ""
var IdArr = NSMutableArray()
var servicenameArr = [[String: String]]()
var artistArray:NSMutableArray = NSMutableArray()
override func viewDidLoad() {
    super.viewDidLoad()
    
    artistTbleView.dataSource = self
    artistTbleView.delegate = self
    
    profileImg.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    nameFiled.setLeftPaddingPoints(15)
    // tbleHeight.constant = 0
    UserDefaults.standard.removeObject(forKey: "userarray")
    fetch_artist_register()
    
    categoryCollectionView.dataSource = self
    categoryCollectionView.delegate = self
    
    // Do any additional setup after loading the view.
}

override func viewWillAppear(_ animated: Bool) {
    
    if UserDefaults.standard.value(forKey: "userarray") == nil
    {
        
    }
    else
    {
        servicenameArr = UserDefaults.standard.value(forKey: "userarray") as! [[String: String]]
        print("11",servicenameArr)
        artistArray = NSMutableArray(array:servicenameArr)
        artistTbleView.isHidden = false
        artistTbleView.reloadData()
    }
    
}

@IBAction func editProfile(_ sender: UIButton) {
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
@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
    
}
@IBAction func addUser(_ sender: UIButton) {
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistSearchVC") as! ArtistSearchVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
    
}

@IBAction func deleteArtist(_ sender: UIButton) {
    let tagVal : Int = sender.tag
    UserDefaults.standard.set(true, forKey: "Added")
    if artistArray.count != 0
    {
        servicenameArr.remove(at: tagVal)
        artistArray.removeObject(at: tagVal)
        UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
        artistTbleView.reloadData()
    }
    else
    {
        artistTbleView.isHidden = true
        UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
        
    }
    
}

@IBAction func updateProfile(_ sender: UIButton) {
    
    if nameFiled.text != ""
    {
        if IdArr.count != 0
        {
            artist_register()
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Select category", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
        
    }
    else
    {
        let alert = UIAlertController(title: "", message: "Enter name", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
}

// MARK: - fetch_artist_register
func fetch_artist_register()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_register", method: .post, parameters: ["artist_id" : UserDefaults.standard.value(forKey: "ap_artId") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.fetch_artist_register()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                
                
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    self.nameFiled.text = json["name"] as! String
                    
                    self.cat_ID = json["category_id"] as! String
                    let addNsarray:NSArray = cat_ID.components(separatedBy: ",") as NSArray
                    IdArr = NSMutableArray(array: addNsarray)
                    
                    self.categoryCollectionView.dataSource = self
                    self.categoryCollectionView.delegate = self
                    fetch_metatags()
                    let layout1 = UICollectionViewCenterLayout()
                    layout1.estimatedItemSize = CGSize(width: 140, height: 40)
                    self.categoryCollectionView.collectionViewLayout = layout1
                    
                    let otheArr:NSArray = json["other_user"] as! NSArray
                    self.artistArray = NSMutableArray(array:otheArr)
                    let uimg:String = json["artist_img"] as! String
                    if uimg == ""
                    {
                        self.profileImg.image = UIImage(named: "adefault")
                        
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
                                self.profileImg.image = UIImage(named: "adefault")
                            }
                        }
                        
                    }
                    
                    if artistArray.count != 0
                    {
                        self.servicenameArr  = self.artistArray as! [[String : String]]
                        UserDefaults.standard.setValue(self.servicenameArr, forKey: "userarray")
                        
                        artistTbleView.reloadData()
                        artistTbleView.isHidden = false
                    }
                    else
                    {
                        artistTbleView.isHidden = true
                    }
                    UserDefaults.standard.setValue(json["artist_id"] as! String, forKey: "ap_artId")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
}

@objc func camera()
{
    if UIImagePickerController.isSourceTypeAvailable(.camera){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    
}

@objc func photoLibrary()
{
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .photoLibrary
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
     //str1=ConvertImageToBase64String(img: selectedImg)
    let image1 : UIImage = selectedImg.resize(400)
    let imageData = image1.jpegData(compressionQuality: 0.75)
    //let t =  selectedImg.jpeg!
    str1 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
   // str1 = ConvertImageToBase64String(img: image1)
    profileImg.image = image1
    self.dismiss(animated: true, completion: nil)
    
}

@objc func ConvertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 0)?.base64EncodedString() ?? ""
}

func json(from object: [[String:Any]]) throws -> String {
    let data = try JSONSerialization.data(withJSONObject: object)
    return String(data: data, encoding: .utf8)!
}

//MARK: artist_register ;
func artist_register()
{
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    let uID = UserDefaults.standard.value(forKey: "ap_artId") as! String
    
    let date = Date()
    let formator = DateFormatter()
    formator.dateFormat = "HH:mm:ss"
    formator.locale = Locale.init(identifier: "en_US_POSIX")
    let strDate = formator.string(from: date)
    let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
    
    let imageData = self.profileImg.image?.jpegData(compressionQuality: 0.0)
    let strBase64 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
    
    let finalcat:String = IdArr.componentsJoined(by: ",")
    
    if artistArray.count != 0
    {
        do {
            string1 = try! json(from:artistArray as! [[String : Any]])
            print("111",string1)
        }
        catch { print(error) }
    }
    else
    {
        
    }
    Alamofire.request("https://stumbal.com/process.php?action=update_artist_user", method: .post, parameters: ["artist_id":uID,"name":nameFiled.text!,"category_id":finalcat,"sub_cat_id":subCat_ID,"other_user":string1,"artist_image":imagePath,"artist_image_string":strBase64], encoding:  URLEncoding.httpBody).responseJSON
    { response in
        if let data = response.data
        {
            let json = String(data: data, encoding: String.Encoding.utf8)
            print("=====1======")
            print("Response: \(String(describing: json))")
            if let json: NSDictionary = response.result.value as? NSDictionary
            
            {
                print("JSON: \(json)")
                print("66666666666")
                
                if  json["result"] as! String == "success"
                {
                    
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.dismiss(animated: false, completion: nil)
                    
                }
            }
        }
    }
    
}

func fetch_metatags()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_metatags", method: .post, parameters: nil, encoding:  URLEncoding.httpBody).responseJSON { response in
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
                    self.fetch_metatags()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.categoryArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    if self.categoryArray.count != 0 {
                        
                        self.categoryCollectionView.isHidden = false
                        self.categoryCollectionView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.categoryCollectionView.isHidden = true
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

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return  categoryArray.count
}

func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
{
    self.viewWillLayoutSubviews()
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "titleCell",
                                                                for: indexPath) as? RoundedCollectionViewCell else{
        return RoundedCollectionViewCell()
    }
    
    
    let n = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
    
    let id = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_id")as! String
    
    
    if IdArr.count != 0
    {
        for i  in 0...IdArr.count-1 {
            let name : String = IdArr[i] as! String
            if name == id {
                cell.roundedView.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
                UserDefaults.standard.set(true, forKey: String(format: "Selected%d", indexPath.row))
                break
            }else{
                cell.roundedView.backgroundColor = UIColor.darkGray
                UserDefaults.standard.set(false, forKey: String(format: "Selected%d", indexPath.row))
            }
        }
    }
    else
    {
        
    }
    
    cell.textLabel.text = n
    cell.layoutSubviews()
    return cell
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let selectedCell:RoundedCollectionViewCell = categoryCollectionView.cellForItem(at: indexPath)! as! RoundedCollectionViewCell
    let id = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_id")as! String
    
    if !UserDefaults.standard.bool(forKey: String(format: "Selected%d", indexPath.row)) {
        selectedCell.roundedView.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        UserDefaults.standard.set(true, forKey: String(format: "Selected%d", indexPath.row))
        IdArr.add(id)
        
    }else{
        selectedCell.roundedView.backgroundColor = UIColor.darkGray
        UserDefaults.standard.set(false, forKey: String(format: "Selected%d", indexPath.row))
        let val : String = id
        for i in 0...IdArr.count - 1 {
            if IdArr[i] as! String == val {
                //  IdArr.remove(activityArr[indexPath.row])
                //  IdArr.remove(categoryArray[indexPath.row])
                IdArr.remove(id)
                break
            }else{
                
            }
        }
        
    }
    
}

//MARK:  TableView Method
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return artistArray.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cell = artistTbleView.dequeueReusableCell(withIdentifier: "SearchArtistTblCell", for: indexPath) as! SearchArtistTblCell
    
    
    let eimg:String = (artistArray.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
    
    if eimg == ""
    {
        cell.profileImg.image = UIImage(named: "adefault")
        
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
                cell.profileImg.image = UIImage(named: "adefault")
            }
        }
        
    }
    
    cell.artistNameLbl.text! = (artistArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
    cell.artistIdLbl.text! = (artistArray.object(at: indexPath.row) as AnyObject).value(forKey: "stumbal_id")as! String
    
    cell.addObj.tag = indexPath.row
    return cell
}

}



