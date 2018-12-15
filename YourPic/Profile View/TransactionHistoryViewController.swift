
import Foundation
import UIKit

class TransactionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var transactionTableView: UITableView!
    let fetchtransactionsById = FetchAllTransactionsByIdService()
    
    var transactionList = NSMutableArray()
    
    var transactionDataDictionary = NSDictionary()
    // MARK: - UIViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            self.fetchTransactions()
  
        } else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func fetchTransactions() {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        fetchtransactionsById.fetchAllTransactionsByIdData(userId: userId ) {(result, message, status )in
            
            let transactionDetails = result as? FetchAllTransactionsByIdService
   
            progressHUD.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            
            if let transactionDataDict = transactionDetails?.transactionData {
                self.transactionDataDictionary = transactionDataDict
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
            
            if let resultValue: String = self.transactionDataDictionary.value(forKey: "result") as? String {
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
            if let messageValue: String = self.transactionDataDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                let transactionListArray: NSArray = (self.transactionDataDictionary.value(forKey: "data") as! NSArray)
                self.transactionList = transactionListArray.mutableCopy() as! NSMutableArray
                
                self.transactionTableView.reloadData()
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //make sure you use the relevant array sizes
            return self.transactionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let transactionCell = transactionTableView.dequeueReusableCell(withIdentifier:"Transaction",for:indexPath) as! TransactionCell
        let transactionData:NSDictionary = self.transactionList[indexPath.row] as! NSDictionary
        
        var gameTypeValue:String = ""
        var transactionDescpValue:String = ""
        var transactionTimeValue:String = ""
        var transactionCreditValue:String = ""
        var transactionWithdrawnValue:String = ""
        var transactionAmountValue:String = ""
        var transactionDescriptionValue:String = ""
        
        if let gameType: String = transactionData.value(forKey: "SportsName") as? String {
            gameTypeValue = gameType
        }
        
        if let transactionDescp: String = transactionData.value(forKey: "DraftTypeName") as? String {
            transactionDescpValue = transactionDescp
        }
        
        if let transactionTime: String = transactionData.value(forKey: "TransactionDate") as? String {
            transactionTimeValue = transactionTime
        }
        
        if let transactionCredit: Double = transactionData.value(forKey: "AmtCredited") as? Double {
            transactionCreditValue = String(transactionCredit)
        }
        
        if let transactionWithdrawn: Double = transactionData.value(forKey: "AmtDebited") as? Double {
            transactionWithdrawnValue = String(transactionWithdrawn)
        }
        
        if let transactionAmount: Double = transactionData.value(forKey: "Amount") as? Double {
            transactionAmountValue = String(transactionAmount)
        }
        
        if let transactionDescription: String = transactionData.value(forKey: "Description") as? String {
            transactionDescriptionValue = transactionDescription
        }
        
        transactionCell.configureCell(gameType: gameTypeValue, transactionDescp: transactionDescpValue, transactionTime: transactionTimeValue, transactionCredit: transactionCreditValue, transactionWithdrawn: transactionWithdrawnValue, transactionAmount: transactionAmountValue,transactionDescription: transactionDescriptionValue)
        
            return transactionCell as TransactionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}



