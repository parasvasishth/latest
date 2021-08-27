//
//  ArtistRegisterVC.swift
//  Stumbal
//
//  Created by mac on 03/04/21.
//

import UIKit
import Alamofire
import Kingfisher
class ArtistRegisterVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

@IBOutlet var profileImg: UIImageView!
@IBOutlet var nameLbl: UITextField!
@IBOutlet var categoryField: UITextField!
@IBOutlet var subCategoryFiled: UITextField!
@IBOutlet var otheruserLbl: UILabel!
@IBOutlet var otherHeight: NSLayoutConstraint!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var blackView: UIView!
    @IBOutlet var artsitTbleView: UITableView!
    @IBOutlet var profileView: UIView!
    @IBOutlet var tblHeight: NSLayoutConstraint!
    var pickerOne : UIImagePickerController?
var imgName:String = ""
var str1:String = ""
var categoryArray:NSArray = NSArray()
var subCategoryArray:NSArray = NSArray()
let thePicker = UIPickerView()
let thePicker1 = UIPickerView()
var catPickerData1 = [String]()
var catPickerData2 = [String]()
var subCatPickerData1 = [String]()
var subCatPickerData2 = [String]()
var myPicker2Data1 = [String]()
var myPicker2Data2 = [String]()
var hud = MBProgressHUD()
var cat_ID:String = ""
var subCat_ID:String = ""
    var otherartistArray:[String] = []
    var IdArr = NSMutableArray()
    var servicenameArr = [[String: String]]()
    var artistArray:NSMutableArray = NSMutableArray()
    var string1:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    UserDefaults.standard.removeObject(forKey: "userarray")
   
    nameLbl.setLeftPaddingPoints(10)
    nameLbl.attributedPlaceholder =
        NSAttributedString(string: "Enter Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
   
    nameLbl.setLeftPaddingPoints(15)

    artsitTbleView.dataSource = self
    artsitTbleView.delegate = self
    categoryCollectionView.dataSource = self
    categoryCollectionView.delegate = self
    //tblHeight.constant = 0
    
    fetch_metatags()
    
  
    DispatchQueue.main.async { [self] in
       
        profileView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    }
    
    let layout = UICollectionViewCenterLayout()
    layout.estimatedItemSize = CGSize(width: 140, height: 40)
    categoryCollectionView.collectionViewLayout = layout
    // Do any additional setup after loading the view.
}
override func viewWillAppear(_ animated: Bool) {
    
    if UserDefaults.standard.value(forKey: "userarray") == nil
    {
        tblHeight.constant = 0
    
    }
    else
    {
        servicenameArr = UserDefaults.standard.value(forKey: "userarray") as! [[String: String]]
        print("11",servicenameArr)
        tblHeight.constant = 400
       artistArray = NSMutableArray(array:servicenameArr)
        artsitTbleView.isHidden = false
        artsitTbleView.reloadData()
    }

}

    @IBAction func deleteUser(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        UserDefaults.standard.set(true, forKey: "Added")
        if artistArray.count != 0
        {
            servicenameArr.remove(at: tagVal)
            artistArray.removeObject(at: tagVal)
            UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
             artsitTbleView.reloadData()
        }
        else
        {
            artsitTbleView.isHidden = true
            artsitTbleView.reloadData()
          tblHeight.constant = 0
            UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
           
        }
    }
    
@IBAction func add(_ sender: UIButton) {
  //  UserDefaults.standard.set(false, forKey: "aback")
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistSearchVC") as! ArtistSearchVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}

@IBAction func back(_ sender: UIButton) {
    var eventCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
    eventCon.modalPresentationStyle = .fullScreen
    self.present(eventCon, animated: false, completion:nil)
}
    
@IBAction func selectProfile(_ sender: UIButton) {
    
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
    
@IBAction func register(_ sender: UIButton) {
    if nameLbl.text != ""
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
   // str1 = ConvertImageToBase64String(img: image1)
    let date = Date()
    let formator = DateFormatter()
    formator.dateFormat = "HH:mm:ss"
    formator.locale = Locale.init(identifier: "en_US_POSIX")
    let strDate = formator.string(from: date)
    let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
    imgName = imagePath
    profileImg.image = image1
    self.dismiss(animated: false, completion: nil)
    
}

func ConvertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 0.75)?.base64EncodedString() ?? ""
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
    
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    
    let finalcat:String = IdArr.componentsJoined(by: ",")
    
    if artistArray.count != 0
    {
        do {
            string1 = try! json(from:artistArray as! [[String : Any]])
            print("111",string1)
        } catch { print(error) }
        
    }
    else
    {
        
    }
    

    
    Alamofire.request("https://stumbal.com/process.php?action=artist_register", method: .post, parameters: ["user_id":uID,"artist_image":imgName,"artist_image_string":str1,"name":nameLbl.text!,"category_id":finalcat,"sub_cat_id":"","other_user":string1], encoding:  URLEncoding.httpBody).responseJSON
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
                    let alert = UIAlertController(title: "", message: "You have successfully registered…", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 2
                    
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        alert.dismiss(animated: false, completion: nil)
                        
                        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        signuCon.modalPresentationStyle = .fullScreen
                        self.present(signuCon, animated: false, completion:nil)
                        
                        //  self.fecth_Profile()
                    }
                }
            }
        }
    }
    
}

//MARK: fetch_metatags ;

    func fetch_metatags()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
        
        
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
    //    let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
    //    cell.LeftAlignedCollectionViewFlowLayout()
    //    cell.categoryNameLbl.heightAnchor = 50
        
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "titleCell",
                                                            for: indexPath) as? RoundedCollectionViewCell else {
                                                                return RoundedCollectionViewCell()
        }
        
        
    //    cell.categoryNameLbl.layer.cornerRadius = 25;
    //    cell.categoryNameLbl.clipsToBounds = true
    //
        
        
        
        
    //    let n = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
    //
    //    //        let menuData=categoryArray[indexPath.row]
    //    //
    //    cell.categoryNameLbl.text = "    \(n)    "
    //
    //
    //    if arrSelectedIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
    //        cell.categoryNameLbl.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
    //    }
    //    else {
    //        cell.categoryNameLbl.backgroundColor = UIColor.darkGray
    //    }
        
        
        
        
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
            UserDefaults.standard.set(false, forKey: String(format: "Selected%d", indexPath.row))
         }
        
        
        
        
        
        cell.textLabel.text = n
      
         //cell.layoutSubviews()
         return cell
        
        
        
      //  cell.layoutSubviews()
        
        
        
        //return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //    print("You selected cell #\(indexPath.item)!")
    //
    //    let strData = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_id")as! String
    //
    //    if arrSelectedIndex.contains(indexPath) {
    //        arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
    //        arrSelectedData = arrSelectedData.filter { $0 != strData}
    //    }
    //    else {
    //        arrSelectedIndex.append(indexPath)
    //        arrSelectedData.append(strData)
    //    }
    //
    //    fetch_metatags()
    //
        
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
                    if IdArr.count != 0
                    {
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
                    else
                    {
                        
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
              let cell = artsitTbleView.dequeueReusableCell(withIdentifier: "SearchArtistTblCell", for: indexPath) as! SearchArtistTblCell
              
    
        
             
           
//            cell.profileImg?.sd_setImage(with: URL(string: (self.artistArray[indexPath.row] as AnyObject).value(forKey:"artist_img") as! String)) { (image, error, cache, urls) in
//                        if (error != nil) {
//                            cell.profileImg.image = UIImage(named: "adefault")
//                        } else {
//                            cell.profileImg.image = image
//                        }
//            }
            
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
    
    



