
import Foundation
import UIKit

class LiveCell: UITableViewCell {
    
    @IBOutlet weak var draftView: UIView!
    @IBOutlet var createdDateLbl: UILabel?
    @IBOutlet var draftCountLbl: UILabel?
    @IBOutlet var winningLbl: UILabel?
    @IBOutlet var gameTypeImage: UIImageView!
    @IBOutlet weak var draftTypeValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(createdDate: String!,draftCount: String!, sportsId: String!, winnings: String!) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        
        dateFormatter.dateFormat = "yyyy/MM/dd";
        let dateValue = dateFormatter.date(from: createdDate)
        
        dateFormatter.dateFormat = "MMM d";
        let dateStr = dateFormatter.string(from: dateValue!)
        
        draftCountLbl?.text = String(draftCount)
        winningLbl?.text = String(winnings)
        
        if sportsId == "3" {
            draftTypeValue?.backgroundColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            winningLbl?.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            draftCountLbl?.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            createdDateLbl?.text = String(dateStr) + ", " + "Soccer Draft"
            gameTypeImage.image = #imageLiteral(resourceName: "Football_Logo")
        }else if sportsId == "1" {
            draftTypeValue?.backgroundColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            winningLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            draftCountLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            createdDateLbl?.text = String(dateStr) + ", " + "NFL Draft"
            gameTypeImage.image = #imageLiteral(resourceName: "American_Football_Logo")
        }else if sportsId == "2" {
            draftTypeValue?.backgroundColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            winningLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            draftCountLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            createdDateLbl?.text = String(dateStr) + ", " + "NBA Draft"
            gameTypeImage.image = #imageLiteral(resourceName: "Basketball_Logo")
        }
        
        
        draftView?.layer.cornerRadius = 0
        draftView?.layer.borderWidth = 1
        draftView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
    }
}


