
import Foundation
import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate{
    
    let registerService = RegisterService()
    
    @IBOutlet var txtUserEmail :UITextField?
    @IBOutlet var txtUserName :UITextField?
    @IBOutlet var txtPassword :UITextField?
    @IBOutlet var txtConfirmPswd :UITextField?
    
    @IBOutlet var emailContainerView :UIView?
    @IBOutlet var userNameContainerView :UIView?
    @IBOutlet var passwordContainerView :UIView?
    @IBOutlet var confirmPswdContainerView :UIView?
    
    @IBOutlet var btnRegister :UIButton?
    @IBOutlet var btnFBLogin :UIButton?
    @IBOutlet var btnGoogleLogin :UIButton?
    @IBOutlet var btnTwitterLogin :UIButton?
    
    var loginDictionary : NSDictionary?
    // MARK: - UIViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtUserEmail?.delegate = self
        self.txtUserName?.delegate = self
        self.txtPassword?.delegate = self
        self.txtConfirmPswd?.delegate = self
        
        self.emailContainerView?.layer.cornerRadius = 10
        self.userNameContainerView?.layer.cornerRadius = 10
        self.passwordContainerView?.layer.cornerRadius = 10
        self.confirmPswdContainerView?.layer.cornerRadius = 10
        
        btnRegister?.layer.cornerRadius = 10
        btnRegister?.layer.borderWidth = 1
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if Reachability.isConnectedToNetwork() == true {
        if textField == txtUserName {
            txtUserEmail?.becomeFirstResponder()
        }else if textField == txtUserEmail{
            txtPassword?.becomeFirstResponder()
        }else if textField == txtPassword {
            txtConfirmPswd?.becomeFirstResponder()
        }else if textField == txtConfirmPswd {
            txtConfirmPswd?.resignFirstResponder()
            self.register()
        }
        }else{
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        return true
    }
    
    func register () {
        let usernameStr : String = (txtUserName?.text)!
        let passwordStr : String = (txtPassword?.text)!
        
        if usernameStr == "" {
            let alertController = UIAlertController(title: "Warning", message: "Username cannot be empty.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else if usernameStr.count < 2 {
            let alertController = UIAlertController(title: "Warning", message: "Username should have min 2 letters.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else if txtUserEmail?.text == "" {
            let alertController = UIAlertController(title: "Warning", message: "User email cannot be empty.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if !(isValidEmail(testStr: (txtUserEmail?.text)!)){
            let alertController = UIAlertController(title: "Warning", message: "Please enter valid user email.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else if !(isValidPassword(text: (txtPassword?.text)!)){
            let alertController = UIAlertController(title: "Warning", message: "Your password should have 6 to 20 characters which contain at least one numeric digit, one uppercase, one lowercase letter and one special character.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else if (passwordStr.count > 20) || (passwordStr.count < 6){
            let alertController = UIAlertController(title: "Warning", message: "Your password should have 6 to 20 characters which contain at least one numeric digit, one uppercase, one lowercase letter and one special character.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else if txtPassword?.text == "" || txtConfirmPswd?.text == "" {
            let alertController = UIAlertController(title: "Warning", message: "Password/Confirm Password cannot be empty.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        } else if passwordStr.count < 5 {
            let alertController = UIAlertController(title: "Warning", message: "Password should have min 5 letters.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else {
            
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            //  self.view.backgroundColor = UIColor.black
            
            //Login Api
            registerService.registerUser(userName: (txtUserName?.text!)!, password: (txtPassword?.text!)!, confirmPassword: (txtConfirmPswd?.text!)!, email: (txtUserEmail?.text!)!) {(result, message, status )in
                
                progressHUD.removeFromSuperview()
                
                let registerDetails = result as? RegisterService
              
                if let registerDict = registerDetails?.registerData {
                    self.loginDictionary = registerDict
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
                }else{
                    let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                if result == "1"
                {
                    let alertController = UIAlertController(title: "Your Pick", message: "Account Created, Please confirm email to Login", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
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
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            self.register()
      
        } else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
       
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword( text : String) -> Bool{
        
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        print("\(capitalresult)")
        
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print("\(numberresult)")
        
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/_]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluate(with: text)
        print("\(specialresult)")
        
        return capitalresult && numberresult && specialresult
        
    }
}
