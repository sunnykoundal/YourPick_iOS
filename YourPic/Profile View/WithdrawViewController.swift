
import Foundation
import UIKit
import SwiftR
import WebKit

class WithdrawViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

//    var payPalConfig = PayPalConfiguration()
//    let fetchBalanceService = FetchBalanceService()
//
//    var environment:String = PayPalEnvironmentNoNetwork {
//        willSet(newEnvironment) {
//            if (newEnvironment != environment) {
//                PayPalMobile.preconnect(withEnvironment: newEnvironment)
//            }
//        }
//    }

    // MARK: - UIViewLifeCycle
    
   // @IBOutlet weak var btnPayNow: UIButton!
    
    @IBOutlet weak var webView : WKWebView?
    @IBOutlet weak var webViewNavbar : UIView?
    let progressHUD = ProgressHUD(text: "Loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        btnPayNow?.layer.cornerRadius = 10
//
//        payPalConfig.acceptCreditCards = false
//        payPalConfig.payPalShippingAddressOption = .payPal;
        
        self.loadWebView()
    }
    
    func loadWebView()
    {
        self.view.addSubview(self.progressHUD)
//        self.view.isUserInteractionEnabled = false
        
        let urlStr = "https://sandbox.gamblingtec.com/widget/balances"
        let url : NSURL = NSURL(string: urlStr)!
        let req = NSURLRequest(url:url as URL)
        
        self.webView?.isHidden = false
        self.webViewNavbar?.isHidden = false
        self.view.bringSubview(toFront: self.webView!)
        self.view.bringSubview(toFront: self.webViewNavbar!)
        
        self.webView?.load(req as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
//    @IBAction func btnPayNow(_ sender: AnyObject) {
////        let payment = PayPalPayment()
////        // Amount, currency, and description
////        payment.amount = NSDecimalNumber(string: "100")
////        payment.currencyCode = "USD"
////        payment.shortDescription = "Awesome saws"
////        payment.intent = .authorize
////
////        if payment.processable {
////            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
////            present(paymentViewController!, animated: true, completion: nil)
////        }
////        else {
////            print("Payment not processalbe: \(payment)")
////        }
//    }
//
//    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
//        print("PayPal Payment Cancelled")
//
//        paymentViewController.dismiss(animated: true, completion: nil)
//    }
//
//    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
//        print("PayPal Payment Success !")
//        paymentViewController.dismiss(animated: true, completion: { () -> Void in
//            // send completed confirmaion to your server
//            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
//
//        })
//
//        let progressHUD = ProgressHUD(text: "Loading")
//        self.view.addSubview(progressHUD)
//        self.view.isUserInteractionEnabled = false
//
//        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
//        //Login Api
//        self.fetchBalanceService.fetchBalanceData(userId: userId) {(result, message, status )in
//
//            let draftDetails = result as? FetchBalanceService
//            var draftsData = NSDictionary()
//            progressHUD.removeFromSuperview()
//            self.view.isUserInteractionEnabled = true
//            //
//
//            if let draftsDataDict = draftDetails?.playerDetailsData {
//                draftsData = draftsDataDict
//            }else{
//                let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
//
//                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//                    (action : UIAlertAction!) -> Void in
//                })
//
//                alertController.addAction(cancelAction)
//                self.present(alertController, animated: true, completion: nil)
//                return
//            }
//
//            var result:String = ""
//            var message:String = ""
//
//            if let resultValue: String = draftsData.value(forKey: "result") as? String {
//                result = resultValue
//            }else{
//                let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
//
//                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//                    (action : UIAlertAction!) -> Void in
//                })
//
//                alertController.addAction(cancelAction)
//                self.present(alertController, animated: true, completion: nil)
//                return
//            }
//            if let messageValue: String = draftsData.value(forKey: "message") as? String{
//                message = messageValue
//            }
//
//
//            if result == "1"
//            {
//
//                let alertController = UIAlertController(title: "Success", message: "Amount withdrawn successfully successfully", preferredStyle: UIAlertControllerStyle.alert)
//
//                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//                    (action : UIAlertAction!) -> Void in
//                })
//
//                alertController.addAction(cancelAction)
//                self.present(alertController, animated: true, completion: nil)
//
//            }
//            else if result == "0"
//            {
//                let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
//
//                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//                    (action : UIAlertAction!) -> Void in
//                })
//
//                alertController.addAction(cancelAction)
//                self.present(alertController, animated: true, completion: nil)
//
//            }
//        }
//    }
//
//    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation")

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


