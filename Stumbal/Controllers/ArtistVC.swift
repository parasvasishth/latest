//
//  ArtistVC.swift
//  Stumbal
//
//  Created by mac on 18/03/21.
//

import UIKit
import Alamofire
import SDWebImage
import Kingfisher
class ArtistVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SWRevealViewControllerDelegate{
    
    @IBOutlet var artistTblView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var menu: UIButton!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    var hud = MBProgressHUD()
    var AppendArr:NSMutableArray = NSMutableArray()
    var pastArray:NSMutableArray = NSMutableArray()
    var artistRating:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        loadingView.isHidden = false
        artistTblView.dataSource = self
        artistTblView.delegate = self
        
        searchBar.delegate = self
        
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
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 10)
            
            textfield.setLeftPaddingPoints(5)
            textfield.clearButtonMode = .never
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        setupSearchBar(searchBar: searchBar)
        
    }
    
    func setupSearchBar(searchBar : UISearchBar) {
        
        searchBar.setPlaceholderTextColorTo(color: #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1))
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        loadingView.isHidden = false
        fetch_all_artist()
    }
    
    @IBAction func back(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    //MARK: fetch_all_artist ;
    func fetch_all_artist()
    {
        
        //    hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //    hud.mode = MBProgressHUDMode.indeterminate
        //    hud.self.bezelView.color = UIColor.black
        //    hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_all_artist", method: .post, parameters: ["user_id":uID,"search":searchBar.text!], encoding:  URLEncoding.httpBody).responseJSON { response in
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                
                if json == ""
                {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.loadingView.isHidden = true
                    let alert = UIAlertController(title: "", message: "Loading...", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                        self.fetch_all_artist()
                    }))
                    self.present(alert, animated: false, completion: nil)
                    
                }
                else
                {
                    do  {
                        self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                        
                        if self.AppendArr.count != 0 {
                            
                            self.statusLbl.isHidden = true
                            self.artistTblView.isHidden = false
                            self.artistTblView.reloadData()
                            self.loadingView.isHidden = true
                            self.tabBarController?.tabBar.isHidden = false
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                        else  {
                            self.artistTblView.isHidden = true
                            self.statusLbl.isHidden = false
                            self.loadingView.isHidden = true
                            self.tabBarController?.tabBar.isHidden = false
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
    
    // MARK: - fetch_app_user
    func fetch_app_user()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        self.pastArray = NSMutableArray()
        
        let u_id = UserDefaults.standard.value(forKey: "u_Id") as! String
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_all_artist", method: .post, parameters:["search":searchBar.text!,"user_id":u_id], encoding:  URLEncoding.httpBody).responseJSON { response in
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("=====1======")
                print("Response: \(String(describing: json))")
                
                self.pastArray = NSMutableArray()
                do  {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.pastArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    self.AppendArr = NSMutableArray()
                    if self.pastArray.count != 0
                    {
                        
                        for i in 0...self.pastArray.count-1
                        {
                            if (self.pastArray.object(at: i) as AnyObject).value(forKey: "name") is NSNull {
                            } else {
                                print((self.pastArray.object(at:i) as AnyObject).value(forKey: "name"),i)
                                self.AppendArr.add(self.pastArray[i])
                            }
                        }
                        if self.AppendArr.count != 0 {
                            
                            self.artistTblView.isHidden = false
                            self.artistTblView.reloadData()
                            self.statusLbl.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else  {
                            
                            self.artistTblView.isHidden = true
                            self.statusLbl.isHidden = false
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }
                    else
                    {
                        self.artistTblView.isHidden = true
                        self.statusLbl.isHidden = false
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetch_app_user()
    }
    
    //MARK: tableView Methode
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppendArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  artistTblView.dequeueReusableCell(withIdentifier: "ArtistTblCell", for: indexPath) as! ArtistTblCell
        
        cell.namelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
        //   cell.categoryLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
        cell.profileView.layer.cornerRadius = cell.profileView.frame.height / 2
        cell.profileView.layer.masksToBounds = false
        cell.profileView.clipsToBounds = true
        
        let ai:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
        
        if ai == ""
        {
            cell.eventImg.image = UIImage(named: "adefault")
            
        }
        else
        {
            let url = URL(string: ai)
            let processor = DownsamplingImageProcessor(size: cell.eventImg.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
            cell.eventImg.kf.indicatorType = .activity
            cell.eventImg.kf.setImage(
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
                    cell.eventImg.image = UIImage(named: "adefault")
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "sub_cat_name")as! String
        
        let n = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
        let cn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "category_name")as! String
        
        let ai = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_id")as! String
        
        let aimg = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "artist_img")as! String
        
        let ar = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "avg_rating")as! String
        if ar == ""
        {
            artistRating = "0" + "/5"
        }
        else
        {
            artistRating = ar + "/5"
        }
        
        UserDefaults.standard.setValue(artistRating, forKey: "Event_artrating")
        UserDefaults.standard.setValue(scn, forKey: "Event_subcat")
        UserDefaults.standard.setValue(n, forKey: "Event_name")
        UserDefaults.standard.setValue(cn, forKey: "Event_cat")
        UserDefaults.standard.setValue(ai, forKey: "Event_artid")
        UserDefaults.standard.setValue(aimg, forKey: "Event_artimg")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewArtistUserProfileVC") as! NewArtistUserProfileVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
}
extension UISearchBar
{
    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
}
