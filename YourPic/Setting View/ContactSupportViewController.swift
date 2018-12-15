//
//  ContactSupportViewController.swift
//  YourPic
//
//  Created by Krishna_Mac_6 on 11/04/18.
//  Copyright © 2018 Krishna_Mac_6. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ContactSupportViewController: UIViewController,  MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    // MARK: - UIViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let balance: Int = UserDefaults.standard.integer(forKey: "Balance")
        self.balanceLbl.text = "€" + String(balance)
    }
    
    // MARK: - IBAction
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func launchEmail(sender: AnyObject) {
        
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
    
    @IBAction func sendMessage(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
     //   messageVC.recipients = ["Enter tel-nr"]
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)
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
}
