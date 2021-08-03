//
//  EventMapVC.swift
//  Stumbal
//
//  Created by mac on 06/05/21.
//

import UIKit
import MapKit
import Alamofire
import Kingfisher
class EventMapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
@IBOutlet var mapView: MKMapView!
@IBOutlet var eventView: UIView!
@IBOutlet var eventimg: UIImageView!
@IBOutlet var eventNameLbl: UILabel!
@IBOutlet var eventAddressLbl: UILabel!
@IBOutlet var ratingView: FloatRatingView!
var distance:String = ""
var hud = MBProgressHUD()
var newPin = MKPointAnnotation()
var eventArray:NSMutableArray = NSMutableArray()
var annotation1 = MKPointAnnotation()
var latLongAry = NSMutableArray()
let geocoder = CLGeocoder()
private var tileRenderer: MKTileOverlayRenderer?
var locationManager = CLLocationManager()
var lat:Float = 0
var long:Float = 0
var providerRating:String = ""
var artistRating:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    UserDefaults.standard.removeObject(forKey: "isotherlocation")
    fetch_user_distance()
    // Do any additional setup after loading the view.
}

@IBAction func deleteeventview(_ sender: UIButton) {
    eventView.isHidden = true
}
@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}

@IBAction func selectevent(_ sender: UIButton) {
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
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
                
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}

func fetch_nearby_event()
{
//    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//    hud.mode = MBProgressHUDMode.indeterminate
//    hud.self.bezelView.color = UIColor.black
//    hud.label.text = "Loading...."
    let id = UserDefaults.standard.value(forKey: "u_Id") as! String
    
    Alamofire.request("https://stumbal.com/process.php?action=fetch_events", method: .post
                      , parameters: ["user_id":id,"lat":lat,"lng":long,"distance":distance], encoding:  URLEncoding.httpBody).responseJSON
        { [self] response in
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
                                    self.fetch_nearby_event()
                                }))
                                self.present(alert, animated: false, completion: nil)
                                
                            }
                            else
                            {
                                do  {
                                    self.eventArray = NSMutableArray()
                                    self.latLongAry = NSMutableArray()
                                    self.eventArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
                                    print("5566262")
                                    print(self.eventArray)
                                    
                                    if self.eventArray.count>0
                                    {
                                        
                                        for index in 0..<self.eventArray.count {
                                            
                                            for index in 0..<self.eventArray.count {
                                                let latData: String = (self.eventArray.object(at: index) as AnyObject).value(forKey: "lat") as! String
                                                let lat : Double = Double(latData)!
                                                let longData : String = (self.eventArray.object(at: index) as AnyObject).value(forKey: "lng") as! String
                                                let long : Double = Double(longData)!
                                                
                                                self.annotation1.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                                print("lat",lat,long)
                                                let aryIndex:String = String(format: "%d", index)
                                                print("111",AnyIndex.self)
                                                
                                                let sikkim = CityLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude:long), title: aryIndex)
                                                
                                                self.annotation1.title = "5666565"
                                                self.latLongAry.add(sikkim)
                                                
                                            }
                                            self.mapView.addAnnotations(self.latLongAry as![MKAnnotation])
                                            
                                        }
                                        
                                        MBProgressHUD.hide(for: self.view, animated: true);
                                        print("Hello")
                                        
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

// MARK: - Current location Function
func  getCurrentlocationofUser(){
    self.locationManager.delegate = self
    self.mapView.showsUserLocation = true
    self.mapView.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
}

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    let location = locations.last! as CLLocation
    var center  = CLLocationCoordinate2D()
    if UserDefaults.standard.bool(forKey: "isotherlocation"){
        
        if UserDefaults.standard.value(forKey: "usersource_lat") == nil
        {
            UserDefaults.standard.set(false, forKey: "isotherlocation")
            // getCurrentlocationofUser()
        }
        else
        {
            UserDefaults.standard.set(false, forKey: "isotherlocation")
            center = CLLocationCoordinate2D(latitude: (UserDefaults.standard.value(forKey: "usersource_lat") as! NSString).doubleValue, longitude: (UserDefaults.standard.value(forKey: "usersource_long") as! NSString).doubleValue)
        }
    }
    else{
        lat = Float(locValue.latitude)
        long = Float(locValue.longitude)
        center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
        
        //set region on the map
        self.mapView.setRegion(region, animated: true)
    }) { (completed: Bool) -> Void in
    }
    
    newPin.coordinate = location.coordinate
    fetch_nearby_event()
    locationManager.stopUpdatingLocation()
}

func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
    if annotation.isEqual(mapView.userLocation){
        annotationView.image = UIImage(named:"user")
        
        return annotationView
    }else{
        
        let annotationLabel = UILabel(frame: CGRect(x: -40, y: -35, width: 105, height: 30))
        annotationLabel.numberOfLines = 3
        annotationLabel.textAlignment = .center
        annotationLabel.backgroundColor = .white
        annotationLabel.font = UIFont(name: "Rockwell", size: 10)
        let i:Int = ((annotation.title) as! NSString).integerValue
        
        
        //        if (eventArray.object(at: i) as AnyObject).value(forKey: "provider_status") as! String == "Premium provider"
        //        {
        //            annotationView.image = UIImage(named:"imp")
        //        }
        //        else
        //        {
        annotationView.image = UIImage(named:"e")
        // }
        
        let titleval : String = (eventArray.object(at: i) as AnyObject).value(forKey: "event_name") as! String
        //  annotationView.canShowCallout = true
        annotationLabel.text = titleval
        
      //  annotationView.addSubview(annotationLabel)
        return annotationView
    }
}

func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    //   geoCode(location: location)
}

func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    print("calloutAccessoryControlTapped")
}

func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
    print("didSelectAnnotationTapped")
    
    if  eventArray.count != 0
    {
        var selectedAnnotation = view.annotation
        
        let i:Int = ((selectedAnnotation?.title) as! NSString).integerValue
        
        let titleval : String = (eventArray.object(at: i) as AnyObject).value(forKey: "event_name") as! String
        print("144",titleval)
        eventNameLbl.text = (eventArray.object(at: i) as AnyObject).value(forKey: "event_name")as! String
        
        eventAddressLbl.text = (eventArray.object(at: i) as AnyObject).value(forKey: "address")as! String
        
        ratingView.rating = ((eventArray.object(at: i) as AnyObject).value(forKey: "provider_avg_rating")as! NSString).doubleValue
        
        let eimg:String = (eventArray.object(at: i) as AnyObject).value(forKey: "event_img")as! String
        
        if eimg == ""
        {
            self.eventimg.image = UIImage(named: "edefault")
            
        }
        else
        {
            let url = URL(string: eimg)
            let processor = DownsamplingImageProcessor(size: self.eventimg.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 0)
            self.eventimg.kf.indicatorType = .activity
            self.eventimg.kf.setImage(
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
                    self.eventimg.image = UIImage(named: "edefault")
                }
            }
            
        }
        
        let pn = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name")as! String
        let add = (eventArray.object(at: i) as AnyObject).value(forKey: "address")as! String
        let od = (eventArray.object(at: i) as AnyObject).value(forKey: "open_date")as! String
        let cd = (eventArray.object(at: i) as AnyObject).value(forKey: "close_date")as! String
        let ot = (eventArray.object(at: i) as AnyObject).value(forKey: "open_time")as! String
        let ct = (eventArray.object(at: i) as AnyObject).value(forKey: "close_time")as! String
        let ai = (eventArray.object(at: i) as AnyObject).value(forKey: "event_img") as! String
        let en = (eventArray.object(at: i) as AnyObject).value(forKey: "event_name") as! String
        let aid = (eventArray.object(at: i) as AnyObject).value(forKey: "artist_id") as! String
        let eid = (eventArray.object(at: i) as AnyObject).value(forKey: "event_id") as! String
        let tp = (eventArray.object(at: i) as AnyObject).value(forKey: "ticket_price") as! String
        
        let lat = (eventArray.object(at: i) as AnyObject).value(forKey: "lat") as! String
        
        let long = (eventArray.object(at: i) as AnyObject).value(forKey: "lng") as! String
        
        let scn = (eventArray.object(at: i) as AnyObject).value(forKey: "sub_cat_name")as! String
        
        let n = (eventArray.object(at: i) as AnyObject).value(forKey: "artist")as! String
        
        let cn = (eventArray.object(at: i) as AnyObject).value(forKey: "category_name")as! String
        
        let ai1 = (eventArray.object(at: i) as AnyObject).value(forKey: "artist_id")as! String
        
        let aimg = (eventArray.object(at: i) as AnyObject).value(forKey: "artist_img")as! String
        let ec = (eventArray.object(at: i) as AnyObject).value(forKey: "event_category")as! String
        let pid = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_id")as! String
        
        let spr = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_avg_rating")as! String
        if spr == ""
        {
            providerRating = "0" + "/5"
        }
        else
        {
            providerRating = spr + "/5"
        }
        
        let ar = (eventArray.object(at: i) as AnyObject).value(forKey: "artist_avg_rating")as! String
        if ar == ""
        {
            artistRating = "0" + "/5"
        }
        else
        {
            artistRating = ar + "/5"
        }
        
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
        eventView.isHidden = false
    }
}
}
