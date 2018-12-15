
import Foundation
import UIKit
import SwiftR
import WebKit

class DepositMoneyViewController: UIViewController, PayPalPaymentDelegate, WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var webView : WKWebView?
    @IBOutlet weak var webViewNavbar : UIView?
    let progressHUD = ProgressHUD(text: "Loading")
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    let addTransactionService = AddTransactionService()
    let addtransactionByIdService = AddTransactionByIdService()
    // MARK: - UIViewLifeCycle
    var resultText = "" // empty
    var payPalConfig = PayPalConfiguration() // default
    var amount: String = ""
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var amountTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payPalConfig.acceptCreditCards = true
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        
        self.webView?.navigationDelegate = self
        self.webView?.uiDelegate = self
        self.webView?.scrollView.delegate = self
        
        payPalConfig.payPalShippingAddressOption = .payPal;
        
        amountTxt?.layer.cornerRadius = 3
        amountTxt?.layer.borderWidth = 1
        amountTxt?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 1.0).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func depositAmountBtn(_ sender: Any) {
        if amountTxt.text == "" {
            let alertController = UIAlertController(title: "Warning", message: "Please enter deposit amount.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.loadWebView()
            
        }
        
    }
    
    func depositUsingPaypal(){
        
        resultText = ""
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        // Optional: include multiple items
        amount = (amountTxt.text?.replacingOccurrences(of: "€", with: ""))!
        
        let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 1, withPrice: NSDecimalNumber(string: amount), withCurrency: "USD", withSku: "Hip-0037")
        
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Deposit Amount", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }
        
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        resultText = ""
//        successView.isHidden = true
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
            let payPalresponse : NSDictionary = completedPayment.confirmation as NSDictionary

            let response : NSDictionary = payPalresponse.value(forKey: "response") as! NSDictionary
            print(response.value(forKey: "id") ?? "null")
            
            self.resultText = completedPayment.description
            
            
            if Reachability.isConnectedToNetwork() == true {
                
//            self.showSuccess()
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            self.view.isUserInteractionEnabled = false
            
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            //Login Api
            self.addTransactionService.addTransactionData(transactionId: response.value(forKey: "id") as! String, userId: userId, amount: self.amount) {(result, message, status )in
                self.view.isUserInteractionEnabled = true
                
                let draftDetails = result as? AddTransactionService
                var draftsData = NSDictionary()
                
                progressHUD.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                //
                
                if let draftsDataDict = draftDetails?.playerDetailsData {
                    draftsData = draftsDataDict
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
                
                if let resultValue: String = draftsData.value(forKey: "result") as? String {
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
                if let messageValue: String = draftsData.value(forKey: "message") as? String{
                    message = messageValue
                }
                
                
                if result == "1"
                {
                    self.addTransactionById()
                    
                }
                else if result == "0"
                {
                    let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                }
            } else {
                let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        })
    }
    
    func addTransactionById()
    {
        self.view.addSubview(self.progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        if Reachability.isConnectedToNetwork() == true {
            
        self.addtransactionByIdService.addTransactionByIdData(userId: userId, amount: self.amount) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            
            let transactionDetails = result as? AddTransactionByIdService
            var transactionDetailsData = NSDictionary ()
            
            self.progressHUD.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            //
            if let transactionDetailsDataDict = transactionDetails?.transactionDetailData {
                transactionDetailsData = transactionDetailsDataDict
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
            
            if let resultValue: String = transactionDetailsData.value(forKey: "result") as? String {
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
            if let messageValue: String = transactionDetailsData.value(forKey: "message") as? String{
                message = messageValue
            }
            
            
            if result == "1"
            {
                let data:NSDictionary = transactionDetailsData.value(forKey: "data") as! NSDictionary
                
                let balance: Double = data.value(forKey: "DecimalValue") as! Double
                
                self.delegate.totalAmount = balance
                UserDefaults.standard.set(balance, forKey: "Amount")
                self.amountTxt.text = ""
                let alertController = UIAlertController(title: "Success", message: "Amount deposited successfully", preferredStyle: UIAlertControllerStyle.alert)
                
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
        } else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func returnKeyboard(_ sender: UIButton) {
        amountTxt?.resignFirstResponder()
    }
    
    func loadWebView() {
        //        self.removeWebData()
        self.amountTxt.resignFirstResponder()
        self.view.addSubview(self.progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let balance: Double = self.delegate.totalAmount
        
        self.amount = (amountTxt.text?.replacingOccurrences(of: "€", with: ""))!
        
        var amountToDeposit: Double = Double(self.amount)! + balance
        amountToDeposit = round(amountToDeposit * 100) / 100
        amountToDeposit = amountToDeposit * 100
        
        
        let urlStr = "https://sandbox.gamblingtec.com/widget/launch/8b41985b-850b-4c2a-bd39-4fd9951969c2" + "?type=deposit&amount=\(amountToDeposit)&currency=EUR&return=" + "http://200.124.153.227:443/Home.html/deposit"
        let url : NSURL = NSURL(string: urlStr)!
        let req = NSURLRequest(url:url as URL)
    
        self.webView?.isHidden = false
        self.webViewNavbar?.isHidden = false
        self.view.bringSubview(toFront: self.webView!)
        self.view.bringSubview(toFront: self.webViewNavbar!)
        
        self.webView?.load(req as URLRequest)
    }
    
    @IBAction func navBarBackBtn(_ sender: Any) {
        if (self.webView?.canGoBack)! {
            self.webView?.goBack()
        }else{
            self.webView?.isHidden = true
            self.webViewNavbar?.isHidden = true
            
            self.view.sendSubview(toBack: self.webView!)
            self.view.sendSubview(toBack: self.webViewNavbar!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation")
        //        let isLogedIn:Bool = (UserDefaults.standard.value(forKey: "LogedIn") != nil)
        
        
        
        let urlStr : NSURL = webView.url! as NSURL
        let urlString: String = urlStr.absoluteString!
        let redirectUrlArr = urlString.components(separatedBy: "?")
        
        if urlString == "https://sandbox.gamblingtec.com/oauth/authorize" {
            //self.startAuth()
        }else if redirectUrlArr[0] == "http://200.124.153.227:443/Home.html/deposit"{
            self.webView?.isHidden = true
            self.webViewNavbar?.isHidden = true
            
            self.view.sendSubview(toBack: self.webView!)
            self.view.sendSubview(toBack: self.webViewNavbar!)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!)
    {
        print("didCommitNavigation - content arriving?\(String(describing: webView.url))")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
        print("didFailNavigation")
        
        self.view.isUserInteractionEnabled = true
        self.progressHUD.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("didStartProvisionalNavigation")
       self.view.addSubview(self.progressHUD)
        self.view.isUserInteractionEnabled = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("didFinishNavigation")
        self.view.isUserInteractionEnabled = true
        self.progressHUD.removeFromSuperview()
    }
}

