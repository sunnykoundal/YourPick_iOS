
import Foundation
import UIKit
import UICircularProgressRing

class UserPickPlayerCell: UITableViewCell {
    
    @IBOutlet var playerNameLbl: UILabel?
    @IBOutlet var playerPickPositionLbl: UILabel?
    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var playerView: UIView!
    @IBOutlet weak var cellRing: UICircularProgressRingView!
    @IBOutlet weak var pickedName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configureCell(playerName: String!,playerId:Int64, playerPickPosition: String!, playerImg: String!) {
        playerView?.layer.cornerRadius = 10
        playerView?.layer.borderWidth = 1
        playerView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        
        let userId: Int64 = Int64(UserDefaults.standard.integer(forKey: "UserId"))
        
        
        if playerId == userId {
            playerNameLbl?.text = "Your's pick"
        }else{
            playerNameLbl?.text = String(playerName) + "'s" + " " + "pick"
        }
        
        playerPickPositionLbl?.text = String(playerPickPosition)
        
        self.playerImage.sd_setImage(with: URL(string: playerImg), placeholderImage:#imageLiteral(resourceName: "ProfilePlaceholder"))
        
        let splitPlayerName:NSArray = playerName.components(separatedBy: " ") as NSArray
        
        if splitPlayerName.count > 1 {
           let firstName = splitPlayerName.firstObject as! String
            let secondName = splitPlayerName[1] as! String
            let pickerName = splitPlayerName.lastObject as! String
            
            if secondName.lowercased() == pickerName.lowercased() {
                playerNameLbl?.text = firstName
            }else{
                playerNameLbl?.text = firstName + " " + secondName
            }
            pickedName.text = "(" + pickerName + ")"
        }
        
        playerImage?.layer.cornerRadius = playerImage.frame.size.width/2
        playerImage?.layer.borderWidth = 1
        playerImage?.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        playerImage?.clipsToBounds = true;
    }
}


