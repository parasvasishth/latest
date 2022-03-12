//
//  NewArtistProposalListVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 05/01/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewArtistProposalListVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    @IBOutlet weak var proposalTblView: UICollectionView!
    @IBOutlet weak var seconView: UIView!
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingCollView: UICollectionView!
    @IBOutlet weak var pastCollView: UICollectionView!
    @IBOutlet weak var eventHistoryHeight: NSLayoutConstraint!
    @IBOutlet weak var eventHistoryLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var menu: UIButton!
    var catArray:NSArray = NSArray()
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    var proposalArray:NSMutableArray = NSMutableArray()
    var pastArr:NSMutableArray = NSMutableArray()
    private let spacing:CGFloat = 10.0
    private let spacing1:CGFloat = 15.0
    private let spacing2:CGFloat = 10.0
    var proposalId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

       // menu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        
        loadingView.isHidden = false
        upcomingCollView.delegate = self
        upcomingCollView.dataSource = self
        pastCollView.delegate = self
        pastCollView.dataSource = self
        proposalTblView.delegate = self
        proposalTblView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        self.proposalTblView?.collectionViewLayout = layout

        let layout1 = UICollectionViewFlowLayout()
        layout1.sectionInset = UIEdgeInsets(top: spacing1, left: spacing1, bottom: spacing1, right: spacing1)
        layout1.minimumLineSpacing = spacing1
        layout1.minimumInteritemSpacing = spacing1
        layout1.scrollDirection = .horizontal
        self.upcomingCollView?.collectionViewLayout = layout1

        let layout2 = UICollectionViewFlowLayout()
        layout2.sectionInset = UIEdgeInsets(top: spacing2, left: spacing2, bottom: spacing2, right: spacing2)
        layout2.minimumLineSpacing = spacing2
        layout2.minimumInteritemSpacing = spacing2
        layout2.scrollDirection = .horizontal
        self.pastCollView?.collectionViewLayout = layout2
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftViewMode = .never
        searchBar.delegate = self
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
           } else {
               // Fallback on earlier versions
           }
        
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
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "Poppins", size: 14.0)

        
        //searchBar.searchTextField.font = UIFont(name: "YOUR-FONT-NAME", size: 13)

        fetch_send_proposal()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteProposal(_ sender: UIButton) {
        let tagVal : Int = sender.tag
        proposalId = (proposalArray.object(at: tagVal) as AnyObject).value(forKey: "proposal_id")as! String
        delete_proposal()
    }
    
    @IBAction func proposal(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewSendProposalVC") as! NewSendProposalVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetch_send_proposal1()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        //backObj.isHidden = false
    }

    func delete_proposal()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=delete_proposal", method: .post, parameters: ["proposal_id":proposalId],encoding:  URLEncoding.httpBody).responseJSON{ response in
            if let data = response.data
            {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.delete_proposal()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                    
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        print("JSON: \(json)")
                        print("66666666666")
                        
                        if  json["result"] as! String == "success"
                        {
                            
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            let alert = UIAlertController(title: "", message: "Proposal Deleted  Successfully", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            // change to desired number of seconds (in this case 5 seconds)
                            let when = DispatchTime.now() + 2
                            
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                
                                alert.dismiss(animated: true, completion: nil)
                                self.fetch_send_proposal()
                                //  self.dismiss(animated: true, completion: nil)
                                
                            }
                        }
                        
                        else {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "", message: "Unsuccess", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        
                        
                    }
                    
                }
            }
        }
    }

    
    //MARK: fetch_send_proposal ;
    func fetch_send_proposal()
    {
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.self.bezelView.color = UIColor.black
//        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "ap_artId") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_send_proposal", method: .post, parameters: ["artist_id" :uID ,"search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_send_proposal()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.proposalArray = NSMutableArray()
                        self.proposalArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        if self.proposalArray.count != 0 {
                            
                            self.firstView.isHidden = false
                            self.firstViewHeight.constant = 105
                            self.proposalTblView.isHidden = false
                            self.proposalTblView.reloadData()
                            self.fetch_upcoming_events()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.firstView.isHidden = true
                            self.firstViewHeight.constant = 0
                            self.proposalTblView.isHidden = true
                            self.fetch_upcoming_events()
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
    
    //MARK: fetch_send_proposal1 ;
    func fetch_send_proposal1()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "ap_artId") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_send_proposal", method: .post, parameters: ["artist_id" :uID ,"search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_send_proposal()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.proposalArray = NSMutableArray()
                        self.proposalArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        if self.proposalArray.count != 0 {
                            
                            self.firstView.isHidden = false
                            self.firstViewHeight.constant = 105
                            self.proposalTblView.isHidden = false
                            self.proposalTblView.reloadData()
                           // self.fetch_upcoming_events()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.firstView.isHidden = true
                            self.firstViewHeight.constant = 0
                            self.proposalTblView.isHidden = true
                           // self.fetch_upcoming_events()
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
    
    
    //MARK: fetch_upcoming_events ;
        func fetch_upcoming_events()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
    //            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //            hud.mode = MBProgressHUDMode.indeterminate
    //            hud.self.bezelView.color = UIColor.black
    //            hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "ap_artId") as! String

            print("123",uID)

            Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_upcomingevent", method: .post, parameters: ["artist_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { response in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("=====1======")
                    print("Response: \(String(describing: json))")

                 if json == ""
                 {
                     MBProgressHUD.hide(for: self.view, animated: true);
                    // self.loadingView.isHidden = true
                     let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                         self.fetch_upcoming_events()
                     }))
                     self.present(alert, animated: false, completion: nil)

                 }
                 else
                 {
                     do  {
                        self.AppendArr = NSMutableArray()
                         self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                         //                    print(self.Arr.count)
                         //                    print(self.Arr)
                         //                    self.AppendArr = NSMutableArray()
                         //                    for i in 0...self.Arr.count-1
                         //                    {
                         //                        if (self.Arr.object(at: i) as AnyObject).value(forKey: "card_number") is NSNull {
                         //                        } else {
                         //                            print((self.Arr.object(at:i) as AnyObject).value(forKey: "name"),i)
                         //                            self.AppendArr.add(self.Arr[i])
                         //                        }
                         //
                         //                    }
                         //
                         //                    print(self.AppendArr)


                         if self.AppendArr.count != 0 {


    //                            let contentOffset = self.eventTblView.contentOffset
    //
    //                            self.eventTblView.layoutIfNeeded()
    //                            self.eventTblView.setContentOffset(contentOffset, animated: false)
    //                            self.tblHeight.constant =  CGFloat(126 * self.AppendArr.count)
    //
                           // self.statusLbl.isHidden = true
    //                         self.upcomingLblHeight.constant = 21
    //                         self.upcominglbl.isHidden = false
    //                         self.upcomingCollHeight.constant = 100
    //                         self.upcomingLineHeight.constant = 2
                            self.upcomingCollView.isHidden = false
                             self.seconView.isHidden = false
                             self.secondViewHeight.constant = 182
                             //self.eventHistoryHeight.constant = 30
                            self.upcomingCollView.reloadData()
                             self.fetch_past_events()
                          //  self.tblHeight.constant = 400

                             MBProgressHUD.hide(for: self.view, animated: true)
                         }

                         else  {


                             self.seconView.isHidden = true
                             self.secondViewHeight.constant = 0
                            // self.eventHistoryHeight.constant = 0
                              self.upcomingCollView.isHidden = true
                          
                             self.fetch_past_events()
                          
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

    //MARK: fetch_past_events ;
        func fetch_past_events()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
    //        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //        hud.mode = MBProgressHUDMode.indeterminate
    //        hud.self.bezelView.color = UIColor.black
    //        hud.label.text = "Loading...."
            let uID = UserDefaults.standard.value(forKey: "ap_artId") as! String

            print("123",uID)

            Alamofire.request("https://stumbal.com/process.php?action=fetch_artist_pastevent", method: .post, parameters: ["artist_id" :uID], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("=====1======")
                    print("Response: \(String(describing: json))")

                 if json == ""
                 {
                     MBProgressHUD.hide(for: self.view, animated: true);
                    // loadingView.isHidden = true
                     let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                         self.fetch_past_events()
                     }))
                     self.present(alert, animated: false, completion: nil)

                 }
                 else
                 {
                     do  {
                        self.pastArr = NSMutableArray()
                         self.pastArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        


                         if self.pastArr.count != 0 {

                             self.thirdView.isHidden = false
                             self.thirdViewHeight.constant = 299
                             self.pastCollView.isHidden = false
                             self.eventHistoryHeight.constant = 30
                             self.pastCollView.reloadData()
                          
                             self.loadingView.isHidden = true
                             MBProgressHUD.hide(for: self.view, animated: true)
                         }

                         else  {
                  
                             self.thirdView.isHidden = false
                             self.thirdViewHeight.constant = 0
                             self.eventHistoryHeight.constant = 0
                              self.pastCollView.isHidden = false
                        
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == upcomingCollView
        {
            return AppendArr.count
        }
        else if collectionView == pastCollView
        {
            return pastArr.count
        }
        else
        {
            return proposalArray.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == upcomingCollView
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 10
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.upcomingCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: 188, height: 135)
                //188 ,90
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else  if collectionView == pastCollView
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 15
            
            let totalSpacing = (2 * self.spacing1) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.pastCollView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
              //  220,250
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else
        {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 10
            
            let totalSpacing = (2 * self.spacing2) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.proposalTblView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: 188, height: 82)
                //188 ,90
            }else{
                return CGSize(width: 0, height: 0)
            }
        }

    }
    var providerRating:String = ""
    var artistRating:String = ""

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == upcomingCollView
        {
            let cell = upcomingCollView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCollectionViewCell", for: indexPath) as! UpcomingEventsCollectionViewCell
            
            cell.eventNamelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
            cell.venueNameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
            let r:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "remain_days")as! String
            
            cell.remainingLbl.text = "In " + r + " days"
            
            return cell
        }
        else if collectionView == pastCollView
        {
            let cell = pastCollView.dequeueReusableCell(withReuseIdentifier: "PastEventsCollectionViewCell", for: indexPath) as! PastEventsCollectionViewCell
                        let eimg:String = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img")as! String
            
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
            
                        
                        cell.eventNameLbl.text = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
            return cell
        }
        else
        {
            let cell = proposalTblView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCollectionViewCell", for: indexPath) as! UpcomingEventsCollectionViewCell
            cell.eventNamelbl.text = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
            cell.venueNameLbl.text = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
            cell.deleteProposalObj.tag = indexPath.row
            
            return cell
        }

    }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == upcomingCollView
            {
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
                UserDefaults.standard.setValue(od, forKey: "e_opend")
                UserDefaults.standard.setValue(ot, forKey: "e_opent")
                UserDefaults.standard.setValue(cd, forKey: "e_closed")
                UserDefaults.standard.setValue(ct, forKey: "e_closet")
    
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
                let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewUpcomingEventDetailVC") as! NewUpcomingEventDetailVC
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:false, completion:nil)
            }
            else if collectionView == pastCollView
            {
                let pn = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
                let add = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "address")as! String
                let od = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_date")as! String
                let cd = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_date")as! String
                let ot = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
                let ct = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
                let ai = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_img") as! String
                let en = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
                let aid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id") as! String
                let eid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_id") as! String
                let tp = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "ticket_price") as! String
    
                let lat = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "lat") as! String
    
                let long = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "lng") as! String
    
    
    
                let scn = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String
    
                let n = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist")as! String
    
                let cn = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
    
                let ai1 = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String
    
                let aimg = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
                let ec = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_category")as! String
                let pid = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_id")as! String
    
                let spr = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "event_avg_rating")as! String
                if spr == ""
                {
                    providerRating = "0" + "/5"
                }
                else
                {
                    providerRating = spr + "/5"
                }
    
                let ar = (pastArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_avg_rating")as! String
                if ar == ""
                {
                    artistRating = "0" + "/5"
                }
                else
                {
                    artistRating = ar + "/5"
                }
                UserDefaults.standard.setValue(od, forKey: "e_opend")
                UserDefaults.standard.setValue(ot, forKey: "e_opent")
                UserDefaults.standard.setValue(cd, forKey: "e_closed")
                UserDefaults.standard.setValue(ct, forKey: "e_closet")
    
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
                let storyBoard : UIStoryboard = UIStoryboard(name: "Third", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewPastEventDetailVC") as! NewPastEventDetailVC
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:false, completion:nil)
            }
            else
            {
                let pn = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
                let d = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "post_detail")as! String
                let p = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "proposed_price")as! String
                let v = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "video")as! String
                let da = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
                let t = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "time")as! String
                let vimg = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "venue_img")as! String
                let vthub = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "thumbnail_img")as! String
                let en:String = (proposalArray.object(at: indexPath.row) as AnyObject).value(forKey: "event_name")as! String
                
                UserDefaults.standard.setValue(vthub, forKey: "p_videoimg")
                UserDefaults.standard.setValue(pn, forKey: "p_name")
                UserDefaults.standard.setValue(d, forKey: "p_desc")
                UserDefaults.standard.setValue(p, forKey: "p_price")
                UserDefaults.standard.setValue(v, forKey: "p_video")
                UserDefaults.standard.setValue(da, forKey: "p_date")
                UserDefaults.standard.setValue(t, forKey: "p_time")
                UserDefaults.standard.setValue(vimg, forKey: "p_img")
                UserDefaults.standard.setValue(en, forKey: "p_ename")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProposalDetailVC") as! NewProposalDetailVC
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:false, completion:nil)
            }
        }
}
