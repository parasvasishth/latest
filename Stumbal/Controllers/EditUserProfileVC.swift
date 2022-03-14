//
//  EditUserProfileVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 17/12/21.
//

import UIKit
import Alamofire
import Kingfisher

class EditUserProfileVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var clickView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var birthLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var peveryOneLbl: UILabel!
    @IBOutlet weak var pMyFriendLbl: UILabel!
    @IBOutlet weak var pOnlyMeLbl: UILabel!
    @IBOutlet weak var eEveryOneLbl: UILabel!
    @IBOutlet weak var efriendLbl: UILabel!
    @IBOutlet weak var eOnlyLbl: UILabel!
    @IBOutlet weak var gEveryOneLbl: UILabel!
    @IBOutlet weak var gmyfriendLbl: UILabel!
    @IBOutlet weak var gOnlyMeLbl: UILabel!
    @IBOutlet weak var uEveryOneLbl: UILabel!
    @IBOutlet weak var uFriendLbl: UILabel!
    @IBOutlet weak var uOnlyMelbl: UILabel!
    
    @IBOutlet weak var clickLbl: UILabel!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var genderFeild: UITextField!
    
    @IBOutlet weak var selectCatField: UITextField!
    @IBOutlet weak var categoryTblView: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var tbleViewHeight: NSLayoutConstraint!
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
    var catId:String = ""
    var IdArr = NSMutableArray()
    var imgName:String = ""
    var str1:String = ""
    var pickerOne : UIImagePickerController?
    var friendString:String = ""
    var eventString:String = ""
    var generString:String = ""
    var upcomingString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoadingView.isHidden = false
        
        thePicker2.isHidden = true
        thePicker2.delegate = self
        thePicker2.dataSource = self
        genderFeild.inputView = thePicker2
        genderFeild.delegate = self
        
       
       

        
        genderPickerData = ["Male","Female","Other"]
        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.layer.masksToBounds = false
        profileView.clipsToBounds = true
        
        categoryTblView.dataSource = self
        categoryTblView.delegate = self
        
        birthField.addInputViewDatePicker14(target: self, selector: #selector(doneButtonPressed))
        
        selectCatField.attributedPlaceholder = NSAttributedString(string: "Select", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        // Do any additional setup after loading the view.
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        peveryOneLbl.isUserInteractionEnabled = true
        peveryOneLbl.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
        pMyFriendLbl.isUserInteractionEnabled = true
        pMyFriendLbl.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        pOnlyMeLbl.isUserInteractionEnabled = true
        pOnlyMeLbl.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
        eEveryOneLbl.isUserInteractionEnabled = true
        eEveryOneLbl.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped4(tapGestureRecognizer:)))
        efriendLbl.isUserInteractionEnabled = true
        efriendLbl.addGestureRecognizer(tapGestureRecognizer4)
        
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(imageTapped5(tapGestureRecognizer:)))
        eOnlyLbl.isUserInteractionEnabled = true
        eOnlyLbl.addGestureRecognizer(tapGestureRecognizer5)
        
        
        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(imageTapped6(tapGestureRecognizer:)))
        gEveryOneLbl.isUserInteractionEnabled = true
        gEveryOneLbl.addGestureRecognizer(tapGestureRecognizer6)
        
        let tapGestureRecognizer7 = UITapGestureRecognizer(target: self, action: #selector(imageTapped7(tapGestureRecognizer:)))
        gmyfriendLbl.isUserInteractionEnabled = true
        gmyfriendLbl.addGestureRecognizer(tapGestureRecognizer7)
        
        let tapGestureRecognizer8 = UITapGestureRecognizer(target: self, action: #selector(imageTapped8(tapGestureRecognizer:)))
        gOnlyMeLbl.isUserInteractionEnabled = true
        gOnlyMeLbl.addGestureRecognizer(tapGestureRecognizer8)
        
        let tapGestureRecognizer9 = UITapGestureRecognizer(target: self, action: #selector(imageTapped9(tapGestureRecognizer:)))
        uEveryOneLbl.isUserInteractionEnabled = true
        uEveryOneLbl.addGestureRecognizer(tapGestureRecognizer9)
        
        let tapGestureRecognizer10 = UITapGestureRecognizer(target: self, action: #selector(imageTapped10(tapGestureRecognizer:)))
        uFriendLbl.isUserInteractionEnabled = true
        uFriendLbl.addGestureRecognizer(tapGestureRecognizer10)
        
        let tapGestureRecognizer11 = UITapGestureRecognizer(target: self, action: #selector(imageTapped11(tapGestureRecognizer:)))
        uOnlyMelbl.isUserInteractionEnabled = true
        uOnlyMelbl.addGestureRecognizer(tapGestureRecognizer11)
        
        let tapGestureRecognizer12 = UITapGestureRecognizer(target: self, action: #selector(imageTapped12(tapGestureRecognizer:)))
        clickView.isUserInteractionEnabled = true
        clickView.addGestureRecognizer(tapGestureRecognizer12)
        
        let tapGestureRecognizer13 = UITapGestureRecognizer(target: self, action: #selector(imageTapped13(tapGestureRecognizer:)))
        clickLbl.isUserInteractionEnabled = true
        clickLbl.addGestureRecognizer(tapGestureRecognizer13)
        
        let tapGestureRecognizer14 = UITapGestureRecognizer(target: self, action: #selector(imageTapped14(tapGestureRecognizer:)))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(tapGestureRecognizer14)
        
        thePicker.isHidden = true
        thePicker.delegate = self
        thePicker.dataSource = self
        selectCatField.inputView = thePicker
        selectCatField.delegate = self
        
        thePicker1.isHidden = true
        thePicker1.delegate = self
        thePicker1.dataSource = self
        genderFeild.inputView = thePicker1
        genderFeild.delegate = self
        
//        thePicker2.isHidden = true
//        thePicker2.delegate = self
//        thePicker2.dataSource = self
//        birthField.inputView = thePicker2
//        birthField.delegate = self
        
//        yds()
//        thePicker.selectRow(70, inComponent:0, animated:true)
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateStyle = DateFormatter.Style.long
//
//        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        // fetch_metatags()
       

        fecth_Profile()
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.birthField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
           // datePicker.maximumDate = Date()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            self.birthField.text = dateFormatter.string(from: datePicker.date)
        }
        self.birthField.resignFirstResponder()
    }
    
    func yds()
    {
        var formattedDate: String? = ""
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        formattedDate = format.string(from: date)

        var years:NSArray = NSArray()
        var yearsTillNow: NSArray {
            var years = [String]()
            for i in (Int(formattedDate!)!-50..<Int(formattedDate!)!+1).reversed() {
                years.append("\(i)")
            }
            return years as NSArray
        }
        birthArray = yearsTillNow
        birthArray.reverseObjectEnumerator()
        birthArray1 = birthArray.reversed() as NSArray
        
        print("456",birthArray1)
       
        print(yearsTillNow)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        friendString = "Everyone"
        self.peveryOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.peveryOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.pMyFriendLbl.backgroundColor = UIColor.black
        self.pMyFriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.pOnlyMeLbl.backgroundColor = UIColor.black
        self.pOnlyMeLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
        friendString = "Friend"
        self.pMyFriendLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.pMyFriendLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.peveryOneLbl.backgroundColor = UIColor.black
        self.peveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.pOnlyMeLbl.backgroundColor = UIColor.black
        self.pOnlyMeLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer){
        friendString = "Only Me"
        self.pOnlyMeLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.pOnlyMeLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.pMyFriendLbl.backgroundColor = UIColor.black
        self.pMyFriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.peveryOneLbl.backgroundColor = UIColor.black
        self.peveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer){
        eventString = "Everyone"
        self.eEveryOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.eEveryOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.efriendLbl.backgroundColor = UIColor.black
        self.efriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.eOnlyLbl.backgroundColor = UIColor.black
        self.eOnlyLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped4(tapGestureRecognizer: UITapGestureRecognizer){
        eventString = "Friend"
        self.efriendLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.efriendLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.eOnlyLbl.backgroundColor = UIColor.black
        self.eOnlyLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.eEveryOneLbl.backgroundColor = UIColor.black
        self.eEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped5(tapGestureRecognizer: UITapGestureRecognizer){
        eventString = "Only Me"
        self.eOnlyLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.eOnlyLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.efriendLbl.backgroundColor = UIColor.black
        self.efriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.eEveryOneLbl.backgroundColor = UIColor.black
        self.eEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped6(tapGestureRecognizer: UITapGestureRecognizer){
        generString = "Everyone"
        self.gEveryOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.gEveryOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.gmyfriendLbl.backgroundColor = UIColor.black
        self.gmyfriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.gOnlyMeLbl.backgroundColor = UIColor.black
        self.gOnlyMeLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped7(tapGestureRecognizer: UITapGestureRecognizer){
        generString = "Friend"
        self.gmyfriendLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.gmyfriendLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.gOnlyMeLbl.backgroundColor = UIColor.black
        self.gOnlyMeLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.gEveryOneLbl.backgroundColor = UIColor.black
        self.gEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped8(tapGestureRecognizer: UITapGestureRecognizer){
        generString = "Only Me"
        self.gOnlyMeLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.gOnlyMeLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.gmyfriendLbl.backgroundColor = UIColor.black
        self.gmyfriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.gEveryOneLbl.backgroundColor = UIColor.black
        self.gEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped9(tapGestureRecognizer: UITapGestureRecognizer){
        upcomingString = "Everyone"
        self.uEveryOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.uEveryOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.uOnlyMelbl.backgroundColor = UIColor.black
        self.uOnlyMelbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.uFriendLbl.backgroundColor = UIColor.black
        self.uFriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped10(tapGestureRecognizer: UITapGestureRecognizer){
        upcomingString = "Friend"
        self.uFriendLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.uFriendLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.uOnlyMelbl.backgroundColor = UIColor.black
        self.uOnlyMelbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.uEveryOneLbl.backgroundColor = UIColor.black
        self.uEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func imageTapped11(tapGestureRecognizer: UITapGestureRecognizer){
        upcomingString = "Only Me"
        self.uOnlyMelbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
        self.uOnlyMelbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
        
        self.uFriendLbl.backgroundColor = UIColor.black
        self.uFriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        self.uEveryOneLbl.backgroundColor = UIColor.black
        self.uEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
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
        
      //  let selectedImg=info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
      let selectedImg = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        //let image1 : UIImage = selectedImg.resize(400)
       // let imageData = image1.jpegData(compressionQuality: 0.75)
        
        
        //        str1 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
        //       // str1 = ConvertImageToBase64String(img: image1)
        //        let date = Date()
        //        let formator = DateFormatter()
        //        formator.dateFormat = "HH:mm:ss"
        //        formator.locale = Locale.init(identifier: "en_US_POSIX")
        //        let strDate = formator.string(from: date)
        //        let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
        //        imgName = imagePath
        profileImg.image = selectedImg
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
    
    // MARK: - Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        //    let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
        //    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        //    self.present(alert, animated: false, completion: nil)
        
        if firstnameField .text != ""
        {
            if lastnameField.text != ""
            {
                if emailField.text != ""
                {
                    if isValidEmail(emailField.text!)
                    {
                        update_user_profile()
                    }
                    else
                    {
                        let alert = UIAlertController(title: "", message: "Enter valid email", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                }
                else
                {
                    let alert = UIAlertController(title: "", message: "Enter email", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else
            {
                let alert = UIAlertController(title: "", message: "Enter last name", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Enter first name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //    for i in 0...artistArray.count-1
        //    {
        //        let id:String = (artistArray.object(at: i) as AnyObject).value(forKey: "cat_id")as! String
        //        IdArr.add(id)
        //    }
        //    print("111",IdArr)
        //    let finalcat:String = IdArr.componentsJoined(by: ",")
        //print("11111",finalcat)
    }
    @IBAction func deleteBtn(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        
        if artistArray.count != 0
        {
             servicenameArr.remove(at: tagVal)
            artistArray.removeObject(at: tagVal)
            categoryTblView.isHidden = false
            categoryTblView.reloadData()
            tbleViewHeight.constant = 180
        }
        else
        {
            categoryTblView.isHidden = true
            categoryTblView.reloadData()
            tbleViewHeight.constant = 0
            // UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
            
        }
    }
    
    var string1:String = ""
    //MARK: update_user_profile ;
    func update_user_profile()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        
      //  let finalcat:String = IdArr.componentsJoined(by: ",")
        
        if artistArray.count != 0
        {
            do {
                string1 = try! json(from:(artistArray as! NSMutableArray) as! [[String : Any]])
                print("111",string1)
            } catch { print(error) }
            
        }
        else
        {
            
        }
        
        //            $user_id = $_REQUEST['user_id'];
        //            $fname=$_REQUEST['fname'];
        //            $lname = $_REQUEST['lname'];
        //            $gender=$_REQUEST['gender'];
        //            $email=$_REQUEST['email'];
        //            $dob =$_REQUEST['dob'];
        //            $meta_tags=$_REQUEST['meta_tags'];
        //            $friend = $_REQUEST['friends'];
        //            $event_history = $_REQUEST['event_history'];
        //            $genres = $_REQUEST['genres'];
        //            $upcoming_event = $_REQUEST['upcoming_event'];
        //             $logo_image=$_REQUEST['profile_image'];
        //            $logo_string=$_REQUEST['profile_string'];
        let date = Date()
        let formator = DateFormatter()
        formator.dateFormat = "HH:mm:ss"
        formator.locale = Locale.init(identifier: "en_US_POSIX")
        let strDate = formator.string(from: date)
        imgName = "iOSImage_\(strDate)_\(drand48()).png"
        
        
        let imageData = self.profileImg.image?.jpegData(compressionQuality: 0.0)
        str1 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
        
        print("444",birthField.text!)
        Alamofire.request("https://stumbal.com/process.php?action=update_user_profile", method: .post, parameters: ["user_id":uID,"fname":firstnameField.text!,"lname":lastnameField.text!,"gender":genderFeild.text!,"email":emailField.text!,"dob":birthField.text!,"meta_tags":string1,"friends":friendString,"event_history":eventString,"genres":generString,"upcoming_event":upcomingString,"profile_image":imgName,"profile_string":str1], encoding:  URLEncoding.httpBody).responseJSON
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
                        let alert = UIAlertController(title: "", message: "You have successfully updated.", preferredStyle: .alert)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if textField == selectCatField
        {
            UserDefaults.standard.set(true, forKey: "pcate")
            UserDefaults.standard.set(false, forKey: "pgender")
            fetch_venues()
        }
        else if textField == genderFeild
        {
            UserDefaults.standard.set(false, forKey: "pcate")
            UserDefaults.standard.set(true, forKey: "pgender")
            self.thePicker1.isHidden = false
            self.thePicker1.reloadAllComponents()
        }
//        else if textField == birthField
//        {
//            UserDefaults.standard.set(false, forKey: "pcate")
//            UserDefaults.standard.set(false, forKey: "pgender")
//            self.thePicker2.isHidden = false
//            thePicker2.reloadAllComponents()
//
//        }
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == selectCatField {
//            // do what is needed
//        }
//    }
//
    // MARK: - fecth_Profile
    func fecth_Profile()
    {
        
        //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //hud.mode = MBProgressHUDMode.indeterminate
        //hud.self.bezelView.color = UIColor.black
        //hud.label.text = "Loading...."
        self.LoadingView.isHidden = false
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
                        
                        
                        self.firstnameField.text = json["fname"] as! String
                        self.lastnameField.text = json["lname"] as! String
                        self.emailField.text = json["email"] as! String
                        self.genderFeild.text = json["gender"] as! String
                        self.birthField.text = json["dob"] as! String
                           let name: NSArray = json["meta_tags"] as! NSArray
                        
                          self.artistArray = NSMutableArray(array:name)
                        self.servicenameArr = name as! [[String : String]]
                        if self.artistArray.count != 0
                        {
                           // self.tblHeight.constant = 180
                            self.tbleViewHeight.constant = 180
                            self.categoryTblView.isHidden = false
                            self.categoryTblView.reloadData()
                            
                        }
                        else
                        {
                            self.categoryTblView.isHidden = true
                            self.tbleViewHeight.constant = 0
                            //self.tblHeight.constant = 0
                        }
                        
                        //  self.artistArray = json["meta_tags"] as! NSArray as! NSMutableArray
                        
                        
                        if json["friends"] as! String == "Friend"
                        {
                            
                            self.pMyFriendLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.pMyFriendLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.peveryOneLbl.backgroundColor = UIColor.black
                            self.peveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.pOnlyMeLbl.backgroundColor = UIColor.black
                            self.pOnlyMeLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.friendString = "Friend"
                        }
                        else if json["friends"] as! String == "Only Me"
                        {
                            self.pOnlyMeLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.pOnlyMeLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.peveryOneLbl.backgroundColor = UIColor.black
                            self.peveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.pMyFriendLbl.backgroundColor = UIColor.black
                            self.pMyFriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.friendString = "Only Me"
                        }
                        else
                        {
                            self.peveryOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.peveryOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.pOnlyMeLbl.backgroundColor = UIColor.black
                            self.pOnlyMeLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.pMyFriendLbl.backgroundColor = UIColor.black
                            self.pMyFriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.friendString = "Everyone"
                        }
                        
                        
                        if json["event_history"] as! String == "Friend"
                        {
                            
                            self.efriendLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.efriendLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.eOnlyLbl.backgroundColor = UIColor.black
                            self.eOnlyLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.eEveryOneLbl.backgroundColor = UIColor.black
                            self.eEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.eventString = "Friend"
                        }
                        else if json["event_history"] as! String == "Only Me"
                        {
                            self.eOnlyLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.eOnlyLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.efriendLbl.backgroundColor = UIColor.black
                            self.efriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.eEveryOneLbl.backgroundColor = UIColor.black
                            self.eEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.eventString = "Only Me"
                        }
                        else
                        {
                            self.eEveryOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.eEveryOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.efriendLbl.backgroundColor = UIColor.black
                            self.efriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.eOnlyLbl.backgroundColor = UIColor.black
                            self.eOnlyLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.eventString = "Everyone"
                        }
                        
                        
                        if json["genres"] as! String == "Friend"
                        {
                            
                            self.gmyfriendLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.gmyfriendLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.gOnlyMeLbl.backgroundColor = UIColor.black
                            self.gOnlyMeLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.gEveryOneLbl.backgroundColor = UIColor.black
                            self.gEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.generString = "Friend"
                        }
                        else if json["genres"] as! String == "Only Me"
                        {
                            self.gOnlyMeLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.gOnlyMeLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.gmyfriendLbl.backgroundColor = UIColor.black
                            self.gmyfriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.gEveryOneLbl.backgroundColor = UIColor.black
                            self.gEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.generString = "Only Me"
                        }
                        else
                        {
                            self.gEveryOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.gEveryOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.gmyfriendLbl.backgroundColor = UIColor.black
                            self.gmyfriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.gOnlyMeLbl.backgroundColor = UIColor.black
                            self.gOnlyMeLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.generString = "Everyone"
                        }
                        
                        if json["upcoming_event"] as! String == "Friend"
                        {
                            
                            self.uFriendLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.uFriendLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.uOnlyMelbl.backgroundColor = UIColor.black
                            self.uOnlyMelbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.uEveryOneLbl.backgroundColor = UIColor.black
                            self.uEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.upcomingString = "Friend"
                        }
                        else if json["upcoming_event"] as! String == "Only Me"
                        {
                            self.uOnlyMelbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.uOnlyMelbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.uFriendLbl.backgroundColor = UIColor.black
                            self.uFriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.uEveryOneLbl.backgroundColor = UIColor.black
                            self.uEveryOneLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.upcomingString = "Only Me"
                        }
                        else
                        {
                            self.uEveryOneLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
                            self.uEveryOneLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
                            
                            self.uFriendLbl.backgroundColor = UIColor.black
                            self.uFriendLbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            
                            self.uOnlyMelbl.backgroundColor = UIColor.black
                            self.uOnlyMelbl.textColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
                            self.upcomingString = "Everyone"
                        }
                        
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
                        
                        self.LoadingView.isHidden = true
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        
                    }
                    else
                    {
                        self.LoadingView.isHidden = true
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
    }
    
    //MARK: fetch_events ;
    func fetch_events()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
        //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //    hud.mode = MBProgressHUDMode.indeterminate
        //    hud.self.bezelView.color = UIColor.black
        //    hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
        
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
                        self.categoryArray = NSArray()
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
                        
                    }
                    catch
                    {
                        print("error")
                    }
                    
                }
                
                
            }
        }
        
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
                        self.categoryArray = NSArray()
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
                        
                    }
                    catch
                    {
                        print("error")
                    }
                    
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
        let cell = categoryTblView.dequeueReusableCell(withIdentifier: "UserCategoryTableViewCell", for: indexPath) as! UserCategoryTableViewCell
        
        cell.catNamelbl.text! = (artistArray.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
        
        
        cell.deleteObj.tag = indexPath.row
        return cell
    }
    
    // MARK: - Picker Method
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int
    
    {
       
        if UserDefaults.standard.bool(forKey: "pcate") == true
        {
            return catPickerData1.count
        }
        else if UserDefaults.standard.bool(forKey: "pgender") == true
        {
            return genderPickerData.count
        }
        else
        {
            return birthArray1.count
        }
       
        
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if UserDefaults.standard.bool(forKey: "pcate") == true
        {
            return catPickerData1[row]
        }
        else if UserDefaults.standard.bool(forKey: "pgender") == true
        {
            return genderPickerData[row]
        }
        else
        {
            return birthArray1[row] as! String
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // selectCatField.text = catPickerData1[row]
        
        if UserDefaults.standard.bool(forKey: "pcate") == true
        {
            catId = catPickerData2[row]
            self.dict.setValue(catPickerData1[row],forKey:"name")
            self.dict.setValue(catPickerData2[row],forKey:"cat_id")
            
            otherArtistArray.append(catPickerData2[row])
            self.servicenameArr.append(self.dict as! [String : String])
           
            
            selectCatField.attributedPlaceholder = NSAttributedString(string: "Select", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
               artistArray = NSMutableArray(array:servicenameArr)
            print("111",artistArray)
            print("1451",servicenameArr)
            categoryTblView.reloadData()
            categoryTblView.isHidden = false
            tbleViewHeight.constant = 180
        //    tblHeight.constant = 180
            UserDefaults.standard.setValue(servicenameArr, forKey: "userarray")
          
        }
        else if UserDefaults.standard.bool(forKey: "pgender") == true
        {
            genderFeild.text = genderPickerData[row]
        }
        else
        {
            birthField.text = birthArray1[row] as! String
        }
        
     

    }
    
//    func donePicker() {
//
//        selectCatField.resignFirstResponder()
//
//    }
    
}
extension UITextField {
    
    @objc func addInputViewDatePicker14(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.setDate(Date(), animated: false)
     //  Calendar.current.dateComponents([.day], from:"25/11/2019", to: "15/09/2025")
      //  datePicker.minimumDate = startDate?.addingTimeInterval(60 * 60 * 24 * 90) //  90 days interval offset
       
        
      //  datePicker.minimumDate = Date() // this to set the start date today
        //this to set the date range you can change " byAdding: .year " to "byAdding: .month" if you went the range by month or to "byAdding: .day"
        let nextDays = Calendar.current.date(byAdding: .year, value: 14, to: Date())
        datePicker.maximumDate = Date()
        //nextDays ?? Date() // this to set the maximum date
        self.inputView = datePicker
        
       
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    
    @objc func addInputViewDatePicker15(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.setDate(Date(), animated: false)
     //  Calendar.current.dateComponents([.day], from:"25/11/2019", to: "15/09/2025")
      //  datePicker.minimumDate = startDate?.addingTimeInterval(60 * 60 * 24 * 90) //  90 days interval offset
       
        
      //  datePicker.minimumDate = Date() // this to set the start date today
        //this to set the date range you can change " byAdding: .year " to "byAdding: .month" if you went the range by month or to "byAdding: .day"
        let nextDays = Calendar.current.date(byAdding: .year, value: 14, to: Date())
        datePicker.minimumDate = Date()
        //nextDays ?? Date() // this to set the maximum date
        self.inputView = datePicker
        
       
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
}
