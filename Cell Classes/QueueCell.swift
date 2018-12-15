
import Foundation
import UIKit

class QueueCell: UITableViewCell {
    
    @IBOutlet var playerNameLbl: UILabel?
    @IBOutlet var playerTypeLbl: UILabel?
    @IBOutlet var ratingLbl: UILabel?
    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var playerView: UIView!
    @IBOutlet weak var favrioteBtn: UIButton!
    @IBOutlet weak var projLbl: UILabel!
    @IBOutlet weak var teamOpponentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(playerName: String!, playerType: String!,rating: String!, playerImg: String!, roastersPosition: String!, teamName:String!, opponentsName:String!) {
        playerView?.layer.cornerRadius = 10
        playerView?.layer.borderWidth = 1
        playerView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        
        
        
        playerNameLbl?.text = String(playerName)
        playerTypeLbl?.text = String(playerType)
        ratingLbl?.text = String(rating)
        
//        self.playerImage.sd_setShowActivityIndicatorView(true)
//        self.playerImage.sd_setIndicatorStyle(.gray)
        self.playerImage.sd_setImage(with: URL(string: playerImg), placeholderImage:#imageLiteral(resourceName: "ProfilePlaceholder"))
        
        if roastersPosition == "QB"{
            let textColor:UIColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            //            let textColor:UIColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: playerType, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 14.0)!])
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location:0,length:playerType.count))
            
            playerTypeLbl?.attributedText = myMutableString
            
            teamOpponentLbl?.text = teamName + " " + "vs" + " " + opponentsName
            ratingLbl?.textColor = textColor
            projLbl.textColor = textColor
            
        }else if roastersPosition == "RB"{
            
            let textColor:UIColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: playerType, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 14.0)!])
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location:0,length:playerType.count))
            
            playerTypeLbl?.attributedText = myMutableString
            
            teamOpponentLbl?.text = teamName + " " + "vs" + " " + opponentsName
            ratingLbl?.textColor = textColor
            projLbl.textColor = textColor
        }else if roastersPosition == "WRTE" {
            let textColor:UIColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: playerType, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 14.0)!])
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location:0,length:playerType.count))
            
            playerTypeLbl?.attributedText = myMutableString
            
            teamOpponentLbl?.text = teamName + " " + "vs" + " " + opponentsName
            ratingLbl?.textColor = textColor
            projLbl.textColor = textColor
        }else if roastersPosition == "Center"{
            let textColor:UIColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            //            let textColor:UIColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: playerType, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 14.0)!])
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location:0,length:playerType.count))
            
            playerTypeLbl?.attributedText = myMutableString
            
            teamOpponentLbl?.text = teamName + " " + "vs" + " " + opponentsName
            ratingLbl?.textColor = textColor
            projLbl.textColor = textColor
            
        }else if roastersPosition == "Forward"{
            
            let textColor:UIColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: playerType, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 14.0)!])
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location:0,length:playerType.count))
            
            playerTypeLbl?.attributedText = myMutableString
            
            teamOpponentLbl?.text = teamName + " " + "vs" + " " + opponentsName
            ratingLbl?.textColor = textColor
            projLbl.textColor = textColor
        }else if roastersPosition == "Guard"{
            let textColor:UIColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: playerType, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 14.0)!])
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location:0,length:playerType.count))
            
            playerTypeLbl?.attributedText = myMutableString
            
            teamOpponentLbl?.text = teamName + " " + "vs" + " " + opponentsName
            ratingLbl?.textColor = textColor
            projLbl.textColor = textColor
        }else if roastersPosition == "Attacker"{
            let textColor:UIColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
            
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: playerType, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 14.0)!])
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location:0,length:playerType.count))
            
            playerTypeLbl?.attributedText = myMutableString
            
            teamOpponentLbl?.text = teamName + " " + "vs" + " " + opponentsName
            ratingLbl?.textColor = textColor
            projLbl.textColor = textColor
        }else if roastersPosition == "Defender"{
            let textColor:UIColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: playerType, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 14.0)!])
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location:0,length:playerType.count))
            
            playerTypeLbl?.attributedText = myMutableString
            
            teamOpponentLbl?.text = teamName + " " + "vs" + " " + opponentsName
            ratingLbl?.textColor = textColor
            projLbl.textColor = textColor
        }else if roastersPosition == "Midfielder"{
            let textColor:UIColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: playerType, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 14.0)!])
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location:0,length:playerType.count))
            
            playerTypeLbl?.attributedText = myMutableString
            
            teamOpponentLbl?.text = teamName + " " + "vs" + " " + opponentsName
            ratingLbl?.textColor = textColor
            projLbl.textColor = textColor
        }
        
        playerImage?.layer.cornerRadius = playerImage.frame.size.width/2
        playerImage?.layer.borderWidth = 1
        playerImage?.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        playerImage?.clipsToBounds = true;
    }
}
