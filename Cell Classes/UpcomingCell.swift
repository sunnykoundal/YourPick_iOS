
import Foundation
import UIKit

class UpcomingCell: UITableViewCell {
    
    @IBOutlet var draftNameLbl: UILabel?
    @IBOutlet var playerPickPositionLbl: UILabel?
    @IBOutlet var gameTypeImage: UIImageView!
    @IBOutlet var playerView: UIView!
    @IBOutlet var playerMatchDayLbl: UILabel?
    @IBOutlet var playerMatchTimeLbl: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell( type: String!, draftType: String!, opponent: String!,gameStart: String!) {
        draftNameLbl?.text = "  " + String(opponent)
        
        var splitDraftType = draftType.components(separatedBy: " ")
    
        playerPickPositionLbl?.text = String(splitDraftType[0])
        
        var splitDateArray = gameStart.components(separatedBy: " ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "eee hh:mma"
        
        let dateStr: String = splitDateArray[3] + " " + splitDateArray[4] + splitDateArray[5]
        let date = dateFormatter.date(from: dateStr)! as Date
        
        dateFormatter.dateFormat = "eee hh:mma"
        
        let dateValue = dateFormatter.string(from: date)
        
        let dateValueArray = dateValue.components(separatedBy: " ")
        
        self.playerMatchDayLbl?.text = dateValueArray[0]
        self.playerMatchTimeLbl?.text = dateValueArray[1]
        
        playerView?.layer.cornerRadius = 0
        playerView?.layer.borderWidth = 1
        playerView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        
        if type == "SOCCER" {
            playerPickPositionLbl?.backgroundColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            gameTypeImage.image = #imageLiteral(resourceName: "Football_Logo")
        }else if type == "NFL" {
            playerPickPositionLbl?.backgroundColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            gameTypeImage.image = #imageLiteral(resourceName: "American_Football_Logo")
        }else if type == "NBA" {
            playerPickPositionLbl?.backgroundColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            gameTypeImage.image = #imageLiteral(resourceName: "Basketball_Logo")
        }
    }
}



