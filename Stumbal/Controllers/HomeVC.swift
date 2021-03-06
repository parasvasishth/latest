//
//  HomeVC.swift
//  Stumbal
//
//  Created by mac on 17/03/21.
//

import UIKit
import MapKit
import Alamofire
import GooglePlaces
import SDWebImage
import Kingfisher
class CityLocation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.title = title
        self.coordinate = coordinate
    }
}

class HomeVC: UIViewController,UISearchBarDelegate,CLLocationManagerDelegate,UITextFieldDelegate,GMSAutocompleteViewControllerDelegate,SWRevealViewControllerDelegate {
    
    @IBOutlet var menu: UIButton!
    @IBOutlet var testImge: UIImageView!
    @IBOutlet var ratingView: FloatRatingView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var eventnameLbl: UILabel!
    @IBOutlet var showView: UIView!
    @IBOutlet var providerNamelbl: UILabel!
    @IBOutlet var timelbl: UILabel!
    var hud = MBProgressHUD()
    @IBOutlet var eventImg: UIImageView!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var searchFeild: UITextField!
    @IBOutlet var menuObj1: UIButton!
    @IBOutlet var loadingView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventMenu: UIButton!
    @IBOutlet weak var hilLbl: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var exploreObj: UIButton!
    @IBOutlet weak var eventTblView: UITableView!
    @IBOutlet weak var mapExploreView: UIView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var gpsObj: UIButton!
    @IBOutlet weak var mapmenuObj: UIButton!
    @IBOutlet weak var newSearchImg: UIImageView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var exploreGpsObj: UIButton!
    var lat:Float = 0
    var long:Float = 0
    var locationManager = CLLocationManager()
    var newPin = MKPointAnnotation()
    var eventArray:NSMutableArray = NSMutableArray()
    var annotation1 = MKPointAnnotation()
    var latLongAry = NSMutableArray()
    var pastArray = NSMutableArray()
    var AppendArr:NSMutableArray = NSMutableArray()
    
    let geocoder = CLGeocoder()
    private var tileRenderer: MKTileOverlayRenderer?
    var distance:String = ""
    var cat_id:String = ""
    var providerRating:String = ""
    var artistRating:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        //searchFeild.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.loadingView.isHidden = false
    //mapView.layer.backgroundColor = #colorLiteral(red: 0.8078431373, green: 0.6745098039, blue: 0.8392156863, alpha: 1)
        
        showView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        mapView.isHidden = true
        eventTblView.backgroundColor = .clear
        eventTblView.dataSource = self
        eventTblView.delegate = self
            searchFeild.attributedPlaceholder =
            NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1) ])
        
     
        //Search event by location
   
        mapView.layoutMargins.bottom = -100 // removes the 'legal' text
        mapView.layoutMargins.top = -100 // prevents unneeded misplacement of the camera
        
        menu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        menuObj1.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        eventMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.revealViewController().delegate = self
        
        searchFeild.delegate = self
        searchFeild.text = ""
        
    
        
        UserDefaults.standard.set(false, forKey: "isotherlocation")
        UserDefaults.standard.removeObject(forKey: "usersource_lat")
        UserDefaults.standard.removeObject(forKey: "usersource_long")
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .left
        self.view.addGestureRecognizer(swipeDown)
    
        mapView.delegate = self
        
        backgroundImg.layer.masksToBounds = false
        backgroundImg.layer.shadowColor = #colorLiteral(red: 0.1058823529, green: 0.003921568627, blue: 0.1529411765, alpha: 1)
        backgroundImg.layer.shadowOpacity = 0.50
        backgroundImg.layer.shadowRadius = 2
        backgroundImg.layer.cornerRadius = 2
        
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5) 
       // self.tabBarController?.tabBar.isHidden = true
       
    }


    override func viewWillAppear(_ animated: Bool) {
        self.loadingView.isHidden = false
        if UserDefaults.standard.bool(forKey: "isotherlocation") == true
        {
           
            check_artist_user()
            //self.getCurrentlocationofUser()
            
        }
        else
        {
            UserDefaults.standard.set(false, forKey: "isotherlocation")
            UserDefaults.standard.removeObject(forKey: "usersource_lat")
            UserDefaults.standard.removeObject(forKey: "usersource_long")
            searchFeild.text = ""
            if UserDefaults.standard.bool(forKey: "HomeEvent") == true
            {
                UserDefaults.standard.set(false, forKey: "HomeEvent")
                
            }
            else
            {
//                for annotation in mapView.annotations{
//                    mapView.removeAnnotation(annotation)
//                }
//                mapView.removeOverlays(mapView.overlays)
//                mapView.delegate = self
                check_artist_user()
//                DispatchQueue.main.async { [self] in
//                    self.mapView.addAnnotation(annotation1) //Yes!! This method adds the annotations
//                }
                // getCurrentlocationofUser()
            }
           
        }
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }

    }
    
    // MARK: - fetch_user_distance
    func fetch_user_distance()
    {
        
        //        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.indeterminate
        //        hud.self.bezelView.color = UIColor.black
        //        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=fetch_user_distance", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
        { [self] response in
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
                        self.fetch_user_distance()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
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
                        self.fecth_Profile()
                        
                        // MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
        
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        
        switch position {
        
        case FrontViewPosition.leftSideMostRemoved:
            print("LeftSideMostRemoved")
        // UserDefaults.standard.set(true, forKey: "homesw")
        // Left most position, front view is presented left-offseted by rightViewRevealWidth+rigthViewRevealOverdraw
        
        case FrontViewPosition.leftSideMost:
            print("LeftSideMost")
        // Left position, front view is presented left-offseted by rightViewRevealWidth
        
        case FrontViewPosition.leftSide:
            print("LeftSide")
            
        // Center position, rear view is hidden behind front controller
        case FrontViewPosition.left:
            print("Left")
            //Closed
            //0 rotation
            UserDefaults.standard.set(false, forKey: "homesw")
            
            
        // Right possition, front view is presented right-offseted by rearViewRevealWidth
        case FrontViewPosition.right:
            print("Right")
            UserDefaults.standard.set(true, forKey: "homesw")
        //Opened
        //rotated
        
        // Right most possition, front view is presented right-offseted by rearViewRevealWidth+rearViewRevealOverdraw
        
        case FrontViewPosition.rightMost:
            print("RightMost")
            
        // Front controller is removed from view. Animated transitioning from this state will cause the sam
        // effect than animating from FrontViewPositionRightMost. Use this instead of FrontViewPositionRightMost when
        // you intent to remove the front controller view from the view hierarchy.
        
        case FrontViewPosition.rightMostRemoved:
            print("RightMostRemoved")
            
        }
        
    }
    
    @IBAction func exploreGps(_ sender: UIButton) {
        
    }
    
    @IBAction func exploreBtn(_ sender: UIButton) {
        mapView.isHidden = false
       // searchView.isHidden = false
        gpsObj.isHidden = false
        mapmenuObj.isHidden = false
        newSearchImg.isHidden = false
        searchFeild.isHidden = false
    }
    
    @IBAction func gps(_ sender: UIButton) {
        searchFeild.text = ""
        getCurrentlocationofUser()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                self.revealViewController().panGestureRecognizer().isEnabled = true
            case .down:
                print("Swiped down")
            case .left:
                self.revealViewController().panGestureRecognizer().isEnabled = true
                
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    // MARK: - fecth_Profile
    func fecth_Profile()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
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
                        let n:String = json["fname"] as! String 
                        self.hilLbl.text = "Hi" + " " + n + "."
                        self.getCurrentlocationofUser()
                        MBProgressHUD.hide(for: self.view, animated: true)
                
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
    
    
    // MARK: - check_artist_user
    func check_artist_user()
    {
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=check_artist_user", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.check_artist_user()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        
                        let result:String = json["result"] as! String
                        
                        if result == "artist"
                        {
                            
                            
                            UserDefaults.standard.setValue(json["result"] as! String, forKey: "checkuser")
                            UserDefaults.standard.setValue(json["artist_id"] as! String, forKey: "ap_artId")
                            // MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                        else
                        {
                            UserDefaults.standard.setValue(json["result"] as! String, forKey: "checkuser")
                            // MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                        self.fetch_user_distance()
                        
                        
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
    
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition)
    {
        if position == FrontViewPosition.left     // if it not statisfy try this --> if revealController.frontViewPosition == FrontViewPosition.Left
        {
            self.view.isUserInteractionEnabled = true
            revealController.panGestureRecognizer().isEnabled=true
        }
        else
        {
            self.view.isUserInteractionEnabled = false
            revealController.panGestureRecognizer().isEnabled=false
        }
    }
    
    @IBAction func cancelView(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = false
        showView.isHidden = true
        exploreGpsObj.isHidden = true
       

    }
    
    
    @IBAction func selectevent(_ sender: UIButton) {
        //showView.isHidden = true
        
        UserDefaults.standard.set(true, forKey: "HomeEvent")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewVenueDetailVC") as! NewVenueDetailVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchFeild
        {
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.modalPresentationStyle = .fullScreen
            autocompleteController.delegate = self
            present(autocompleteController, animated: false, completion: nil)
        }
    }

    
    // MARK: - Current location Function
    func  getCurrentlocationofUser(){
        self.locationManager.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self;
        self.map.showsUserLocation = true
        self.map.delegate = self;
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
        
        Alamofire.request("https://stumbal.com/process.php?action=top_events", method: .post, parameters: ["lat":lat,"lng":long], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                            
                           // self.statusLbl.isHidden = true
                            self.eventTblView.isHidden = false
                            self.eventTblView.reloadData()
                            
                            
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
                                self.loadingView.isHidden = true
                                
                                self.tabBarController?.tabBar.isHidden = false
                            }
                            
                            else  {
                                
                                
                            
                               MBProgressHUD.hide(for: self.view, animated: true)
                                self.loadingView.isHidden = true
                                self.tabBarController?.tabBar.isHidden = false
                            }
                           
                            self.loadingView.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.eventTblView.isHidden = true
                           // self.statusLbl.isHidden = false
                            //  self.selectcardLbl.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.loadingView.isHidden = true
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

    
    //MARK: Google Place Picker Delegate Methods
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        searchFeild.text = place.formattedAddress
        
        lat = Float(place.coordinate.latitude)
        long = Float(place.coordinate.longitude)
        
        UserDefaults.standard.set(String(lat), forKey: "usersource_lat")
        UserDefaults.standard.set(String(long), forKey: "usersource_long")
        print("1444")
        searchFeild.text = place.formattedAddress
        
        UserDefaults.standard.set(true, forKey: "isotherlocation")
        
        dismiss(animated: false, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
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
                // UserDefaults.standard.set(false, forKey: "isotherlocation")
                center = CLLocationCoordinate2D(latitude: (UserDefaults.standard.value(forKey: "usersource_lat") as! NSString).doubleValue, longitude: (UserDefaults.standard.value(forKey: "usersource_long") as! NSString).doubleValue)
                
            }
        }
        else{
            lat = Float(locValue.latitude)
            long = Float(locValue.longitude)
            
            //  lat = -33.826090
            // long = 150.996450
            center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            // center = CLLocationCoordinate2D(latitude: -33.826090, longitude: 150.996450)
        }
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: { [self] in
            
            //set region on the map
            self.mapView.setRegion(region, animated: true)
           
        }) { (completed: Bool) -> Void in
        }
        locationManager.stopUpdatingLocation()
     
        newPin.coordinate = location.coordinate
        
        
        if UserDefaults.standard.bool(forKey: "eventdirection") == true
        {
            getdirection()
        }
        else
        {
           // fetch_nearby_event()
            
            fetch_events()
        }
     
        MBProgressHUD.hide(for: self.view, animated: true)
    }
   
    //MARK: Make Path
    func getdirection() {
      
  
     let destlat = (UserDefaults.standard.value(forKey: "Event_lat") as! NSString).doubleValue
     let destlong = (UserDefaults.standard.value(forKey: "Event_long") as! NSString).doubleValue

//        self.mapView.removeOverlays(self.mapView.overlays)
//        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let sourcecordinate = CLLocationCoordinate2DMake(Double(lat), Double(long))
        let destcoordinate = CLLocationCoordinate2DMake(destlat, destlong)
        let sourcePin = custompin(pintitle: "My Address", pinsubtitle: "", location: sourcecordinate,pinimage: UIImage(named: "homer")!)
               let destinationPin = custompin(pintitle: "Event Address", pinsubtitle: "", location: destcoordinate,pinimage: UIImage(named: "e")!)
    
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
            self.fetch_nearby_event()
        })
       // self.performGoogleSearch(userlat: self.sourcelat, userlong: self.sourcelong, destlat: self.destlat, destlong: self.destlong)
    }
    
   
    
  
//       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//             let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
//             annotationView.image = UIImage(named:"pickup")
//             return annotationView
//         }


    
   
    
  
    func fetch_nearby_event()
    {
        //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //hud.mode = MBProgressHUDMode.indeterminate
        //hud.self.bezelView.color = UIColor.black
        //hud.label.text = "Loading...."
        //  let id = UserDefaults.standard.value(forKey: "uid") as! String
        
        if UserDefaults.standard.bool(forKey: "isotherlocation") == true
        {
            UserDefaults.standard.set(false, forKey: "isotherlocation")
            
        }
        else
        {
            if UserDefaults.standard.bool(forKey: "tabcategory") == true
            {
                
            }
            else
            {
                lat = 0
                long = 0
                distance = "0"
            }
        }
        
        if UserDefaults.standard.bool(forKey: "tabcategory") == true
        {
            cat_id = UserDefaults.standard.value(forKey: "tab_Cat_id") as! String
            UserDefaults.standard.set(false, forKey: "tabcategory")
           // self.lat = self.lat
           // long = long
           // distance = distance
        }
        else
        {
            
        }
        
    Alamofire.request("https://stumbal.com/process.php?action=fetch_nearby_vendor", method: .post,parameters:["lat":lat,"lng":long,"distance":distance,"cat_id":cat_id], encoding:  URLEncoding.httpBody).responseJSON
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
                                    self.loadingView.isHidden = true
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
                                                
                                                self.loadingView.isHidden = true
                                                
                                            }
                                            
                                            else  {
                                                
                                                self.loadingView.isHidden = true
                                            
                                               MBProgressHUD.hide(for: self.view, animated: true)
                                            }
                                            
                                           
                                        }
                                        else
                                        {
                                            self.loadingView.isHidden = true
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
    
}
extension HomeVC:MKMapViewDelegate
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

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if UserDefaults.standard.bool(forKey: "eventdirection") == true
        {

            UserDefaults.standard.set(false, forKey: "eventdirection")
            if !(annotation is custompin) {
                    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
                annotationView.image = UIImage(named:"mapdot")
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


                //
                if eventArray.count != 0
                {
                    if (eventArray.object(at: i) as AnyObject).value(forKey: "provider_status") as! String == "Premium provider"

                    {
                       // annotationView.image = UIImage(named:"imp")
                        annotationView.image = UIImage(named:"mapdot")
                       // mapdot
                    }
                    else
                    {
                       // annotationView.image = UIImage(named:"e")
                        annotationView.image = UIImage(named:"mapdot")
                    }

                    let titleval : String = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name") as! String
                    //  annotationView.canShowCallout = true
                    annotationLabel.text = titleval

                    // annotationView.addSubview(annotationLabel)

                }
                return annotationView
            }
        }
        else
        {
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


                //
                if eventArray.count != 0
                {
                    if (eventArray.object(at: i) as AnyObject).value(forKey: "provider_status") as! String == "Premium provider"

                    {
                       // annotationView.image = UIImage(named:"imp")
                        annotationView.image = UIImage(named:"mapdot")
                    }
                    else
                    {
                       // annotationView.image = UIImage(named:"e")
                        annotationView.image = UIImage(named:"mapdot")
                    }

                    let titleval : String = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name") as! String
                    //  annotationView.canShowCallout = true
                    annotationLabel.text = titleval

                    // annotationView.addSubview(annotationLabel)

                }
                return annotationView
            }
        }


    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        print("didSelectAnnotationTapped")

        if  eventArray.count != 0
        {
            var selectedAnnotation = view.annotation

            let i:Int = ((selectedAnnotation?.title) as! NSString).integerValue

            let titleval : String = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name") as! String
            print("144",titleval)


            eventnameLbl.text = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name")as! String

            addressLbl.text = (eventArray.object(at: i) as AnyObject).value(forKey: "address")as! String

            ratingLbl.text = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_avg_rating") as! String


//            let eimg:String = (eventArray.object(at: i) as AnyObject).value(forKey: "venue_img")as! String
//
//            if eimg == ""
//            {
//                self.eventImg.image = UIImage(named: "vdefault")
//
//            }
//            else
//            {
//                let url = URL(string: eimg)
//                let processor = DownsamplingImageProcessor(size: self.eventImg.bounds.size)
//                    |> RoundCornerImageProcessor(cornerRadius: 0)
//                self.eventImg.kf.indicatorType = .activity
//                self.eventImg.kf.setImage(
//                    with: url,
//                    placeholder: nil,
//                    options: [
//                        .processor(processor),
//                        .scaleFactor(UIScreen.main.scale),
//                        .transition(.fade(1)),
//                        .cacheOriginalImage
//                    ])
//                {
//                    result in
//                    switch result {
//                    case .success(let value):
//                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                    case .failure(let error):
//                        print("Job failed: \(error.localizedDescription)")
//                        self.eventImg.image = UIImage(named: "vdefault")
//                    }
//                }
//
//            }
            let vn = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_name")as! String
            let add = (eventArray.object(at: i) as AnyObject).value(forKey: "address")as! String
           // let vi = (eventArray.object(at: i) as AnyObject).value(forKey: "venue_img")as! String
            let id = (eventArray.object(at: i) as AnyObject).value(forKey: "provider_id")as! String
          //  let c = (eventArray.object(at: i) as AnyObject).value(forKey: "contact")as! String


            UserDefaults.standard.setValue(vn, forKey: "V_name")
            UserDefaults.standard.setValue(add, forKey: "V_add")
           // UserDefaults.standard.setValue(vi, forKey: "V_image")
            UserDefaults.standard.setValue(id, forKey: "V_id")
          //  UserDefaults.standard.setValue(c, forKey: "V_contact")
            showView.isHidden = false
            exploreGpsObj.isHidden = false
            tabBarController?.tabBar.isHidden = true
        }
        else
        {
            print("1111")
        }
    }

}
extension HomeVC : UITableViewDelegate,UITableViewDataSource
{
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
        let cell =  eventTblView.dequeueReusableCell(withIdentifier: "HomeEventListTableViewCell", for: indexPath) as! HomeEventListTableViewCell
        
        
        cell.eventNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
       // 1B0127
//        cell.eventNameLbl.layer.shadowPath = UIBezierPath(rect: cell.eventNameLbl.bounds).cgPath
      cell.eventNameLbl.layer.masksToBounds = false
     cell.eventNameLbl.layer.shadowColor = #colorLiteral(red: 0.1058823529, green: 0.003921568627, blue: 0.1529411765, alpha: 1)
        cell.eventNameLbl.layer.shadowRadius = 2
    //cell.eventNameLbl.layer.shadowOffset =
        cell.eventNameLbl.layer.shadowOpacity = 0.80
        
        
//cell.eventNameLbl.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor
    
       // cell.eventNameLbl.layer.cornerRadius = 10.0
        
        
     
     
       // cell.eventNameLbl.layer.cornerRadius = 2
        
     
       // cell.eventimg.contentMode = .center
   
     //  DispatchQueue.main.async { [self] in
       //     cell.eventListView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
//
     //   }
        cell.eventimg.roundCorners5([.topLeft, .topRight], radius: 10)

//
        let eimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
    
    
    
        if eimg == ""
        {
            cell.eventimg.image = UIImage(named: "edefault")
    
        }
        else
        {
            let url = URL(string: eimg)
            let processor = DownsamplingImageProcessor(size: cell.eventimg.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 0)
            cell.eventimg.kf.indicatorType = .activity
            cell.eventimg.kf.setImage(
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
                    cell.eventimg.image = UIImage(named: "edefault")
                }
            }
    
        }
        
//        eventImg.layer.masksToBounds = false
//        eventImg.layer.shadowColor = UIColor.black.cgColor
//        eventImg.layer.shadowOpacity = 0.50
//        eventImg.layer.shadowRadius = 4
//        eventImg.layer.cornerRadius = 0
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
        let edesc = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_desc")as! String
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

        UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
        UserDefaults.standard.setValue(n, forKey: "Event_name")
        UserDefaults.standard.setValue(cn, forKey: "Event_cat")
        UserDefaults.standard.setValue(ai1, forKey: "Event_artid")
        UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
        UserDefaults.standard.setValue(providerRating, forKey: "Event_providerrating")
        UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
        UserDefaults.standard.setValue(pid, forKey: "V_id")

        let f = od + " to " + cd + " timing " + ot + " to " + ct


        UserDefaults.standard.setValue(od, forKey: "e_opend")
        UserDefaults.standard.setValue(ot, forKey: "e_opent")
        UserDefaults.standard.setValue(cd, forKey: "e_closed")
        UserDefaults.standard.setValue(ct, forKey: "e_closet")

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
//        let alert = UIAlertController(title: "", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    public func roundCorners5(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}


//extension UIView {
//
//    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//        if #available(iOS 11.0, *) {
//            clipsToBounds = true
//            layer.cornerRadius = radius
//            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
//        } else {
//            let path = UIBezierPath(
//                roundedRect: bounds,
//                byRoundingCorners: corners,
//                cornerRadii: CGSize(width: radius, height: radius)
//            )
//            let mask = CAShapeLayer()
//            mask.path = path.cgPath
//            layer.mask = mask
//        }
//    }
//}
extension UIView {

func roundCorners(corners:UIRectCorner, radius: CGFloat) {
    
    DispatchQueue.main.async {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
}
