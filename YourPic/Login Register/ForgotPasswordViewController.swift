
import Foundation
import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate{
    
    let forgotPasswordService = ForgotPasswordService()
    
    @IBOutlet var txtUserEmail :UITextField?
    
    @IBOutlet var emailContainerView :UIView?
    
    @IBOutlet var btnSavePassword: UIButton!
    @IBOutlet var btnSubmit :UIButton?
    @IBOutlet var otpView: UIView!
    @IBOutlet var resetPasswordView: UIView!
    @IBOutlet var lblOtpEmail: UILabel!
    @IBOutlet var txtOtp: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    
    var loginDictionary : NSDictionary?
    var userEmail:String = ""
    var onOTPScreen:Bool = false
    // MARK: - UIViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtUserEmail?.delegate = self
        self.emailContainerView?.layer.cornerRadius = 10
        
        btnSubmit?.layer.cornerRadius = 10
        btnSubmit?.layer.borderWidth = 1
        
        btnSavePassword?.layer.cornerRadius = 10
        btnSavePassword?.layer.borderWidth = 1
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IBAction
    
    @IBAction func backBtn(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func returnKeyboard(_ sender: UIButton) {
        txtUserEmail?.resignFirstResponder()
    }
    
    @IBAction func returnToLoginBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitBtn(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            if !(isValidEmail(testStr: (txtUserEmail?.text)!)){
                let alertController = UIAlertController(title: "Warning", message: "Please enter valid user email.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }else if txtUserEmail?.text != "" {
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            //  self.view.backgroundColor = UIColor.black
            
            self.userEmail = (txtUserEmail?.text!)!
            //Login Api
            forgotPasswordService.forgotPassword(userName: self.userEmail) {(result, message, status )in
                
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
                    self.lblOtpEmail.text = "We have sent an OTP on your email.\n \(String(describing: (self.txtUserEmail?.text!)!))"
                    self.otpView.isHidden = false
                    self.onOTPScreen = true
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
        }else{
            let alertController = UIAlertController(title: "Warning", message: "Username Can't be empty.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        } else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func resendOtpBtn(_ sender: Any) {
        
        //        let storyboard = UIStoryboard(name: "Home", bundle:nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "home") as! HomeViewController
        //        self.present(controller, animated: true, completion: nil)
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        //  self.view.backgroundColor = UIColor.black
        
        //Login Api
        forgotPasswordService.forgotPassword(userName: self.userEmail) {(result, message, status )in
            
            let registerDetails = result as? RegisterService
            progressHUD.removeFromSuperview()

            
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
            }
            
            
            if result == "1"
            {
                let alertController = UIAlertController(title: "Warning", message: "OTP sent to you email.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        if onOTPScreen {
        if txtOtp.text != "" {
            
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            //  self.view.backgroundColor = UIColor.black
            
            //Login Api
            forgotPasswordService.verifyOTP(userName: self.userEmail, otpCode:(txtOtp?.text!)!) {(result, message, status )in
                
                let registerDetails = result as? RegisterService
                
                progressHUD.removeFromSuperview()
                
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
                    self.otpView.isHidden = true
                    self.resetPasswordView.isHidden = false
                    
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
        }else{
            let alertController = UIAlertController(title: "Warning", message: "OTP can't be empty.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        } else if (txtUserEmail?.text == ""){
            
                let alertController = UIAlertController(title: "Warning", message: "Username Can't be empty.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            
        }else{
            let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return true;
    }
    
    @IBAction func savePasswordBtn(_ sender: Any) {
        let passwordStr : String = (txtPassword.text)!
        if (txtPassword.text == "" || txtConfirmPassword.text == "")  {
            let alertController = UIAlertController(title: "Warning", message: "Password/Confirm Password cannot be empty.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
//        else if passwordStr.count < 6 {
//            let alertController = UIAlertController(title: "Warning", message: "Password should have min 6 letters.", preferredStyle: UIAlertControllerStyle.alert)
//
//            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//                (action : UIAlertAction!) -> Void in
//            })
//
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
        else if !(isValidPassword(text: (txtPassword?.text)!)){
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
        }else{
            
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            //  self.view.backgroundColor = UIColor.black
            
            //Login Api
            forgotPasswordService.resetPassword(userName: self.userEmail, password:(txtPassword?.text!)!, confirmPassword:(txtConfirmPassword?.text!)!) {(result, message, status )in
                
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
                
                progressHUD.removeFromSuperview()
                
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
                    let alertController = UIAlertController(title: "Your Pick", message: "Your password has been reset.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                        self.resetPasswordView.isHidden = true
                        self.otpView.isHidden = true
                        
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
