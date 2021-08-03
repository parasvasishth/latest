//
//  TimingVC.swift
//  ACCESS
//
//  Created by mac on 16/02/21.
//  Copyright © 2021 mac. All rights reserved.
//

import UIKit
import Alamofire
class TimingVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var timingTableView: UITableView!
    var hud = MBProgressHUD()
    var AppendArr: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        timingTableView.dataSource = self
        timingTableView.delegate = self
        fetch_vendor_store_timing()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: fetch_vendor_store_timing ;
    func fetch_vendor_store_timing()
    {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
        let uID = UserDefaults.standard.value(forKey: "V_id") as! String
        
        print("123",uID)
        
        Alamofire.request("https://stumbal.com/process.php?action=fetch_store_timing", method: .post, parameters: ["provider_id":uID], encoding:  URLEncoding.httpBody).responseJSON { response in
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
                        self.fetch_vendor_store_timing()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                do  {
                    self.AppendArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
                    
                    if self.AppendArr.count != 0 {
                        self.timingTableView.isHidden = false
                        self.timingTableView.reloadData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                        
                    else  {
                        self.timingTableView.isHidden = true
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
        let cell =  timingTableView.dequeueReusableCell(withIdentifier: "TimingTableViewCell", for: indexPath) as! TimingTableViewCell
        
        
        cell.dayLbl.text = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "day")as! String
        let st = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "open_time")as! String
        let et = (AppendArr.object(at: indexPath.row) as AnyObject).value(forKey: "close_time")as! String
        
        cell.dayTimingLbl.text =  st + " To " + et
        return cell
    }
    
}
