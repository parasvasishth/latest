//
//  NewArtistRegisteredVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 23/12/21.
//

import UIKit
import Alamofire
import Kingfisher
class NewArtistRegisteredVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UISearchBarDelegate,UITextViewDelegate {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var clickView: UIView!
    @IBOutlet weak var artistNameField: UITextField!
    @IBOutlet weak var clickLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var catTblView: UITableView!
    @IBOutlet weak var catTblHeight: NSLayoutConstraint!
    @IBOutlet weak var artistTblView: UITableView!
    @IBOutlet weak var artistListTblView: UITableView!
    @IBOutlet weak var artistTblHeight: NSLayoutConstraint!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var artistTblListHeight: NSLayoutConstraint!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var spotiImg: UIImageView!
    @IBOutlet weak var spotiyLbl: UILabel!
    @IBOutlet weak var instaImg: UIImageView!
    @IBOutlet weak var instaLbl: UILabel!
    @IBOutlet weak var twiImg: UIImageView!
    @IBOutlet weak var twiLbl: UILabel!
    @IBOutlet weak var pentaImg: UIImageView!
    @IBOutlet weak var pentalbl: UILabel!
    @IBOutlet weak var cloudImg: UIImageView!
    @IBOutlet weak var cloudLbl: UILabel!
    var categoryArray:NSArray = NSArray()
    var catPickerData1 = [String]()
    var catPickerData2 = [String]()
    var myPicker2Data2 = [String]()
    let thePicker = UIPickerView()
    let thePicker1 = UIPickerView()
    let thePicker2 = UIPickerView()
    var genderPickerData = [String]()
    var birthArray:NSArray = NSArray()
    var birthArray1:NSArray = NSArray()
    var hud = MBProgressHUD()
    var otherArtistArray:[String] = []
    var dict:NSMutableDictionary = NSMutableDictionary()
    var servicenameArr = [[String: String]]()
    var artistArray:NSMutableArray = NSMutableArray()
    var artistlistArray:NSMutableArray = NSMutableArray()
    var catId:String = ""
    var imgName:String = ""
    var str1:String = ""
    var pickerOne : UIImagePickerController?
    var string1:String = ""
    var servicenameArr1 = [[String: String]]()
    var maxLen:Int = 100;
    var spotiString:String = ""
    var instaString:String = ""
    var cloudString:String = ""
    var twitterString:String = ""
    var bandString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = false
        UserDefaults.standard.set(false, forKey: "addother")
        UserDefaults.standard.set(false, forKey: "searchother")
        
        linkTextView.placeholder = "Enter link"
//        linkTextView.textColor = UIColor.white
      linkTextView.delegate = self
        
        categoryField.setLeftPaddingPoints(10)
        artistNameField.setLeftPaddingPoints(10)
        
        bioTxtView.delegate = self
        catTblHeight.constant = 0
        artistTblHeight.constant = 0
        artistTblListHeight.constant = 0
        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.layer.masksToBounds = false
        profileView.clipsToBounds = true
        
        catTblView.dataSource = self
        catTblView.delegate = self
        
        artistTblView.dataSource = self
        artistTblView.delegate = self
        
        artistListTblView.dataSource = self
        artistListTblView.delegate = self
        countLbl.text = "0/100"
        categoryField.attributedPlaceholder = NSAttributedString(string: "Select", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        thePicker.isHidden = true
        thePicker.delegate = self
        thePicker.dataSource = self
        categoryField.inputView = thePicker
        categoryField.delegate = self
        
        let tapGestureRecognizer13 = UITapGestureRecognizer(target: self, action: #selector(imageTapped13(tapGestureRecognizer:)))
        clickLbl.isUserInteractionEnabled = true
        clickLbl.addGestureRecognizer(tapGestureRecognizer13)
        
        let tapGestureRecognizer14 = UITapGestureRecognizer(target: self, action: #selector(imageTapped14(tapGestureRecognizer:)))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(tapGestureRecognizer14)
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftViewMode = .never
        searchBar.delegate = self
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
           } else {
               // Fallback on earlier versions
           }
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {

            //textfield.backgroundColor = UIColor.yellow
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            textfield.setLeftPaddingPoints(5)
            textfield.clearButtonMode = .never
           // textfield.textColor = UIColor.green

    //        if let leftView = textfield.leftView as? UIImageView {
    //            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
    //            leftView.tintColor = UIColor.red
    //        }
        }
       
        spotiImg.image = UIImage(named: "gspotify")
        instaImg.image = UIImage(named: "ginsta")
        twiImg.image = UIImage(named: "twitterg")
        pentaImg.image = UIImage(named: "pentag")
        cloudImg.image = UIImage(named: "cloudg")
        
        self.loadingView.isHidden = false
        
        
        // Do any additional setup after loading the view.
    }
    
   
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//
//    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//         if linkTextView.text == "Enter link" {
//            linkTextView.text = ""
//            linkTextView.textColor = UIColor.white
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if linkTextView.text == "" {
//            linkTextView.text = "Enter link"
//            linkTextView.textColor = UIColor.white
//        }
//    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       if textView == bioTxtView
        {
//           let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//           let numberOfChars = newText.count
//           countLbl.text = String(numberOfChars) + "/100"
//           return numberOfChars < 100
           
           let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            if numberOfChars > 100
            {
                return self.textLimit(existingText: textView.text,
                                          newText: text,
                                          limit: 100)
            }
            else
            {
                countLbl.text = String(numberOfChars) + "/100"
     //           return numberOfChars < 101    // 10 Limit Value
                
                return self.textLimit(existingText: textView.text,
                                          newText: text,
                                          limit: 100)
            }
           // 10 Limit Value
       }
//        else if textView == linkTextView
//        {
//            if text == "\n" {
//                linkTextView.resignFirstResponder()
//            }
//            
//        }
        return true
    }
    
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if textField == categoryField
        {
           
            fetch_venues()
        }
      
     
    }
    
    @IBAction func popupCancel(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "spoti") == true
        {
            spotiString = linkTextView.text!
            linkTextView.text = ""
            hideView.isHidden = true
            linkView.isHidden = true
            
            if spotiString != ""
            {
                spotiImg.image = UIImage(named: "spotifyp")
                spotiyLbl.textColor = UIColor.white
            }
            else
            {
                spotiyLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                spotiImg.image = UIImage(named: "gspotify")
            }
            
            
        }
        else if UserDefaults.standard.bool(forKey: "insta") == true
        {
            instaString = linkTextView.text!
            linkTextView.text = ""
            hideView.isHidden = true
            linkView.isHidden = true
            
            if instaString != ""
            {
                instaImg.image = UIImage(named: "pinsta")
                instaLbl.textColor = UIColor.white
            }
            else
            {
                instaLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                instaImg.image = UIImage(named: "ginsta")
            }
        }
        else if UserDefaults.standard.bool(forKey: "twitter") == true
        {
            twitterString = linkTextView.text!
            linkTextView.text = ""
            hideView.isHidden = true
            linkView.isHidden = true
            if twitterString != ""
            {
                twiImg.image = UIImage(named: "twitterp")
                twiLbl.textColor = UIColor.white
            }
            else
            {
                twiLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                twiImg.image = UIImage(named: "twitterg")
            }
        }
        else if UserDefaults.standard.bool(forKey: "band") == true
        {
            bandString = linkTextView.text!
            linkTextView.text = ""
            hideView.isHidden = true
            linkView.isHidden = true
            if bandString != ""
            {
                pentaImg.image = UIImage(named: "pentap")
                pentalbl.textColor = UIColor.white
            }
            else
            {
                pentalbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                pentaImg.image = UIImage(named: "pentag")
            }
        }
        else
        {
            cloudString = linkTextView.text!
            linkTextView.text = ""
            hideView.isHidden = true
            linkView.isHidden = true
            if cloudString != ""
            {
                cloudImg.image = UIImage(named: "cloudp")
                cloudLbl.textColor = UIColor.white
            }
            else
            {
                cloudLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                cloudImg.image = UIImage(named: "cloudg")
            }
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if linkTextView.text != ""
        {
            if UserDefaults.standard.bool(forKey: "spoti") == true
            {
                spotiString = linkTextView.text!
                linkTextView.text = ""
                hideView.isHidden = true
                linkView.isHidden = true
                
                if spotiString != ""
                {
                    spotiImg.image = UIImage(named: "spotifyp")
                    spotiyLbl.textColor = UIColor.white
                }
                else
                {
                    spotiyLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                    spotiImg.image = UIImage(named: "gspotify")
                }
                
                
            }
            else if UserDefaults.standard.bool(forKey: "insta") == true
            {
                instaString = linkTextView.text!
                linkTextView.text = ""
                hideView.isHidden = true
                linkView.isHidden = true
                
                if instaString != ""
                {
                    instaImg.image = UIImage(named: "pinsta")
                    instaLbl.textColor = UIColor.white
                }
                else
                {
                    instaLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                    instaImg.image = UIImage(named: "ginsta")
                }
            }
            else if UserDefaults.standard.bool(forKey: "twitter") == true
            {
                twitterString = linkTextView.text!
                linkTextView.text = ""
                hideView.isHidden = true
                linkView.isHidden = true
                if twitterString != ""
                {
                    twiImg.image = UIImage(named: "twitterp")
                    twiLbl.textColor = UIColor.white
                }
                else
                {
                    twiLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                    twiImg.image = UIImage(named: "twitterg")
                }
            }
            else if UserDefaults.standard.bool(forKey: "band") == true
            {
                bandString = linkTextView.text!
                linkTextView.text = ""
                hideView.isHidden = true
                linkView.isHidden = true
                if bandString != ""
                {
                    pentaImg.image = UIImage(named: "pentap")
                    pentalbl.textColor = UIColor.white
                }
                else
                {
                    pentalbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                    pentaImg.image = UIImage(named: "pentag")
                }
            }
            else
            {
                cloudString = linkTextView.text!
                linkTextView.text = ""
                hideView.isHidden = true
                linkView.isHidden = true
                if cloudString != ""
                {
                    cloudImg.image = UIImage(named: "cloudp")
                    cloudLbl.textColor = UIColor.white
                }
                else
                {
                    cloudLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2392156863, blue: 0.2352941176, alpha: 1)
                    cloudImg.image = UIImage(named: "cloudg")
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter Link", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func twitter(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "twitter")
        UserDefaults.standard.set(false, forKey: "spoti")
        UserDefaults.standard.set(false, forKey: "insta")
        UserDefaults.standard.set(false, forKey: "band")
        UserDefaults.standard.set(false, forKey: "cloud")
        hideView.isHidden = false
        linkView.isHidden = false
        linkTextView.text = twitterString
    }
    
    @IBAction func instagram(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "twitter")
        UserDefaults.standard.set(false, forKey: "spoti")
        UserDefaults.standard.set(true, forKey: "insta")
        UserDefaults.standard.set(false, forKey: "band")
        UserDefaults.standard.set(false, forKey: "cloud")
        hideView.isHidden = false
        linkView.isHidden = false
        linkTextView.text = instaString
    }
    
    @IBAction func spotify(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "twitter")
        UserDefaults.standard.set(true, forKey: "spoti")
        UserDefaults.standard.set(false, forKey: "insta")
        UserDefaults.standard.set(false, forKey: "band")
        UserDefaults.standard.set(false, forKey: "cloud")
        hideView.isHidden = false
        linkView.isHidden = false
        linkTextView.text = spotiString
    }
    @IBAction func band(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "twitter")
        UserDefaults.standard.set(false, forKey: "spoti")
        UserDefaults.standard.set(false, forKey: "insta")
        UserDefaults.standard.set(true, forKey: "band")
        UserDefaults.standard.set(false, forKey: "cloud")
        hideView.isHidden = false
        linkView.isHidden = false
        linkTextView.text = bandString
    }
    
    @IBAction func cloud(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "twitter")
        UserDefaults.standard.set(false, forKey: "spoti")
        UserDefaults.standard.set(false, forKey: "insta")
        UserDefaults.standard.set(false, forKey: "band")
        UserDefaults.standard.set(true, forKey: "cloud")
        hideView.isHidden = false
        linkView.isHidden = false
        linkTextView.text = cloudString
    }
    @IBAction func deleteUser(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        if artistlistArray.count != 0
        {
            servicenameArr1.remove(at: tagVal)
            artistlistArray.removeObject(at: tagVal)
//            self.artistListTblView.isHidden = false
//            self.artistTblListHeight.constant = 185
            
            if artistlistArray.count != 0
            {
                self.artistTblHeight.constant = 185
                self.artistTblView.isHidden = false
                 artistTblView.reloadData()
            }
            else
            {
                self.artistTblHeight.constant = 0
                self.artistTblView.isHidden = true
                 artistTblView.reloadData()
            }
            
          
        }
        else
        {
           
            self.artistTblHeight.constant = 0
            artistTblView.isHidden = true
          //  self.artistTblListHeight.constant = 0
          //  self.artistListTblView.isHidden = true
            artistTblView.reloadData()
        }
    }
    @IBAction func addArtist(_ sender: UIButton) {
        
        
        
        UserDefaults.standard.set(true, forKey: "addother")
        UserDefaults.standard.set(false, forKey: "searchother")
        let tagVal : Int = sender.tag
        let n  = (self.searchArray.object(at: tagVal) as AnyObject).value(forKey: "name")as! String
      
        let img = (self.searchArray.object(at: tagVal) as AnyObject).value(forKey: "artist_img")as! String
        
        self.dict.setValue(n, forKey: "name")
     
        self.dict.setValue(img, forKey: "artist_img")
        
        searchBar.text = ""
      
        self.servicenameArr1.append(self.dict as! [String : String])
        artistlistArray = NSMutableArray(array:servicenameArr1)
        print("1111",artistlistArray)
       // servicenameArr = [[String: String]]()
     //   searchArray = NSMutableArray()
        artistTblView.isHidden = false
        self.artistTblHeight.constant = 185
      //  artistListTblView.isHidden = false
       // self.artistTblListHeight.constant = 185
      //  artistListTblView.reloadData()
        artistTblView.reloadData()
//        self.dict.setValue(catPickerData1[row],forKey:"name")
//        self.dict.setValue(catPickerData2[row],forKey:"cat_id")
//
//        otherArtistArray.append(catPickerData2[row])
//        self.servicenameArr.append(self.dict as! [String : String])
//
//
//        selectCatField.attributedPlaceholder = NSAttributedString(string: "Select", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//           artistArray = NSMutableArray(array:servicenameArr)
//        print("111",artistArray)
//        print("1451",servicenameArr)
    }
    
    @IBAction func deleteArtist(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        if artistlistArray.count != 0
        {
            servicenameArr1.remove(at: tagVal)
            artistlistArray.removeObject(at: tagVal)
            self.artistListTblView.isHidden = false
            self.artistTblListHeight.constant = 185
            self.artistTblHeight.constant = 0
            self.artistTblView.isHidden = true
             artistListTblView.reloadData()
        }
        else
        {
            artistTblView.isHidden = true
            self.artistTblHeight.constant = 0
            self.artistTblListHeight.constant = 0
            self.artistListTblView.isHidden = true
            artistTblView.reloadData()
        }
    }
    
    @IBAction func deleteCat(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        
        if artistArray.count != 0
        {
             servicenameArr.remove(at: tagVal)
            artistArray.removeObject(at: tagVal)
            catTblView.isHidden = false
            catTblView.reloadData()
            catTblHeight.constant = 180
        }
        else
        {
            catTblView.isHidden = true
            catTblView.reloadData()
            catTblHeight.constant = 0
            // UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
            
        }
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        artist_register()
    }
    
    func fetch_venues()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        //  let id = UserDefaults.standard.value(forKey: "uid") as! String
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_metatags", method: .post
                          , parameters: nil, encoding:  URLEncoding.httpBody).responseJSON
        { response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                print("22222222222222")
                
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.fetch_venues()
                    }))
                    self.present(alert, animated: false, completion: nil)
                }
                else
                {
                    do  {
                        self.categoryArray = NSMutableArray()
                        self.categoryArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        print("5566262")
                        print(self.categoryArray)
                        
                        
                        var jsonElement = NSDictionary()
                        
                        self.catPickerData1 = [String]()
                        self.catPickerData2 = [String]()
                        
                        if self.categoryArray.count>0
                        {
                            
                            self.myPicker2Data2 = NSMutableArray() as! [String]
                            //    print(jsonResult)
                            for i in 0...self.categoryArray.count-1
                            {
                                print("55556622144")
                                // print(jsonResult)
                                jsonElement = self.categoryArray[i] as! NSDictionary
                                
                                print(jsonElement)
                                let n = jsonElement["category_name"] as! String
                                let m = jsonElement["category_id"] as! String
                                
                                self.catPickerData1.append(n)
                                self.catPickerData2.append(m)
                                DispatchQueue.main.async(execute: {
                                    
                                    self.thePicker.isHidden = false
                                    self.thePicker.reloadAllComponents()
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                })
                                
                            }
                            
                        }
                        
                        else
                        {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        if self.categoryArray.count != 0 {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            
                            
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
    var otherartistString:String = ""
    var categoryString:String = ""
    //MARK: artist_register ;
    func artist_register()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        
      
        
        if artistlistArray.count != 0
        {
            do {
                otherartistString = try! json(from:artistlistArray as! [[String : Any]])
                print("111",otherartistString)
            } catch { print(error) }
            
        }
        else
        {
            
        }
        
        
        if artistArray.count != 0
        {
            do {
                categoryString = try! json(from:(artistArray as! NSMutableArray) as! [[String : Any]])
                print("111",categoryString)
            } catch { print(error) }
            
        }
        else
        {
            
        }
        
        Alamofire.request("https://stumbal.com/process.php?action=artist_register", method: .post, parameters: ["user_id":uID,"artist_image":imgName,"artist_image_string":str1,"name":artistNameField.text!,"category_id":categoryString,"other_user":otherartistString,"bio":bioTxtView.text!,"spotify":spotiString,"instagram":instaString,"twitter":twitterString,"band_camp":bandString,"sound_cloud":cloudString], encoding:  URLEncoding.httpBody).responseJSON
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
                        
                        UserDefaults.standard.set(true, forKey: "ArtistLogin")
                        let alert = UIAlertController(title: "", message: "You have successfully registered…", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        
                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 2
                        
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            alert.dismiss(animated: false, completion: nil)
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        //    nextViewController.tabBarController?.selectedIndex = 3
                            nextViewController.modalPresentationStyle = .fullScreen
                            self.present(nextViewController, animated:false, completion:nil)
                            
                            //  self.fecth_Profile()
                        }
                    }
                }
            }
        }
        
    }

    
    @objc func imageTapped12(tapGestureRecognizer: UITapGestureRecognizer){
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImg=info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let image1 : UIImage = selectedImg.resize(400)
        let imageData = image1.jpegData(compressionQuality: 0.75)
       // str1 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
         str1 = ConvertImageToBase64String(img: image1)
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
    
    
    @objc func imageTapped13(tapGestureRecognizer: UITapGestureRecognizer){
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
    
    @objc func imageTapped14(tapGestureRecognizer: UITapGestureRecognizer){
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
    
    //MARK:  TableView Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == catTblView
        {
            return artistArray.count
        }
        else
        {
            if UserDefaults.standard.bool(forKey: "searchother") == true
            {
                return searchArray.count
            }
            else
            {
               return artistlistArray.count
            }
            
          
        }
//        else
//        {
//            return artistlistArray.count
//        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == catTblView
        {
            let cell = catTblView.dequeueReusableCell(withIdentifier: "UserCategoryTableViewCell", for: indexPath) as! UserCategoryTableViewCell
            print("1111",artistArray)
            cell.catNamelbl.text = (artistArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
            
            
            cell.deleteObj.tag = indexPath.row
            return cell
        }
        else
        {
            if UserDefaults.standard.bool(forKey: "searchother") == true
            {
                let cell = artistTblView.dequeueReusableCell(withIdentifier: "UserCategoryTableViewCell", for: indexPath) as! UserCategoryTableViewCell
                
                let eimg:String = (self.searchArray.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
                
                cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
                cell.profileView.layer.masksToBounds = false
                cell.profileView.clipsToBounds = true
                
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
                
                cell.catNamelbl.text! = (searchArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
                cell.deleteArtistObj.isHidden = true
                cell.addArtistObj.isHidden = false
            
              //  cell.deleteArtistObj.tag = indexPath.row
                cell.addArtistObj.tag = indexPath.row
                cell.deleteArtistObj.tag = indexPath.row
                
                //
                return cell
            }
            else
            {
                let cell = artistTblView.dequeueReusableCell(withIdentifier: "UserCategoryTableViewCell", for: indexPath) as! UserCategoryTableViewCell
                
                let eimg:String = (self.artistlistArray.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
                
                cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
                cell.profileView.layer.masksToBounds = false
                cell.profileView.clipsToBounds = true
                
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
                
                cell.catNamelbl.text! = (artistlistArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
                cell.deleteArtistObj.isHidden = false
                cell.addArtistObj.isHidden = true
                
              //  cell.deleteArtistObj.tag = indexPath.row
                cell.addArtistObj.tag = indexPath.row
                cell.deleteArtistObj.tag = indexPath.row
                //
                return cell
            }
            
            
          
        }
        
    }
    
    // MARK: - Picker Method
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int
    {
     return catPickerData1.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return catPickerData1[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // selectCatField.text = catPickerData1[row]

            catId = catPickerData2[row]
            self.dict.setValue(catPickerData1[row],forKey:"name")
            self.dict.setValue(catPickerData2[row],forKey:"cat_id")
            
            otherArtistArray.append(catPickerData2[row])
            self.servicenameArr.append(self.dict as! [String : String])
           
            
            categoryField.attributedPlaceholder = NSAttributedString(string: "Select", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
               artistArray = NSMutableArray(array:servicenameArr)
            print("111",artistArray)
            print("1451",servicenameArr)
            catTblView.reloadData()
            catTblView.isHidden = false
            catTblHeight.constant = 180
        //    tblHeight.constant = 180
            UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
   
    }
    
    var pastArray:NSMutableArray = NSMutableArray()
    var searchArray:NSMutableArray = NSMutableArray()
    // MARK: - fetch_app_user
    func fetch_app_user()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        self.pastArray = NSMutableArray()
        
        let u_id = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_app_user", method: .post, parameters:["search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_app_user()
                    }))
                    self.present(alert, animated: false, completion: nil)
                }
                else
                {
                    self.pastArray = NSMutableArray()
                    do  {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.pastArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        self.searchArray = NSMutableArray()
                        if self.pastArray.count != 0
                        {
                            
                            for i in 0...self.pastArray.count-1
                            {
                                if (self.pastArray.object(at: i) as AnyObject).value(forKey: "user_name") is NSNull {
                                } else {
                                    print((self.pastArray.object(at:i) as AnyObject).value(forKey: "user_name"),i)
                                    self.searchArray.add(self.pastArray[i])
                                }
                            }
                            if self.searchArray.count != 0 {
                                UserDefaults.standard.set(false, forKey: "addother")
                                UserDefaults.standard.set(true, forKey: "searchother")
                                
                                self.artistTblView.isHidden = false
                                self.artistListTblView.isHidden = true
                             
                                self.artistTblHeight.constant = 185
                                self.artistTblListHeight.constant = 0
                          
                                self.artistTblView.reloadData()
                            
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            else  {
                               
                                if self.searchBar.text != ""
                                {
                                    UserDefaults.standard.set(false, forKey: "addother")
                                    UserDefaults.standard.set(true, forKey: "searchother")
                                    
                                }
                                else
                                {
                                    if self.artistlistArray.count != 0
                                    {
                                        UserDefaults.standard.set(true, forKey: "addother")
                                        UserDefaults.standard.set(false, forKey: "searchother")
                                        self.artistTblView.isHidden = false
                                        self.artistTblHeight.constant = 185
                                        self.artistTblView.reloadData()
                                    }
                                    else
                                    {
                                        UserDefaults.standard.set(false, forKey: "addother")
                                        UserDefaults.standard.set(true, forKey: "searchother")
                                        self.artistTblView.isHidden = true
                                        self.artistTblHeight.constant = 0
                                        self.artistTblView.reloadData()
                                    }
                                    
                                   
                                }
                                
                              //  UserDefaults.standard.set(true, forKey: "addother")
                              //  UserDefaults.standard.set(false, forKey: "searchother")
//
                               
//                                    self.artistListTblView.isHidden = true
//                                    self.artistTblHeight.constant = 0
//                                    self.artistTblListHeight.constant = 0
                      
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        }
                        else
                        {

                                self.artistTblView.isHidden = true
                                self.artistListTblView.isHidden = true
                                self.artistTblHeight.constant = 0
                                self.artistTblListHeight.constant = 0
                     
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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != ""
        {
            fetch_app_user()
            
            
        }
        else
        {
            if self.artistlistArray.count != 0
                                           {
                                              // self.artistListTblView.isHidden = false
                                              // self.artistTblListHeight.constant = 185
                                                self.artistTblHeight.constant = 185
                                               self.artistTblView.isHidden = false
                                           }
                                           else
                                           {
                                             
                                               self.artistTblHeight.constant = 0
                                               self.artistTblListHeight.constant = 0
                                               self.artistTblView.isHidden = true
                                               self.artistListTblView.isHidden = true
                                               self.artistTblView.reloadData()
                                   }
            
        }
       
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        //backObj.isHidden = false
    }

 

}

