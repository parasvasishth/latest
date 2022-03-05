//
//  TabBarVC.swift
//  Stumbal
//
//  Created by mac on 18/03/21.
//

import UIKit

class TabBarVC: UITabBarController {
    static private(set) var currentInstance: TabBarVC?
override func viewDidLoad() {
    super.viewDidLoad()
     // self.tabBar.barTintColor = UIColor.white
  //  self.tabBar.isTranslucent = true
    
//    self.tabBar.layer.masksToBounds = true
//    self.tabBar.isTranslucent = true
//    self.tabBar.barStyle = .blackOpaque
//    self.tabBar.layer.cornerRadius = 20
//    self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  //  tabBar.roundCorners(corners: [.topRight , .topLeft], radius: 20)
    TabBarVC.currentInstance = self
    let selectedColor   =  #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)
    let unselectedColor = UIColor.white
    let appearance = UITabBarItem.appearance()
    let attributes = [NSAttributedString.Key.font:UIFont(name: "Poppins", size: 13)]
    appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
    

    if let items = self.tabBar.items {
        for item in items {
            if let image = item.image {
                item.image = image.withRenderingMode( .alwaysOriginal )
                if(item.title! == "Home")
                {
                    item.selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)
                    
                }
                if(item.title! == "Artist")
                {
                    item.selectedImage = UIImage(named: "artist")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)
                    
                }
                if(item.title! == "Event")
                {
                    item.selectedImage = UIImage(named: "event")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)
                    
                }
                if(item.title! == "Profile")
                {
                    item.selectedImage = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)
                    
                }
                if(item.title! == "")
                {
                    item.selectedImage = UIImage(named: "power")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)
                    
                }
                // item.selectedImage = UIImage(named: "(Imagename)-a")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
}
    
//    @IBDesignable class TabBarWithCorners: UITabBar {
//        @IBInspectable var color: UIColor?
//        @IBInspectable var radii: CGFloat = 15.0
//
//        private var shapeLayer: CALayer?
//
//        override func draw(_ rect: CGRect) {
//            addShape()
//        }
//
//        private func addShape() {
//            let shapeLayer = CAShapeLayer()
//
//            shapeLayer.path = createPath()
//            shapeLayer.strokeColor = UIColor.gray.withAlphaComponent(0.1).cgColor
//            shapeLayer.fillColor = color?.cgColor ?? UIColor.white.cgColor
//            shapeLayer.lineWidth = 2
//            shapeLayer.shadowColor = UIColor.black.cgColor
//            shapeLayer.shadowOffset = CGSize(width: 0   , height: -3);
//            shapeLayer.shadowOpacity = 0.2
//            shapeLayer.shadowPath =  UIBezierPath(roundedRect: bounds, cornerRadius: radii).cgPath
//
//
//            if let oldShapeLayer = self.shapeLayer {
//                layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
//            } else {
//                layer.insertSublayer(shapeLayer, at: 0)
//            }
//
//            self.shapeLayer = shapeLayer
//        }
//
//        private func createPath() -> CGPath {
//            let path = UIBezierPath(
//                roundedRect: bounds,
//                byRoundingCorners: [.topLeft, .topRight],
//                cornerRadii: CGSize(width: radii, height: 0.0))
//
//            return path.cgPath
//        }
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            self.isTranslucent = true
//            var tabFrame            = self.frame
//            tabFrame.size.height    = 65 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero)
//            tabFrame.origin.y       = self.frame.origin.y +   ( self.frame.height - 65 - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero))
//            self.layer.cornerRadius = 20
//            self.frame            = tabFrame
//            self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0) })
//        }
//
//    }

override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

    if(item.title! == "Home")
    {

        if UserDefaults.standard.bool(forKey: "homesw") == true
        {
            self.revealViewController().revealToggle(animated: true)
        }
        else
        {
            item.selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
            item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    if(item.title! == "Artist")
    {

//        if UserDefaults.standard.bool(forKey: "homesw") == true
//        {
//
//            self.revealViewController().revealToggle(animated: true)
//
//            //            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            //            signuCon.modalPresentationStyle = .fullScreen
//            //            self.present(signuCon, animated: false, completion:nil)
//        }
//        else
//        {
            item.selectedImage = UIImage(named: "artist")?.withRenderingMode(.alwaysOriginal)
            item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)
      //  }

    }
    if(item.title! == "Event")
    {
        item.selectedImage = UIImage(named: "event")?.withRenderingMode(.alwaysOriginal)
        item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)

    }
    if(item.title! == "Profile")
    {
        item.selectedImage = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
        item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)

    }
    if(item.title! == "")
    {
        item.selectedImage = UIImage(named: "tlogo")?.withRenderingMode(.alwaysOriginal)
        item.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.862745098, green: 0.6941176471, blue: 0.9058823529, alpha: 1)], for: .selected)

    }

}

}
