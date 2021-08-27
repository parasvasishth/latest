//
//  ContactVC.swift
//  Stumbal
//
//  Created by mac on 01/05/21.
//

import UIKit
import WebKit
class ContactVC: UIViewController,WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "https://stumbal.com/contact/");
        
        let requestObj = NSURLRequest(url: url! as URL);
        webView.load(requestObj as URLRequest);
        self.view.addSubview(webView)
        
        webView.scrollView.bounces = false
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView!)
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("confirm('Hello from evaluateJavascript()')", completionHandler: nil)
    }
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let title = NSLocalizedString("OK", comment: "OK Button")
        let ok = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true)
        completionHandler()
    }
    
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if let text = alert.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
            completionHandler(nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        //        if ipad will crash on this do this (https://stackoverflow.com/questions/42772973/ios-wkwebview-javascript-alert-crashing-on-ipad?noredirect=1&lq=1):
        //        if let presenter = alertController.popoverPresentationController {
        //            presenter.sourceView = self.view
        //        }
        //
        //        self.present(alertController, animated: true, completion: nil)
    }
    
    //    func webView(_ webView: WKWebView,
    //                     runJavaScriptConfirmPanelWithMessage message: String,
    //                     initiatedByFrame frame: WKFrameInfo,
    //                     completionHandler: @escaping (Bool) -> Void) {
    //
    //            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
    //
    //            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
    //                completionHandler(true)
    //            }))
    //
    //            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
    //                completionHandler(false)
    //            }))
    //
    //            self.present(alertController, animated: true, completion: nil)
    //        }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
        
    }
}
