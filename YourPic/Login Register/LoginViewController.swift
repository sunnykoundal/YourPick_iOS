
import Foundation
import UIKit
import Crashlytics
import WebKit

class LoginViewController: UIViewController,UITextFieldDelegate, WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let fetchUserDataService = FetchUserDataService()
    
    let loginService = LoginService()
    var homePage = HomeViewController()
    var playDetailPage = PlayDetailsViewController()
    let progressHUD = ProgressHUD(text: "Loading")
    
    @IBOutlet weak var webView : WKWebView?
    @IBOutlet var txtUserEmail :UITextField?
    @IBOutlet var txtUserPassword :UITextField?
    
    @IBOutlet var emailContainerView :UIView?
    @IBOutlet var pswdContainerView :UIView?
    
    @IBOutlet var btnLogin :UIButton?
    @IBOutlet var btnFBLogin :UIButton?
    @IBOutlet var btnGoogleLogin :UIButton?
    @IBOutlet var btnTwiiterLogin :UIButton?
    @IBOutlet var btnForgotPassword :UIButton?
    @IBOutlet var btnRegister: UIButton!
    
    var loginDictionary : NSDictionary?
    var userProfileDataDictionary = NSDictionary()
    
    // MARK: - UIViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView?.navigationDelegate = self
        self.webView?.uiDelegate = self
        self.webView?.scrollView.delegate = self
        
        self.loadWebView()
        
        self.emailContainerView?.layer.cornerRadius = 10
        self.pswdContainerView?.layer.cornerRadius = 10
        
        btnLogin?.layer.cornerRadius = 10
        btnLogin?.layer.borderWidth = 1
        
        self.txtUserEmail?.delegate = self
        self.txtUserPassword?.delegate = self
        
        let registerTitle:String = "Don't have an account? REGISTER HERE"
        var registerTitleMutableString = NSMutableAttributedString()
        
        registerTitleMutableString = NSMutableAttributedString(string: registerTitle as String, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16, weight: .semibold)])
        
        registerTitleMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 113.0/255.0, green: 193.0/255.0, blue: 68.0/255.0, alpha: 1.0), range: NSRange(location:23,length:13))
        registerTitleMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:23))
        
        btnRegister.setAttributedTitle(registerTitleMutableString, for: .normal)
        
        //        self.login()
        //        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        if (self.webView?.canGoBack)! {
            self.webView?.goBack()
        }else{
             self.dismiss(animated: false, completion: nil)
        }
    }
    
    func loadWebView() {
        //self.removeWebData()
        
        self.view.addSubview(self.progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let urlStr = "https://sandbox.gamblingtec.com/widget/login" + "?redirectTo=" + "https://sandbox.gamblingtec.com/oauth/authorize"
        let url : NSURL = NSURL(string: urlStr)!
        let req = NSURLRequest(url:url as URL)
        self.webView?.load(req as URLRequest)
    }
    
    func startAuth() {
        let uuid = UUID().uuidString
        
        self.view.addSubview(self.progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let urlStr = "https://sandbox.gamblingtec.com/oauth/authorize" + "?client_id=fantasymobile" + "&response_type=code" +
            "&scope=basic%20transparent&state=" + uuid
        
        let url : NSURL = NSURL(string: urlStr)!
        let req = NSURLRequest(url:url as URL)
        self.webView?.load(req as URLRequest)
    }
    
    // MARK: - IBAction
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUserEmail {
            txtUserPassword?.becomeFirstResponder()
        }else{
            txtUserPassword?.resignFirstResponder()
            if Reachability.isConnectedToNetwork() == true {
                //                self.login()
                
            } else {
                let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        return true
    }
    
    @IBAction func registerBtn(_ sender: Any) {
    }
    
    func login(codeValue:String) {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        //  self.view.backgroundColor = UIColor.black
        
        //Login Api
        
        loginService.userLogin(code:codeValue) {(result, message, status )in
            
            progressHUD.removeFromSuperview()
            
            let loginDetails = result as? LoginService
            if let loginDict = loginDetails?.loginData {
                self.loginDictionary = loginDict
            }else{
                let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                    
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            
            
            var result:String = ""
            var message:String = ""
            
            if let resultValue: String = self.loginDictionary?.value(forKey: "result") as? String {
                result = resultValue
            }else{
                let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if let messageValue: String = self.loginDictionary?.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                let userData: NSDictionary = self.loginDictionary?.value(forKey: "data") as! NSDictionary
                
                
                let userId: Int64 = userData.value(forKey: "UserId") as! Int64
                //                let userName: String = userData.value(forKey: "UserName") as! String
                //                let userImg: String = userData.value(forKey: "Image") as! String
                //                let amount: Double = userData.value(forKey: "Ammount") as! Double
                //
                //                UserDefaults.standard.set(userId, forKey: "UserId")
                //                UserDefaults.standard.set(userName, forKey: "UserName")
                //                UserDefaults.standard.set(userImg, forKey: "UserImage")
                //                 UserDefaults.standard.set(true, forKey: "Loged In")
                //                 UserDefaults.standard.set(amount, forKey: "Amount")
                //
                //                self.delegate.totalAmount = amount
                self.fetchUserProfileData(userId: userId)
                
            }
            else if result == "0"
            {
                let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    func fetchUserProfileData(userId: Int64 ) {
        let progressHUD = ProgressHUD(text: "Loading")
        
        if Reachability.isConnectedToNetwork() == true {
            
            //Show loading Indicator
            
            self.view.addSubview(progressHUD)
            //  self.view.backgroundColor = UIColor.black
            
            //Login Api
            fetchUserDataService.fetchUserData(userId:userId) {(result, message, status )in
                self.view.isUserInteractionEnabled = true
                progressHUD.removeFromSuperview()
                
                let userProfileData = result as? FetchUserDataService
                
                if let userProfileDataDict = userProfileData?.userData {
                    self.userProfileDataDictionary = userProfileDataDict
                }else{
                    let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                        
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                
                
                var result:String = ""
                var message:String = ""
                
                if let resultValue: String = self.userProfileDataDictionary.value(forKey: "result") as? String {
                    result = resultValue
                }else{
                    let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                        self.view.isUserInteractionEnabled = true
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                if let messageValue: String = self.userProfileDataDictionary.value(forKey: "message") as? String{
                    message = messageValue
                }
                if result == "1"
                {
                    let userData: NSDictionary = self.userProfileDataDictionary.value(forKey: "data") as! NSDictionary
                    
                    if let userName: String = userData.value(forKey: "UserName") as? String {
                        UserDefaults.standard.set(userName, forKey: "UserName")
                    }
                    
                    if let userImg: String = userData.value(forKey: "Image") as? String {
                        UserDefaults.standard.set(userImg, forKey: "UserImage")
                    }
                    
                    if let amount: Double = userData.value(forKey: "Ammount") as? Double {
                        UserDefaults.standard.set(amount, forKey: "Amount")
                        self.delegate.totalAmount = amount
                    }
                    
                    UserDefaults.standard.set(userId, forKey: "UserId")
                    UserDefaults.standard.set(true, forKey: "Loged In")
            
                    let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                    // Create View Controllers
                    self.homePage = mainStoryBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                    
                    self.present(self.homePage, animated: true, completion: nil)
                }
                else if result == "0"
                {
                    let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
            
        } else {
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        //        if Reachability.isConnectedToNetwork() == true {
        //            self.login()
        //
        //        } else {
        //            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
        //
        //            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
        //                (action : UIAlertAction!) -> Void in
        //            })
        //
        //            alertController.addAction(cancelAction)
        //            self.present(alertController, animated: true, completion: nil)
        //
        //        }
        
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation")
//        let isLogedIn:Bool = (UserDefaults.standard.value(forKey: "LogedIn") != nil)
        
        let urlStr : NSURL = webView.url! as NSURL
        let urlString: String = urlStr.absoluteString!
        let redirectUrlArr = urlString.components(separatedBy: "?")
        
        if urlString == "https://sandbox.gamblingtec.com/oauth/authorize" {
            self.startAuth()
        }else if redirectUrlArr[0] == "http://200.124.153.227:443/Home.html"{
            let code : String = webView.url!.valueOf("code")!
            print(code)
            
            
            if Reachability.isConnectedToNetwork() == true {
                self.login(codeValue: code)
                
            } else {
                let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommitNavigation - content arriving?")
        
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFailNavigation")
        
        self.view.isUserInteractionEnabled = true
        self.progressHUD.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
        self.view.addSubview(self.progressHUD)
        self.view.isUserInteractionEnabled = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinishNavigation")
        self.view.isUserInteractionEnabled = true
        self.progressHUD.removeFromSuperview()
    }
    
    func removeWebData() {
        
        if #available(iOS 9.0, *) {
            
            let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
            let date = NSDate(timeIntervalSince1970: 0)
            
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date as Date, completionHandler: {
                #if DEBUG
                
                print("remove all data in iOS9 later")
                
                #endif
            })
            
        }else {
            
            // Remove the basic cache.
            URLCache.shared.removeAllCachedResponses()
            
            // Delete system cookie store in the app
            let storage = HTTPCookieStorage.shared
            if let cookies = storage.cookies {
                for cookie in cookies {
                    storage.deleteCookie(cookie)
                }
            }
            
            do {
                // Clear web cache
                try deleteLibraryFolderContents(folder: "Caches")
                try deleteLibraryFolderContents(folder: "Cookies")
                
                // Removes all app cache storage.
                try deleteLibraryFolder(folder: "WebKit")
                
            } catch {
                #if DEBUG
                
                print("Delete library folders error in iOS9 below")
                
                #endif
                
            }
        }
    }
    
    //MARK: -   Delete folder in library
    func deleteLibraryFolder(folder: String) throws {
        let manager = FileManager.default
        let library = manager.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let dir = library.appendingPathComponent(folder)
        try manager.removeItem(at: dir)
    }
    
    /**
     Delete contents in library folder
     */
    private func deleteLibraryFolderContents(folder: String) throws {
        let manager = FileManager.default
        let library = manager.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: .userDomainMask)[0]
        let dir = library.appendingPathComponent(folder)
        let contents = try manager.contentsOfDirectory(atPath: dir.path)
        for content in contents {
            do {
                try manager.removeItem(at: dir.appendingPathComponent(content))
            } catch where ((error as NSError).userInfo[NSUnderlyingErrorKey] as? NSError)?.code == Int(EPERM) {
                #if DEBUG
                
                print("Couldn't delete some library contents.")
                
                #endif
            }
        }
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}

