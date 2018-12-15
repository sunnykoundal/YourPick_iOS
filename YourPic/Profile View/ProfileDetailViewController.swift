
import Foundation
import UIKit
import SwiftR
import WebKit

class ProfileDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate{
    
    let fetchUserDataService = FetchUserDataService()
    
     let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var depositMoneyPage = DepositMoneyViewController()
    var withdrawPage = WithdrawViewController()
    var transactionPage = TransactionHistoryViewController()
    var settingScreen = SettingsViewController()
    var signOutService = SignOutService()
    
    var descriptionText: String = ""
    var url : String = ""
    var logoutUser = NSDictionary()
    
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var ticketValueLbl: UILabel!
    @IBOutlet weak var draftsValueLbl: UILabel!
    @IBOutlet weak var winningValueLbl: UILabel!
    @IBOutlet weak var balanceValueLbl: UILabel!
    @IBOutlet weak var followerValueLbl: UILabel!
    @IBOutlet weak var followingValueLbl: UILabel!
    var userData = NSDictionary()
     var userProfileDataDictionary = NSDictionary()
    
    let uploadImageService = UploadProfilePicService()
    var imageUploaded:Bool = false
    var isFirstTime:Bool = true
    // MARK: - UIViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage?.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage?.layer.borderWidth = 1
        profileImage?.clipsToBounds = true;
        profileImage.layer.borderColor = UIColor.clear.cgColor
        
        cameraBtn.backgroundColor = UIColor.white
        cameraBtn.layer.cornerRadius = cameraBtn.frame.size.height/2
        cameraBtn.clipsToBounds = true;
        
        self.fetchUserData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchUserData()
        
    }
    func fetchUserData() {
        let progressHUD = ProgressHUD(text: "Loading")

        if Reachability.isConnectedToNetwork() == true {
            
            //Show loading Indicator
            
            self.view.addSubview(progressHUD)
            //  self.view.backgroundColor = UIColor.black
            
            let userId: Int64 = Int64(UserDefaults.standard.integer(forKey: "UserId"))
            
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
                    if let userDataValue: NSDictionary = self.userProfileDataDictionary.value(forKey: "data") as? NSDictionary{
                        self.userData = userDataValue
                    }
                    
                    self.setValuesToFields()
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
    func setValuesToFields() {
        let playerImg: String = UserDefaults.standard.string(forKey: "UserImage")!
        
        self.profileImage.sd_setImage(with: URL(string: playerImg), placeholderImage:#imageLiteral(resourceName: "ProfilePlaceholder"))
    
//        var firstNameValue: String = ""
//        var lastNameValue: String = ""
        
//        if let firstName: String = userData.value(forKey: "FirstName") as? String {
//            firstNameValue = firstName
//        }
//
//        if let lastName: String = userData.value(forKey: "LastName") as? String {
//            lastNameValue = lastName
//        }
        var UserNameValue: String = ""
        
        if let UserName: String = userData.value(forKey: "UserName") as? String {
            UserNameValue = UserName
        }
        
//        self.playerNameLbl.text = firstNameValue + " " + lastNameValue
        self.playerNameLbl.text = UserNameValue
       
        if let draftCount: Int64 = userData.value(forKey: "DraftCount") as? Int64 {
            self.draftsValueLbl.text = String(draftCount)
        }
        
        if let amount: Double = userData.value(forKey: "Ammount") as? Double {
            self.delegate.totalAmount = amount
            UserDefaults.standard.set(amount, forKey: "Amount")
        }
        
        let balance: Double = Double(self.delegate.totalAmount)
        
        self.balanceValueLbl.text = "€" + String(balance)
    }
    
    @IBAction func selectPorfileImageBtn(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Please select the image.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default , handler:{ (UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func depositMoneyBtn(_ sender: Any) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
        
        self.depositMoneyPage = mainStoryBoard.instantiateViewController(withIdentifier: "DepositMoney") as! DepositMoneyViewController
        
        self.present(self.depositMoneyPage, animated: true, completion: nil)
    }
    
    @IBAction func withdrawnBtn(_ sender: Any) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
        
        self.withdrawPage = mainStoryBoard.instantiateViewController(withIdentifier: "Withdraw") as! WithdrawViewController
        
        self.present(self.withdrawPage, animated: true, completion: nil)
    }
    
    @IBAction func transactionHistoryBtn(_ sender: Any) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
        
        self.transactionPage = mainStoryBoard.instantiateViewController(withIdentifier: "TransactionHistory") as! TransactionHistoryViewController
        
        self.present(self.transactionPage, animated: true, completion: nil)
    }
    
    @IBAction func ruleBtn(_ sender: Any) {
        
    }
    
    @IBAction func signOutBtn(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            self.signOut()
        
        } else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func inviteFriendBtn(_ sender: Any) {
        
        let myWebsite = NSURL(string: "https://www.apple.com/in/ios/app-store/")
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        let shareItems:Array = [url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func settingBtn(_ sender: Any) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
        
        self.settingScreen = mainStoryBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.present(self.settingScreen, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let image2 = image.resized(toWidth: 372.0)
            let data = UIImageJPEGRepresentation(image2!, 1.0)
            
            self.uploadImageToServer(imageData: data!)
        }else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToServer(imageData:Data)
    {
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
  
        if Reachability.isConnectedToNetwork() == true {
            
            
            uploadImageService.uploadImage(userId:"\(userId)", imageData: imageData, onCompletion: {(result, message, status )in
            progressHUD.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
                
                var userData = NSDictionary()
                var userImg : String = ""
                
                if  let userDataDict: NSDictionary = result!.value(forKey: "data") as? NSDictionary {
                    userData = userDataDict
                }else{
                    let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                if  let userImgValue: String = userData.value(forKey: "ResultText1") as? String {
                    userImg = userImgValue
                }else{
                    let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                UserDefaults.standard.set(userImg, forKey: "UserImage")
           
                self.setValuesToFields()
            })

        } else {
            progressHUD.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            
            let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
   // MARK: - ActivityViewController delegate
    
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        NSLog("Place holder")
        return descriptionText as AnyObject;
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        NSLog("Place holder itemForActivity")
        if(activityType == UIActivityType.mail.rawValue){
            return descriptionText as AnyObject
        } else if(activityType == UIActivityType.postToTwitter.rawValue){
            return descriptionText + " via @iOSgetstarted " + url as AnyObject
        } else {
            return descriptionText + " url" as AnyObject
        }
    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        NSLog("Place holder subjectForActivity")
        if(activityType == UIActivityType.mail.rawValue){
            return "Hey check this out!!"
        } else if(activityType == UIActivityType.postToTwitter.rawValue){
            return descriptionText + " via @iOSgetstarted " + url
        } else {
            return descriptionText + " via @iOSgetstarted " + url
        }
    }
    
   func signOut() {
    
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
    
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        signOutService.logoutUser(userId: userId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            
            let logoutUserData = result as? SignOutService
            
            progressHUD.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            //
            if let logoutUserDict = logoutUserData?.logoutUserData {
                self.logoutUser = logoutUserDict
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
            
            if let resultValue: String = self.logoutUser.value(forKey: "result") as? String {
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
            if let messageValue: String = self.logoutUser.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                UserDefaults.standard.removeObject(forKey: "UserId")
                UserDefaults.standard.removeObject(forKey: "UserName")
                UserDefaults.standard.removeObject(forKey: "UserImage")
                UserDefaults.standard.removeObject(forKey: "Balance")
//                UserDefaults.standard.removeObject(forKey: "Loged In")
                UserDefaults.standard.set(false, forKey: "Loged In")
                var joinNowPage = JoinNowViewController()
                let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                // Create View Controllers
                joinNowPage = mainStoryBoard.instantiateViewController(withIdentifier: "JoinNow") as! JoinNowViewController
                
                self.present(joinNowPage, animated: true, completion: nil)
                
//                // Remove all cache
//                URLCache.shared.removeAllCachedResponses()
//
//                // Delete any associated cookies
//                if let cookies = HTTPCookieStorage.shared.cookies {
//                    for cookie in cookies {
//                        HTTPCookieStorage.shared.deleteCookie(cookie)
//                    }
//                }
                self.removeWebData()
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

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
