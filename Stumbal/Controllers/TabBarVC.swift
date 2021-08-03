//
//  TabBarVC.swift
//  Stumbal
//
//  Created by mac on 18/03/21.
//

import UIKit

class TabBarVC: UITabBarController {

override func viewDidLoad() {
    super.viewDidLoad()
    //  self.tabBar.barTintColor = UIColor.white
    self.tabBar.isTranslucent = true
    
    let selectedColor   = UIColor.red
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
                    item.selectedImage = UIImage(named: "homer")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
                    
                }
                if(item.title! == "Artist")
                {
                    item.selectedImage = UIImage(named: "artistr")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
                    
                }
                if(item.title! == "Event")
                {
                    item.selectedImage = UIImage(named: "eventr")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
                    
                }
                if(item.title! == "Profile")
                {
                    item.selectedImage = UIImage(named: "profiler")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
                    
                }
                if(item.title! == "")
                {
                    item.selectedImage = UIImage(named: "power")?.withRenderingMode(.alwaysOriginal)
                    item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
                    
                }
                // item.selectedImage = UIImage(named: "(Imagename)-a")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    //        tabBar.unselectedItemTintColor = UIColor.white
    //
    //        if #available(iOS 13.0, *) {
    //            tabBar.selectedItem?.selectedImage?.withTintColor(#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
    //        } else {
    //            // Fallback on earlier versions
    //        }
    // Do any additional setup after loading the view.
    

}
   

override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    
    if(item.title! == "Home")
    {
        
        if UserDefaults.standard.bool(forKey: "homesw") == true
        {
            self.revealViewController().revealToggle(animated: true)
        }
        else
        {
            item.selectedImage = UIImage(named: "homer")?.withRenderingMode(.alwaysOriginal)
            item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
    if(item.title! == "Artist")
    {
        
        if UserDefaults.standard.bool(forKey: "homesw") == true
        {
            
            self.revealViewController().revealToggle(animated: true)
            
            //            var signuCon = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            //            signuCon.modalPresentationStyle = .fullScreen
            //            self.present(signuCon, animated: false, completion:nil)
        }
        else
        {
            item.selectedImage = UIImage(named: "artistr")?.withRenderingMode(.alwaysOriginal)
            item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
        }
        
    }
    if(item.title! == "Event")
    {
        item.selectedImage = UIImage(named: "eventr")?.withRenderingMode(.alwaysOriginal)
        item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
        
    }
    if(item.title! == "Profile")
    {
        item.selectedImage = UIImage(named: "profiler")?.withRenderingMode(.alwaysOriginal)
        item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
        
    }
    if(item.title! == "")
    {
        item.selectedImage = UIImage(named: "power")?.withRenderingMode(.alwaysOriginal)
        item.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
        
    }
    
}

}
