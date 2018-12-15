//
//  FrequentlyAskViewController.swift
//  YourPic
//
//  Created by Krishna_Mac_6 on 12/04/18.
//  Copyright © 2018 Krishna_Mac_6. All rights reserved.
//

import Foundation
import WebKit

class FrequentlyAskViewController: UIViewController , WKNavigationDelegate,WKUIDelegate{
    
  @IBOutlet weak var webView : WKWebView!
    var progressHUD :ProgressHUD!
    
    // MARK: - UIViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
          webView.navigationDelegate = self
          webView.uiDelegate = self
       
        progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD!)
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        progressHUD.removeFromSuperview()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        progressHUD.removeFromSuperview()
    }
    
    // MARK: - IBAction
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
