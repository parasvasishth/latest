//
//  NewTicketVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 15/02/22.
//

import UIKit
import Alamofire
import Kingfisher
class NewTicketVC: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var eventLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var scanCollView: UICollectionView!
    var BannerArr = NSMutableArray()
var dataArray = NSArray()
var offSet: CGFloat = 0
    var timer = Timer()
    var counter = 0
var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        //show_banners()
        
      
        
        self.itemView.roundCorners([.topLeft, .topRight], radius: 15.0)
        booking_tickets_scan()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//         changeImage()
//        //autoScroll()
//        print("111112321")
//    }

//    func ScrollEnd() {
//        print("4554545")
//                }
    
    @objc func openImage(sender: UITapGestureRecognizer)
    {
        
    }
    
    @objc func openImage1(sender: UITapGestureRecognizer)
    {
        
    }

    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * self.scroll.frame.size.width
        self.scroll.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }

    // MARK: - Banner Method
    @objc func autoScroll() {
        let totalPossibleOffset = CGFloat(BannerArr.count - 1) * self.view.bounds.size.width
        
     
       
            offSet += self.view.bounds.size.width
  
        self.scanCollView.contentOffset.x = CGFloat(self.offSet)
        let pageNumber = round(self.scanCollView.contentOffset.x / self.scanCollView.frame.size.width)
        self.pageControl.currentPage = Int(pageNumber)
        print("111",pageNumber)
        print("111111",BannerArr.count-2)
        
        var p:Int = Int(pageNumber)
        
        
    
    }
    // MARK: - booking_tickets_scan
    func booking_tickets_scan()
    {

    //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //hud.mode = MBProgressHUDMode.indeterminate
    //hud.self.bezelView.color = UIColor.black
    //hud.label.text = "Loading...."
        
        Alamofire.request("https://stumbal.com/process.php?action=booking_tickets_scan", method: .post, parameters: ["user_id" : UserDefaults.standard.value(forKey: "u_Id") as! String,"event_id": UserDefaults.standard.value(forKey: "Event_id") as! String], encoding:  URLEncoding.httpBody).responseJSON
    { response in
        if let data = response.data
        {
            let json = String(data: data, encoding: String.Encoding.utf8)
            
            print("Response: \(String(describing: json))")
            if json == ""
            {
                MBProgressHUD.hide(for: self.view, animated: true);
               // self.loadingView.isHidden = true
                let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                    self.booking_tickets_scan()
                }))
                self.present(alert, animated: false, completion: nil)
                
                
            }
            else
            {
                
                
                if let json: NSDictionary = response.result.value as? NSDictionary
                
                {
                     let result:String = json["result"] as! String
                   if result == "Success"
                    {
                       
                       
                       self.dataArray = json["code"] as! NSArray
                       self.venueLbl.text = json["vendor_name"] as! String
                       self.eventLbl.text = json["event_name"] as! String
                       self.dateLbl.text = json["date of purchase"] as! String
                       
                       
                       self.scanCollView.dataSource = self
                       self.scanCollView.delegate = self
                       self.pageControl.numberOfPages = self.dataArray.count
                       self.pageControl.currentPage = 0
                       
                       let q:String = json["quantity"] as! String
                       if q == ""
                       {
                           self.qtyLbl.text = "1" + "X TICKETS"
                       }
                       else
                       {
                           self.qtyLbl.text = q + "X TICKETS"
                       }
                       let p:String = json["price"] as! String
                       self.priceLbl.text = "TOTAL: A$" + p
                       
//                       DispatchQueue.main.async {
//                           self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
//                       }
                       
                       self.BannerArr = self.dataArray.mutableCopy() as! NSMutableArray
                       if self.BannerArr.count > 0{
                           DispatchQueue.main.async {
                             //  self.changeImage()
                               self.scanCollView.reloadData()

                           }
                       }else{

                       }
                   }
                    else
                    {
                        
                    }
                
                    
           
                    
                }
                else
                {
                  //  self.loadingView.isHidden = true

                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }

    }

    
    // MARK: - banner
    func show_banners()
    {
       
        Alamofire.request("https://chumki.org/Stepup/Apis/process.php?action=Banners", method: .post, parameters: ["language":"en"], encoding:  URLEncoding.httpBody).responseJSON
            { response in
                            if let data = response.data
                            {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("Response: \(String(describing: json))")
                                if json == ""
                                {
                                    let alert = UIAlertController(title: "Network Error: Could not connect to server.", message: "Oops! Network was failed to process your request. Do you want to try again?", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                        print("Action")
                                        self.show_banners()
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                else
                                {
                                    do  {
                                        
                                        self.dataArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
                                        
                                        print("5566262",self.dataArray)
                                        self.BannerArr = self.dataArray.mutableCopy() as! NSMutableArray
                                        if self.BannerArr.count > 0{
                                            DispatchQueue.main.async {
                                                
                                                self.ShowBanners()
                                                
                                            }
                                        }else{
                                            
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

    func configurePageControl() {
        self.pageControl.numberOfPages = BannerArr.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    func ShowBanners()  {
        configurePageControl()
        for i in 0..<BannerArr.count {
            let imageView = UIImageView()
            let x = self.view.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: self.scroll.frame.width, height: self.scroll.frame.height)
           imageView.contentMode = .scaleToFill
//
           imageView.layer.cornerRadius = 8;
            imageView.clipsToBounds = true
//           // imageView.sd_setImage(with: URL(string: (self.BannerArr[i] as AnyObject).value(forKey:"Image") as! String), placeholderImage: UIImage(named: "placeholder.png"))
//
//
//
//            //  self.view.addSubview(label)
//
           imageView.image = UIImage(named: "scaneer")
//
            imageView.isUserInteractionEnabled = true
//            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(openImage(sender:)))
//            imageView.tag = i
//            imageView.addGestureRecognizer(tapgesture)
//            self.scroll.contentSize.width = self.scroll.frame.size.width * CGFloat(i + 1)
//            self.scroll.addSubview(imageView)
            
            let imageView1 = UIImageView()
            let x1 = self.view.frame.size.width * CGFloat(i)
            imageView1.frame = CGRect(x: 107, y: 30, width: 160, height: 160)
            imageView1.contentMode = .scaleToFill
            
            imageView1.layer.cornerRadius = 8;
            imageView1.clipsToBounds = true
            imageView1.sd_setImage(with: URL(string: (self.BannerArr[i] as AnyObject).value(forKey:"image") as! String), placeholderImage: UIImage(named: "vdefault"))
            imageView1.isUserInteractionEnabled = true
            let tapgesture1 = UITapGestureRecognizer(target: self, action: #selector(openImage1(sender:)))
            imageView1.tag = i
            imageView1.addGestureRecognizer(tapgesture1)
            self.scroll.contentSize.width = self.scroll.frame.size.width * CGFloat(i + 1)
            self.scroll.addSubview(imageView)
            self.scroll.addSubview(imageView1)
            
            self.pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    @objc func changeImage() {
     
     if counter < dataArray.count {
         let index = IndexPath.init(item: counter, section: 0)
         self.scanCollView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         pageControl.currentPage = counter
         counter += 1
     } else {
         counter = 0
         let index = IndexPath.init(item: counter, section: 0)
         self.scanCollView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
         pageControl.currentPage = counter
         counter = 1
     }
         
     }
}
extension NewTicketVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//       print("25222")
//       // changeImage()
//    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            let cell = scanCollView.dequeueReusableCell(withReuseIdentifier: "ScannerCollectionViewCell", for: indexPath) as! ScannerCollectionViewCell
        let eimg:String = (dataArray.object(at: indexPath.row) as AnyObject).value(forKey: "image")as! String
        
        if eimg == ""
        {
            cell.scanimg.image = UIImage(named: "h_qrcode")
            
        }
        else
        {
            let url = URL(string: eimg)
            let processor = DownsamplingImageProcessor(size: cell.scanimg.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
            cell.scanimg.kf.indicatorType = .activity
            cell.scanimg.kf.setImage(
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
                  //  self.changeImage()
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    cell.scanimg.image = UIImage(named: "h_qrcode")
                }
            }
            
        }
        return cell
    }
}
extension NewTicketVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = scanCollView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
