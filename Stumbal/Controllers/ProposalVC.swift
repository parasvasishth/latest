//
//  ProposalVC.swift
//  Stumbal
//
//  Created by mac on 23/03/21.
//

import UIKit
import Alamofire
import Kingfisher
class ProposalVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
var inviteArray:[inviteList] = []
@IBOutlet var proposalTblView: UITableView!
@IBOutlet var statusLbl: UILabel!
@IBOutlet var searchBar: UISearchBar!
var hud = MBProgressHUD()
var AppendArr:NSMutableArray = NSMutableArray()
var proposalId:String = ""
override func viewDidLoad() {
    super.viewDidLoad()
    
    proposalTblView.dataSource = self
    proposalTblView.delegate = self
    searchBar.delegate = self
    
    if #available(iOS 13.0, *) {
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
       } else {
           // Fallback on earlier versions
       }
    
    searchBar.setImage(UIImage(named: "search1"), for: .search, state: .normal)
    
    if UserDefaults.standard.value(forKey:"ap_artId") == nil
    {
        self.statusLbl.isHidden = false
        self.proposalTblView.isHidden = true
    }
    else
    {
        fetch_send_proposal()
    }
}

    override func viewDidLayoutSubviews() {

        setupSearchBar(searchBar: searchBar)

    }

        func setupSearchBar(searchBar : UISearchBar) {

        searchBar.setPlaceholderTextColorTo(color: #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1))

       }

    
@IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
    
}

@IBAction func deleteProposal(_ sender: UIButton) {
    let tagVal : Int = sender.tag
    proposalId = (AppendArr.object(at: tagVal) as AnyObject).value(forKey: "proposal_id")as! String
    delete_proposal()
    
}

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    //backObj.isHidden = false
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  if UserDefaults.standard.value(forKey:"ap_artId") == nil
    {
        self.statusLbl.isHidden = false
       self.proposalTblView.isHidden = true
    }
    else
    {
        fetch_send_proposal()
    }
   
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

//MARK: fetch_events ;
func fetch_send_proposal()
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
                    self.AppendArr = NSMutableArray()
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.AppendArr.count != 0 {
                        
                        self.statusLbl.isHidden = true
                        self.proposalTblView.isHidden = false
                        self.proposalTblView.reloadData()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    else  {
                        self.statusLbl.isHidden = false
                        self.proposalTblView.isHidden = true
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
    let cell =  proposalTblView.dequeueReusableCell(withIdentifier: "ProposalTblCell", for: indexPath) as! ProposalTblCell
    
    cell.nameLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
   
    if (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String == ""
    {
        cell.dotImg.isHidden = true
        cell.dateLbl.text = ""
    }
    else
    {
        cell.dotImg.isHidden = false
        cell.dateLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
        
    }
    
    
     if (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "time")as! String == ""
     {
         cell.timeImg.isHidden = true
         cell.timelbl.text = ""
     }
     else
     {
         cell.timeImg.isHidden = false
        cell.timelbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "time")as! String
         
     }
    
  
    let pimg:String = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "venue_img")as! String
    if (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "proposed_price")as! String == ""
    {
        cell.priceLbl.text = ""
    }
    else
    {
        
      let p = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "proposed_price")as! String
       cell.priceLbl.text = "$" + p
    }
  
    
    if pimg == ""
    {
        cell.profileImg.image = UIImage(named: "vdefault")
        
    }
    else
    {
        let url = URL(string: pimg)
        let processor = DownsamplingImageProcessor(size: cell.profileImg.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        cell.profileImg.kf.indicatorType = .activity
        cell.profileImg.kf.setImage(
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
                cell.profileImg.image = UIImage(named: "vdefault")
            }
        }
        
    }
    cell.deleteobj.tag = indexPath.row
    
    
    return cell
}
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let pn = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "provider_name")as! String
    let d = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "post_detail")as! String
    let p = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "proposed_price")as! String
    let v = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "video")as! String
    let da = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "date")as! String
    let t = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "time")as! String
    let vimg = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "venue_img")as! String
    let vthub = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "thumbnail_img")as! String
    
    
    UserDefaults.standard.setValue(vthub, forKey: "p_videoimg")
    UserDefaults.standard.setValue(pn, forKey: "p_name")
    UserDefaults.standard.setValue(d, forKey: "p_desc")
    UserDefaults.standard.setValue(p, forKey: "p_price")
    UserDefaults.standard.setValue(v, forKey: "p_video")
    UserDefaults.standard.setValue(da, forKey: "p_date")
    UserDefaults.standard.setValue(t, forKey: "p_time")
    UserDefaults.standard.setValue(vimg, forKey: "p_img")
    
    var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "ViewProposalVC") as! ViewProposalVC
    signuCon.modalPresentationStyle = .fullScreen
    self.present(signuCon, animated: false, completion:nil)
}


}
