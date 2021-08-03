//
//  PastEventDetailVC.swift
//  Stumbal
//
//  Created by mac on 20/05/21.
//

import UIKit
import CoreLocation
import MapKit
import Kingfisher
class PastEventDetailVC: UIViewController,CLLocationManagerDelegate{

@IBOutlet var eventImg: UIImageView!
@IBOutlet var eventnamelbl: UILabel!
@IBOutlet var timeLbl: UILabel!
@IBOutlet var addressLbl: UILabel!
@IBOutlet var venuenamelbl: UILabel!
@IBOutlet var ratingLbl: UILabel!
@IBOutlet var categorylbl: UILabel!
override func viewDidLoad() {
    super.viewDidLoad()
    
    venuenamelbl.text = UserDefaults.standard.value(forKey: "e_providername") as! String
    addressLbl.text = UserDefaults.standard.value(forKey: "e_provideradd") as! String
    timeLbl.text = UserDefaults.standard.value(forKey: "e_time") as! String
    eventnamelbl.text = UserDefaults.standard.value(forKey: "e_name") as! String
    
    self.eventImg.sd_setImage(with: URL(string:UserDefaults.standard.value(forKey: "e_profile") as! String), placeholderImage: UIImage(named: "edefault"))
    
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
    ratingLbl.text = UserDefaults.standard.value(forKey: "Event_providerrating") as! String
    
}

@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
}

@IBAction func direction(_ sender: UIButton) {
    let la = (UserDefaults.standard.value(forKey: "Event_lat") as! NSString).doubleValue
    let lo = (UserDefaults.standard.value(forKey: "Event_long") as! NSString).doubleValue
    
    let add = UserDefaults.standard.value(forKey: "e_provideradd") as! String
    
    
    let coordinate = CLLocationCoordinate2DMake(la, lo)
    
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
    mapItem.name = add
    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    
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
        
    }
}
}
