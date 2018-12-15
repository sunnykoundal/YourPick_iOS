
import Foundation
import UIKit

class DraftCell: UITableViewCell {
    
    @IBOutlet var enteredLbl: UILabel?
    @IBOutlet var entrantsLbl: UILabel?
    @IBOutlet var entryLbl: UILabel?
    @IBOutlet var prizesLbl: UILabel?
    @IBOutlet var draftNameLbl: UILabel?
    @IBOutlet var gameTypeImage: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var waitingOpponentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(entered: String!, entrants: String!,entry: String!, prizes: String!, draftName: String!, type: String!,draftType:String!) {
       
        enteredLbl?.text = String(entrants)
        entrantsLbl?.text = String(entered) + "/" + String(entrants)
        entryLbl?.text = self.getSymbolForCurrencyCode(code: "EUR")! + String(entry)
        prizesLbl?.text = self.getSymbolForCurrencyCode(code: "EUR")! + prizes
        draftNameLbl?.text = draftType + "(" + draftName + ")"
        
        let percentage: Float = (NSString(string: entered).floatValue/NSString(string: entrants).floatValue)
        progressView.setProgress(percentage, animated: false)
        progressView.trackTintColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 1.0)
        progressView.backgroundColor = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        if type == "SOCCER" {
            enteredLbl?.backgroundColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            entrantsLbl?.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            entryLbl?.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            prizesLbl?.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            progressView.progressTintColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            gameTypeImage.image = #imageLiteral(resourceName: "Football_Logo")
        }else if type == "NFL" {
            enteredLbl?.backgroundColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            entrantsLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            entryLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            prizesLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            progressView.progressTintColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            gameTypeImage.image = #imageLiteral(resourceName: "American_Football_Logo")
        }else if type == "NBA" {
            enteredLbl?.backgroundColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            entrantsLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            entryLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            prizesLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            progressView.progressTintColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            gameTypeImage.image = #imageLiteral(resourceName: "Basketball_Logo")
        }
        
        
    }
    
    func getSymbolForCurrencyCode(code: String) -> String?
    {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
}
