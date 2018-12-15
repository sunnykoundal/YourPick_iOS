
import Foundation
import UIKit

class UpcomingDraftCell: UITableViewCell {
    
    @IBOutlet var playerNameLbl: UILabel?
    @IBOutlet var gameTimingLbl: UILabel?
    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var playerView: UIView!
    @IBOutlet var gameRatingLbl: UILabel?
    @IBOutlet weak var playerPositionLbl: UILabel!
    @IBOutlet weak var btnSwapPlayer: UIButton!
    
    
    var isUnselectedPlayerSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell( name: String!, time: String!, rating: String!,imageUrl: String!, team:String, opponents:String,  position: String, swapPlayer:Int64, userId:Int64) {
        
        playerView?.layer.cornerRadius = 4
        playerView?.layer.borderWidth = 1
        playerView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        playerView?.clipsToBounds = true
        
        playerImage?.layer.cornerRadius = playerImage.frame.size.height/2
        playerImage?.layer.borderWidth = 1
      //  playerImage?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        self.playerImage.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        playerImage?.clipsToBounds = true
        
        playerNameLbl?.text = name
        if time != ""{
        let timeArray = time.components(separatedBy: ".")
        let timeValue:String = timeArray[0]
        let timeValueArray = timeValue.components(separatedBy: "T")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let timeStr = dateFormatter.date(from: timeValueArray[1])
        
        dateFormatter.dateFormat = "hh:mma"
      
        let time = dateFormatter.string(from: timeStr!)
        print(time)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.date(from: timeValueArray[0])!
        let weekDay = Calendar.current.component(.weekday, from: todayDate)
        
        var day:String = ""
        
        if weekDay == 1{
            day = "Sun"
        }
        if weekDay == 2 {
            day = "Mon"
        }
        if weekDay == 3 {
            day = "Tus"
        }
        if weekDay == 4 {
            day = "Wed"
        }
        if weekDay == 5 {
            day = "Thur"
        }
        if weekDay == 6 {
            day = "Fri"
        }
        if weekDay == 7 {
            day = "Sat"
        }
        
        let teams:String = team + " " + "vs" + " " + opponents
        
        let timeWithTeams: String = day + " " + time + " " + teams
        
        gameTimingLbl?.text = timeWithTeams
        }
        gameRatingLbl?.text = rating 
        
//        self.playerImage.sd_setShowActivityIndicatorView(true)
//        self.playerImage.sd_setIndicatorStyle(.gray)
        self.playerImage.sd_setImage(with: URL(string: imageUrl), placeholderImage:#imageLiteral(resourceName: "ProfilePlaceholder"))
        
        self.playerPositionLbl.text = position
        
        var textColor:UIColor!
        
        if position == "QB"{
            textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "RB"{
            textColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "WR" || position == "TE" {
            textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "C"{
            textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "SF" || position == "PF"{
            textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "PG" || position == "SG"{
            textColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "A"{
            textColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = "Attacker"
        }else if position == "D"{
            textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = "Defender"
        }else if position == "M"{
            textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = "Mid-Fielder"
        }
    
        self.playerPositionLbl.textColor = textColor
        self.gameRatingLbl?.textColor = textColor
        
        if swapPlayer == 1
        {
            if userId == UserDefaults.standard.integer(forKey: "UserId")
            {
                btnSwapPlayer.isHidden = false
                self.gameRatingLbl?.frame.origin.y = self.btnSwapPlayer.frame.origin.y + self.btnSwapPlayer.frame.size.height 
            }
            else
            {
                btnSwapPlayer.isHidden = true
                self.gameRatingLbl?.frame.origin.y = (self.playerNameLbl?.frame.origin.y)! + 20
            }
        }
        else
        {
            if isUnselectedPlayerSelected
            {
               // btnSwapPlayer.isHidden = false
               self.gameRatingLbl?.frame.origin.y = self.btnSwapPlayer.frame.origin.y + self.btnSwapPlayer.frame.size.height
            }
            else
            {
                btnSwapPlayer.isHidden = true
                self.gameRatingLbl?.frame.origin.y = (self.playerNameLbl?.frame.origin.y)! + 20
            }
        }
    }
    
    func configureResultsCell( name: String!, homeTeamScore: String!, awayTeamScore:String, rating: String!,imageUrl: String!, opponents:String,  position: String, status: String) {
        
        btnSwapPlayer.isHidden = true
        self.gameRatingLbl?.frame.origin.y = (self.playerNameLbl?.frame.origin.y)! + 20
        
        playerView?.layer.cornerRadius = 4
        playerView?.layer.borderWidth = 1
        playerView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        playerView?.clipsToBounds = true
        
        playerImage?.layer.cornerRadius = playerImage.frame.size.height/2
        playerImage?.layer.borderWidth = 1
        playerImage?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        playerImage?.clipsToBounds = true
        
        playerNameLbl?.text = name
        
        let score = homeTeamScore + "-" + awayTeamScore
        let teams:String = score + " " + "vs" + " " + opponents + " " + status
        
        gameTimingLbl?.text = teams
        
        gameRatingLbl?.text = rating
        
        //        self.playerImage.sd_setShowActivityIndicatorView(true)
        //        self.playerImage.sd_setIndicatorStyle(.gray)
        self.playerImage.sd_setImage(with: URL(string: imageUrl), placeholderImage:#imageLiteral(resourceName: "ProfilePlaceholder"))
        
        self.playerPositionLbl.text = position
        
        var textColor:UIColor!
        
        if position == "QB"{
            textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "RB"{
            textColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "WR" || position == "TE" {
            textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "C"{
            textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "SF" || position == "PF"{
            textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "PG" || position == "SG"{
            textColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = position
        }else if position == "A"{
            textColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = "Attacker"
        }else if position == "D"{
            textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = "Defender"
        }else if position == "M"{
            textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            self.playerPositionLbl.text = "Mid-Fielder"
        }
        
        self.playerPositionLbl.textColor = textColor
        self.gameRatingLbl?.textColor = textColor
    }
}
