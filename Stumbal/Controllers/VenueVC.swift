//
//  VenueVC.swift
//  Stumbal
//
//  Created by mac on 19/03/21.
//

import UIKit
import Alamofire
import CoreLocation
import Kingfisher
class VenueVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate {
@IBOutlet var venueTblView: UITableView!
@IBOutlet var statuslbl: UILabel!
@IBOutlet var searchBar: UISearchBar!
var hud = MBProgressHUD()
var venueArray:[venueList] = []
var AppendArr:NSMutableArray = NSMutableArray()
var distance:String = ""
var lat:Float = 0
var long:Float = 0
var locationManager = CLLocationManager()
override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 13.0, *) {
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
       } else {
           // Fallback on earlier versions
       }
    
    searchBar.setImage(UIImage(named: "search1"), for: .search, state: .normal)
    
    venueTblView.dataSource = self
    venueTblView.delegate = self
    // fetch_venues()
    searchBar.delegate = self
    //lat = -33.8337195
    //long = 150.9683735
    //
    // 22.6857
    //  75.8597
    
    //    lat = 22.6857
    //    long = 75.8597
    
    
    
    // Do any additional setup after loading the view.
}
    
    override func viewDidLayoutSubviews() {

        setupSearchBar(searchBar: searchBar)

    }

        func setupSearchBar(searchBar : UISearchBar) {

        searchBar.setPlaceholderTextColorTo(color: #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1))

       }

    
    override func viewWillAppear(_ animated: Bool) {
        fetch_user_distance()
    }
@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
    
}

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    //backObj.isHidden = false
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    lat = 0
    long = 0
    distance = "0"
    fetch_venue_nearby()
}


// MARK: - fetch_user_distance
func fetch_user_distance()
{
    
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=fetch_user_distance", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.fetch_user_distance()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                
                
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                    
                    
                    
                    if json["distance"] as! String == ""
                    {
                        self.distance = "5"
                    }
                    else
                    {
                        self.distance = json["distance"] as! String
                    }
                    self.getCurrentlocationofUser()
                    
                    //  self.fetch_venue_nearby()
                    
                    //  MBProgressHUD.hide(for: self.view, animated: true)
                    
                    
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
}

//MARK: fetch_events ;

func fetch_venues()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.self.bezelView.color = UIColor.black
    hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_venues", method: .post, parameters: nil, encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                    self.fetch_venues()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.AppendArr.count != 0 {
                        
                        
                        self.venueTblView.isHidden = false
                        self.venueTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.venueTblView.isHidden = true
                        
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

// MARK: - Current location Function
func  getCurrentlocationofUser(){
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
}


func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    
    let location = locations.last! as CLLocation
    var center  = CLLocationCoordinate2D()
    
    lat = Float(locValue.latitude)
    long = Float(locValue.longitude)
    // center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    self.fetch_venue_nearby()
    locationManager.stopUpdatingLocation()
}

func fetch_venue_nearby()
{
    // UserDefaults.standard.set(self.userId, forKey: "User id")
    //        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //        hud.mode = MBProgressHUDMode.indeterminate
    //        hud.self.bezelView.color = UIColor.black
    //        hud.label.text = "Loading...."
    let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    print("123",uID)
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_venue_nearby", method: .post, parameters: ["user_id":uID,"lat":lat,"lng":long,"distance":distance,"search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                    self.fetch_venue_nearby()
                }))
                self.present(alert, animated: false, completion: nil)
                
            }
            else
            {
                do  {
                    self.AppendArr = NSMutableArray()
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    
                    if self.AppendArr.count != 0 {
                        
                        
                        self.venueTblView.isHidden = false
                        self.statuslbl.isHidden = true
                        self.venueTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.venueTblView.isHidden = true
                        self.statuslbl.isHidden = false
                        
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


func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
    guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
          let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
    else {
        return nil
    }
    
    let context = CGContext(data: nil,
                            width: Int(size.width),
                            height: Int(size.height),
                            bitsPerComponent: image.bitsPerComponent,
                            bytesPerRow: 0,
                            space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                            bitmapInfo: image.bitmapInfo.rawValue)
    context?.interpolationQuality = .high
    context?.draw(image, in: CGRect(origin: .zero, size: size))
    
    guard let scaledImage = context?.makeImage() else { return nil }
    
    return UIImage(cgImage: scaledImage)
}


//MARK: tableView Methode
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
//      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//          self.viewWillLayoutSubviews()
//      }
//
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AppendArr.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  venueTblView.dequeueReusableCell(withIdentifier: "VenueTblCell", for: indexPath) as! VenueTblCell
    
    cell.venueNamelbl.text = (self.AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "vname")as! String
    cell.venueAddressLbl.text = (self.AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
    let ar = (self.AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "avg_rating")as! String
    
    let vi =  (self.AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "venue_img")as! String
    
    
    if vi == ""
    {
        cell.venueImg.image = UIImage(named: "vdefault")
        
    }
    else
    {
        let url = URL(string: vi)
        let processor = DownsamplingImageProcessor(size: cell.venueImg.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        cell.venueImg.kf.indicatorType = .activity
        cell.venueImg.kf.setImage(
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
                cell.venueImg.image = UIImage(named: "vdefault")
            }
        }
        
    }
    if ar == ""
    {
        cell.ratingLbl.text = "0" + "/5"
    }
    else
    {
        cell.ratingLbl.text = ar + "/5"
    }
    
    return cell
}


func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let vn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "vname")as! String
    let add = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
    let i = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "venue_img")as! String
    let id = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "venue_id")as! String
    let c = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "contact")as! String
    let la = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "lat")as! String
    let lo = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "lng")as! String
    
    
    UserDefaults.standard.setValue(vn, forKey: "V_name")
    UserDefaults.standard.setValue(add, forKey: "V_add")
    UserDefaults.standard.setValue(i, forKey: "V_image")
    UserDefaults.standard.setValue(id, forKey: "V_id")
    UserDefaults.standard.setValue(c, forKey: "V_contact")
    UserDefaults.standard.setValue(la, forKey: "Event_lat")
    UserDefaults.standard.setValue(lo, forKey: "Event_long")
    
    
   // UserDefaults.standard.setValue(la, forKey: "V_lat")
  //  UserDefaults.standard.setValue(lo, forKey: "V_long")
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ServiceProviderDetailVC") as! ServiceProviderDetailVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}
}

extension UIImage {
func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
}
extension UIImage {
convenience init?(url: URL?) {
    guard let url = url else { return nil }
    
    do {
        self.init(data: try Data(contentsOf: url))
    } catch {
        print("Cannot load image from url: \(url) with error: \(error)")
        return nil
    }
}
}
