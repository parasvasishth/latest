//
//  InviteVC.swift
//  Stumbal
//
//  Created by mac on 23/03/21.
//

import UIKit
import Contacts
import Alamofire
protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}
//import PhoneNumberKit
class InviteVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var inviteTblView: UITableView!
    var inviteArray:[inviteList] = []
    var contactArray:[contactlist] = []
    var arrSelectedData = [String]()
   // var servicenameArr:NSMutableArray = NSMutableArray()
    var productDic:NSMutableDictionary = NSMutableDictionary()
    var dict:NSMutableDictionary = NSMutableDictionary()
    var final:String = ""
    var hud = MBProgressHUD()
    var servicenameArr = [[String: String]]()
    var finalArray:NSMutableArray = NSMutableArray()
    var responseArray:NSMutableArray = NSMutableArray()
  //  var artistArray:[artistList] = []
   // let testDic: OrderedDictionary = ["kg": 1, "g": 2, "mg": 3, "lb": 4, "oz": 5, "t": 6]
    var firstArr  = NSMutableArray()
    var secArr  = NSMutableArray()
   // var name = "Ravi Porwal"
    var finalArr = NSMutableArray()
    var is_get_value = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
//       let i1 = inviteList(name: "Timothy Voldz", code: "@timothyvoldz", photo: "a1")
//       let i2 = inviteList(name: "Patrick Rodriquiz", code: "@prod", photo: "a2")
//       let i3 = inviteList(name: "lenora medina", code: "@medina", photo: "a3")
//       let i4 = inviteList(name: "Mary Fisher", code: "@maryfisher", photo: "a4")
//       let i5 = inviteList(name: "Jason Green", code: "@jason", photo: "e3")
//       let i6 = inviteList(name: "Gracee fremain", code: "@grace", photo: "e4")
//       let i7 = inviteList(name: "Jhone Smith", code: "@smith", photo: "e1")
//       let i8 = inviteList(name: "Locas cole", code: "@locas", photo: "c1")
//        
//        inviteArray = [i1,i2,i3,i4,i5,i6,i7,i8]
//        inviteTblView.dataSource = self
//        inviteTblView.delegate = self
        
        inviteTblView.dataSource = self
        inviteTblView.delegate = self
       fetchContacts()


        // Do any additional setup after loading the view.
    }
    
//    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
//            if let arr = self as? [[String:AnyObject]],
//                let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
//                let str = String(data: dat, encoding: String.Encoding.utf8) {
//                return str
//            }
//            return "[]"
//        }
//

    private func fetchContacts() {
        print("Attempting to fetch contacts")
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [self] (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            
            if granted {
                print("access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { [self] (contact, stopPointer) in
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        let c = contact.phoneNumbers.first?.value.stringValue ?? ""
                print("12111",contact)
                        
                 //   String  = "(123) 456-7890".replaceAll("[()\\-\\s]", "");
                        //self.dict.setValue(pn, forKey: "name")
                        // self.dict.setValue(pid, forKey: "name")
                       // self.dict.setValue(pid, forKey: "id")
                        
                        let unsafeChars = CharacterSet.alphanumerics.inverted  // Remove the .inverted to get the opposite result.

                            let cleanChars  = c.components(separatedBy: unsafeChars).joined(separator: "")

                        print("111",cleanChars)
                       
                      print("211",contact.givenName)
                        print("111",contact.familyName)
                        let n = contact.givenName + " " + contact.familyName
                        self.dict = NSMutableDictionary()
                       
                   
                       print("111",dict)
                        dict.setValue(n, forKey: "name")
                        dict.setValue(cleanChars, forKey: "Contact")
                        dict.setValue("", forKey: "status")
                    self.servicenameArr.append(self.dict as! [String : String])
                      
                    })
                    
                    print("1211",self.servicenameArr)
//                    print("1111",self.contactArray)
//
                  firstArr = NSMutableArray(array:servicenameArr)
//                    servicenameArr = []
//                    for i in 0...self.finalArray.count-1
//                    {
//                        self.dict = NSMutableDictionary()
//                        let name:String = (self.finalArray.object(at:i) as AnyObject).value(forKey: "name") as! String
//                        let con:String =  (self.finalArray.object(at:i) as AnyObject).value(forKey: "contact") as! String
//                        let status:String =  (self.finalArray.object(at:i) as AnyObject).value(forKey: "status") as! String
//                        self.dict.setValue(name, forKey: "name")
//                        self.dict.setValue(con, forKey: "contact")
//                        self.dict.setValue(status, forKey: "status")
//                        self.servicenameArr.append(self.dict as! [String : String])
//
//
//                    }
//
//
//                    print("14",servicenameArr)
                    
                    
                    let str = try! toJSON(array: servicenameArr)
                    print("111",str)
                    final = str
                
                    match_contact()
                    
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    

    
    func toJSON(array: [[String: Any]]) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        return String(data: data, encoding: .utf8)!
    }

    func fromJSON(string: String) throws -> [[String: Any]] {
        let data = string.data(using: .utf8)!
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else {
            throw NSError(domain: NSCocoaErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
        }
        return jsonObject.map { $0 as! [String: Any] }
    }
    
    var arr:[Any] = [Any]()
    
    //MARK: match_contact ;
        func match_contact()
        {
            // UserDefaults.standard.set(self.userId, forKey: "User id")
            DispatchQueue.main.async(execute: {
                self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                self.hud.mode = MBProgressHUDMode.indeterminate
                self.hud.self.bezelView.color = UIColor.black
                self.hud.label.text = "Loading...."
            })
           
            let uID = UserDefaults.standard.value(forKey: "u_Id") as! String
            
            print("123",uID)
            
            Alamofire.request("https://stumbal.com/process.php?action=match_contact", method: .post, parameters: ["contacts" :final], encoding:  URLEncoding.httpBody).responseJSON { [self] response in
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
                         self.match_contact()
                     }))
                     self.present(alert, animated: false, completion: nil)
                     
                 }
                 else
                 {
                     do  {
                        self.secArr = NSMutableArray()
                         self.secArr =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as! NSMutableArray
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
                         
                         
                         if self.secArr.count != 0 {
                             
                            print("111",self.secArr)

                            for i in 0..<self.firstArr.count {
                                let get_first_name : String = ((self.firstArr[i] as AnyObject).value(forKey: "name")) as! String

                                for j in 0..<self.secArr.count {
                                    self.is_get_value = false
                                    let get_sec_name : String = ((self.secArr[j] as AnyObject).value(forKey: "name")) as! String
                                    if (get_first_name == get_sec_name) {
                                        self.finalArr.add(self.secArr[j])
                                        self.is_get_value = true
                                        break;
                                    }
                                }
                                if !self.is_get_value {
                                    self.finalArr.add(self.firstArr[i])
                                }
                            }
                            print(self.finalArr)
                            
                            if self.finalArr.count != 0
                            {
                                let nameDiscriptor = NSSortDescriptor(key: "name", ascending: true, selector: Selector("caseInsensitiveCompare:"))

                                arr = (finalArr as NSMutableArray).sortedArray(using: [nameDiscriptor])
                                print("111",arr)
                                let t:NSArray = arr as! NSArray
                                finalArr = NSMutableArray(array: t)

                            print("4444",finalArr)
                                
                                self.inviteTblView.reloadData()
                                self.inviteTblView.isHidden = false
                            }
                            else
                            {
                               
                                self.inviteTblView.isHidden = true
                            }

                             MBProgressHUD.hide(for: self.view, animated: true)
                         }
                             
                         else  {
                            for i in 0..<self.firstArr.count {
                                let get_first_name : String = ((self.firstArr[i] as AnyObject).value(forKey: "name")) as! String

                                for j in 0..<self.secArr.count {
                                    self.is_get_value = false
                                    let get_sec_name : String = ((self.secArr[j] as AnyObject).value(forKey: "name")) as! String
                                    if (get_first_name == get_sec_name) {
                                        self.finalArr.add(self.secArr[j])
                                        self.is_get_value = true
                                        break;
                                    }
                                }
                                if !self.is_get_value {
                                    self.finalArr.add(self.firstArr[i])
                                }
                            }
                            
                            if self.finalArr.count != 0
                            {
                               
//                                self.arr1 = self.arr1.sorted(by: { (Obj1, Obj2) -> Bool in
//                                    let Obj1_Name = (Obj1 as AnyObject).name ?? ""
//                                    let Obj2_Name = (Obj2 as AnyObject).name ?? ""
//                                      return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
//                                }) as NSArray

                                let nameDiscriptor = NSSortDescriptor(key: "name", ascending: true, selector: Selector("caseInsensitiveCompare:"))

                                arr = (finalArr as NSMutableArray).sortedArray(using: [nameDiscriptor])
                                print("111",arr)
                                let t:NSArray = arr as! NSArray
                                finalArr = NSMutableArray(array: t)

                            print("4444",finalArr)
                                self.inviteTblView.reloadData()
                                self.inviteTblView.isHidden = false
                            }
                            else
                            {
                               
                                self.inviteTblView.isHidden = true
                            }
                            
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
  
//    func toDictionary<E, K, V>(
//        array:       [E],
//        transformer: (element: E) -> (key: K, value: V)?)
//        -> Dictionary<K, V>
//    {
//        return array.reduce([:]) {
//            (var dict, e) in
//            if let (key, value) = transformer(element: e)
//            {
//                dict[key] = value
//            }
//            return dict
//        }
//    }

    func allItemsMatch<C1: Container, C2: Container>
        (_ someContainer: C1, _ anotherContainer: C2) -> Bool
        where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
            
            // Check that both containers contain the same number of items.
            if someContainer.count != anotherContainer.count {
                return false
            }
            
            // Check each pair of items to see if they are equivalent.
            for i in 0..<someContainer.count {
                if someContainer[i] != anotherContainer[i] {
                    return false
                }
            }
            
            // All items match, so return true.
            return true
    }


   
 
    // MARK: - check_contact_list
    func check_contact_list()
    {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
     //   https://stumbal.com/process.php?action=match_contact
        print("444",final)
        Alamofire.request("https://stumbal.com/contact_code.php", method: .post,parameters: ["contacts":final],encoding:  URLEncoding.httpBody).responseJSON{ response in
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
                        self.check_contact_list()
                    }))
                    self.present(alert, animated: false, completion: nil)
                }
                else
                {
                    if let json: NSDictionary = response.result.value as? NSDictionary
                    
                    {
                        print("JSON: \(json)")
                        let result : String = json["result"]! as! String
                        if  result == "success"
                        {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            
                        }
                        
                        else {
                            
                            MBProgressHUD.hide(for: self.view, animated: false)
                            let alert = UIAlertController(title: "", message: result, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: false, completion: nil)
                            
                        }
                    }
                    
                }
            }
        }
    }

    
    @IBAction func invite(_ sender: UIButton) {
    //    let url = UserDefaults.standard.value(forKey: "https://testflight.apple.com/join/q9X0UBCo")
        
        if let name = URL(string: "https://apps.apple.com/us/app/stumbal/id1566360669"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
          // show alert for not available
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return finalArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  inviteTblView.dequeueReusableCell(withIdentifier: "SearchArtistTblCell", for: indexPath) as! SearchArtistTblCell
        
      
        cell.artistNameLbl.text = (finalArr.object(at: indexPath.row) as AnyObject).value(forKey: "name")as! String
        cell.contactLbl.text = (finalArr.object(at: indexPath.row) as AnyObject).value(forKey: "Contact")as! String
        
        if (finalArr.object(at: indexPath.row) as AnyObject).value(forKey: "status")as! String == ""
        {
            cell.inviteObj.isHidden = false
        }
        else
        {
            cell.inviteObj.isHidden = true
        }
        
        return cell
   }
  
}


