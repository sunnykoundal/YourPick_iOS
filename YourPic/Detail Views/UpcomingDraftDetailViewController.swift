
import Foundation
import UIKit

class UpcomingDraftDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let fetchUpcomingDraftDetailService = FetchUpcomingDraftDetailServices()
    let fetchDraftResultDetailService = FetchDraftResultDetailService()
    let fetchLiveMatchDetailService = FetchLiveMatchDetailService()
    let fetchPlayerDetailsService = FetchPlayerDetailsService()
    
    let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
    var upcomingDataTimer = Timer()
    
    @IBOutlet weak var opponentsScroller: UIScrollView!
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var notActivePlayersView: UIView!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var upcomingGraphDetailTitle: UILabel!
    
    // Mark:- Player Details Object
    
    @IBOutlet weak var playerDetailBg: UIView!
    @IBOutlet weak var playerDetailMainView: UIView!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var playerMatchDetailLbl: UILabel!
    @IBOutlet weak var projectionLbl: UILabel!
    @IBOutlet weak var averageLbl: UILabel!
    @IBOutlet weak var playerDetailView: UIView!
    
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
    @IBOutlet weak var noteTxtView: UITextView!
    
    var playerDetailsDataArray = NSArray()
    var playerDetailsData = NSDictionary()
    
    var swapPlayerScreen = SwapPlayerViewController()
    var draftDetailPage = DraftDetailViewController()
    var draftId:Int = 0
    var playId:Int64 = 0
    var sportsId:Int64 = 0
    var isLive:Bool = false
    var isResult:Bool = false
    var isFromGame:Bool = false
    // MARK: - UIViewLifeCycle
    var draftDetailArray = NSArray ()
    var draftplayerListArray = NSArray ()
    var userUpcomingDraftDetailsDictionary = NSDictionary()
    var selectedPlayerTeamList = NSMutableArray ()
    var projectionList = NSMutableArray ()
    var timer = Timer()
    var isConnectionLost:Bool = false
    var playerBtn = UIButton()
    
    var selectedButtonTag: Int = 0
    var userDraftResultsDetailDictionary = NSDictionary()
    var liveMatchesDetailDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingDataTimer.invalidate()
        upcomingDataTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        if Reachability.isConnectedToNetwork() == true {
            if self.isLive{
                self.upcomingGraphDetailTitle.text = "Live Details"
                self.infoBtn.isHidden = true
                self.fetchLiveMatchDetail(playId:  playId)
            }else if self.isResult{
                self.upcomingGraphDetailTitle.text = "Result Details"
                self.infoBtn.isHidden = true
                self.fetchDraftResultDetail(playId: playId)
            } else{
                self.infoBtn.isHidden = false
            fetchUpcomingDraftDetail(playId: playId, draftId: draftId)
            }
            
        } else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reachability), userInfo: nil, repeats: true)
        
        self.clearImagesFromDirectory()
    }
    
    @objc func reachability() {
        
        if Reachability.isConnectedToNetwork() == true {
            if isConnectionLost{
                timer.invalidate()
                if self.isLive{
                    self.fetchLiveMatchDetail(playId:  playId)
                }else if self.isResult{
                    self.fetchDraftResultDetail(playId: playId)
                } else{
                    fetchUpcomingDraftDetail(playId: playId, draftId: draftId)
                }
                isConnectionLost = false
            }
           
        } else {
            isConnectionLost = true
            print("Internet connection FAILED")
            
            let alert = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: recheckReachability)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func recheckReachability(action: UIAlertAction) {
        self.reachability()
    }
    
    @objc func runTimedCode() {
        if Reachability.isConnectedToNetwork() == true {
            if self.isLive{
                self.fetchLiveMatchDetail(playId:  playId)
            }else if self.isResult{
                self.fetchDraftResultDetail(playId: playId)
            } else{
                fetchUpcomingDraftDetail(playId: playId, draftId: draftId)
            }
        } else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func addPlayerButtons() {
        var xAxis: Int = 0
        
        if self.draftDetailArray.count == 2{
            xAxis = 110
        }else if self.draftDetailArray.count == 3{
            xAxis = 30
        }else{
            xAxis = 10
        }
        
        for i in 0..<self.draftDetailArray.count {
            
            let playerDetail:NSDictionary = self.draftDetailArray[i] as! NSDictionary

            let playerImageUrl: String = playerDetail.value(forKey: "ImagePath") as! String
            let firstName = playerDetail.value(forKey: "UserName")
//            let lastName: String = playerDetail.value(forKey: "LastName") as! String
//            let winningPosition: Int64 = playerDetail.value(forKey: "WinningPosition") as! Int64
            
            let playerName: String = firstName as! String
            
            self.playerBtn = UIButton()
            self.playerBtn.frame = CGRect(x: xAxis, y: 1, width: 65, height: 65)
            self.playerBtn.backgroundColor = UIColor.clear
            self.playerBtn.tag = i
        
            self.playerBtn.sd_setImage(with: URL(string: playerImageUrl), for: .normal)
            
            self.playerBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            if i == self.selectedButtonTag{
                self.playerBtn.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
                self.playerBtn.layer.borderWidth = 3
            }else{
                self.playerBtn.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
                self.playerBtn.layer.borderWidth = 1
            }
            
            self.playerBtn.layer.cornerRadius = playerBtn.frame.size.width/2
            
            self.playerBtn.clipsToBounds = true;
            
            let troffyImg = UIImageView(frame: CGRect(x:xAxis, y:Int(playerBtn.frame.origin.y + playerBtn.frame.width/2 + 15), width:25, height:25))
            troffyImg.layer.cornerRadius = troffyImg.frame.width/2
            troffyImg.layer.borderWidth = 1
            troffyImg.clipsToBounds = true
            troffyImg.tag = i + 300
            troffyImg.image = #imageLiteral(resourceName: "First Troffy")
            troffyImg.isHidden = true
            
            let positionLbl = UILabel(frame: CGRect(x: xAxis + 60, y: Int(playerBtn.frame.height/2 - 10) , width: 50, height: 30))
            positionLbl.textAlignment = .center
            positionLbl.text = String(self.calculatePojections(buttonTag: i))
            positionLbl.font = positionLbl.font.withSize(12)
            positionLbl.numberOfLines = 2
            positionLbl.tag = i + 200
            
            let nameLbl = UILabel(frame: CGRect(x: playerBtn.frame.origin.x + 7, y: playerBtn.frame.size.height + 10, width: 65, height: 60))
            nameLbl.textAlignment = .center
            nameLbl.text = playerName
            nameLbl.font = nameLbl.font.withSize(12)
            nameLbl.numberOfLines = 5
            nameLbl.sizeToFit()
            
            self.opponentsScroller.addSubview(nameLbl)
            
            self.opponentsScroller.addSubview(self.playerBtn)
            
            if isLive || isResult{
                if isResult{
                self.opponentsScroller.addSubview(troffyImg)
                }
                self.opponentsScroller.addSubview(positionLbl)
            }
            if isLive || isResult{
                xAxis = xAxis + 120
            }else{
                xAxis = xAxis + 100
            }
            self.opponentsScroller.contentSize = CGSize(width: xAxis + 150, height: Int(self.opponentsScroller.frame.size.height))
           
           
           
        }
        
        for subview in self.opponentsScroller.subviews{
            
            let maxNumber = self.projectionList.value(forKeyPath: "@max.self") as? Double
            print("\(maxNumber ?? 0)")
            
            let index = self.projectionList.index(of: maxNumber ?? 0.0)
            
            if subview.tag == index + 300 {
                subview.isHidden = false
            }
            // Do what you want to do with the subview
            print(subview)
            
        }
        
    }
    
    func downloadUsersImages(imageUrl: String, imageName: String) {
        URLSession.shared.dataTask(with: NSURL(string: imageUrl)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "nil")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                // get the documents directory url
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                // choose a name for your image
                let fileName = imageName
                // create the destination file url to save your image
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                // get your UIImage jpeg data representation and check if the destination file url already exists
                let image = UIImage(data: data!)
                if let data = UIImageJPEGRepresentation(image!, 1.0),
                    !FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        // writes the image data to disk
                        try data.write(to: fileURL)
                        print("file saved")
                    } catch {
                        print("error saving file:", error)
                    }
                }
            })
        }).resume()
    }
    
    func clearImagesFromDirectory() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func calculatePojections(buttonTag: Int) -> Double{

        let playerDetail:NSDictionary = self.draftDetailArray[buttonTag] as! NSDictionary

        let userId : Int = playerDetail.value(forKey: "UserId") as! Int
        var total : Double = 0

        for i in 0..<self.draftplayerListArray.count  {
            let playerTeamMember:NSDictionary = self.draftplayerListArray[i] as! NSDictionary

            let playerTeamMemberUserId : Int = playerTeamMember.value(forKey: "UserId") as! Int

            if userId == playerTeamMemberUserId {
                if let projValue:Double = playerTeamMember.value(forKey: "Points") as? Double {
                    total = total + projValue
                }

            }
        }
        projectionList.add(total)
        return total
    }
    
    func fetchUpcomingDraftDetail(playId: Int64, draftId: Int) {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        fetchUpcomingDraftDetailService.fetchUpcomingDraftDetailData(userId: userId, playId: playId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
             progressHUD.removeFromSuperview()
            
            let upcomingDraftDetails = result as? FetchUpcomingDraftDetailServices
           
            if let userUpcomingDraftDetailsDict = upcomingDraftDetails?.draftDetailData {
                self.userUpcomingDraftDetailsDictionary = userUpcomingDraftDetailsDict
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
            
            if let resultValue: String = self.userUpcomingDraftDetailsDictionary.value(forKey: "result") as? String {
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
            if let messageValue: String = self.userUpcomingDraftDetailsDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                self.draftDetailArray = (self.userUpcomingDraftDetailsDictionary.value(forKey: "data") as! NSArray)
                self.draftplayerListArray = (self.userUpcomingDraftDetailsDictionary.value(forKey: "UserPlayers") as! NSArray)
               
                for i in 0..<self.draftDetailArray.count {
                    let playerDetail:NSDictionary = self.draftDetailArray[i] as! NSDictionary
                  
                   if let playerImageUrl = playerDetail.value(forKey: "ImagePath") ,
                    let firstName = playerDetail.value(forKey: "UserName") {
                    
                    self.downloadUsersImages(imageUrl: playerImageUrl as! String, imageName: firstName as! String)
                    }
                }
                
                self.selectedButtonTag = 0
                self.addPlayerButtons()
                self.filterThePlayers(tagValue: 0)
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
    
    // MARK: - Fetch  Draft Result Detail
    
    func fetchDraftResultDetail(playId:Int64) {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        
        fetchDraftResultDetailService.fetchDraftResultDetailsData(userId: userId, playId: playId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            let draftResultDetails = result as? FetchDraftResultDetailService
            
            if let userDraftResultsDetailDict = draftResultDetails?.draftResultDetailData {
                self.userDraftResultsDetailDictionary = userDraftResultsDetailDict
            }else{
                let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                    self.view.isUserInteractionEnabled = true
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            
            
            var result:String = ""
            var message:String = ""
            
            if let resultValue: String = self.userDraftResultsDetailDictionary.value(forKey: "result") as? String {
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
            if let messageValue: String = self.userDraftResultsDetailDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                self.draftDetailArray = (self.userDraftResultsDetailDictionary.value(forKey: "data") as! NSArray)
                self.draftplayerListArray = (self.userDraftResultsDetailDictionary.value(forKey: "UserPlayers") as! NSArray)
                
                self.selectedButtonTag = 0
                self.addPlayerButtons()
                self.filterThePlayers(tagValue: 0)
                
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
    
    // MARK: - Fetch  Live Matches Detail
    
    func fetchLiveMatchDetail(playId:Int64) {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        
        fetchLiveMatchDetailService.fetchLiveMatchesDetailsData(userId: userId, playId: playId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            
            let liveMatchesDetails = result as? FetchLiveMatchDetailService
            
            if let liveMatchesDetailDict = liveMatchesDetails?.draftLiveMatchesDetailData {
                self.liveMatchesDetailDictionary = liveMatchesDetailDict
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
            
            if let resultValue: String = self.liveMatchesDetailDictionary.value(forKey: "result") as? String {
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
            if let messageValue: String = self.liveMatchesDetailDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                self.draftDetailArray = (self.liveMatchesDetailDictionary.value(forKey: "data") as! NSArray)
                self.draftplayerListArray = (self.liveMatchesDetailDictionary.value(forKey: "UserPlayers") as! NSArray)
                
                for i in 0..<self.draftDetailArray.count {
                    let playerDetail:NSDictionary = self.draftDetailArray[i] as! NSDictionary
                    
                    if let playerImageUrl: String = playerDetail.value(forKey: "ImagePath") as! String,
                        let firstName: String = playerDetail.value(forKey: "UserName") as! String{
                    
                    self.downloadUsersImages(imageUrl: playerImageUrl, imageName: firstName)
                    }
                }
                
                self.selectedButtonTag = 0
                self.addPlayerButtons()
                self.filterThePlayers(tagValue: 0)
                
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
    
    @objc func buttonAction(sender: UIButton!) {
        let tagValue: Int = sender.tag
        
        self.selectedButtonTag = tagValue
        self.addPlayerButtons()
        self.filterThePlayers(tagValue: tagValue)
    }
    
    @objc func swapButtonAction(sender: UIButton!)
    {
        let tagValue: Int = sender.tag
        let indexpath = IndexPath(row: tagValue, section: 0)
        
        let playersDetail:NSDictionary = self.selectedPlayerTeamList[indexpath.row] as! NSDictionary
        
        var playerNameValue: String = ""
        var gameTimeValue: String = ""
        var imageUrlValue: String = ""
        var teamValue: String = ""
        var opponentValue: String = ""
        var positionValue: String = ""
        var matchDetail = ""
        var position = ""
        var textColor:UIColor!
        var playId = Int64()
        var userDraftPlayerIdd = Int64()
        
        if let playerName: String = playersDetail.value(forKey: "Name") as? String {
            playerNameValue = playerName
        }
        
        if let gameTime: String = playersDetail.value(forKey: "GameDate") as? String {
            gameTimeValue = gameTime
        }
        
        if let team: String = playersDetail.value(forKey: "Team") as? String {
            teamValue = team
        }
        
        if let opponent: String = playersDetail.value(forKey: "Opponent") as? String {
            opponentValue = opponent
        }
        
        if let imageUrl: String = playersDetail.value(forKey: "PhotoUrl") as? String {
            imageUrlValue = imageUrl
        }
        
        if let playIdd:Int64 = playersDetail.value(forKey: "PlayId") as? Int64 {
            playId = playIdd
        }
        
        if let position: String = playersDetail.value(forKey: "Position") as? String {
            positionValue = position
        }
        
        if let UserDraftPlayerId:Int64 = playersDetail.value(forKey: "UserDraftPlayerId") as? Int64 {
            userDraftPlayerIdd = UserDraftPlayerId
        }
        
        if gameTimeValue != ""{
            let timeArray = gameTimeValue.components(separatedBy: ".")
            let timeValue:String = timeArray[0]
            let timeValueArray = timeValue.components(separatedBy: "T")
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
            dateFormatter.dateFormat = "HH:mm:ss"
          
            // initially set the format based on your datepicker date / server String
            
            let myString:String = timeValueArray[0]
            let dateValueArray = myString.components(separatedBy: "-")
            
            let strDate =  "\(dateValueArray[1])/\(dateValueArray[2])"
            let timeStr = dateFormatter.date(from: timeValueArray[1])
            
            dateFormatter.dateFormat = "hh:mma"
            
            let time = dateFormatter.string(from: timeStr!)
            
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
            
            let teams:String = teamValue + " " + "vs" + " " + opponentValue
            
            if positionValue == "QB"{
                textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
                position = positionValue
            }else if positionValue == "RB"{
                textColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
                position = positionValue
            }else if positionValue == "WR" || positionValue == "TE" {
                textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                position = positionValue
            }else if positionValue == "C"{
                textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
                position = positionValue
            }else if positionValue == "SF" || positionValue == "PF"{
                textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                position = positionValue
            }else if positionValue == "PG" || positionValue == "SG"{
                textColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
                position = positionValue
            }else if positionValue == "A"{
                textColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
                position = positionValue
            }else if positionValue == "D"{
                textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
                position = positionValue
            }else if positionValue == "M"{
                textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                position = positionValue
            }
            
            matchDetail = teams + " " + day + " " + strDate + " " + time
        }
        
        if let cell = self.playersTableView.cellForRow(at:indexpath) as? UpcomingDraftCell
        {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
        // Create View Controllers
        self.swapPlayerScreen = mainStoryBoard.instantiateViewController(withIdentifier: "swapPlayer") as! SwapPlayerViewController
        self.swapPlayerScreen.position = position
        self.swapPlayerScreen.textColor = textColor
        self.swapPlayerScreen.gameTiming = matchDetail
        self.swapPlayerScreen.name = playerNameValue
        self.swapPlayerScreen.playId = playId
        self.swapPlayerScreen.userDraftPlayerId = userDraftPlayerIdd
        self.swapPlayerScreen.sportsId = self.sportsId
        self.swapPlayerScreen.playerImg = (cell.playerImage?.image)!
            
        self.present(self.swapPlayerScreen, animated: false, completion: nil)
        }
    }
    
    func filterThePlayers(tagValue:Int) {
        let playerDetail:NSDictionary = self.draftDetailArray[tagValue] as! NSDictionary
        
        let userId : Int = playerDetail.value(forKey: "UserId") as! Int
        
        selectedPlayerTeamList.removeAllObjects()
        
        for i in 0..<self.draftplayerListArray.count  {
            let playerTeamMember:NSDictionary = self.draftplayerListArray[i] as! NSDictionary
            
            let playerTeamMemberUserId : Int = playerTeamMember.value(forKey: "UserId") as! Int
            
            if userId == playerTeamMemberUserId {
                selectedPlayerTeamList.add(playerTeamMember)
            }
        }
        self.playersTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.runTimedCode()
        playersTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        upcomingDataTimer.invalidate()
        timer.invalidate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func infoBtn(_ sender: Any) {
        
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
        // Create View Controllers
        self.draftDetailPage = mainStoryBoard.instantiateViewController(withIdentifier: "DraftDetails") as! DraftDetailViewController
        self.draftDetailPage.draftId = draftId
        self.draftDetailPage.isFromUpcoming = true
        
        self.present(self.draftDetailPage, animated: false, completion: nil)
    }
    
    // tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //make sure you use the relevant array sizes
        if self.selectedPlayerTeamList.count == 0 {
            self.notActivePlayersView.isHidden = false
            self.view.bringSubview(toFront: self.notActivePlayersView)
        }else{
            self.notActivePlayersView.isHidden = true
            self.view.sendSubview(toBack: self.notActivePlayersView)
        }
        return self.selectedPlayerTeamList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let upcomingDraftCell = self.playersTableView.dequeueReusableCell(withIdentifier:"UpcomingDraft",for:indexPath) as! UpcomingDraftCell
        
        let playersDetail:NSDictionary = self.selectedPlayerTeamList[indexPath.row] as! NSDictionary
        
        var playerNameValue: String = ""
        var gameTimeValue: String = ""
        var gameRatingValue: String = ""
        var imageUrlValue: String = ""
        var teamValue: String = ""
        var opponentValue: String = ""
        var positionValue: String = ""
        var homeTeamScoreValue: String = ""
        var awayTeamScoreValue: String = ""
        var statusValue: String = ""
        var swapPlayer: Int64 = 0
        var getUserId: Int64 = 0
        
        if let playerName: String = playersDetail.value(forKey: "Name") as? String {
            playerNameValue = playerName
        }
        
        if let gameTime: String = playersDetail.value(forKey: "GameDate") as? String {
            gameTimeValue = gameTime
        }
        
        if isResult{
            if let gameRating: Double = playersDetail.value(forKey: "Points") as? Double {
                gameRatingValue = String(gameRating)
            }
        }
        
        if isLive {
            if let gameRating: Double = playersDetail.value(forKey: "Points") as? Double {
                gameRatingValue = String(gameRating) + " " + "pts"
            }
        }else if isResult {
            if let matchDetails: NSDictionary = playersDetail.value(forKey: "MatchDetails") as? NSDictionary {
                if let gameRating: Double = matchDetails.value(forKey: "FantasyPointsFanDuel") as? Double {
                    gameRatingValue = String(gameRating) + " " + "pts"
                }
            }
            
            if let matchDetails: NSDictionary = playersDetail.value(forKey: "SoccerPlayersGame") as? NSDictionary {
                if let gameRating: Double = matchDetails.value(forKey: "FantasyPoints") as? Double {
                    gameRatingValue = String(gameRating) + " " + "pts"
                }
            }
        }else{
            if let matchDetails: NSDictionary = playersDetail.value(forKey: "MatchDetails") as? NSDictionary {
                if let gameRating: Double = matchDetails.value(forKey: "FantasyPointsFanDuel") as? Double {
                    gameRatingValue = String(gameRating) + " " + "proj"
                }
            }
            
            if let matchDetails: NSDictionary = playersDetail.value(forKey: "SoccerPlayersGame") as? NSDictionary {
                if let gameRating: Double = matchDetails.value(forKey: "FantasyPoints") as? Double {
                    gameRatingValue = String(gameRating) + " " + "proj"
                }
            }
        }
        
        
        if let team: String = playersDetail.value(forKey: "Team") as? String {
            teamValue = team
        }
        
        if let opponent: String = playersDetail.value(forKey: "Opponent") as? String {
            opponentValue = opponent
        }
        
        if let imageUrl: String = playersDetail.value(forKey: "PhotoUrl") as? String {
            imageUrlValue = imageUrl
        }
        
        if let position: String = playersDetail.value(forKey: "Position") as? String {
            positionValue = position
        }
        
        if let homeTeamScore: Int64 = playersDetail.value(forKey: "HomeTeamScore") as? Int64 {
            homeTeamScoreValue = String(homeTeamScore)
        }
        
        if let awayTeamScore: Int64 = playersDetail.value(forKey: "AwayTeamScore") as? Int64 {
            awayTeamScoreValue = String(awayTeamScore)
        }
        
        if let status: String = playersDetail.value(forKey: "Status") as? String {
            statusValue = status
        }
        
        if let swap = playersDetail.value(forKey: "SwapRequired") as? Int64 {
            swapPlayer = swap
        }
        
        
        if let userId = playersDetail.value(forKey: "UserId") as? Int64 {
            getUserId = userId
        }
        
        
        if isResult {
            
            upcomingDraftCell.configureResultsCell(name: playerNameValue, homeTeamScore: homeTeamScoreValue, awayTeamScore: awayTeamScoreValue, rating: gameRatingValue, imageUrl: imageUrlValue, opponents: opponentValue, position: positionValue, status: statusValue)
        }else{
            upcomingDraftCell.btnSwapPlayer.tag = indexPath.row
            upcomingDraftCell.btnSwapPlayer.addTarget(self, action: #selector(swapButtonAction), for: .touchUpInside)

            upcomingDraftCell.configureCell(name: playerNameValue, time: gameTimeValue, rating: gameRatingValue, imageUrl: imageUrlValue, team: teamValue, opponents: opponentValue, position: positionValue, swapPlayer:swapPlayer, userId:getUserId)
        }
        return upcomingDraftCell as UpcomingDraftCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isResult {
            var draftPlayer = NSDictionary()
            
            
            draftPlayer = self.selectedPlayerTeamList[indexPath.row] as! NSDictionary

            var playerIdValue: Int64 = 0
        
            if let playerId: Int64 = draftPlayer.value(forKey: "PlayerID") as? Int64 {
                playerIdValue = playerId
            }
            
            if let playerRating: Double = draftPlayer.value(forKey: "FantasyPointsFanDuel") as? Double {
                self.projectionLbl.text = String(playerRating)
            }
            
            if Reachability.isConnectedToNetwork() == true {
                self.fetchPlayerDetails(playerId:playerIdValue ,sportsId: Int(self.sportsId))
                
            } else {
                let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    func fetchPlayerDetails(playerId: Int64,sportsId: Int) {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        //Login Api
        fetchPlayerDetailsService.fetchPlayerDetailsData(playId: playerId, sportsId: sportsId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            
            let playerDetails = result as? FetchPlayerDetailsService
            
            progressHUD.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            //
            if let playerDetailsDataDict = playerDetails?.playerDetailsData {
                self.playerDetailsData = playerDetailsDataDict
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
            
            if let resultValue: String = self.playerDetailsData.value(forKey: "result") as? String {
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
            if let messageValue: String = self.playerDetailsData.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                self.playerDetailsDataArray = (self.playerDetailsData.value(forKey: "data") as! NSArray)
                self.setplayerDetailsfieldValue(sportsId: sportsId)
                self.playerDetailMainView.isHidden = false
                self.playerDetailBg.isHidden = false
                self.view.bringSubview(toFront: self.playerDetailBg)
                self.view.bringSubview(toFront: self.playerDetailMainView)
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
    
    @IBAction func backBtn(_ sender: Any) {
        if isFromGame {
            var homePage = HomeViewController()
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
            // Create View Controllers
            homePage = mainStoryBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
            homePage.sportsId = "0"
            
            self.present(homePage, animated: true, completion: nil)
        }else{
        self.dismiss(animated: false, completion: nil)
        }
    }
    
    func setplayerDetailsfieldValue(sportsId: Int){
    
        var latestNewsDate: String = ""
        
        playerImage?.layer.cornerRadius = playerImage.frame.size.width/2
        playerImage?.layer.borderWidth = 1
        playerImage?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        playerImage?.clipsToBounds = true;
        
        playerDetailView?.layer.cornerRadius = 5.0
        playerDetailView?.layer.borderWidth = 1
        playerDetailView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        playerDetailView?.clipsToBounds = true;
    
        if sportsId == 1{
            self.firstTitle.text = "Yds"
            self.secondTitle.text = "TD"
            self.thirdTitle.text = "INT"
            self.forthTitle.text = "RuYd"
            self.fifthTitle.text = "RuTd"
            self.sixthTitle.text = "Total"
        }else if sportsId == 3{
            self.firstTitle.text = "SCR"
            self.secondTitle.text = "GLS"
            self.thirdTitle.text = "AST"
            self.forthTitle.text = "FLD"
            self.fifthTitle.text = "TKLW"
            self.sixthTitle.text = "Total"
        }
        
        for i in 0..<self.playerDetailsDataArray.count {
            let detail = self.playerDetailsDataArray[i] as! NSDictionary
            if i == 0 {
                self.playerNameLbl.text = (detail.value(forKey: "Name") as! String)
                
                if let averageInt = detail.value(forKey: "FantasyPointsFanDuel") as? Double {
                    self.averageLbl.text = String(averageInt)
                }
                
                if let note = detail.value(forKey: "InjuryNotes") as? String {
                    self.noteTxtView.text = note
                }else{
                    self.noteTxtView.text = "No news found!"
                }
                
                var positionValue : String = ""
                var teamValue : String = ""
                var opponentValue : String = ""
                var timeValue : String = ""
                
                if let playerImg = detail.value(forKey: "PhotoUrl") as? String {
                    self.playerImage.sd_setImage(with: URL(string: playerImg), placeholderImage:#imageLiteral(resourceName: "ProfilePlaceholder"))
                    
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
                    let timeValueArray = time.components(separatedBy: "T")
                    
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
                
                let matchDetail : String = positionValue + " " + teamValue + " " + "vs"  + opponentValue + timeValue
                
                var myMutableString = NSMutableAttributedString()
                
                myMutableString = NSMutableAttributedString(string: matchDetail as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 13.0)!])
                
                var textColor:UIColor!
                
                if positionValue == "QB"{
                    textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
                }else if positionValue == "RB"{
                    textColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
                }else if positionValue == "WR" || positionValue == "TE" {
                    textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                }else if positionValue == "C"{
                    textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
                }else if positionValue == "SF" || positionValue == "PF"{
                    textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                }else if positionValue == "PG" || positionValue == "SG"{
                    textColor = UIColor(red: 255.0/255.0, green: 76.0/255.0, blue: 26.0/255.0, alpha: 1.0)
                }else if positionValue == "A"{
                    textColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
                }else if positionValue == "D"{
                    textColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 234.0/255.0, alpha: 1.0)
                }else if positionValue == "M"{
                    textColor = UIColor(red: 132.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                }
                
                myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value:textColor, range: NSRange(location:0,length:positionValue.count))
                
                myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "AmericanTypewriter-Bold", size: 13.0)!, range: NSRange(location:positionValue.count + 1,length:teamValue.count))
                
                myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:positionValue.count + teamValue.count + 2,length:timeValue.count))
                
                myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:matchDetail.count - timeValue.count,length:timeValue.count))
                
                playerMatchDetailLbl.attributedText = myMutableString
            }
            if let playerGameDict = detail.value(forKey: "NBAPlayersGame"){
                
                if detail["NBAPlayersGame"] is NSNull {
                    print("playerGameDict is Null")
                }
                else{
                    let playerGame = playerGameDict as! NSDictionary
                    
                    if i == 0 {
                        if let pointsInt = playerGame.value(forKey: "Points") as? Double {
                            self.points1Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Double {
                            self.assists1Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "BlockedShots") as? Double {
                            self.blockedShots1Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "Steals") as? Double {
                            self.steals1Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints1Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Rebounds") as? Double {
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
                        if let pointsInt = playerGame.value(forKey: "Points") as? Double {
                            self.points2Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Double {
                            self.assists2Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "BlockedShots") as? Double {
                            self.blockedShots2Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "Steals") as? Double {
                            self.steals2Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints2Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Rebounds") as? Double {
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
                        if let pointsInt = playerGame.value(forKey: "Points") as? Double {
                            self.point3Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Double {
                            self.assists3Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "BlockedShots") as? Double {
                            self.blockedShots3Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "Steals") as? Double {
                            self.steals3Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints3Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Rebounds") as? Double {
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
                        if let pointsInt = playerGame.value(forKey: "Points") as? Double {
                            self.points4Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Double {
                            self.assists4Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "BlockedShots") as? Double {
                            self.blockedShots4Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "Steals") as? Double {
                            self.steals4Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints4Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Rebounds") as? Double {
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
                }
                else{
                    let playerGame = playerGameDict as! NSDictionary
                    
                    if i == 0 {
                        if let pointsInt = playerGame.value(forKey: "PassingYards") as? Double {
                            self.points1Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Interceptions") as? Double {
                            self.assists1Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "RushingYards") as? Double {
                            self.blockedShots1Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "RushingTouchdowns") as? Double {
                            self.steals1Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints1Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Touchdowns") as? Double {
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
                        if let pointsInt = playerGame.value(forKey: "PassingYards") as? Double {
                            self.points2Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Interceptions") as? Double {
                            self.assists2Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "RushingYards") as? Double {
                            self.blockedShots2Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "RushingTouchdowns") as? Double {
                            self.steals2Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints2Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Touchdowns") as? Double {
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
                        if let pointsInt = playerGame.value(forKey: "PassingYards") as? Double {
                            self.point3Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Interceptions") as? Double {
                            self.assists3Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "RushingYards") as? Double {
                            self.blockedShots3Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "RushingTouchdowns") as? Double {
                            self.steals3Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints3Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Touchdowns") as? Double {
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
                        if let pointsInt = playerGame.value(forKey: "PassingYards") as? Double {
                            self.points4Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Interceptions") as? Double {
                            self.assists4Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "RushingYards") as? Double {
                            self.blockedShots4Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "RushingTouchdowns") as? Double {
                            self.steals4Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints4Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Touchdowns") as? Double {
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
            
            
            if let playerGameDict = detail.value(forKey: "SoccerPlayersGame"){
                
                if detail["SoccerPlayersGame"] is NSNull {
                    print("playerGameDict is Null")
                }
                else{
                    let playerGame = playerGameDict as! NSDictionary
                    
                    if i == 0 {
                        if let pointsInt = playerGame.value(forKey: "Score") as? Double {
                            self.points1Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Double {
                            self.assists1Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "Fouled") as? Double {
                            self.blockedShots1Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "TacklesWon") as? Double {
                            self.steals1Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints1Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Goals") as? Double {
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
                        if let pointsInt = playerGame.value(forKey: "Score") as? Double {
                            self.points2Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Double {
                            self.assists2Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "Fouled") as? Double {
                            self.blockedShots2Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "TacklesWon") as? Double {
                            self.steals2Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints2Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Goals") as? Double {
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
                        if let pointsInt = playerGame.value(forKey: "Score") as? Double {
                            self.point3Lbl.text = String(pointsInt)
                        }
                        
                        if let assistsInt = playerGame.value(forKey: "Assists") as? Double {
                            self.assists3Lbl.text = String(assistsInt)
                        }
                        
                        if let blockedShotsInt = playerGame.value(forKey: "Fouled") as? Double {
                            self.blockedShots3Lbl.text = String(blockedShotsInt)
                        }
                        
                        if let stealsInt = playerGame.value(forKey: "TacklesWon") as? Double {
                            self.steals3Lbl.text = String(stealsInt)
                        }
                        
                        if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                            self.fantasyPoints3Lbl.text = String(fantasyPointsInt)
                        }
                        
                        if let reboundsInt = playerGame.value(forKey: "Goals") as? Double {
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
                    }
                }
            }
            
        }
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.playerDetailMainView.isHidden = true
        self.playerDetailBg.isHidden = true
        self.view.sendSubview(toBack: self.playerDetailBg)
        self.view.sendSubview(toBack: self.playerDetailMainView)
    }
}

