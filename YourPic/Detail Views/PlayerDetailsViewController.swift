
import Foundation
import UIKit
import SwiftR
import UICircularProgressRing

class PlayerDetailsViewController: UIViewController {
    var playerDetailsData = NSArray()
    var sportsId : Int = 0
    // MARK: - UIViewLifeCycle
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var playerMatchDetailLbl: UILabel!
    @IBOutlet weak var projectionLbl: UILabel!
    @IBOutlet weak var averageLbl: UILabel!
    @IBOutlet weak var playerDetailView: UIView!
    @IBOutlet weak var draftPlayerBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var secondTitle: UILabel!
    @IBOutlet weak var thirdTitle: UILabel!
    @IBOutlet weak var forthTitle: UILabel!
    @IBOutlet weak var fifthTitle: UILabel!
    @IBOutlet weak var sixthTitle: UILabel!
    
    @IBOutlet weak var oponent1Lbl: UILabel!
    @IBOutlet weak var oponent2Lbl: UILabel!
    @IBOutlet weak var oponent3Lbl: UILabel!
    @IBOutlet weak var oponent4Lbl: UILabel!
    
    @IBOutlet weak var points1Lbl: UILabel!
    @IBOutlet weak var points2Lbl: UILabel!
    @IBOutlet weak var point3Lbl: UILabel!
    @IBOutlet weak var points4Lbl: UILabel!
    
    @IBOutlet weak var rebounds1Lbl: UILabel!
    @IBOutlet weak var rebounds2Lbl: UILabel!
    @IBOutlet weak var rebounds3Lbl: UILabel!
    @IBOutlet weak var rebounds4Lbl: UILabel!
    
    @IBOutlet weak var assists1Lbl: UILabel!
    @IBOutlet weak var assists2Lbl: UILabel!
    @IBOutlet weak var assists3Lbl: UILabel!
    @IBOutlet weak var assists4Lbl: UILabel!
    
    @IBOutlet weak var blockedShots1Lbl: UILabel!
    @IBOutlet weak var blockedShots2Lbl: UILabel!
    @IBOutlet weak var blockedShots3Lbl: UILabel!
    @IBOutlet weak var blockedShots4Lbl: UILabel!
    
    @IBOutlet weak var steals1Lbl: UILabel!
    @IBOutlet weak var steals2Lbl: UILabel!
    @IBOutlet weak var steals3Lbl: UILabel!
    @IBOutlet weak var steals4Lbl: UILabel!
    
    @IBOutlet weak var fantasyPoints1Lbl: UILabel!
    @IBOutlet weak var fantasyPoints2Lbl: UILabel!
    @IBOutlet weak var fantasyPoints3Lbl: UILabel!
    @IBOutlet weak var fantasyPoints4Lbl: UILabel!
    
    override func viewDidLoad() {
        self.setfieldsValue()
        super.viewDidLoad()
    }
    
    func setfieldsValue(){
        
        playerImage?.layer.cornerRadius = playerImage.frame.size.width/2
        playerImage?.layer.borderWidth = 1
        playerImage?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        playerImage?.clipsToBounds = true;
        
        playerDetailView?.layer.cornerRadius = 5.0
        playerDetailView?.layer.borderWidth = 1
        playerDetailView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        playerDetailView?.clipsToBounds = true;
        
        draftPlayerBtn?.layer.cornerRadius = 5.0
        draftPlayerBtn?.layer.borderWidth = 1
        draftPlayerBtn?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        draftPlayerBtn?.clipsToBounds = true;
        
        favouriteBtn?.layer.cornerRadius = 4.0
        favouriteBtn?.layer.borderWidth = 2
        favouriteBtn?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        favouriteBtn?.clipsToBounds = true;
        
        if self.sportsId == 1{
            self.firstTitle.text = "Yds"
            self.secondTitle.text = "TD"
            self.thirdTitle.text = "INT"
            self.forthTitle.text = "RuYd"
            self.fifthTitle.text = "RuTd"
            self.sixthTitle.text = "Total"
        }
        
        for i in 0..<self.playerDetailsData.count {
            let detail = self.playerDetailsData[i] as! NSDictionary
            self.playerNameLbl.text = (detail.value(forKey: "Name") as! String)
            
            if let averageInt = detail.value(forKey: "FantasyPointsFanDuel") as? Float {
                self.averageLbl.text = String(averageInt)
            }
            
            var positionValue : String = ""
            var teamValue : String = ""
            var opponentValue : String = ""
            var timeValue : String = ""
            
            if let playerImg = detail.value(forKey: "PhotoUrl") as? String {
                URLSession.shared.dataTask(with: NSURL(string: playerImg)! as URL, completionHandler: { (data, response, error) -> Void in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        let image = UIImage(data: data!)
                        self.playerImage.image = image
                    })
                }).resume()
            }
            
            if let position = detail.value(forKey: "Position") as? String {
                positionValue = position
            }
            
            if let team = detail.value(forKey: "Team") as? String {
                teamValue = team
            }
            
            if let opponent = detail.value(forKey: "Opponent") as? String {
                opponentValue = opponent
            }
            
            if let time = detail.value(forKey:"GameDate") as? String {
                let timeArray = time.components(separatedBy: ".")
                let timeValueOnly:String = timeArray[0]
                
                let timeValueArray = timeValueOnly.components(separatedBy: "T")
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
                dateFormatter.dateFormat = "HH:mm:ss"
                
                let time = dateFormatter.date(from: timeValueArray[1])
                
                dateFormatter.dateFormat = "HH:mm a"
                
                let timeStr = dateFormatter.string(from: time!)
                
                dateFormatter.dateFormat = "yyy-mm-dd"
                let date = dateFormatter.date(from: timeValueArray[0])!
                
                dateFormatter.dateFormat = "eee"
                let day = dateFormatter.string(from: date)
                
                timeValue = " " + day + "," + " " + timeStr
            }
            
            let matchDetail : String = positionValue + " " + teamValue + " " + "@"  + opponentValue + timeValue
            
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: matchDetail as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 13.0)!])
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:positionValue.count))
            
            myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "AmericanTypewriter-Bold", size: 13.0)!, range: NSRange(location:positionValue.count + 1,length:teamValue.count))
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:positionValue.count + teamValue.count + 2,length:timeValue.count))
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:matchDetail.count - timeValue.count,length:timeValue.count))
            
            playerMatchDetailLbl.attributedText = myMutableString
            
            if let playerGameDict = detail.value(forKey: "NBAPlayersGame"){
                
                if detail["NBAPlayersGame"] is NSNull {
                    print("playerGameDict is Null")
                }
                else{
                    let playerGame = playerGameDict as! NSDictionary
                    
                    if i == 0 {
                        if let pointsInt = playerGame.value(forKey: "Points") as? Float {
                            self.points1Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Float {
                            self.assists1Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "BlockedShots") as? Float {
                            self.blockedShots1Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "Steals") as? Float {
                            self.steals1Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Float {
                            self.fantasyPoints1Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Rebounds") as? Float {
                            self.rebounds1Lbl.text = String(reboundsInt)
                        }
                        
                        var opponentValue : String = ""
                        var dateValue : String = ""
                        var isProjectionValue : Bool = false
                        
                        if let isProjection = detail.value(forKey: "IsProjection") as? Bool {
                            isProjectionValue = isProjection
                        }
                        
                        if let opponent = playerGame.value(forKey: "Opponent") as? String {
                            opponentValue = opponent
                        }
                        
                        if let gameDate = playerGame.value(forKey: "GameDate") as? String {
                            let timeValueArray = gameDate.components(separatedBy: "T")
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
                            dateFormatter.dateFormat = "yyyy-mm-dd"
                            let date = dateFormatter.date(from: timeValueArray[0])!
                            
                            dateFormatter.dateFormat = "mm/dd"
                            let dateStr = dateFormatter.string(from: date)
                            
                            dateValue = dateStr
                        }
                        
                        if isProjectionValue{
                            self.oponent1Lbl.text = "Projection"
                            self.oponent1Lbl.font = UIFont.boldSystemFont(ofSize: 11.0)
                        }else{
                            self.oponent1Lbl.text = dateValue + " " + "vs" + " " + opponentValue
                        }
                    }else if i == 1 {
                        if let pointsInt = playerGame.value(forKey: "Points") as? Float {
                            self.points2Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Float {
                            self.assists2Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "BlockedShots") as? Float {
                            self.blockedShots2Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "Steals") as? Float {
                            self.steals2Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Float {
                            self.fantasyPoints2Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Rebounds") as? Float {
                            self.rebounds2Lbl.text = String(reboundsInt)
                        }
                        
                        var opponentValue : String = ""
                        var dateValue : String = ""
                        var isProjectionValue : Bool = false
                        
                        if let isProjection = detail.value(forKey: "IsProjection") as? Bool {
                            isProjectionValue = isProjection
                        }
                        
                        if let opponent = playerGame.value(forKey: "Opponent") as? String {
                            opponentValue = opponent
                        }
                        
                        if let gameDate = playerGame.value(forKey: "GameDate") as? String {
                            let timeValueArray = gameDate.components(separatedBy: "T")
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
                            dateFormatter.dateFormat = "yyyy-mm-dd"
                            let date = dateFormatter.date(from: timeValueArray[0])!
                            
                            dateFormatter.dateFormat = "mm/dd"
                            let dateStr = dateFormatter.string(from: date)
                            
                            dateValue = dateStr
                        }
                        
                        if isProjectionValue{
                            self.oponent2Lbl.text = "Projection"
                            self.oponent2Lbl.font = UIFont.boldSystemFont(ofSize: 11.0)
                        }else{
                            self.oponent2Lbl.text = dateValue + " " + "vs" + " " + opponentValue
                        }
                        
                    }else if i == 2 {
                        if let pointsInt = playerGame.value(forKey: "Points") as? Float {
                            self.point3Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Float {
                            self.assists3Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "BlockedShots") as? Float {
                            self.blockedShots3Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "Steals") as? Float {
                            self.steals3Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Float {
                            self.fantasyPoints3Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Rebounds") as? Float {
                            self.rebounds3Lbl.text = String(reboundsInt)
                        }
                        
                        var opponentValue : String = ""
                        var dateValue : String = ""
                        var isProjectionValue : Bool = false
                        
                        if let isProjection = detail.value(forKey: "IsProjection") as? Bool {
                            isProjectionValue = isProjection
                        }
                        
                        if let opponent = playerGame.value(forKey: "Opponent") as? String {
                            opponentValue = opponent
                        }
                        
                        if let gameDate = playerGame.value(forKey: "GameDate") as? String {
                            let timeValueArray = gameDate.components(separatedBy: "T")
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
                            dateFormatter.dateFormat = "yyyy-mm-dd"
                            let date = dateFormatter.date(from: timeValueArray[0])!
                            
                            dateFormatter.dateFormat = "mm/dd"
                            let dateStr = dateFormatter.string(from: date)
                            
                            dateValue = dateStr
                        }
                        
                        if isProjectionValue{
                            self.oponent3Lbl.text = "Projection"
                            self.oponent3Lbl.font = UIFont.boldSystemFont(ofSize: 11.0)
                        }else{
                                        self.oponent3Lbl.text = dateValue + " " + "vs" + " " + opponentValue
                        }
                        
                    }else if i == 3 {
                        if let pointsInt = playerGame.value(forKey: "Points") as? Float {
                            self.points4Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Float {
                            self.assists4Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "BlockedShots") as? Float {
                            self.blockedShots4Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "Steals") as? Float {
                            self.steals4Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Float {
                            self.fantasyPoints4Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Rebounds") as? Float {
                            self.rebounds4Lbl.text = String(reboundsInt)
                        }
                        
                        var opponentValue : String = ""
                        var dateValue : String = ""
                        var isProjectionValue : Bool = false
                        
                        if let isProjection = detail.value(forKey: "IsProjection") as? Bool {
                            isProjectionValue = isProjection
                        }
                        
                        if let opponent = playerGame.value(forKey: "Opponent") as? String {
                            opponentValue = opponent
                        }
                        
                        if let gameDate = playerGame.value(forKey: "GameDate") as? String {
                            let timeValueArray = gameDate.components(separatedBy: "T")
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
                            dateFormatter.dateFormat = "yyyy-mm-dd"
                            let date = dateFormatter.date(from: timeValueArray[0])!
                            
                            dateFormatter.dateFormat = "mm/dd"
                            let dateStr = dateFormatter.string(from: date)
                            
                            dateValue = dateStr
                        }
                        if isProjectionValue{
                            self.oponent4Lbl.text = "Projection"
                            self.oponent4Lbl.font = UIFont.boldSystemFont(ofSize: 11.0)
                        }else{
                        self.oponent4Lbl.text = dateValue + " " + "vs" + " " + opponentValue
                    }
                    }
                }
            }
            
            if let playerGameDict = detail.value(forKey: "MatchDetails"){
                
                if detail["MatchDetails"] is NSNull {
                    print("playerGameDict is Null")
                    return
                }
                else{
                    let playerGame = playerGameDict as! NSDictionary
                    
                    if i == 0 {
                        if let pointsInt = playerGame.value(forKey: "PassingYards") as? Float {
                            self.points1Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Interceptions") as? Float {
                            self.assists1Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "RushingYards") as? Float {
                            self.blockedShots1Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "RushingTouchdowns") as? Float {
                            self.steals1Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Float {
                            self.fantasyPoints1Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Touchdowns") as? Float {
                            self.rebounds1Lbl.text = String(reboundsInt)
                        }
                        
                        var opponentValue : String = ""
                        var dateValue : String = ""
                        var isProjectionValue : Bool = false
                        
                        if let isProjection = detail.value(forKey: "IsProjection") as? Bool {
                            isProjectionValue = isProjection
                        }
                        
                        if let opponent = playerGame.value(forKey: "Opponent") as? String {
                            opponentValue = opponent
                        }
                        
                        if let gameDate = playerGame.value(forKey: "GameDate") as? String {
                            let timeValueArray = gameDate.components(separatedBy: "T")
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
                            dateFormatter.dateFormat = "yyyy-mm-dd"
                            let date = dateFormatter.date(from: timeValueArray[0])!
                            
                            dateFormatter.dateFormat = "mm/dd"
                            let dateStr = dateFormatter.string(from: date)
                            
                            dateValue = dateStr
                        }
                        
                        if isProjectionValue{
                            self.oponent1Lbl.text = "Projection"
                            self.oponent1Lbl.font = UIFont.boldSystemFont(ofSize: 11.0)
                        }else{
                            self.oponent1Lbl.text = dateValue + " " + "vs" + " " + opponentValue
                        }
                    }else if i == 1 {
                        if let pointsInt = playerGame.value(forKey: "PassingYards") as? Float {
                            self.points2Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Interceptions") as? Float {
                            self.assists2Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "RushingYards") as? Float {
                            self.blockedShots2Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "RushingTouchdowns") as? Float {
                            self.steals2Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Float {
                            self.fantasyPoints2Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Touchdowns") as? Float {
                            self.rebounds2Lbl.text = String(reboundsInt)
                        }
                        
                        var opponentValue : String = ""
                        var dateValue : String = ""
                        var isProjectionValue : Bool = false
                        
                        if let isProjection = detail.value(forKey: "IsProjection") as? Bool {
                            isProjectionValue = isProjection
                        }
                        
                        if let opponent = playerGame.value(forKey: "Opponent") as? String {
                            opponentValue = opponent
                        }
                        
                        if let gameDate = playerGame.value(forKey: "GameDate") as? String {
                            let timeValueArray = gameDate.components(separatedBy: "T")
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
                            dateFormatter.dateFormat = "yyyy-mm-dd"
                            let date = dateFormatter.date(from: timeValueArray[0])!
                            
                            dateFormatter.dateFormat = "mm/dd"
                            let dateStr = dateFormatter.string(from: date)
                            
                            dateValue = dateStr
                        }
                        
                        if isProjectionValue{
                            self.oponent2Lbl.text = "Projection"
                            self.oponent2Lbl.font = UIFont.boldSystemFont(ofSize: 11.0)
                        }else{
                            self.oponent2Lbl.text = dateValue + " " + "vs" + " " + opponentValue
                        }
                        
                    }else if i == 2 {
                        if let pointsInt = playerGame.value(forKey: "PassingYards") as? Float {
                            self.point3Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Interceptions") as? Float {
                            self.assists3Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "RushingYards") as? Float {
                            self.blockedShots3Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "RushingTouchdowns") as? Float {
                            self.steals3Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Float {
                            self.fantasyPoints3Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Touchdowns") as? Float {
                            self.rebounds3Lbl.text = String(reboundsInt)
                        }
                        
                        var opponentValue : String = ""
                        var dateValue : String = ""
                        var isProjectionValue : Bool = false
                        
                        if let isProjection = detail.value(forKey: "IsProjection") as? Bool {
                            isProjectionValue = isProjection
                        }
                        
                        if let opponent = playerGame.value(forKey: "Opponent") as? String {
                            opponentValue = opponent
                        }
                        
                        if let gameDate = playerGame.value(forKey: "GameDate") as? String {
                            let timeValueArray = gameDate.components(separatedBy: "T")
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
                            dateFormatter.dateFormat = "yyyy-mm-dd"
                            let date = dateFormatter.date(from: timeValueArray[0])!
                            
                            dateFormatter.dateFormat = "mm/dd"
                            let dateStr = dateFormatter.string(from: date)
                            
                            dateValue = dateStr
                        }
                        
                        if isProjectionValue{
                            self.oponent3Lbl.text = "Projection"
                            self.oponent3Lbl.font = UIFont.boldSystemFont(ofSize: 11.0)
                        }else{
                            self.oponent3Lbl.text = dateValue + " " + "vs" + " " + opponentValue
                        }
                        
                    }else if i == 3 {
                        if let pointsInt = playerGame.value(forKey: "PassingYards") as? Float {
                            self.points4Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Interceptions") as? Float {
                            self.assists4Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "RushingYards") as? Float {
                            self.blockedShots4Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "RushingTouchdowns") as? Float {
                            self.steals4Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Float {
                            self.fantasyPoints4Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Touchdowns") as? Float {
                            self.rebounds4Lbl.text = String(reboundsInt)
                        }
                        
                        var opponentValue : String = ""
                        var dateValue : String = ""
                        var isProjectionValue : Bool = false
                        
                        if let isProjection = detail.value(forKey: "IsProjection") as? Bool {
                            isProjectionValue = isProjection
                        }
                        
                        if let opponent = playerGame.value(forKey: "Opponent") as? String {
                            opponentValue = opponent
                        }
                        
                        if let gameDate = playerGame.value(forKey: "GameDate") as? String {
                            let timeValueArray = gameDate.components(separatedBy: "T")
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
                            dateFormatter.dateFormat = "yyyy-mm-dd"
                            let date = dateFormatter.date(from: timeValueArray[0])!
                            
                            dateFormatter.dateFormat = "mm/dd"
                            let dateStr = dateFormatter.string(from: date)
                            
                            dateValue = dateStr
                        }
                        if isProjectionValue{
                            self.oponent4Lbl.text = "Projection"
                            self.oponent4Lbl.font = UIFont.boldSystemFont(ofSize: 11.0)
                        }else{
                            self.oponent4Lbl.text = dateValue + " " + "vs" + " " + opponentValue
                        }
                    }
                }
            }
        }
    }
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

