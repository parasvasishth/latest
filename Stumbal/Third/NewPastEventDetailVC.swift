//
//  NewPastEventDetailVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 08/02/22.
//

import UIKit
import Kingfisher
import Alamofire
import MapKit
import EventKit
import EventKitUI
import CoreLocation
class NewPastEventDetailVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var eventDetailLbl: UILabel!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectEventimg: UIImageView!
    @IBOutlet weak var selecteventNameLbl: UILabel!
    @IBOutlet weak var invitelbl: UILabel!
    @IBOutlet weak var attendingLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var calenderLbl: UILabel!
    @IBOutlet weak var refundView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    var cateArr:[String] = [String]()
    private let spacing2:CGFloat = 10.0
    var hud = MBProgressHUD()
    let eventStore = EKEventStore()
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
    let geocoder = CLGeocoder()
    private var tileRenderer: MKTileOverlayRenderer?
    var distance:String = ""
    var cat_id:String = ""
   // var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        let pimg:String = UserDefaults.standard.value(forKey: "e_profile") as! String
        
        if pimg == ""
        {
            self.selectEventimg.image = UIImage(named: "edefault")
        }
        else
        {
            let url = URL(string: pimg)
            let processor = DownsamplingImageProcessor(size: self.selectEventimg.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 0)
            self.selectEventimg.kf.indicatorType = .activity
            self.selectEventimg.kf.setImage(
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
                    self.selectEventimg.image = UIImage(named: "edefault")
                }
            }
            
        }
        
       // categoryCollView.dataSource = self
 //       categoryCollView.delegate = self
        let pn:String = UserDefaults.standard.value(forKey: "e_providername") as! String
        let en:String = UserDefaults.standard.value(forKey: "e_name") as! String
        
        eventNameLbl.text = en + " at " + pn
        selecteventNameLbl.text = en + " at " + pn
        addressLbl.text = UserDefaults.standard.value(forKey: "e_provideradd") as! String
      //  dateLbl.text = UserDefaults.standard.value(forKey: "e_time") as! String
        eventDetailLbl.text = UserDefaults.standard.value(forKey: "Event_desc") as! String
        
        let p = UserDefaults.standard.value(forKey: "Event_ticketprice") as! String
        let tpu2 =  Float(p)!.currencyUS
        
        priceLbl.text = tpu2
        
        let od:String = UserDefaults.standard.value(forKey: "e_opend") as! String
        let cd:String = UserDefaults.standard.value(forKey: "e_closed") as! String
        let ot:String = UserDefaults.standard.value(forKey: "e_opent") as! String
        let ct:String = UserDefaults.standard.value(forKey: "e_closet") as! String
        
        dateLbl.text = od + " - " + cd
        timeLbl.text = ot + " - " + ct
        
        
        cateArr.append(UserDefaults.standard.value(forKey: "Event_categoryname") as! String)
        
//        let layout2 = UICollectionViewFlowLayout()
//        layout2.sectionInset = UIEdgeInsets(top: spacing2, left: spacing2, bottom: spacing2, right: spacing2)
//        layout2.minimumLineSpacing = spacing2
//        layout2.minimumInteritemSpacing = spacing2
//        layout2.scrollDirection = .horizontal
//        self.categoryCollView?.collectionViewLayout = layout2
        
//        if cateArr.count != 0
//        {
//            categoryCollView.isHidden = false
//            categoryCollView.reloadData()
//        }
//        else
//        {
//            categoryCollView.isHidden = true
//        }
        let c:String = UserDefaults.standard.value(forKey: "Event_categoryname") as! String
        catLbl.text = " " + c + " "
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
        invitelbl.isUserInteractionEnabled = true
        invitelbl.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        attendingLbl.isUserInteractionEnabled = true
        attendingLbl.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
        artistLbl.isUserInteractionEnabled = true
        artistLbl.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped4(tapGestureRecognizer:)))
        venueLbl.isUserInteractionEnabled = true
        venueLbl.addGestureRecognizer(tapGestureRecognizer4)
        
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(imageTapped5(tapGestureRecognizer:)))
        calenderLbl.isUserInteractionEnabled = true
        calenderLbl.addGestureRecognizer(tapGestureRecognizer5)
        // Do any additional setup after loading the view.
       // event_status()
        getCurrentlocationofUser()
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        selectView.isHidden = true
    }
    
    @IBAction func buy(_ sender: UIButton) {
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func selectBtn(_ sender: UIButton) {
        selectView.isHidden = false
    }
   
    @IBAction func refund(_ sender: UIButton) {
    }
    @IBAction func viewTicket(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewTicketVC") as! NewTicketVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
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
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewInviteFriendOnEventVC") as! NewInviteFriendOnEventVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewFriendOnEventVC") as! NewFriendOnEventVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer){
        if UserDefaults.standard.value(forKey: "Event_artid") as! String == ""
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BlankArtistProfileVC") as! BlankArtistProfileVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else
        {
//                var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistUserProfileVC") as! ArtistUserProfileVC
//                signuCon.modalPresentationStyle = .fullScreen
//                self.present(signuCon, animated: false, completion:nil)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewArtistUserProfileVC") as! NewArtistUserProfileVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
            
        }
    }
    
    @objc func imageTapped4(tapGestureRecognizer: UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewVenueDetailVC") as! NewVenueDetailVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @objc func imageTapped5(tapGestureRecognizer: UITapGestureRecognizer){
       
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = UserDefaults.standard.value(forKey: "e_name") as! String
                    
                    let od:String =  UserDefaults.standard.value(forKey: "e_opend") as! String
                    let cd:String =  UserDefaults.standard.value(forKey: "e_closed") as! String
                    
                    // UserDefaults.standard.setValue(cd, forKey: "e_closed")
                    // UserDefaults.standard.setValue(ct, forKey: "e_closet")
                    
                    
                    var dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    var s = dateFormatter.date(from: od)
                    var s1 = dateFormatter.date(from: cd)
                    // let h:String = od + "04:00 AM"
                    
                    
                    //                    let formatter = DateFormatter()
                    //                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    //                    formatter.dateFormat = "dd-MM-yyyy h:mm a"
                    //                    formatter.amSymbol = "AM"
                    //                    formatter.pmSymbol = "PM"
                    //
                    //                    let dateString = formatter.date(from: h)
                    
                    
                    event.startDate = s
                    event.endDate = s1
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = self.eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                    
                }
            }
            
            
        })
    }
    
    // MARK: - event_status
    func event_status()
    {
   
        
        //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //    hud.mode = MBProgressHUDMode.indeterminate
        //    hud.self.bezelView.color = UIColor.black
        //    hud.label.text = "Loading...."
        Alamofire.request("https://stumbal.com/process.php?action=event_status", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id":UserDefaults.standard.value(forKey: "Event_id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                        self.event_status()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                        
                    {
                        
              
                        
                        var result:String = json["status"] as! String
                        
                        if result == "You have book the ticket"
                        {
                            
                            
                        }
                        else
                        {
                           
                            
                        }
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
      //  fetch_nearby_event()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
      
            return cateArr.count
      
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let collection = self.categoryCollView{
            let width = (collection.bounds.width)
            return CGSize(width: width, height: 40)
        }else{
            return CGSize(width: 0, height: 0)
        }
        }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
     
            let cell = categoryCollView.dequeueReusableCell(withReuseIdentifier: "ProfileCategoriesCollectionViewCell", for: indexPath) as! ProfileCategoriesCollectionViewCell
            
        cell.cateLbl.text = cateArr[indexPath.row] as! String
            

            return cell
        }


}
extension NewPastEventDetailVC: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        
    }
}
extension NewPastEventDetailVC:MKMapViewDelegate
{
    //MARK: Show Route On Map
       func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           let renderer = MKPolylineRenderer(overlay: overlay)
           renderer.strokeColor = #colorLiteral(red: 0.8078431373, green: 0.6745098039, blue: 0.8392156863, alpha: 1)
           renderer.lineWidth = 5.0
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
//                annotationView.image = UIImage(named:"homer")
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
//                    return annotationView
//                }
//
//            }
//        return annotationView
//        }
}
