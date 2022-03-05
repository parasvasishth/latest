//
//  DirectionVC.swift
//  Stumbal
//
//  Created by mac on 17/06/21.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import Kingfisher
//
class custompin: NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
     var imageName: UIImage?
    init(pintitle:String,pinsubtitle:String,location:CLLocationCoordinate2D,pinimage:UIImage) {
        self.title = pintitle
        self.subtitle = pinsubtitle
        self.coordinate = location
         self.imageName = pinimage
    }
}
class DirectionVC: UIViewController,CLLocationManagerDelegate{

    @IBOutlet var showView: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var venueImg: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var floatrateView: FloatRatingView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    var sourcelat:Double = 0
    var sourcelong:Double = 0
    var destlat:Double = 0
    var destlong:Double = 0
    let anotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    var newPin = MKPointAnnotation()
    var lat:Float = 0
    var long:Float = 0
    var eventArray:NSMutableArray = NSMutableArray()
    var annotation1 = MKPointAnnotation()
    var latLongAry = NSMutableArray()
    var pastArray = NSMutableArray()
    var AppendArr = NSMutableArray()
    let geocoder = CLGeocoder()
    private var tileRenderer: MKTileOverlayRenderer?
    var distance:String = ""
    var cat_id:String = ""
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.layoutMargins.bottom = -100 // removes the 'legal' text
        mapView.layoutMargins.top = -100 // prevents unneeded misplacement of the camera
        
        self.showView.roundCorners([.topLeft, .topRight], radius: 15.0)
       // UserDefaults.standard.setValue(vi, forKey: "V_image")
       // UserDefaults.standard.setValue(id, forKey: "V_id")
        fetch_venue_detail()
       
        // Do any additional setup after loading the view.
    }
    
    // MARK: - fetch_venue_detail
    func  fetch_venue_detail()
    {

        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=fetch_venue_detail", method: .post, parameters: ["venue_id" : UserDefaults.standard.value(forKey: "V_id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.fetch_venue_detail()
                    }))
                    self.present(alert, animated: true, completion: nil)


                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary

                    {   self.nameLbl.text = json["vname"] as! String
                        self.addressLbl.text = json["address"] as! String
                        
                        UserDefaults.standard.setValue( json["vname"] as! String, forKey: "V_name")
                        UserDefaults.standard.setValue(json["address"] as! String, forKey: "V_add")
                       
                        let avg:String = json["avg_rating"] as! String
                        
                        if avg == ""
                        {
                            self.ratingLbl.text = "0.0"
                        }
                        else
                        {
                            self.ratingLbl.text = avg
                        }
                        
                        self.showView.isHidden = false
                      
                        MBProgressHUD.hide(for: self.view, animated: true)

                        self.fecth_Profile()
                    }
                    else
                    {
                        self.fecth_Profile()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }

    }
    
    @IBAction func touchBtn(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "HomeEvent")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewVenueDetailVC") as! NewVenueDetailVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func cancelView(_ sender: UIButton) {
        showView.isHidden = true
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
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
        
        Alamofire.request("https://stumbal.com/process.php?action=top_events", method: .post, parameters: ["lat":sourcelat,"lng":sourcelong], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_events()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.AppendArr = NSMutableArray()
                        self.eventArray = NSMutableArray()
                        self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        if self.AppendArr.count != 0 {
                            
                          
                            
                            
                            for i in 0...self.AppendArr.count-1
                            {
                                if (self.AppendArr.object(at: i) as AnyObject).value(forKey: "lat") as! String == "" {
                                } else {
                                    print((self.AppendArr.object(at:i) as AnyObject).value(forKey: "type"),i)
                                    self.eventArray.add(self.AppendArr[i])
                                }
                                
                            }
                            
                            if self.eventArray.count != 0 {
                                
                                for index in 0..<self.eventArray.count {
                                    
                                    for index in 0..<self.eventArray.count {
                                        let latData: String = (self.eventArray.object(at: index) as AnyObject).value(forKey: "lat") as! String
                                        let lat : Double = Double(latData)!
                                        let longData : String = (self.eventArray.object(at: index) as AnyObject).value(forKey: "lng") as! String
                                        let long : Double = Double(longData)!
                                        
                                        self.annotation1.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                       // print("lat",lat,long)
                                        let aryIndex:String = String(format: "%d", index)
                                      //  print("111",AnyIndex.self)
                                        
                                        let sikkim = CityLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude:long), title: aryIndex)
                                        
                                        self.annotation1.title = "5666565"
                                        self.latLongAry.add(sikkim)
                                        
                                    }
                                    if self.latLongAry.count != 0
                                    {
                                        self.mapView.addAnnotations(self.latLongAry as![MKAnnotation])
                                    }
                                    else
                                    {
                                        
                                    }
                                }
                                
                                MBProgressHUD.hide(for: self.view, animated: true);
                                print("Hello")
                                
                                
                                
                            }
                            
                            else  {
                                
                                
                            
                               MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        self.getdirection()
                    }
                    catch
                    {
                        print("error")
                    }
                    
                }

            }
        }
        
    }
    
    
    func fetch_nearby_event()
    {
        //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //hud.mode = MBProgressHUDMode.indeterminate
        //hud.self.bezelView.color = UIColor.black
        //hud.label.text = "Loading...."
        //  let id = UserDefaults.standard.value(forKey: "uid") as! String
        
     
 
        
    Alamofire.request("https://stumbal.com/process.php?action=fetch_nearby_vendor", method: .post,parameters:["lat":"0.0","lng":"0.0","distance":"0","cat_id":cat_id], encoding:  URLEncoding.httpBody).responseJSON
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
                                        self.pastArray = NSMutableArray()
                                        self.pastArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
                                        print("5566262")
                                        print(self.eventArray)
                                        
                                        if self.pastArray.count != 0
                                        {
                                            
                                            for i in 0...self.pastArray.count-1
                                            {
                                                if (self.pastArray.object(at: i) as AnyObject).value(forKey: "lat") as! String == "" {
                                                } else {
                                                    print((self.pastArray.object(at:i) as AnyObject).value(forKey: "type"),i)
                                                    self.eventArray.add(self.pastArray[i])
                                                }
                                                
                                            }
                                            
                                            if self.eventArray.count != 0 {
                                                
                                                for index in 0..<self.eventArray.count {
                                                    
                                                    for index in 0..<self.eventArray.count {
                                                        let latData: String = (self.eventArray.object(at: index) as AnyObject).value(forKey: "lat") as! String
                                                        let lat : Double = Double(latData)!
                                                        let longData : String = (self.eventArray.object(at: index) as AnyObject).value(forKey: "lng") as! String
                                                        let long : Double = Double(longData)!
                                                        
                                                        self.annotation1.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                                       // print("lat",lat,long)
                                                        let aryIndex:String = String(format: "%d", index)
                                                      //  print("111",AnyIndex.self)
                                                        
                                                        let sikkim = CityLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude:long), title: aryIndex)
                                                        
                                                        self.annotation1.title = "5666565"
                                                        self.latLongAry.add(sikkim)
                                                        
                                                    }
                                                    if latLongAry.count != 0
                                                    {
                                                        self.mapView.addAnnotations(self.latLongAry as![MKAnnotation])
                                                    }
                                                    else
                                                    {
                                                        
                                                    }
                                                }
                                                
                                                MBProgressHUD.hide(for: self.view, animated: true);
                                                print("Hello")
                                                
                                                
                                                
                                            }
                                            
                                            else  {
                                                
                                                
                                            
                                               MBProgressHUD.hide(for: self.view, animated: true)
                                            }
                                            
                                           
                                        }
                                        else
                                        {
                                           
                                           MBProgressHUD.hide(for: self.view, animated: true)
                                        }
                                    
                                        getdirection()
                                    }
                                    catch
                                    {
                                        print("error")
                                    }
                                    
                                }
                            }
                          }
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
                        self.cat_id = json["cat_name"] as! String
                        self.getCurrentlocationofUser()
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
    
    
    //MARK: Make Path
    func getdirection() {
      
  
        destlat = (UserDefaults.standard.value(forKey: "Event_lat") as! NSString).doubleValue
        destlong = (UserDefaults.standard.value(forKey: "Event_long") as! NSString).doubleValue
//        let source_lat = (UserDefaults.standard.value(forKey: "checkin_lat") as! NSString).doubleValue
//        let source_long = (UserDefaults.standard.value(forKey: "checkin_long") as! NSString).doubleValue
//        let dest_lat = (UserDefaults.standard.value(forKey: "checkout_lat") as! NSString).doubleValue
//        let dest_long = (UserDefaults.standard.value(forKey: "checkout_long") as! NSString).doubleValue
     //   sourcelat = UserDefaults.standard.value(forKey: "checkin_lat") as! String
      //  sourcelong = UserDefaults.standard.value(forKey: "checkin_long") as! String
      //  destlat = UserDefaults.standard.value(forKey: "checkout_lat") as! String
       // destlong = UserDefaults.standard.value(forKey: "checkout_long") as! String
        
//        let sourcecordinate = CLLocationCoordinate2DMake(sourcelat, sourcelong)
//        let destcoordinate = CLLocationCoordinate2DMake(destlat, destlong)
//        let sourcePin = custompin(pintitle: "My Address", pinsubtitle: "", location: sourcecordinate,pinimage: UIImage(named: "homer")!)
//               let destinationPin = custompin(pintitle: "Event Address", pinsubtitle: "", location: destcoordinate,pinimage: UIImage(named: "e")!)
        
        let sourcecordinate = CLLocationCoordinate2DMake(sourcelat, sourcelong)
        let destcoordinate = CLLocationCoordinate2DMake(destlat, destlong)
        let sourcePin = custompin(pintitle: "My Address", pinsubtitle: "", location: sourcecordinate,pinimage: UIImage(named: "source")!)
               let destinationPin = custompin(pintitle: "Event Address", pinsubtitle: "", location: destcoordinate,pinimage: UIImage(named: "desti")!)
    
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        //self.mapView.addAnnotation(newPin)
        
        let sourceplacemark = MKPlacemark(coordinate: sourcecordinate)
        let destiplacemark = MKPlacemark(coordinate: destcoordinate)
        
        let sourceitem = MKMapItem(placemark: sourceplacemark)
        let destitem = MKMapItem(placemark: destiplacemark)
        
        let directionrequest = MKDirections.Request()
        directionrequest.source = sourceitem
        directionrequest.destination = destitem
        directionrequest.transportType = .walking
        
        let direction = MKDirections(request: directionrequest)
        direction.calculate(completionHandler: {
            response, error in
            guard let response = response else{
                if let error = error{
                    print("something went wrong")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rekt  = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion.init(rekt), animated: true)
           // self.fetch_nearby_event()
        })
       // self.performGoogleSearch(userlat: self.sourcelat, userlong: self.sourcelong, destlat: self.destlat, destlong: self.destlong)
    }
//  //MARK: Show Route On Map
//     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//         let renderer = MKPolylineRenderer(overlay: overlay)
//         renderer.strokeColor = UIColor.black
//         renderer.lineWidth = 3.0
//         return renderer
//     }
//       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//             let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
//             annotationView.image = UIImage(named:"pickup")
//             return annotationView
//         }
//  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//   //        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
//   //        annotationView.image = UIImage(named:"car_icon")
//   //        return annotationView
//
//           if !(annotation is custompin) {
//                   let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
//               annotationView.image = UIImage(named:"e")
//                           return annotationView
//
//           }
//
//           let reuseId = "restaurant"
//           var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//           if anView == nil {
//               anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//               anView!.canShowCallout = true
//           }
//           else {
//               anView!.annotation = annotation
//           }
//
//           let restaurantAnnotation = annotation as! custompin
//
//           if (restaurantAnnotation.imageName != nil) {
//               anView!.image = restaurantAnnotation.imageName!
//   //            anView!.image.layer.setCornerRadius(8.0)
//   //            anView!.image.layer.clipsToBounds=true
//           }
//           else {
//               // Perhaps set some default image
//           }
//
//           return anView
//       }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let location = locations.last! as CLLocation
        var center  = CLLocationCoordinate2D()
       
            sourcelat = Double(locValue.latitude)
            sourcelong = Double(locValue.longitude)
            
            //  lat = -33.826090
            // long = 150.996450
            center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            // center = CLLocationCoordinate2D(latitude: -33.826090, longitude: 150.996450)
            
            
        
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
            
            //set region on the map
            self.mapView.setRegion(region, animated: true)
        }) { (completed: Bool) -> Void in
        }
       
        newPin.coordinate = location.coordinate
        locationManager.stopUpdatingLocation()
       getdirection()
      //  fetch_events()
    }
}
extension DirectionVC:MKMapViewDelegate
{
    //MARK: Show Route On Map
       func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           let renderer = MKPolylineRenderer(overlay: overlay)
           renderer.strokeColor = UIColor.black
           renderer.lineWidth = 3.0
           return renderer
       }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        //   geoCode(location: location)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")

    }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//////        if UserDefaults.standard.bool(forKey: "eventdirection") == true
//////        {
////
////          //  UserDefaults.standard.set(false, forKey: "eventdirection")
////            if !(annotation is custompin) {
////                    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
////               // annotationView.image = UIImage(named:"e")
////                         //   return annotationView
////            }
////
////          let reuseId = "restaurant"
////            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
////            if anView == nil {
////                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
////                anView!.canShowCallout = true
////            }
////        return anView
////                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
////                let i:Int = ((annotation.title) as! NSString).integerValue
////
////
//////                //
//////                if eventArray.count != 0
//////                {
//////                    if (eventArray.object(at: i) as AnyObject).value(forKey: "provider_status") as! String == "Premium provider"
//////                    {
//////                        annotationView.image = UIImage(named:"imp")
//////                    }
//////                    else
//////                    {
//////                        annotationView.image = UIImage(named:"e")
//////                    }
//////
//////                    let titleval : String = (eventArray.object(at: i) as AnyObject).value(forKey: "vname") as! String
//////                    //  annotationView.canShowCallout = true
//////                  // annotationLabel.text = titleval
//////
//////                    // annotationView.addSubview(annotationLabel)
//////                    return annotationView
////               // }
////            }
////            else {
////                anView!.annotation = annotation
////            }
////
////            let restaurantAnnotation = annotation as! custompin
////
////            if (restaurantAnnotation.imageName != nil) {
////                anView!.image = restaurantAnnotation.imageName!
////    //            anView!.image.layer.setCornerRadius(8.0)
////    //            anView!.image.layer.clipsToBounds=true
////
////
////            }
////            else {
////                // Perhaps set some default image
////            }
////
////            return anView
//
//            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
//            if annotation.isEqual(mapView.userLocation){
//                annotationView.image = UIImage(named:"user")
//
//               // return annotationView
//            }else{
//
//                let annotationLabel = UILabel(frame: CGRect(x: -40, y: -35, width: 105, height: 30))
//                annotationLabel.numberOfLines = 3
//                annotationLabel.textAlignment = .center
//                annotationLabel.backgroundColor = .white
//                annotationLabel.font = UIFont(name: "Rockwell", size: 10)
//                let i:Int = ((annotation.title) as! NSString).integerValue
//
//
//                //
//                if eventArray.count != 0
//                {
//                    if (eventArray.object(at: i) as AnyObject).value(forKey: "provider_status") as! String == "Premium provider"
//                    {
//                        annotationView.image = UIImage(named:"mapdot")
//                    }
//                    else
//                    {
//                        annotationView.image = UIImage(named:"mapdot")
//                    }
//
//                    let titleval : String = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name") as! String
//                    //  annotationView.canShowCallout = true
//                    annotationLabel.text = titleval
//
//                    // annotationView.addSubview(annotationLabel)
//                    return annotationView
//                }
//
//            }
//        return annotationView
//        }
//
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                
        //        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
        //        annotationView.image = UIImage(named:"car_icon")
        //        return annotationView
                
                if !(annotation is custompin) {
                        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
                    annotationView.image = UIImage(named:"source")
                                return annotationView
                 
                }
                
                let reuseId = "restaurant"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if anView == nil {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                }
                else {
                    anView!.annotation = annotation
                }
                
                let restaurantAnnotation = annotation as! custompin
                
                if (restaurantAnnotation.imageName != nil) {
                    anView!.image = restaurantAnnotation.imageName!
        //            anView!.image.layer.setCornerRadius(8.0)
        //            anView!.image.layer.clipsToBounds=true
                }
                else {
                    // Perhaps set some default image
                }
                
                return anView
            }
//        else
//        {
//            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
//            if annotation.isEqual(mapView.userLocation){
//                annotationView.image = UIImage(named:"user")
//
//                return annotationView
//            }else{
//
//                let annotationLabel = UILabel(frame: CGRect(x: -40, y: -35, width: 105, height: 30))
//                annotationLabel.numberOfLines = 3
//                annotationLabel.textAlignment = .center
//                annotationLabel.backgroundColor = .white
//                annotationLabel.font = UIFont(name: "Rockwell", size: 10)
//                let i:Int = ((annotation.title) as! NSString).integerValue
//
//
//                //
//                if eventArray.count != 0
//                {
//                    if (eventArray.object(at: i) as AnyObject).value(forKey: "provider_status") as! String == "Premium provider"
//
//                    {
//                        annotationView.image = UIImage(named:"imp")
//                    }
//                    else
//                    {
//                        annotationView.image = UIImage(named:"e")
//                    }
//
//                    let titleval : String = (eventArray.object(at: i) as AnyObject).value(forKey: "vname") as! String
//                    //  annotationView.canShowCallout = true
//                    annotationLabel.text = titleval
//
//                    // annotationView.addSubview(annotationLabel)
//
//                }
//                return annotationView
//            }
//        }


   // }

//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
//        print("didSelectAnnotationTapped")
//
//        if  eventArray.count != 0
//        {
//            var selectedAnnotation = view.annotation
//
//            let i:Int = ((selectedAnnotation?.title) as! NSString).integerValue
//
//            let titleval : String = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name") as! String
//            print("144",titleval)
//
//
//            nameLbl.text = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name")as! String
//
//            addressLbl.text = (eventArray.object(at: i) as AnyObject).value(forKey: "address")as! String
//
//           // floatrateView.rating = ((eventArray.object(at: i) as AnyObject).value(forKey: "avg_rating")as! NSString).doubleValue
//            ratingLbl.text = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_avg_rating") as! String
//
//
////            let eimg:String = (eventArray.object(at: i) as AnyObject).value(forKey: "venue_img")as! String
////
////            if eimg == ""
////            {
////                self.venueImg.image = UIImage(named: "vdefault")
////
////            }
////            else
////            {
////                let url = URL(string: eimg)
////                let processor = DownsamplingImageProcessor(size: self.venueImg.bounds.size)
////                    |> RoundCornerImageProcessor(cornerRadius: 0)
////                self.venueImg.kf.indicatorType = .activity
////                self.venueImg.kf.setImage(
////                    with: url,
////                    placeholder: nil,
////                    options: [
////                        .processor(processor),
////                        .scaleFactor(UIScreen.main.scale),
////                        .transition(.fade(1)),
////                        .cacheOriginalImage
////                    ])
////                {
////                    result in
////                    switch result {
////                    case .success(let value):
////                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
////                    case .failure(let error):
////                        print("Job failed: \(error.localizedDescription)")
////                        self.venueImg.image = UIImage(named: "vdefault")
////                    }
////                }
////
////            }
//            let vn = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name")as! String
//            let add = (eventArray.object(at: i) as AnyObject).value(forKey: "address")as! String
//          //  let vi = (eventArray.object(at: i) as AnyObject).value(forKey: "venue_img")as! String
//            let id = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_id")as! String
//          //  let c = (eventArray.object(at: i) as AnyObject).value(forKey: "contact")as! String
//
//
//            UserDefaults.standard.setValue(vn, forKey: "V_name")
//            UserDefaults.standard.setValue(add, forKey: "V_add")
//           // UserDefaults.standard.setValue(vi, forKey: "V_image")
//            UserDefaults.standard.setValue(id, forKey: "V_id")
//           // UserDefaults.standard.setValue(c, forKey: "V_contact")
//            showView.isHidden = false
//
//        }
//        else
//        {
//            print("1111")
//        }
//
//
//    }

}
