

import Foundation
import UIKit

class TransactionCell: UITableViewCell {
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var transactionTimeLbl: UILabel!
    @IBOutlet weak var transactionDescpLbl: UILabel!
    @IBOutlet weak var transactionTypeLbl: UILabel!
    @IBOutlet weak var transactionAmountLbl: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell( gameType: String!, transactionDescp: String!, transactionTime:String!, transactionCredit: String, transactionWithdrawn: String!, transactionAmount: String!, transactionDescription:String) {
        
        
        let timeValueArray = transactionTime.components(separatedBy: "T")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "HH:mm:ss.SSSS"
        
        let time = dateFormatter.date(from: timeValueArray[1])
        
        dateFormatter.dateFormat = "hh:mma"
        
        let timeStr = dateFormatter.string(from: time!)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: timeValueArray[0])!
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateStr = dateFormatter.string(from: date)
        
        transactionTimeLbl.text = dateStr + "," + timeStr
        
        transactionDescpLbl.text = gameType.uppercased() + ":" + " " + transactionDescp
        
        transactionTypeLbl.text = transactionDescription + " " + ":"
        
        if transactionWithdrawn == "0.0" {
        
            if transactionDescp == ""{
                transactionTypeLbl.text = "Deposit :"
                transactionDescpLbl.text = transactionDescription
            }

            transactionAmountLbl.text = "€" + transactionCredit
            transactionAmountLbl.textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        }
        
        if transactionCredit == "0.0" {
            
            if transactionDescp == ""{
                transactionTypeLbl.text = "Withdrawal :"
                transactionDescpLbl.text = transactionDescription
            }
           
            transactionAmountLbl.text = "€" + transactionWithdrawn
            transactionAmountLbl.textColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        }
        
        if gameType == "SOCCER" {
            gameImage.image = #imageLiteral(resourceName: "Football")
            transactionDescpLbl.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        }else if gameType == "NFL" {
            gameImage.image = #imageLiteral(resourceName: "American_Football")
            transactionDescpLbl.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        }else if gameType == "NBA" {
            gameImage.image = #imageLiteral(resourceName: "Basketball")
            transactionDescpLbl.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        }
        
        if gameType == "" {
            if transactionWithdrawn == "0.0" {
                gameImage.image = #imageLiteral(resourceName: "Deposit")
                transactionDescpLbl.textColor = UIColor(red: 52.0/255.0, green: 117.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            }
            
            if transactionCredit == "0.0" {
                gameImage.image = #imageLiteral(resourceName: "Transaction")
                transactionDescpLbl.textColor = UIColor(red: 205.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            }
        }
        if transactionDescription == "Entered"{
            transactionAmountLbl.text = "-" + transactionAmountLbl.text!
        }else if transactionDescription == "Left"{
            transactionAmountLbl.textColor = UIColor(red: 0.0/255.0, green: 105.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        }else if transactionDescription == "Prize"{
            transactionTypeLbl.text = "Paid :"
            transactionAmountLbl.textColor = UIColor(red: 0.0/255.0, green: 105.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        }else if transactionDescription == "Deposited in Wallet"{
            transactionAmountLbl.textColor = UIColor(red: 0.0/255.0, green: 105.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        }else if transactionDescription == "Paid"{
            transactionAmountLbl.textColor = UIColor(red: 0.0/255.0, green: 105.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        }
        
        playerView?.layer.cornerRadius = 0
        playerView?.layer.borderWidth = 1
        playerView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
    }
}
