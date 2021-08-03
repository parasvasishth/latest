//
//  ViewProposalVC.swift
//  Stumbal
//
//  Created by mac on 19/04/21.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit
import Kingfisher
class ViewProposalVC: UIViewController {

    @IBOutlet var providerNameFiled: UITextField!
    @IBOutlet var descripTxtView: UITextView!
    @IBOutlet var videoHeight: NSLayoutConstraint!
    @IBOutlet var videoView: UIView!
    @IBOutlet var videoImg: UIImageView!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var dateFiedl: UITextField!
    @IBOutlet var timeField: UITextField!
    @IBOutlet var trailheight: NSLayoutConstraint!
    var hud = MBProgressHUD()
    override func viewDidLoad() {
    super.viewDidLoad()
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.self.bezelView.color = UIColor.black
        hud.label.text = "Loading...."
    //venueImg.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
        priceField.isUserInteractionEnabled = false
        providerNameFiled.isUserInteractionEnabled = false
        dateFiedl.isUserInteractionEnabled = false
        timeField.isUserInteractionEnabled = false
        
        priceField.setLeftPaddingPoints(10)
        providerNameFiled.setLeftPaddingPoints(10)
        dateFiedl.setLeftPaddingPoints(10)
        timeField.setLeftPaddingPoints(10)
        descripTxtView.leftSpace()
    
    if UserDefaults.standard.value(forKey: "p_video") as! String == ""
    {
        videoView.isHidden = true
        videoHeight.constant = 0
        trailheight.constant = 15
    }
    else
    {
        videoView.isHidden = false
        videoImg.isHidden = false
        videoHeight.constant = 70
        
     

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
    providerNameFiled.text = UserDefaults.standard.value(forKey: "p_name") as! String
    descripTxtView.text = UserDefaults.standard.value(forKey: "p_desc") as! String
    priceField.text = UserDefaults.standard.value(forKey: "p_price") as! String
    dateFiedl.text = UserDefaults.standard.value(forKey: "p_date") as! String
    timeField.text = UserDefaults.standard.value(forKey: "p_time") as! String
    

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        videoImg.isUserInteractionEnabled = true
        videoImg.addGestureRecognizer(tapGestureRecognizer)
        MBProgressHUD.hide(for: self.view, animated: true);
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
    
@IBAction func videoPlay(_ sender: UIButton) {
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
