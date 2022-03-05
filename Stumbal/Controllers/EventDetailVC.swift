//
//  EventDetailVC.swift
//  Stumbal
//
//  Created by mac on 24/03/21.
//

import UIKit
import CoreLocation
import MapKit
import SDWebImage
import Kingfisher
import Alamofire
import EventKit
import EventKitUI
import AlignedCollectionViewFlowLayout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
class TagsLayout: UICollectionViewFlowLayout {
    
    required override init() {super.init(); common()}
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder); common()}
    
    private func common() {
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }
    
    override func layoutAttributesForElements(
                    in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let att = super.layoutAttributesForElements(in:rect) else {return []}
        var x: CGFloat = sectionInset.left
        var y: CGFloat = -1.0
        
        for a in att {
            if a.representedElementCategory != .cell { continue }
            
            if a.frame.origin.y >= y { x = sectionInset.left }
            a.frame.origin.x = x
            x += a.frame.width + minimumInteritemSpacing
            y = a.frame.maxY
        }
        return att
    }
}
class EventDetailVC: UIViewController,CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var eventnameLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var eventImg: UIImageView!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var ratingusernameLbl: UILabel!
    @IBOutlet var ratingView: FloatRatingView!
    @IBOutlet var ratingtextHeight: NSLayoutConstraint!
    @IBOutlet var ratingheight: NSLayoutConstraint!
    @IBOutlet var reviewLbl: UILabel!
    @IBOutlet var reviewheight: NSLayoutConstraint!
    @IBOutlet var viewallobj: UIButton!
    @IBOutlet var viewallHeight: NSLayoutConstraint!
    @IBOutlet var ratingTxtlbl: UILabel!
    @IBOutlet var usernameHeight: NSLayoutConstraint!
    @IBOutlet var trailHeight: NSLayoutConstraint!
    @IBOutlet var lblheight: NSLayoutConstraint!
    @IBOutlet var lbl2: UILabel!
    
    @IBOutlet var collHeight: NSLayoutConstraint!
    @IBOutlet var btncollectionView: UICollectionView!
    var eventArray:NSMutableArray = NSMutableArray()
    var hud = MBProgressHUD()
    //  let eventStore : EKEventStore = EKEventStore()
    let eventStore = EKEventStore()
    var categoryArray:NSMutableArray = NSMutableArray()
    private let spacing:CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.bool(forKey: "past_event") == true
        {
            categoryArray = ["Direction","View Artist","Venue","Review","Friends On Event"]
        }
        else
        {
            categoryArray = ["Direction","Add To Calendar","Invite Friend","Buy Tickets","View Artist","Venue","Review","Friends On Event"]
        }
        
        btncollectionView.dataSource = self
        btncollectionView.delegate = self
        btncollectionView.reloadData()
        btncollectionView.isHidden = false
        eventImg.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
        //    let layout = UICollectionViewCenterLayout()
        //    layout.estimatedItemSize = CGSize(width: 140, height: 40)
        //    btncollectionView.collectionViewLayout = layout
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.btncollectionView?.collectionViewLayout = layout
        
        
        let alignedFlowLayout = btncollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
    }
    override func viewWillAppear(_ animated: Bool) {
        
        fetch_provider_review_rating()
    }
    @IBOutlet var vendorLbl: UILabel!
    @IBAction func addtocalender(_ sender: UIButton) {
        
        //        guard let url = URL(string: "calshow://") else { return }
        //        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        
        eventStore.requestAccess(to: .event) { [self] (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: self.eventStore)
                
                event.title = "Test Title1235"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "This is a note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else{
                
                print("failed to save event with error : \(error) or access not granted")
            }
        }
        
    }
    @IBAction func review(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "EventRating")
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "VendorRatingVC") as! VendorRatingVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    
    @IBAction func viewall(_ sender: UIButton) {
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "EventReviewVC") as! EventReviewVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func direction(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "eventdirection")
        let la = (UserDefaults.standard.value(forKey: "Event_lat") as! NSString).doubleValue
        let lo = (UserDefaults.standard.value(forKey: "Event_long") as! NSString).doubleValue
        let add = UserDefaults.standard.value(forKey: "e_provideradd") as! String
        let coordinate = CLLocationCoordinate2DMake(la, lo)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = add
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func invite(_ sender: UIButton) {
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    @IBAction func buyTicket(_ sender: UIButton) {
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "BuyTicketVC") as! BuyTicketVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    @IBAction func venue(_ sender: UIButton) {
        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ServiceProviderDetailVC") as! ServiceProviderDetailVC
        signuCon.modalPresentationStyle = .fullScreen
        self.present(signuCon, animated: false, completion:nil)
    }
    @IBAction func viewArtist(_ sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: "Event_artid") as! String == ""
        {
            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "BlankArtistProfileVC") as! BlankArtistProfileVC
            signuCon.modalPresentationStyle = .fullScreen
            self.present(signuCon, animated: false, completion:nil)
        }
        else
        {
            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ArtistUserProfileVC") as! ArtistUserProfileVC
            signuCon.modalPresentationStyle = .fullScreen
            self.present(signuCon, animated: false, completion:nil)
            
//            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "NewArtistUserProfileVC") as! NewArtistUserProfileVC
//            signuCon.modalPresentationStyle = .fullScreen
//            self.present(signuCon, animated: false, completion:nil)
            
        }
        
    }
    
    // MARK: - Collection height Method
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.collHeight?.constant = self.btncollectionView.contentSize.height
    }
    
    
    
    //MARK: fetch_provider_review_rating ;
    func fetch_provider_review_rating()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "Event_id") as! String
        Alamofire.request("https://stumbal.com/process.php?action=fetch_event_review_ratings", method: .post, parameters: ["event_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_provider_review_rating()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.eventArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        if self.eventArray.count != 0 {
                            
                            self.vendorLbl.text = UserDefaults.standard.value(forKey: "e_providername") as! String
                            self.addressLbl.text = UserDefaults.standard.value(forKey: "e_provideradd") as! String
                            self.timeLbl.text = UserDefaults.standard.value(forKey: "e_time") as! String
                            self.eventnameLbl.text = UserDefaults.standard.value(forKey: "e_name") as! String
                            //                        if case let self.eventnameLbl.text = UserDefaults.standard.value(forKey: "e_name") as! String {
                            //
                            //                        }
                            
                            self.categoryLbl.text = UserDefaults.standard.value(forKey: "Event_categoryname") as! String
                            
                            
                            self.eventImg.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
                            let pimg:String = UserDefaults.standard.value(forKey: "e_profile") as! String
                            
                            if pimg == ""
                            {
                                self.eventImg.image = UIImage(named: "edefault")
                            }
                            else
                            {
                                let url = URL(string: pimg)
                                let processor = DownsamplingImageProcessor(size: self.eventImg.bounds.size)
                                    |> RoundCornerImageProcessor(cornerRadius: 0)
                                self.eventImg.kf.indicatorType = .activity
                                self.eventImg.kf.setImage(
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
                                        self.eventImg.image = UIImage(named: "edefault")
                                    }
                                }
                                
                            }
                            
                            
                            self.ratingLbl.text = UserDefaults.standard.value(forKey: "Event_providerrating") as! String
                            
                            
                            let vendor = self.eventArray[0] as! NSDictionary
                            self.ratingusernameLbl.text = vendor["name"] as! String
                            self.reviewLbl.text = vendor["review"] as! String
                            self.ratingView.rating = (vendor["rating"] as! NSString).doubleValue
                            
                            self.ratingtextHeight.constant = 21
                            self.ratingheight.constant = 30
                            self.usernameHeight.constant = 21
                            self.reviewheight.constant = 21
                            self.viewallHeight.constant = 40
                            self.lblheight.constant = 1
                            self.ratingView.isHidden = false
                            self.ratingTxtlbl.text = "Rating & Reviews"
                            self.viewallobj.isHidden = false
                            self.lbl2.isHidden = false
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            
                            self.vendorLbl.text = UserDefaults.standard.value(forKey: "e_providername") as! String
                            self.addressLbl.text = UserDefaults.standard.value(forKey: "e_provideradd") as! String
                            self.timeLbl.text = UserDefaults.standard.value(forKey: "e_time") as! String
                            self.eventnameLbl.text = UserDefaults.standard.value(forKey: "e_name") as! String
                            
                            //                        if case let self.eventnameLbl.text = UserDefaults.standard.value(forKey: "e_name") as! String {
                            //
                            //                        }
                            
                            self.categoryLbl.text = UserDefaults.standard.value(forKey: "Event_categoryname") as! String
                            
                            
                            self.eventImg.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
                            let pimg:String = UserDefaults.standard.value(forKey: "e_profile") as! String
                            
                            if pimg == ""
                            {
                                self.eventImg.image = UIImage(named: "edefault")
                            }
                            else
                            {
                                let url = URL(string: pimg)
                                let processor = DownsamplingImageProcessor(size: self.eventImg.bounds.size)
                                    |> RoundCornerImageProcessor(cornerRadius: 0)
                                self.eventImg.kf.indicatorType = .activity
                                self.eventImg.kf.setImage(
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
                                        self.eventImg.image = UIImage(named: "edefault")
                                    }
                                }
                                
                            }
                            
                            
                            self.ratingLbl.text = UserDefaults.standard.value(forKey: "Event_providerrating") as! String
                            
                            
                            
                            
                            self.ratingtextHeight.constant = 0
                            self.ratingheight.constant = 0
                            self.usernameHeight.constant = 0
                            self.reviewheight.constant = 0
                            self.viewallHeight.constant = 0
                            self.lblheight.constant = 0
                            
                            self.ratingView.isHidden = true
                            self.ratingTxtlbl.text = "Rating & Reviews"
                            self.viewallobj.isHidden = true
                            self.trailHeight.constant = 20
                            self.lbl2.isHidden = true
                            
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
    func addEventToCalendar() {
        
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = "Well"
                    event.startDate = Date()
                    event.endDate = Date()
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = self.eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                    
                }
            }
            
            
        })
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  categoryArray.count
    }
    
    //func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    //{
    //    self.viewWillLayoutSubviews()
    //}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 10
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.btncollectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 50.0)
        }else{
            return CGSize(width: 0, height: 0)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //
        //    guard let cell = btncollectionView.dequeueReusableCell(withReuseIdentifier: "titleCell",
        //                                                           for: indexPath) as? RoundedCollectionViewCell else {
        //        return RoundedCollectionViewCell()
        //    }
        //
        
        let cell = btncollectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailCollCell", for: indexPath) as! EventDetailCollCell
        
        cell.nameLbl.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.168627451, blue: 0.6823529412, alpha: 1)
        cell.nameLbl.text = categoryArray[indexPath.row] as! String
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categoryArray[indexPath.row] as! String == "Direction"
        {
            //        let la = (UserDefaults.standard.value(forKey: "Event_lat") as! NSString).doubleValue
            //        let lo = (UserDefaults.standard.value(forKey: "Event_long") as! NSString).doubleValue
            //
            //        let add = UserDefaults.standard.value(forKey: "e_provideradd") as! String
            //        let coordinate = CLLocationCoordinate2DMake(la, lo)
            //        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            //        mapItem.name = add
            //        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            
            //UserDefaults.standard.set(true, forKey: "eventdirection")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DirectionVC") as! DirectionVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
            
        }
        else if categoryArray[indexPath.row] as! String == "Add To Calendar"
        {
            
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
        else if categoryArray[indexPath.row] as! String == "Invite Friend"
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewInviteFriendOnEventVC") as! NewInviteFriendOnEventVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        
        else if categoryArray[indexPath.row] as! String == "Buy Tickets"
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BuyTicketVC") as! BuyTicketVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        
        else if categoryArray[indexPath.row] as! String == "View Artist"
        {
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
        else if categoryArray[indexPath.row] as! String == "Venue"
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewVenueDetailVC") as! NewVenueDetailVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        
        else if categoryArray[indexPath.row] as! String == "Review"
        {
            UserDefaults.standard.set(true, forKey: "EventRating")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VendorRatingVC") as! VendorRatingVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        else if categoryArray[indexPath.row] as! String == "Friends On Event"
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewFriendOnEventVC") as! NewFriendOnEventVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        }
        
    }
}
extension EventDetailVC: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        
    }
}

//            guard let url = URL(string: "calshow://") else { return }
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)

//            eventStore.requestAccess(to: .event) { [self] (granted, error) in
//
//              if (granted) && (error == nil) {
//                  print("granted \(granted)")
//                  print("error \(error)")
//
//                let event:EKEvent = EKEvent(eventStore: self.eventStore)
//               // UserDefaults.standard.setValue(od, forKey: "e_opend")
//                let od:String =  UserDefaults.standard.value(forKey: "e_opend") as! String
//
//                let string = od
//
//                // Create Date Formatter
//                let dateFormatter = DateFormatter()
//
//                // Convert String to Date
//               let d = dateFormatter.date(from: string)
//
//             //   UserDefaults.standard.setValue(ot, forKey: "e_opent")
//                  event.title = UserDefaults.standard.value(forKey: "e_name") as! String
//                  event.startDate = d
//                  event.endDate = Date()
//                  event.notes = "This is a note"
//                let alarmTime = d
//                    let alarm = EKAlarm(absoluteDate: alarmTime!)
//         print("141",alarmTime)
//                event.addAlarm(alarm)
//                  event.calendar = eventStore.defaultCalendarForNewEvents
//                  do {
//                      try eventStore.save(event, span: .thisEvent)
//                  } catch let error as NSError {
//                      print("failed to save event with error : \(error)")
//                  }
//                  print("Saved Event")
//              }
//              else{
//
//                  print("failed to save event with error : \(error) or access not granted")
//              }
//            }

//   addEventToCalendar()
