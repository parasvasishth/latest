//
//  NewSendProposalVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 19/01/22.
//

import UIKit
import Alamofire
import AVFoundation
class NewSendProposalVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var venueField: UITextField!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var descriptionFeild: UITextField!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoImg: UIImageView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeFeild: UITextField!
    @IBOutlet weak var toppriceHeight: NSLayoutConstraint!
    @IBOutlet weak var videoCancelobj: UIButton!
    @IBOutlet weak var ph: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIView!
    var categoryArray:NSArray = NSArray()
    let thePicker = UIPickerView()
    var catPickerData1 = [String]()
    var catPickerData2 = [String]()
    var hud = MBProgressHUD()
    var vendor_ID:String = ""

    var myPicker2Data2 = [String]()
    let imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var datefinal:String = ""
    @IBOutlet weak var videoobj: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false

        thePicker.isHidden = true
        thePicker.delegate = self
        thePicker.dataSource = self
        venueField.inputView = thePicker
        venueField.delegate = self
        
        venueField.delegate = self
        dateField.delegate = self
        timeFeild.delegate = self

        venueField.attributedPlaceholder =
            NSAttributedString(string: "Select a venue", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    eventNameField.attributedPlaceholder =
        NSAttributedString(string: "Event Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
    descriptionFeild.attributedPlaceholder =
        NSAttributedString(string: "Event Desciption", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
    priceField.attributedPlaceholder =
        NSAttributedString(string: "Ticket Price", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        dateField.attributedPlaceholder =
            NSAttributedString(string: "Proposed Date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        timeFeild.attributedPlaceholder =
            NSAttributedString(string: "Proposed Time", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
       // 1C1C1C
        venueField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        eventNameField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        descriptionFeild.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        priceField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        dateField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        timeFeild.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
    
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        videoImg.isUserInteractionEnabled = true
//        videoImg.addGestureRecognizer(tapGestureRecognizer)
        
    venueField.setLeftPaddingPoints(10)
    eventNameField.setLeftPaddingPoints(10)
    descriptionFeild.setLeftPaddingPoints(10)
    priceField.setLeftPaddingPoints(10)
        dateField.setLeftPaddingPoints(10)
        timeFeild.setLeftPaddingPoints(10)
        
        self.loadingView.isHidden = true

        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func done1ButtonPressed() {
        if let  datePicker = self.timeFeild.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            self.timeFeild.text = dateFormatter.string(from: datePicker.date)
        }
        self.timeFeild.resignFirstResponder()
    }

    @objc func doneButtonPressed1() {
        if let  datePicker = self.dateField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.dateField.text = dateFormatter.string(from: datePicker.date)
        }
        self.dateField.resignFirstResponder()
    }

    func previewImageFromVideo(url:NSURL) -> UIImage? {
        let asset = AVAsset(url:url as URL)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value,2)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        print("144",videoURL!)
        print("videoURL:\(String(describing: videoURL))")
        
       // self.dismiss(animated: true, completion: nil)
        
        videoImg.image = previewImageFromVideo(url: videoURL! as NSURL)!
        videoImg.contentMode = .scaleToFill
        videoView.isHidden = true
        videoImg.isHidden = false
        videoCancelobj.isHidden = false
//        ph.constant = 60
//        self.addVideoView.isHidden = true
//        self.removeObj.isHidden = false
//        self.videoImg.isHidden = false
//        self.videoView.isHidden = false
//        UserDefaults.standard.set(true, forKey: "VideoSelect")
        
        imagePickerController.dismiss(animated: true, completion: nil)
        
        //  videoStack.isHidden = false
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == venueField
        {
           fetch_venues()
           
            
        }
        else if textField == dateField
        {
            dateField.addInputViewDatePicker3(target: self, selector: #selector(doneButtonPressed1))
        }
        else if textField == timeFeild
        {
            timeFeild.addInputViewDatePicker7(target: self, selector: #selector(done1ButtonPressed))
            
        }
        else
        {
            
        }
        
    }
    
    
    
    @IBAction func cancelobj(_ sender: UIButton) {
        
    }
    
    @IBAction func videoSelect(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func videoCancel(_ sender: UIButton) {
        str = ""
        videoURL = nil
        videoImg.isHidden = true
        videoCancelobj.isHidden = true
        videoView.isHidden = false
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func sendProposal(_ sender: UIButton) {
        if venueField.text != ""
        {
            if eventNameField.text != ""
            {
                if descriptionFeild.text != ""
                {
                    if videoURL != nil
                    {
                        let fs:Int = Int(fileSize(forURL: videoURL!))
                        if fs < 20
                        {
                            uploadWithAlamofire()
                        }
                        else
                        {
                            let alert = UIAlertController(title: "", message: "Upload video size must be below 20 mb", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: false, completion: nil)
                        }
                        
                    }
                    else
                    {
                       // send_proposal()
            //            let alert = UIAlertController(title: "", message: "Upload Video", preferredStyle: UIAlertController.Style.alert)
            //            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            //            self.present(alert, animated: false, completion: nil)
                        send_proposal()
                        
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "", message: "Enter Description", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                
            }
           
            else
            {
                let alert = UIAlertController(title: "", message: "Enter event name", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: false, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Select Provider", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    func fileSize(forURL url: Any) -> Double {
            var fileURL: URL?
            var fileSize: Double = 0.0
            if (url is URL) || (url is String)
            {
                if (url is URL) {
                    fileURL = url as? URL
                }
                else {
                    fileURL = URL(fileURLWithPath: url as! String)
                }
                var fileSizeValue = 0.0
                try? fileSizeValue = (fileURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
                if fileSizeValue > 0.0 {
                    fileSize = (Double(fileSizeValue) / (1024 * 1024))
                }
            }
            return fileSize
        }

    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
    func ConvertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
    }

    var str:String = ""
    
    // MARK: - send_proposal
    func send_proposal()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        
        self.loadingView.isHidden = false

//        print("144",UserDefaults.standard.value(forKey: "u_Id") as! String,vendor_ID,providerFiled.text!,proposalTxtView.text!,proposalPriceFiled.text!,dateFiled.text!,timeFiled.text!)
//
    //    let inputFormatter = DateFormatter()
    //    inputFormatter.dateFormat = "dd/MM/yyyy"
    //    let showDate = inputFormatter.date(from: dateFiled.text!)
    //    inputFormatter.dateFormat = "yyyy-MM-dd"
    //    let resultString = inputFormatter.string(from: showDate!)
    //    print(resultString)
    //
        
        if dateField.text == ""
        {
            
        }
        else
        {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd/MM/yyyy"
            let showDate = inputFormatter.date(from: dateField.text!)
            inputFormatter.dateFormat = "yyyy-MM-dd"
            datefinal = inputFormatter.string(from: showDate!)
            
        }
        
        
        Alamofire.request("https://stumbal.com/process.php?action=send_proposal", method: .post, parameters: ["artist_id" : UserDefaults.standard.value(forKey: "ap_artId") as! String, "provider_id" : vendor_ID, "proposed_price" : priceField.text!,"date": datefinal, "time": timeFeild.text!, "post_detail": descriptionFeild.text!,"video":"","thumbnail_img":"","thumbnail_img_string":"","event_name" : eventNameField.text!],encoding:  URLEncoding.httpBody).responseJSON{ response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                print("22222222222222")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true

                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.send_proposal()
                    }))
                    self.present(alert, animated: false, completion: nil)
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        print("JSON: \(json)")
                        let result : String = json["result"]! as! String
                        if  result == "success"
                        {
                            self.loadingView.isHidden = true

                            MBProgressHUD.hide(for: self.view, animated: true)
                     
                            let alert = UIAlertController(title: "", message: "Proposal Sent Successfully", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            // change to desired number of seconds (in this case 5 seconds)
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                
                                alert.dismiss(animated: false, completion: nil)
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                                nextViewController.modalPresentationStyle = .fullScreen
                                self.present(nextViewController, animated:false, completion:nil)
                            }
                            
                        }
                        
                        else {
                            
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
    
//MARK: uploadWithAlamofire ;

func uploadWithAlamofire() {
//    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//    hud.mode = MBProgressHUDMode.indeterminate
//    hud.self.bezelView.color = UIColor.black
//    hud.label.text = "Loading...."
    self.loadingView.isHidden = false

    if dateField.text == ""
    {
        
    }
    else
    {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let showDate = inputFormatter.date(from: dateField.text!)
        inputFormatter.dateFormat = "yyyy-MM-dd"
        datefinal = inputFormatter.string(from: showDate!)
        
    }
    
   
    
    
    var imageView = UIImage()
     
       if let thumbnailImage = getThumbnailImage(forUrl: videoURL!) {
        imageView = thumbnailImage
        str = ConvertImageToBase64String(img: imageView)
       }
    
    let date = Date()
    let formator = DateFormatter()
    formator.dateFormat = "HH:mm:ss"
    formator.locale = Locale.init(identifier: "en_US_POSIX")
    let strDate = formator.string(from: date)
    let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
    
    let parameters = [
        "artist_id" : UserDefaults.standard.value(forKey: "ap_artId") as! String,
        "provider_id" : vendor_ID,
        "proposed_price" : descriptionFeild.text!,
        "date": datefinal,
        "time": timeFeild.text!,
        "post_detail": descriptionFeild.text!,
        "thumbnail_img" :imagePath ,
        "thumbnail_img_string" : str ,
        "event_name" : eventNameField.text! ,
    ]

    let date1 = Date()
    let formator1 = DateFormatter()
    formator1.dateFormat = "HH:mm:ss"
    formator1.locale = Locale.init(identifier: "en_US_POSIX")
    let strDate1 = formator1.string(from: date1)
    let timestamp = "iOSVideo_\(strDate1)_\(drand48())"
    
    Alamofire.upload(multipartFormData: { (multipartFormData) in
      //  multipartFormData.append(self.videoURL!, withName: "file")
        multipartFormData.append(self.videoURL!, withName: "video", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")

        for (key, value) in parameters {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
    }, to:"https://stumbal.com/process.php?action=send_proposal")
    { (result) in
        switch result {
        case .success(let upload, _ , _):
            
            upload.responseJSON { response in
                
                print("done")
                print("112122",response)
               
                MBProgressHUD.hide(for: self.view, animated: true);
                self.loadingView.isHidden = true

                
                let alert = UIAlertController(title: "", message: "Proposal Sent Successfully", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 2
                
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    
                    alert.dismiss(animated: false, completion: nil)
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    nextViewController.modalPresentationStyle = .fullScreen
                    self.present(nextViewController, animated:false, completion:nil)
                }
                
            }
            
        case .failure(let encodingError):
            print("failed")
            print(encodingError)
            MBProgressHUD.hide(for: self.view, animated: true);
            
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
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_venues", method: .post
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
                                                let n = jsonElement["vname"] as! String
                                                let m = jsonElement["venue_id"] as! String
                                                
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
        venueField.text = catPickerData1[row]
        vendor_ID = catPickerData2[row]
        
    }
}
extension UITextField {

func addInputViewDatePicker3(target: Any, selector: Selector) {
    
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
    
    
    datePicker.minimumDate = Date() // this to set the start date today
    //this to set the date range you can change " byAdding: .year " to "byAdding: .month" if you went the range by month or to "byAdding: .day"
    let nextDays = Calendar.current.date(byAdding: .year, value: 14, to: Date())
    datePicker.maximumDate = nextDays ?? Date() // this to set the maximum date
    self.inputView = datePicker
    
    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
    
    self.inputAccessoryView = toolBar
}

func addInputViewDatePicker7(target: Any, selector: Selector) {
    
    let screenWidth = UIScreen.main.bounds.width
    
    //Add DatePicker as inputView
    
    let timePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    timePicker.datePickerMode = .time
    if #available(iOS 13.4, *) {
        timePicker.preferredDatePickerStyle = .wheels
    } else {
        // Fallback on earlier versions
    }
    self.inputView = timePicker
    
    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
    
    self.inputAccessoryView = toolBar
}

//@objc func cancelPressed() {
//    self.resignFirstResponder()
//}


}
