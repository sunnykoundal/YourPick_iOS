import UIKit

class SwapPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet var playerNameLbl: UILabel?
    @IBOutlet var gameTimingLbl: UILabel?
    @IBOutlet var playerImage: UIImageView!
    
    let fetchUnselectedPlayer = FetchUnselectedPlayerService()
    let swapPlayerService = SwapPlayerService()
    var unselectedPlayerDetailDictionary = NSDictionary()
    var swapPlayerDetailDictionary = NSDictionary()
    
    var name = ""
    var position = ""
    var gameTiming = ""
    var playId:Int64 = 0
    var sportsId:Int64 = 0
    var userDraftPlayerId:Int64 = 0
    var playerImg = UIImage()
    var textColor = UIColor()
    var playerDataArray = NSArray()
    var samePositionPlayerData = NSMutableArray ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.playersTableView.delegate = self
        self.playersTableView.dataSource = self
        self.playerNameLbl?.text = name
        
        let main_string = position + " " + gameTiming
        
        let range = (main_string as NSString).range(of: position)
        let attributedString = NSMutableAttributedString(string:main_string)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: self.textColor , range: range)
        self.gameTimingLbl?.attributedText = attributedString
        
        self.playerImage.image = playerImg
        
        self.playerImage?.layer.cornerRadius = playerImage.frame.size.height/2
        self.playerImage?.layer.borderWidth = 1
         self.playerImage.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        self.playerImage?.clipsToBounds = true
        
        self.fetchUnselectedPlayerDetail(playId:self.playId)
    }

    @IBAction func backBtn(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func fetchUnselectedPlayerDetail(playId:Int64) {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        
        fetchUnselectedPlayer.fetchUnselectedPlayerDetailData(userId: userId, playId: playId, intValue:self.sportsId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            
            let unselectedPlayerDetails = result as? FetchUnselectedPlayerService
            
            if let UnselectedPlayerDetailDict = unselectedPlayerDetails?.unselectedPlayerDetailData {
                self.unselectedPlayerDetailDictionary = UnselectedPlayerDetailDict
            }
            else{
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

            if let resultValue: String = self.unselectedPlayerDetailDictionary.value(forKey: "result") as? String {
                result = resultValue
            }
            else
            {
                let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)

                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in

                })

                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if let messageValue: String = self.unselectedPlayerDetailDictionary.value(forKey: "message") as? String{
                message = messageValue
            }

            if result == "1"
            {
                self.playerDataArray = (self.unselectedPlayerDetailDictionary.value(forKey: "data") as! NSArray)
                
                self.samePositionPlayerData.removeAllObjects()
                for i in 0..<self.playerDataArray.count {
                    
                    let playerDetail:NSDictionary = self.playerDataArray[i] as! NSDictionary
                    print("playerDetail\(playerDetail)")
                    
                    if let playerPosition : String = playerDetail.value(forKey: "Position") as? String{
                        if playerPosition == self.position
                        {
                            self.samePositionPlayerData.add(playerDetail)
                        }
                    }
                }
                self.playersTableView.reloadData()
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
    
    func SwapPlayer(playerId:Int64, playerGamesId:Int64) {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        swapPlayerService.swapPlayer(longValue: playerGamesId, intValue: self.sportsId, playerId:self.userDraftPlayerId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            
            let swapPlayerDetails = result as? SwapPlayerService
            
            if let swapPlayerDetailDict = swapPlayerDetails?.swapPlayerDetailData {
                self.swapPlayerDetailDictionary = swapPlayerDetailDict
            }
            else{
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
            
            if let resultValue: String = self.swapPlayerDetailDictionary.value(forKey: "result") as? String {
                result = resultValue
            }
            else
            {
                let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                    
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if let messageValue: String = self.swapPlayerDetailDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
             self.dismiss(animated: true, completion: nil)
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
    
    // tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.samePositionPlayerData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let swapPlayerCell = self.playersTableView.dequeueReusableCell(withIdentifier:"UpcomingDraft",for:indexPath) as! UpcomingDraftCell
        
        let playersDetail:NSDictionary = self.samePositionPlayerData[indexPath.row] as! NSDictionary
        
        var playerNameValue: String = ""
        var gameTimeValue: String = ""
        var gameRatingValue: String = ""
        var imageUrlValue: String = ""
        var teamValue: String = ""
        var opponentValue: String = ""
        var positionValue: String = ""
        var swapPlayer: Int64 = 0
        var getUserId: Int64 = 0
        
        if let playerName: String = playersDetail.value(forKey: "Name") as? String {
            playerNameValue = playerName
        }
        
        if let gameTime: String = playersDetail.value(forKey: "GameDate") as? String {
            gameTimeValue = gameTime
        }
        
        if let rating: Double = playersDetail.value(forKey: "FantasyPointsFanDuel") as? Double {
            gameRatingValue =  "\(rating) proj"
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
        
        if let swap = playersDetail.value(forKey: "SwapRequired") as? Int64 {
            swapPlayer = swap
        }
        
        
        if let userId = playersDetail.value(forKey: "UserId") as? Int64 {
            getUserId = userId
        }
        
        swapPlayerCell.isUnselectedPlayerSelected = true
        swapPlayerCell.btnSwapPlayer.tag = indexPath.row
        swapPlayerCell.btnSwapPlayer.addTarget(self, action: #selector(swapButtonAction), for: .touchUpInside)
        
        swapPlayerCell.configureCell(name: playerNameValue, time: gameTimeValue, rating: gameRatingValue, imageUrl: imageUrlValue, team: teamValue, opponents: opponentValue, position: positionValue, swapPlayer:swapPlayer, userId:getUserId)
        return swapPlayerCell as UpcomingDraftCell
    }
    
    @objc func swapButtonAction(sender: UIButton!)
    {
        var playerGamesId: Int64 = 0
        var playerId: Int64 = 0
  
        let tagValue: Int = sender.tag
        let indexpath = IndexPath(row: tagValue, section: 0)
        
        let playersDetail:NSDictionary = self.samePositionPlayerData[indexpath.row] as! NSDictionary
        
        if let playerID = playersDetail.value(forKey:"PlayerID") as? Int64
        {
           playerId = playerID
        }
        
        if let playerGameIdd = playersDetail.value(forKey:"PlayerGamesId") as? Int64
        {
            playerGamesId = playerGameIdd
        }
        
        self.SwapPlayer(playerId:playerId, playerGamesId:playerGamesId)
    }
}
