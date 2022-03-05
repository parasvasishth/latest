//
//  MenuPowerVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 06/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class MenuPowerVC: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var EventCollView: UICollectionView!
    var hud = MBProgressHUD()
    var categoryArray:NSMutableArray = NSMutableArray()
    var eventArray:NSMutableArray = NSMutableArray()
    private let spacing:CGFloat = 10.0
    private let spacing2:CGFloat = 5.0
    var artistRating:String = ""
    var providerRating:String = ""
    var session = URLSession()
    var catname:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false
        categoryCollView.dataSource = self
        categoryCollView.delegate = self
        EventCollView.dataSource = self
        EventCollView.delegate = self
        //searchBar.showsCancelButton = false
        searchBar.setShowsCancelButton(false, animated: false)
       
        // Do any additional setup after loading the view.
    }
   
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       // fetch_events()
        if searchBar.text != ""
        {
            fetch_metatagsSearch()
        }
        else
        {
            fetch_metatags()
        }
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        
        //backObj.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
//        var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "TabCategoryVC") as! TabCategoryVC
//        signuCon.modalPresentationStyle = .fullScreen
//        self.present(signuCon, animated: false, completion:nil)
        searchBar.delegate = self
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
           } else {
               // Fallback on earlier versions
           }
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftViewMode = .never
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {

            //textfield.backgroundColor = UIColor.yellow
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search bar", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            textfield.setLeftPaddingPoints(5)
            textfield.clearButtonMode = .never
           // textfield.textColor = UIColor.green

    //        if let leftView = textfield.leftView as? UIImageView {
    //            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
    //            leftView.tintColor = UIColor.red
    //        }
        }
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        self.EventCollView?.collectionViewLayout = layout
        
//        let layout2 = UICollectionViewFlowLayout()
//        layout2.sectionInset = UIEdgeInsets(top: spacing2, left: spacing2, bottom: spacing2, right: spacing2)
//        layout2.minimumLineSpacing = spacing2
//        layout2.minimumInteritemSpacing = spacing2
//        layout2.scrollDirection = .horizontal
//        self.categoryCollView?.collectionViewLayout = layout2
//
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
        fecth_Profile()
    }

    // MARK: - fecth_Profile
    func fecth_Profile()
    {

//    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//    hud.mode = MBProgressHUDMode.indeterminate
//    hud.self.bezelView.color = UIColor.black
//    hud.label.text = "Loading...."
    Alamofire.request("https://stumbal.com/process.php?action=fetch_user_profile", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String], encoding:  URLEncoding.httpBody).responseJSON
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
                    self.fecth_Profile()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                
                
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                  
                    let n:String = json["fname"] as! String
                    self.nameLbl.text = "Hi " + n + ","
                    self.fetch_metatags()
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
    
    //MARK: fetch_metatags ;
    func fetch_metatags()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_metatags", method: .post, parameters: ["search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { response in
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true
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
                        self.categoryArray = NSMutableArray()
                        self.categoryArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        
                        
                        if self.categoryArray.count != 0 {
                            
                            
                            self.categoryCollView.isHidden = false
                            self.categoryCollView.reloadData()
                            self.top_events_cat_multiple()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.categoryCollView.reloadData()
                            self.categoryCollView.isHidden = true
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
    
    //MARK: fetch_metatagsSearch ;
    func fetch_metatagsSearch()
    {
        // UserDefaults.standard.set(self.userId, forKey: "User id")
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_metatags", method: .post, parameters: ["search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_metatagsSearch()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.categoryArray = NSMutableArray()
                        self.categoryArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        if self.categoryArray.count != 0 {
                            
                            
                            self.categoryCollView.isHidden = false
                            self.categoryCollView.reloadData()
                           // self.top_events_cat_multiple()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.categoryCollView.isHidden = true
                            self.categoryCollView.reloadData()
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

    //MARK: fetch_events ;
    func fetch_events()
    {
         //UserDefaults.standard.set(self.userId, forKey: "User id")
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.self.bezelView.color = UIColor.black
            hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
        //  lat = -33.826090
        // long = 150.996450
        

        Alamofire.request("https://stumbal.com/process.php?action=top_events_cat_single", method: .post, parameters: ["cat_name":catname ,"search":""], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.eventArray = NSMutableArray()
                        self.eventArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        if self.eventArray.count != 0 {
                            
                           // self.statusLbl.isHidden = true
                            self.EventCollView.isHidden = false
                            self.EventCollView.reloadData()
                            self.tabBarController?.tabBar.isHidden = false
                            self.tabBarController?.tabBar.backgroundColor = UIColor.black
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.EventCollView.isHidden = true
                            self.tabBarController?.tabBar.isHidden = false
                            self.tabBarController?.tabBar.backgroundColor = UIColor.black
                           // self.statusLbl.isHidden = false
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

    //MARK: top_events_cat_multiple ;
    func top_events_cat_multiple()
    {
         //UserDefaults.standard.set(self.userId, forKey: "User id")
//            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.mode = MBProgressHUDMode.indeterminate
//            hud.self.bezelView.color = UIColor.black
//            hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
        //  lat = -33.826090
        // long = 150.996450
        

        Alamofire.request("https://stumbal.com/process.php?action=top_events_cat_multiple", method: .post, parameters: ["cat_id":"" ,"search":""], encoding:  URLEncoding.httpBody).responseJSON { response in
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.top_events_cat_multiple()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.eventArray = NSMutableArray()
                        self.eventArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        if self.eventArray.count != 0 {
                            
                           // self.statusLbl.isHidden = true
                            self.EventCollView.isHidden = false
                            self.EventCollView.reloadData()
                            self.loadingView.isHidden = true
                           // self.tabBarController?.tabBar.isHidden = false
                           // self.tabBarController?.tabBar.backgroundColor = UIColor.black
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.EventCollView.isHidden = true
                            self.loadingView.isHidden = true
                            //self.tabBarController?.tabBar.isHidden = false
                            //self.tabBarController?.tabBar.backgroundColor = UIColor.black
                           // self.statusLbl.isHidden = false
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
   
}
extension MenuPowerVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout
{
    //    // MARK: - Collection height Method
    //    override func viewWillLayoutSubviews() {
    //        super.updateViewConstraints()
    //        self.?.constant = self.categoryCollView.contentSize.height
    //    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollView
        {
            return categoryArray.count
        }
        else
        {
            return eventArray.count
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == EventCollView
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 10

            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row

            if let collection = self.EventCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
     else
     {
//         let numberOfItemsPerRow:CGFloat = 2
//         let spacingBetweenCells:CGFloat = 5

//         let totalSpacing = (2 * self.spacing2) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row

         if let collection = self.categoryCollView{
             let width = (collection.bounds.width)
             return CGSize(width: width, height: 50)
             //188 ,90
         }else{
             return CGSize(width: 0, height: 0)
         }
     }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
//    {
//        self.viewWillLayoutSubviews()
//    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     if collectionView == categoryCollView
        {
         let cell = categoryCollView.dequeueReusableCell(withReuseIdentifier: "ProfileCategoriesCollectionViewCell", for: indexPath) as! ProfileCategoriesCollectionViewCell
         
         cell.cateLbl.text = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
       
         if (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String == catname
         {
             cell.catView.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
             cell.cateLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
         }
         else
         {
             cell.catView.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0, blue: 0.1215686275, alpha: 1)
             cell.cateLbl.textColor = #colorLiteral(red: 0.6039215686, green: 0.4823529412, blue: 0.6352941176, alpha: 1)
         }
         
         return cell
     }
        else
        {
            let cell = EventCollView.dequeueReusableCell(withReuseIdentifier: "PastEventsCollectionViewCell", for: indexPath) as! PastEventsCollectionViewCell
            cell.eventNameLbl.isHidden = false
            cell.eventNameLbl.text = ""
            cell.eventNameLbl.text = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
           
            let eimg:String = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String

            if eimg == ""
            {
               cell.eventImgLbl.image = UIImage(named: "edefault")

            }
               else
            {
               let url = URL(string: eimg)
               let processor = DownsamplingImageProcessor(size: cell.eventImgLbl.bounds.size)
                            |> RoundCornerImageProcessor(cornerRadius: 0)
               cell.eventImgLbl.kf.indicatorType = .activity
               cell.eventImgLbl.kf.setImage(
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
                    cell.eventImgLbl.image = UIImage(named: "edefault")
                   }
               }

            }
            return cell
        }
    }
  
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollView
        {
            let cell = categoryCollView.dequeueReusableCell(withReuseIdentifier: "ProfileCategoriesCollectionViewCell", for: indexPath) as! ProfileCategoriesCollectionViewCell
            
            
           
            catname = (categoryArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
       // fetch_metatags()
             fetch_events()
        }
        else
        {
            let pn = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
            let add = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
            let od = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
            let cd = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
            let ot = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
            let ct = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
            let ai = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_img") as! String
            let en = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
            let aid = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id") as! String
            let eid = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_id") as! String
            let tp = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "ticket_price") as! String

            let lat = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "lat") as! String

            let long = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "lng") as! String

            let scn = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String

            let n = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "artist")as! String

            let cn = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String

            let ai1 = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String

            let aimg = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
            let ec = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
            let pid = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String

            let spr = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
            let edesc = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_desc")as! String
            if spr == ""
            {
                providerRating = "0" + "/5"
            }
            else
            {
                providerRating = spr + "/5"
            }

            let ar = (eventArray.object(at: indexPath.row) as AnyObject).value(forKey: "artist_avg_rating")as! String
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
        }
    }
}
