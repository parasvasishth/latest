//
//  NewProposalDetailVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 21/01/22.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit
import Kingfisher
class NewProposalDetailVC: UIViewController {

    @IBOutlet weak var venueField: UITextField!
    @IBOutlet weak var eventField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var videoImg: UIImageView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var VideoimgHeight: NSLayoutConstraint!
    @IBOutlet weak var playHeight: NSLayoutConstraint!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingView.isHidden = false

    //venueImg.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
        priceField.isUserInteractionEnabled = false
        venueField.isUserInteractionEnabled = false
        dateField.isUserInteractionEnabled = false
        timeField.isUserInteractionEnabled = false
        
        venueField.isUserInteractionEnabled = false
        eventField.isUserInteractionEnabled = false
        timeField.isUserInteractionEnabled = false
        dateField.isUserInteractionEnabled = false
        priceField.isUserInteractionEnabled = false
        
        priceField.setLeftPaddingPoints(10)
        venueField.setLeftPaddingPoints(10)
        eventField.setLeftPaddingPoints(10)
        dateField.setLeftPaddingPoints(10)
        timeField.setLeftPaddingPoints(10)
        descriptionField.leftSpace()
        
        venueField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        eventField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        //descriptionFeild.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        priceField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        dateField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        timeField.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
    
    if UserDefaults.standard.value(forKey: "p_video") as! String == ""
    {
        videoImg.isHidden = true
        VideoimgHeight.constant = 0
        playHeight.constant = 0
       // trailheight.constant = 15
    }
    else
    {
       // videoView.isHidden = false
        videoImg.isHidden = false
        VideoimgHeight.constant = 60
        playHeight.constant = 25
        
     

        let uimg:String = UserDefaults.standard.value(forKey: "p_videoimg") as! String
        
        
        if uimg == ""
        {
            self.videoImg.image = UIImage(named: "udefault")
           
        }
        else
        {
           let url = URL(string: uimg)
           let processor = DownsamplingImageProcessor(size: self.videoImg.bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: 0)
           self.videoImg.kf.indicatorType = .activity
           self.videoImg.kf.setImage(
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
                self.videoImg.image = UIImage(named: "udefault")
               }
           }
           
        }
        
  
    }
    venueField.text = UserDefaults.standard.value(forKey: "p_name") as! String
    descriptionField.text = UserDefaults.standard.value(forKey: "p_desc") as! String
    priceField.text = UserDefaults.standard.value(forKey: "p_price") as! String
    dateField.text = UserDefaults.standard.value(forKey: "p_date") as! String
    timeField.text = UserDefaults.standard.value(forKey: "p_time") as! String
        eventField.text = UserDefaults.standard.value(forKey: "p_ename") as! String
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        videoImg.isUserInteractionEnabled = true
        videoImg.addGestureRecognizer(tapGestureRecognizer)
        MBProgressHUD.hide(for: self.view, animated: true);
        self.loadingView.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func playBtn(_ sender: UIButton) {
        let u = UserDefaults.standard.value(forKey: "p_video") as! String
        // if let url = URL(string: AppendArr[indexPath.row]) {
        
        let url = NSURL(string: u);
        let player = AVPlayer(url: url as! URL);
        
        // let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.modalPresentationStyle = .fullScreen
        present(playerViewController, animated: false) {
            player.play()
            
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
      
        let u = UserDefaults.standard.value(forKey: "p_video") as! String
        // if let url = URL(string: AppendArr[indexPath.row]) {
        
        let url = NSURL(string: u);
        let player = AVPlayer(url: url as! URL);
        
       // let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.modalPresentationStyle = .fullScreen
        present(playerViewController, animated: false) {
            player.play()
        }
    }
    func videoSnapshot(filePathLocal:URL) -> UIImage? {
        do
        {
            let asset = AVURLAsset(url: filePathLocal)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at:CMTimeMake(value: Int64(0), timescale: Int32(1)),actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        }
        catch let error as NSError
        {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
}
extension UITextView {
func leftSpace() {
    self.textContainerInset = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
}
}
