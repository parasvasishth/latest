//
//  ReportVC.swift
//  Stumbal
//
//  Created by Dr.Mac on 07/01/22.
//

import UIKit

class ReportVC: UIViewController {

    @IBOutlet weak var abuseLbl: UILabel!
    @IBOutlet weak var istLbl: UILabel!
    @IBOutlet weak var feedbackLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var clickLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
        abuseLbl.isUserInteractionEnabled = true
        abuseLbl.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        istLbl.isUserInteractionEnabled = true
        istLbl.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
        feedbackLbl.isUserInteractionEnabled = true
        feedbackLbl.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped4(tapGestureRecognizer:)))
        contactLbl.isUserInteractionEnabled = true
        contactLbl.addGestureRecognizer(tapGestureRecognizer4)
        
        self.clickLbl.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.clickLbl.addGestureRecognizer(tapgesture)
        
        clickLbl.text = "Please note that your issue may be fixed in the latest version, Click here to update your app."
        let text = (clickLbl.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Click here")
        let textColor: UIColor = .white
            let underLineColor: UIColor = .green
            let underLineStyle = NSUnderlineStyle.single.rawValue
        
        let labelAtributes:[NSAttributedString.Key : Any]  = [
               NSAttributedString.Key.foregroundColor: textColor,
               NSAttributedString.Key.underlineStyle: underLineStyle,
               NSAttributedString.Key.underlineColor: underLineColor
           ]
      //  #colorLiteral(red: 0.6117647059, green: 0.5098039216, blue: 0.3647058824, alpha: 1)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle,value: 1, range: range1)
        attributeString.addAttribute(NSAttributedString.Key.underlineColor, value: #colorLiteral(red: 0.6117647059, green: 0.5098039216, blue: 0.3647058824, alpha: 1), range: range1)
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.6117647059, green: 0.5098039216, blue: 0.3647058824, alpha: 1), range: range1)
        
      //  NSAttributedString(string: text, attributes: labelAtributes)
    //    9C825D
        clickLbl.attributedText = attributeString
        self.loadingView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        let text = (clickLbl.text)!
        let termsRange = (text as NSString).range(of: "Click here")
        if gesture.didTapAttributedTextInLabel(label: clickLbl, inRange: termsRange) {
            print("Tapped terms")
//            if let name = URL(string: ""), !name.absoluteString.isEmpty {
//              let objectsToShare = [name]
//              let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//              self.present(activityVC, animated: true, completion: nil)
//            } else {
//              // show alert for not available
//            }
//
            
            if let url = URL(string: "https://apps.apple.com/us/app/stumbal/id1566360669") {
                UIApplication.shared.open(url)
            }
        }
        else {
           
            print("Tapped none")
            if let url = URL(string: "https://apps.apple.com/us/app/stumbal/id1566360669") {
                UIApplication.shared.open(url)
        }
    }
    }
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
        UserDefaults.standard.set(true, forKey: "Abuse")
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer){
        UserDefaults.standard.set(true, forKey: "Isn't")
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @objc func imageTapped4(tapGestureRecognizer: UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "New", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewContactVC") as! NewContactVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
 

}
