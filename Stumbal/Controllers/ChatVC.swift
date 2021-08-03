//
//  ChatVC.swift
//  Stumbal
//
//  Created by mac on 24/04/21.
//

import UIKit
import Alamofire
import MediaPlayer
import AVFoundation
import AVKit
import SDWebImage
import Kingfisher
class ChatVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,OpalImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate {

@IBOutlet var profileView: UIView!
@IBOutlet var nameLbl: UILabel!
@IBOutlet var messageFiled: UITextField!
@IBOutlet var chatTblView: UITableView!
@IBOutlet var profileImg: UIImageView!
var pastArray:NSMutableArray = NSMutableArray()
var AppendArr:NSMutableArray = NSMutableArray()
var finalImgArr:NSMutableArray = NSMutableArray()
var hud = MBProgressHUD()
var imgDataArray = [Data]()
var imagePicker: OpalImagePickerController!
var pickerOne : UIImagePickerController!
var str1:String = ""
var imgName:String = ""
var imageName:String = ""
var imagePathArray:NSMutableArray = NSMutableArray()
var imagebaseArray:NSMutableArray = NSMutableArray()
var imagebase:String = ""
var imgArray = [UIImage]()
var videoURL: URL?
var uploadStatus:String = ""
let imagePickerController = UIImagePickerController()
var timer: Timer?

override func viewDidLoad() {
    super.viewDidLoad()
    
    chatTblView.dataSource = self
    chatTblView.delegate = self
    
    self.profileView.layer.cornerRadius = self.profileView.frame.height / 2
    self.profileView.layer.masksToBounds = false
    self.profileView.clipsToBounds = true
    
    nameLbl.text = UserDefaults.standard.value(forKey: "friend_name") as! String
    // UserDefaults.standard.value(forKey: "Receiver_id") as! String
    
    // u_Id
    let uimg:String = UserDefaults.standard.value(forKey: "friend_img") as! String
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
    getMessages()
    
    timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
        // do something here
        self?.getMessages()
    }
    setupTable()
   // getMessages()
    // Do any additional setup after loading the view.
}
    func setupTable() {
        // config tableView
        chatTblView.rowHeight = UITableView.automaticDimension
        chatTblView.dataSource = self
        chatTblView.backgroundColor = UIColor(named: "E4DDD6")
        chatTblView.tableFooterView = UIView()
        // cell setup
        chatTblView.register(UINib(nibName: "RightViewCell", bundle: nil), forCellReuseIdentifier: "RightViewCell")
        chatTblView.register(UINib(nibName: "LeftViewCell", bundle: nil), forCellReuseIdentifier: "LeftViewCell")
        
    }

@IBAction func send(_ sender: UIButton) {
    if messageFiled.text != ""
    {
        send()
    }
    else
    {
        
    }
   
}
@IBAction func back(_ sender: UIButton) {
    timer?.invalidate()
    self.dismiss(animated: false, completion: nil)
}

@IBAction func attach(_ sender: UIButton) {
    let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: {(action: UIAlertAction) in
        //alert.setValue(#imageLiteral(resourceName: "smile"), forKey: "image")
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) in
                                        
                                        self.imagePicker = OpalImagePickerController()
                                        self.imagePicker.imagePickerDelegate = self
                                       // self.imagePicker.sourceType = .savedPhotosAlbum
//                                        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
                                        self.imagePicker.selectionImage = UIImage(named: "aCheckImg")
                                        self.imagePicker.maximumSelectionsAllowed = 8 // Number of selected images
                                        self.imagePicker.modalPresentationStyle = .fullScreen
                                        self.present(self.imagePicker!, animated: true, completion: nil)            }))
        self.pickerOne = UIImagePickerController()
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.pickerOne.sourceType=UIImagePickerController.SourceType.camera
            self.pickerOne.allowsEditing=true
            self.pickerOne.delegate=self
            self.pickerOne.modalPresentationStyle = .fullScreen
            self.present(self.pickerOne, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }))
    alert.addAction(UIAlertAction(title: "Video", style: .default, handler: {(action: UIAlertAction) in
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.delegate = self
       // self.imagePickerController.mediaTypes = ["public.image", "public.movie"]
        self.imagePickerController.mediaTypes = ["public.movie"]
        self.imagePickerController.modalPresentationStyle = .fullScreen
        self.present(self.imagePickerController, animated: true, completion: nil)
        
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
}


func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images:[UIImage]) {
    print("123",images)
    UserDefaults.standard.set(true, forKey: "pick")
    imgArray = images
    for image in images{
        let image1 : UIImage = image.resize(300)
        let imageData = image1.jpegData(compressionQuality: 0.75)
        imgDataArray.append(imageData!)
        let strBase64 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
        imagebaseArray.add(strBase64)
        let date = Date()
        let formator = DateFormatter()
        formator.dateFormat = "HH:mm:ss"
        formator.locale = Locale.init(identifier: "en_US_POSIX")
        let strDate = formator.string(from: date)
        let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
        imagePathArray.add(imagePath)
    }
    
    self.imageName = self.imagePathArray.componentsJoined(by: ",")
    self.imagebase = self.imagebaseArray.componentsJoined(by: ",")
    print("1523",imgArray)
    
    
    self.dismiss(animated: false, completion: nil)
    
    uploadPhotoWithAlamofire()
}
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    
    if let selectedImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    {
        let  selectedImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let image1 : UIImage = selectedImg.resize(300)
        let imageData = image1.jpegData(compressionQuality: 0.75)
        
        imgDataArray.append(imageData!)
        let strBase64 = (imageData as AnyObject).base64EncodedString(options: .lineLength64Characters)
        imagebaseArray.add(strBase64)
        
        imgArray.append(selectedImg)
        
        let date = Date()
        let formator = DateFormatter()
        formator.dateFormat = "HH:mm:ss"
        formator.locale = Locale.init(identifier: "en_US_POSIX")
        let strDate = formator.string(from: date)
        let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
        // imagePath
        imagePathArray.add(imagePath)
        
        self.imageName = self.imagePathArray.componentsJoined(by: ",")
        self.imagebase = self.imagebaseArray.componentsJoined(by: ",")
        print("1523",imageName)
        
        self.dismiss(animated: false, completion: nil)
        uploadPhotoWithAlamofire()
        
    }
    else
    {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        print("144",videoURL!)
        print("videoURL:\(String(describing: videoURL))")
        
        self.dismiss(animated: true, completion: nil)
        uploadWithAlamofire()
    }
    
    
    imagePickerController.dismiss(animated: true, completion: nil)
    
    //  videoStack.isHidden = false
}


func ConvertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
}


func camera()
{
    if UIImagePickerController.isSourceTypeAvailable(.camera){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    
}

func photoLibrary()
{
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
}

   
//MARK: uploadWithAlamofire ;

func uploadWithAlamofire() {
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    var imageView = UIImage()
     

       if let thumbnailImage = getThumbnailImage(forUrl: videoURL!) {
        imageView = thumbnailImage
        str1=ConvertImageToBase64String(img: imageView)
       }
    
    let date = Date()
    let formator = DateFormatter()
    formator.dateFormat = "HH:mm:ss"
    formator.locale = Locale.init(identifier: "en_US_POSIX")
    let strDate = formator.string(from: date)
    let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
    let parameters = [
        "sender_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,
        "status_upload" : "Video",
        "reciver_id" : UserDefaults.standard.value(forKey: "friend_rid") as! String,
        "thumbnail_img" : imagePath ,
        "thumbnail_img_string" : str1
    ]
    
    Alamofire.upload(multipartFormData: { (multipartFormData) in
        
        multipartFormData.append(self.videoURL!, withName: "file")
        //fileUrl is your file path in iOS device and withName is parameter name
        for (key, value) in parameters {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
    }, to:"https://stumbal.com/process.php?action=send_msg")
    { (result) in
        switch result {
        case .success(let upload, _ , _):
            
            upload.uploadProgress(closure: { (progress) in
                //MBProgressHUD.hide(for: self.view, animated: true);
                
            })
            
            upload.responseJSON { response in
                
                print("done")
                
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }
            
        case .failure(let encodingError):
            print("failed")
            print(encodingError)
            MBProgressHUD.hide(for: self.view, animated: true);
            
        }
    }
    
}

//MARK: uploadPhotoWithAlamofire ;
func uploadPhotoWithAlamofire() {
    print("145",imgDataArray)
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let parameters = [
        "sender_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,
        "status_upload" : "Photo",
        "reciver_id" :UserDefaults.standard.value(forKey: "friend_rid") as! String,
    ]
    
    Alamofire.upload(multipartFormData: { (multipartFormData) in
        
        let count = self.imgDataArray.count
        
        for i in 0..<count{
            let date = Date()
            let formator = DateFormatter()
            formator.dateFormat = "HH:mm:ss"
            formator.locale = Locale.init(identifier: "en_US_POSIX")
            let strDate = formator.string(from: date)
            let imagePath = "iOSImage_\(strDate)_\(drand48()).png"
            
            multipartFormData.append(self.imgDataArray[i], withName: "files[\(i)]", fileName: imagePath , mimeType: "image/jpeg")
            
        }
        print("multi",multipartFormData)
        for (key, value) in parameters {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
    }, to:"https://stumbal.com/process.php?action=send_msg")
    { (result) in
        switch result {
        case .success(let upload, _ , _):
            
            upload.uploadProgress(closure: { (progress) in
                //MBProgressHUD.hide(for: self.view, animated: true);
                print("uploding")
            })
            
            upload.responseJSON { response in
                
                print("done")
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }
            
        case .failure(let encodingError):
            print("failed")
            print(encodingError)
            MBProgressHUD.hide(for: self.view, animated: true);
            
        }
    }
    
}

//MARK: send ;
func send()
{
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    print("144",UserDefaults.standard.value(forKey: "friend_rid") as! String,UserDefaults.standard.value(forKey: "u_Id") as! String)
    Alamofire.request("https://stumbal.com/process.php?action=send_msg", method: .post, parameters: ["sender_id" : uID,"message":messageFiled.text!,"status_upload":"Text","reciver_id":UserDefaults.standard.value(forKey: "friend_rid") as! String,"file":"","files":""], encoding:  URLEncoding.httpBody).responseJSON
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
                {       self.messageFiled.text = ""
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.getMessages()
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                }
            }
        }
        
    }
    
}
    
  
// MARK: - getMessages
func getMessages()
{
    
    self.pastArray = NSMutableArray()
    
    let u_id = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_messages", method: .post, parameters: ["sender_id" :u_id,"receiver_id":UserDefaults.standard.value(forKey: "friend_rid") as! String], encoding:  URLEncoding.httpBody).responseJSON { response in
        if let data = response.data {
            let json = String(data: data, encoding: String.Encoding.utf8)
            print("=====1======")
            print("Response: \(String(describing: json))")
            
            if json == ""
            {
                MBProgressHUD.hide(for: self.view, animated: true);
//                let alert = UIAlertController(title: “Loading…”, message: "", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
//                    print("Action")
//
//                }))
//                self.present(alert, animated: false, completion: nil)
                
                self.getMessages()
            }
            else
            {
                self.pastArray = NSMutableArray()
                do  {
                    self.pastArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    self.AppendArr = NSMutableArray()
                    
                    self.finalImgArr = NSMutableArray()
                    
                    
                    if self.pastArray.count != 0
                    {
                        
                        for i in 0...self.pastArray.count-1
                        {
                            if (self.pastArray.object(at: i) as AnyObject).value(forKey: "user_name") is NSNull {
                            } else {
                                
                                let status : String = (self.pastArray.object(at:i) as AnyObject).value(forKey: "status") as! String
                                let status_uploded : String = (self.pastArray.object(at:i) as AnyObject).value(forKey: "upstatus") as! String
                                
                                //let name : String = (self.pastArray.object(at:i) as AnyObject).value(forKey: "status") as! String
                                let date : String = (self.pastArray.object(at:i) as AnyObject).value(forKey: "date") as! String
                                let Time : String = (self.pastArray.object(at:i) as AnyObject).value(forKey: "sentat") as! String
                                let name : String = (self.pastArray.object(at:i) as AnyObject).value(forKey: "name") as! String
                                let thumbimg : String = (self.pastArray.object(at:i) as AnyObject).value(forKey: "thumbnail_img") as! String
                                
                                if status_uploded == "Photo" {
                                    let ImgArr : NSArray = (self.pastArray.object(at:i) as AnyObject).value(forKey: "image") as! NSArray
                                    print(ImgArr)
                                    for j in 0...ImgArr.count - 1 {
                                        
                                        let dict : NSDictionary = ImgArr[j] as! NSDictionary
                                        let dict1 : NSMutableDictionary = NSMutableDictionary()
                                        dict1.setValue(status, forKey: "status")
                                        dict1.setValue(date, forKey: "date")
                                        dict1.setValue(Time, forKey: "Time")
                                        dict1.setValue(status_uploded, forKey: "Status_type")
                                        dict1.setValue(name, forKey: "name")
                                        dict1.setValue(dict.value(forKey: "image"), forKey: "NewImage")
                                        dict1.setValue(thumbimg, forKey: "thumbnail_img")
                                        self.finalImgArr.add(dict1)
                                    }
                                }
                                else if status_uploded == "Video"{
                                    
                                    let dict1 : NSMutableDictionary = NSMutableDictionary()
                                    dict1.setValue(status, forKey: "status")
                                    dict1.setValue(date, forKey: "date")
                                    dict1.setValue(Time, forKey: "Time")
                                    dict1.setValue(name, forKey: "name")
                                    dict1.setValue(thumbimg, forKey: "thumbnail_img")
                                    dict1.setValue(status_uploded, forKey: "Status_type")
                                    let video : String = (self.pastArray.object(at:i) as AnyObject).value(forKey: "video") as! String
                                    dict1.setValue(video, forKey: "video")
                                    self.finalImgArr.add(dict1)
                                }
                                else if status_uploded == "Text"{
                                    let dict1 : NSMutableDictionary = NSMutableDictionary()
                                    dict1.setValue(status, forKey: "status")
                                    dict1.setValue(date, forKey: "date")
                                    dict1.setValue(Time, forKey: "Time")
                                    dict1.setValue(name, forKey: "name")
                                    dict1.setValue(status_uploded, forKey: "Status_type")
                                    dict1.setValue(thumbimg, forKey: "thumbnail_img")
                                    let title : String = (self.pastArray.object(at:i) as AnyObject).value(forKey: "message") as! String
                                    dict1.setValue(title, forKey: "title")
                                    self.finalImgArr.add(dict1)
                                }
                                
                            }
                            
                        }
                        print(self.finalImgArr)
                        self.chatTblView.isHidden = false
                        self.chatTblView.reloadData()
                    }
                    else
                    {
                        self.chatTblView.isHidden = true
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
    
    
    func thumbnailForVideo(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true

        var time = asset.duration
        time.value = min(time.value, 2)

        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("failed to create thumbnail")
            return nil
        }
    }
    func videoSnapshot(filePathLocal:URL) -> UIImage? {
        do
        {
            let asset = AVURLAsset(url: filePathLocal)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at:CMTimeMake(value: Int64(0), timescale: Int32(1)),actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        }
        catch let error as NSError
        {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
    
// MARK: - TableView Methods
func numberOfSections(in tableView: UITableView) -> Int  {
    return 1
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return finalImgArr.count
    
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    
    if (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "status")as! String  == "Sender" {
        
        if (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Status_type")as! String  == "Text"
        {
//            let cell = chatTblView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderTableViewCell
//            var bgColor = UIColor.groupTableViewBackground
//            bgColor = UIColor(red: (203.0/255.0), green: (253.0/255.0), blue: (203.0/255.0), alpha: 1.0)
//            cell.viewContainer!.layer.cornerRadius = 10.0
//            cell.viewContainer!.backgroundColor = bgColor
//            cell.lblContent.text  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "title")as! String
       
//
//            let t = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Time")as! String
//            cell.lblDate.text = d + ", " + t
//            return cell
            
            let cell = chatTblView.dequeueReusableCell(withIdentifier: "RightViewCell") as! RightViewCell
            cell.textMessageLabel.text = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "title")as! String
            let d  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
                    let t = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Time")as! String
                  cell.dateLbl.text = d + ", " + t
            
           
            //let view = UIView(frame: frame)
           // view.addPikeOnView(side: .Top)
            return cell
            
            
        }
        else if  (finalImgArr[indexPath.row] as AnyObject).value(forKey:"Status_type") as! String == "Video"
        {
            let cell = chatTblView.dequeueReusableCell(withIdentifier: "VideoRightSideTableViewCell", for: indexPath) as! VideoRightSideTableViewCell
            //                        cell.text  = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "title")as! String
            let u = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "video")as! String
            //
            
            let d  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
            
            let t = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Time")as! String
            cell.videorightTimeLbl.text = d + ", " + t
            
//            cell.rightVideoView.layer.cornerRadius = 2;
//            cell.rightVideoView.clipsToBounds = true
            
            
//            let myColor = #colorLiteral(red: 0.4980392157, green: 0.5490196078, blue: 0.5529411765, alpha: 1)
//            cell.rightVideoView.layer.borderColor = myColor.cgColor
//            cell.rightVideoView.layer.borderWidth = 1.0
            
//            let url = NSURL(string: u);
//            let avPlayer = AVPlayer(url: url as! URL);
//            //cell.videoView = avPlayer;
//            cell.rightSideVideoView.playerLayer.player = avPlayer;
//
//
//            cell.rightSideVideoView.playerLayer.videoGravity = AVLayerVideoGravity.resize
            
//            let url = URL(string: u)
//
//            DispatchQueue.main.async {
//                cell.rightImg.image = self.videoSnapshot(filePathLocal: url!)
//
//            }
            
            let thum:String = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "thumbnail_img")as! String
            
            let url = URL(string: thum)
            let processor = DownsamplingImageProcessor(size: cell.rightImg.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 0)
            cell.rightImg.kf.indicatorType = .activity
            cell.rightImg.kf.setImage(
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
                    cell.rightImg.image = UIImage(named: "udefault")
                }
            }
            
            
            
//            DispatchQueue.main.async(execute: {
//                let url = URL(string: u)
//
//
//                cell.rightImg.image = self.videoSnapshot(filePathLocal: url!)
//
////                if let thumbnailImage = self.getThumbnailImage(forUrl: url!) {
////                        cell.rightImg.image = thumbnailImage
////                    }
//            })
            
       
            
            return cell
            
        }
        else
        {
            let cell = chatTblView.dequeueReusableCell(withIdentifier: "SinglePhotoRightSideTableViewCell", for: indexPath) as! SinglePhotoRightSideTableViewCell
            let d = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
            let t = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Time")as! String
            let vi = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "NewImage")as! String
            
            if vi == ""
            {
                cell.singleRightPhotoImg.image = UIImage(named: "udefault")
                
            }
            else
            {
                let url = URL(string: vi)
                let processor = DownsamplingImageProcessor(size: cell.singleRightPhotoImg.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 0)
                cell.singleRightPhotoImg.kf.indicatorType = .activity
                cell.singleRightPhotoImg.kf.setImage(
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
                        cell.singleRightPhotoImg.image = UIImage(named: "udefault")
                    }
                }
                
            }
            
            
           // cell.singleRightPhotoImg.sd_setImage(with: URL(string: (self.finalImgArr[indexPath.row] as AnyObject).value(forKey:"NewImage") as! String), placeholderImage: UIImage(named: "logo"))
            
            cell.singlerightdtaeLbl.text = d + ", " + t
            return cell
        }
        
        
    }else{
        
        if (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Status_type")as! String  == "Text"
        {
//            let cell = chatTblView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! SenderTableViewCell
//
//            let t  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Time")as! String
//
//            cell.lblContent.text!  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "title")as! String
//
//            cell.snameLbl.text!  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
//
//            let d  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
//            cell.lblDate.text = d + ", " + t
//            return cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftViewCell") as! LeftViewCell
            cell.textMessageLabel.text = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "title")as! String
            let d  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
                    let t = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Time")as! String
                  cell.datelbl.text = d + ", " + t
            return cell
            
        }
        else if (finalImgArr[indexPath.row] as AnyObject).value(forKey:"Status_type") as! String == "Video"
        {
            let cell = chatTblView.dequeueReusableCell(withIdentifier: "VideoLeftSideTableViewCell", for: indexPath) as! VideoLeftSideTableViewCell
            //                        cell.text  = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "title")as! String
            
        //    cell.leftVideoNameLbl.text!  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
            
            let u = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "video")as! String
            //
            
            let d  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
            
            let t = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Time")as! String
            cell.leftVideoTimeLbl.text = d + ", " + t
            
            //cell.leftVideoView.layer.cornerRadius = 2;
          //  cell.leftVideoView.clipsToBounds = true
            
            
//            let myColor = #colorLiteral(red: 0.4980392157, green: 0.5490196078, blue: 0.5529411765, alpha: 1)
//            cell.leftVideoView.layer.borderColor = myColor.cgColor
//            cell.leftVideoView.layer.borderWidth = 1.0
            
          //  let url = NSURL(string: u);
          //  let avPlayer = AVPlayer(url: url as! URL);
            //cell.videoView = avPlayer;
           // cell.leftSideVideoView.playerLayer.player = avPlayer;
            
           // cell.playerView.load(withVideoId: u)
            
            
          //  let url = URL(string: u)

//                if let thumbnailImage = getThumbnailImage(forUrl: url!) {
//                    cell.leftImg.image = thumbnailImage
//                }
        
            
            
//            AVAsset(url: url!).generateThumbnail { [weak self] (image) in
//                          DispatchQueue.main.async {
//                              guard let image = image else { return }
//                              cell.leftImg.image = image
//                          }
//                      }
            
           // cell.leftSideVideoView.playerLayer.videoGravity = AVLayerVideoGravity.resize
            //  cell.videodeleteObj.tag = indexPath.row
            let thum:String = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "thumbnail_img")as! String
            
            let url = URL(string: thum)
            let processor = DownsamplingImageProcessor(size: cell.leftImg.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 0)
            cell.leftImg.kf.indicatorType = .activity
            cell.leftImg.kf.setImage(
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
                    cell.leftImg.image = UIImage(named: "udefault")
                }
            }
            return cell
            
            
        }
        else
        {
            let cell = chatTblView.dequeueReusableCell(withIdentifier: "SinglePhotoLeftSideTableViewCell", for: indexPath) as! SinglePhotoLeftSideTableViewCell
            let d = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
            let t = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "Time")as! String
           // cell.leftPhotonameLbl.text!  = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
            
          //  cell.leftPhotoImg.sd_setImage(with: URL(string: (self.finalImgArr[indexPath.row] as AnyObject).value(forKey:"NewImage") as! String), placeholderImage: UIImage(named: "logo"))
            
            let vi = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "NewImage")as! String
            
            if vi == ""
            {
                cell.leftPhotoImg.image = UIImage(named: "udefault")
                
            }
            else
            {
                let url = URL(string: vi)
                let processor = DownsamplingImageProcessor(size: cell.leftPhotoImg.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 0)
                cell.leftPhotoImg.kf.indicatorType = .activity
                cell.leftPhotoImg.kf.setImage(
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
                        cell.leftPhotoImg.image = UIImage(named: "udefault")
                    }
                }
                
            }
            
            cell.leftPhotoTimeLbl.text = d + ", " + t
            
            return cell
        }
        
    }
    
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
    
    if (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "status")as! String  == "Sender" {
        
        
        if  (finalImgArr[indexPath.row] as AnyObject).value(forKey:"Status_type") as! String == "Video"
        {
            
            //                        cell.text  = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "title")as! String
            let u = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey:
                                                                                "video")as! String
            
            
            
            // if let url = URL(string: AppendArr[indexPath.row]) {
            
            let url = NSURL(string: u);
            let player = AVPlayer(url: url as! URL);
            
            // let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.play()
            }
            
            
            
        }
        else if (finalImgArr[indexPath.row] as AnyObject).value(forKey:"Status_type") as! String == "Photo"
        {
            
            
            let i = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "NewImage")as! String
            UserDefaults.standard.setValue(i, forKey: "SelectImg")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowSelectImageVC") as! ShowSelectImageVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
            
            
            
            
        }
        else
        {
            
        }
        
        
    }else{
        
        
        if (finalImgArr[indexPath.row] as AnyObject).value(forKey:"Status_type") as! String == "Video"
        {
            
            
            let u = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey:
                                                                                "video")as! String
            
            let url = NSURL(string: u);
            let player = AVPlayer(url: url as! URL);
            
            // let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.play()
            }
           
        }
        else if (finalImgArr[indexPath.row] as AnyObject).value(forKey:"Status_type") as! String == "Photo"
        {
            
            
            let i = (finalImgArr.object(at: indexPath.row) as AnyObject).value(forKey: "NewImage")as! String
            UserDefaults.standard.setValue(i, forKey: "SelectImg")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowSelectImageVC") as! ShowSelectImageVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else
        {
            
        }
        
    }
    
}

}
extension UIImage {
func resize(_ wth: CGFloat) -> UIImage {
    let scale = wth / self.size.width
    let newHeight = self.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: wth, height: newHeight))
    self.draw(in: CGRect(x: 0, y: 0, width: wth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}
}

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
