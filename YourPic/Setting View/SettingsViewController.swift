//
//  SettingsViewController.swift
//  YourPic
//
//  Created by Krishna_Mac_6 on 11/04/18.
//  Copyright © 2018 Krishna_Mac_6. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import MessageUI
import AudioToolbox

class SettingsViewController: UIViewController,  MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate  {
    
    let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
     var contactSupportScreen = ContactSupportViewController()
     var faqScreen = FrequentlyAskViewController()
     let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var balanceLbl: UILabel!
    var deviceName :String!
    var iosVersion :String!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    var playSound:Bool = false
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let balance: Int = UserDefaults.standard.integer(forKey: "Balance")
        self.balanceLbl.text = "€" + String(balance)
        
        deviceName = UIDevice.current.name
        iosVersion = UIDevice.current.systemVersion
        
        if UserDefaults.standard.value(forKey: "Sound") != nil{
          self.playSound = (UserDefaults.standard.value(forKey: "Sound") != nil)
        }
        
        if self.playSound{
            self.soundSwitch.setOn(true, animated: true)
        }else{
            self.soundSwitch.setOn(false, animated: true)
        }
    }
        
    // MARK: - IBAction
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func emailSupportBtn(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        else{
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["address@example.com"])
            composeVC.setSubject("Hello!")
            //     composeVC.setMessageBody("Hello from California!", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func textSupportBtn(_ sender: Any) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
        //   messageVC.recipients = ["Enter tel-nr"]
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)
    }
    
    @IBAction func feedbackBtn(_ sender: Any) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        else{
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["address@example.com"])
           // composeVC.setSubject("\(deviceName) \n \(iosVersion)")
            composeVC.setMessageBody("\n\n\n \(deviceName) \n \(iosVersion)", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func rateAppBtn(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            if #available( iOS 10.3,*){
                SKStoreReviewController.requestReview()
            }else{
                self.rateApp(appId: "id937139648")
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

    @IBAction func vibrationSwitch(_ sender: Any) {
        if self.vibrationSwitch.isOn{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    @IBAction func soundSwitch(_ sender: Any) {
        if self.soundSwitch.isOn{
            UserDefaults.standard.set(true, forKey: "Sound")
            self.delegate.playSound = true
        }else{
            UserDefaults.standard.set(false, forKey: "Sound")
            self.delegate.playSound = false
        }
        self.delegate.registerForPushNotifications()
    }
    
    @IBAction func setLimitBtn(_ sender: Any) {
    
    }
    @IBAction func faqBtn(_ sender: Any) {
        self.faqScreen = mainStoryBoard.instantiateViewController(withIdentifier: "FrequentlyAskViewController") as! FrequentlyAskViewController
        self.present(self.faqScreen, animated: true, completion: nil)
    }
    
    @IBAction func vibrateOnNotificationBtn(_ sender: Any) {
        
    }
    
    @IBAction func playSoundBtn(_ sender: Any) {
        
    }
    
    @IBAction func licencseBtn(_ sender: Any) {
        
    }
    
    fileprivate func rateApp(appId: String) {
        openUrl("itms-apps://itunes.apple.com/app/" + appId)
    }
    
    fileprivate func openUrl(_ urlString:String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            // do whatever you need to do after dismissing the mail window
            switch result {
            case .cancelled: print("cancelled")
            case .saved:     print("saved")
            case .sent:
                let alert = UIAlertController(title: "Mail Composer", message: "Mail was successfully sent", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failed:    print("failed")
            }
        }
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) {
            switch result {
            case .cancelled: print("cancelled")
            case .sent:
                let alert = UIAlertController(title: "Message", message: "Message was successfully sent", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failed:    print("failed")
            }
        }
    }
}
