		
 import Foundation
 import UIKit
 
 class DraftDetailViewController: UIViewController{
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    let enterDraftService = EnterDraftService()
    var playDetailPage = PlayDetailsViewController()
    let fetchDraftLobbyService = FetchDraftDetailLobbyService()
    var depositMoneyViewController = DepositMoneyViewController()
    
    
    @IBOutlet weak var draftTypeLbl: UILabel!
    @IBOutlet weak var draftStartLbl: UILabel!
    @IBOutlet weak var roasterLbl: UILabel!
    @IBOutlet weak var pickClockLbl: UILabel!
    @IBOutlet weak var prizesLbl: UILabel!
    @IBOutlet weak var firstPrizeLbl: UILabel!
    @IBOutlet weak var draftName: UILabel!
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet var enteredLbl: UILabel?
    @IBOutlet var entrantsLbl: UILabel?
    @IBOutlet var entryLbl: UILabel?
    @IBOutlet var prizeLbl: UILabel?
    @IBOutlet var draftNameLbl: UILabel?
    @IBOutlet var gameTypeImage: UIImageView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet  var gameStartLbl: UILabel!
    
    var draftsData = NSDictionary()
    var playDictionary = NSDictionary()
    var isFromPlayerDetails:Bool = false
    var isFromUpcoming:Bool = false
    var draftNameValue:String = ""
    
    var draftId:Int = 0
    var timer = Timer()
    var isSignalRStarted:Bool = false
    var isConnectionLost:Bool = false
    
    // MARK: - UIViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsView?.layer.cornerRadius = 10
        detailsView?.layer.borderWidth = 1
        
        self.draftName.text = draftNameValue
        
        if Reachability.isConnectedToNetwork() == true {
            self.fetchDraftFromLobby()
           
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
        
        //    self.setValuesToFields()
    }
    
    @objc func reachability() {
        
        if Reachability.isConnectedToNetwork() == true {
                if isConnectionLost{
                    timer.invalidate()
                    self.fetchDraftFromLobby()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromPlayerDetails{
            self.isFromPlayerDetails = false
            self.dismiss(animated: true, completion: nil)
        }
        
        if isFromUpcoming{
           self.enterBtn.isHidden = true
            self.enteredLbl?.text = "2"
        }else{
            self.enterBtn.isHidden = false
        }
        print("draftId",draftId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
    }
    // MARK: - Status bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Other Method's
    
    func fetchDraftFromLobby() {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        //Login Api
        fetchDraftLobbyService.fetchDraftlobby(draftId: draftId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            
            let draftDetails = result as? FetchDraftDetailLobbyService
    
            progressHUD.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            //
            if let draftsDataDict = draftDetails?.draftData {
                self.draftsData = draftsDataDict
            }else{
                let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                  self.fetchDraftFromLobby()
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            var result:String = ""
            var message:String = ""
            
            if let resultValue: String = self.draftsData.value(forKey: "result") as? String {
                result = resultValue
            }else{
                let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                 self.fetchDraftFromLobby()
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if let messageValue: String = self.draftsData.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                self.setValuesToFields()
                
            }
            else if result == "0"
            {
                let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                    self.fetchDraftFromLobby()
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    func setValuesToFields() {
        
        var prizesArray = NSDictionary()
        
        print("draftsData ===>>>",draftsData)
        
        if let data = draftsData.value(forKey: "data") as? NSDictionary {
            
            if let prizesDict: NSDictionary = data.value(forKey: "DraftPrizes") as? NSDictionary {
                prizesArray = prizesDict
            }
            
            let prizesValue: Double = self.calculateSum(CalculatingValue: prizesArray)
            
            if let draftType: String = data.value(forKey: "DraftType") as? String {
                self.draftTypeLbl.text = draftType
            }
            
            if let draftStart: String = data.value(forKey: "DraftStart") as? String {
                self.draftStartLbl.text = draftStart
            }
            
            if let rosterId: String = data.value(forKey: "RosterId") as? String {
                self.roasterLbl.text = rosterId
            }
            
            if let pickClock: String = data.value(forKey: "PickClock") as? String {
                self.pickClockLbl.text = pickClock
            }
            
            if let prizeId: String = data.value(forKey: "PrizeId") as? String {
                self.prizesLbl.text = prizeId
            }
            
            if let firstPrize: Double = prizesArray.value(forKey: "FirstPrize") as? Double {
                self.firstPrizeLbl.text = "€" + String(firstPrize)
            }
            
            if let gameStarts: String = data.value(forKey: "GameStart") as? String {
                self.gameStartLbl.text = gameStarts
            }
            
            var enteredValue : String = ""
            var entrantsValue : String = ""
            
            if let entered: Int = data.value(forKey: "Entered") as? Int {
                enteredValue = String(entered)
            }
            
            
            
            if let entrants: Int = data.value(forKey: "Entrants") as? Int {
                entrantsValue = String(entrants)
            }
            
            if isFromUpcoming{
                enteredValue = entrantsValue
            }
            
            self.enteredLbl?.text = entrantsValue
            self.entrantsLbl?.text = enteredValue + "/" + entrantsValue
            
            if let entryFee: Int = data.value(forKey: "EntryFee") as? Int {
                self.entryLbl?.text = "€" + String(entryFee)
            }
            
            self.prizesLbl?.text = "€" + String(prizesValue)
            self.prizeLbl?.text = "€" + String(prizesValue)
            
            if let draftName: String = data.value(forKey: "DraftName") as? String {
                self.draftNameLbl?.text = draftName
                self.draftName.text = draftName
            }
            
            var wrteValue : String = ""
            var rbValue : String = ""
            var qbValue : String = ""
            
            if let rosterDict: NSDictionary = data.value(forKey: "DraftRoaster") as? NSDictionary {
                if let wrte: String = rosterDict.value(forKey: "WRTE") as? String {
                    wrteValue = wrte
                }
                
                if let rb: String = rosterDict.value(forKey: "RB") as? String {
                    rbValue = rb
                }
                
                if let qb: String = rosterDict.value(forKey: "QB") as? String {
                    qbValue = qb
                }
            }
            
            if let sportsName: String = data.value(forKey: "SportsName") as? String {
                if sportsName == "SOCCER" {
                    enteredLbl?.backgroundColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
                    entrantsLbl?.textColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
                    entryLbl?.textColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
                    prizeLbl?.textColor = UIColor(red: 247.0/255.0, green: 85.0/255.0, blue: 40.0/255.0, alpha: 1.0)
                    gameTypeImage.image = #imageLiteral(resourceName: "Football_Logo")
                    
                    var attackerValue : String = ""
                    var defenderValue : String = ""
                    var midfielderValue : String = ""
                    
                    if let rosterDict: NSDictionary = data.value(forKey: "DraftRoaster") as? NSDictionary {
                        if let attacker: Int = rosterDict.value(forKey: "Attacker") as? Int {
                            attackerValue = String(attacker)
                        }
                        if let defender: Int = rosterDict.value(forKey: "Defender") as? Int {
                            defenderValue = String(defender)
                        }
                        if let midfielder: Int = rosterDict.value(forKey: "Midfielder") as? Int {
                            midfielderValue = String(midfielder)
                        }
                    }
                    self.roasterLbl.text = attackerValue + "Attacker" + " " + "-" + " " + defenderValue + "Defender" + " " + "-" + " " + midfielderValue + "Midfielder"
                    
                }else if sportsName == "NFL" {
                    enteredLbl?.backgroundColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
                    entrantsLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
                    entryLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
                    prizeLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
                    gameTypeImage.image = #imageLiteral(resourceName: "American_Football_Logo")
                    
                    var wrteValue : String = ""
                    var rbValue : String = ""
                    var qbValue : String = ""
                    
                    if let rosterDict: NSDictionary = data.value(forKey: "DraftRoaster") as? NSDictionary {
                        if let wrte: Int = rosterDict.value(forKey: "WRTE") as? Int {
                            wrteValue = String(wrte)
                        }
                        if let rb: Int = rosterDict.value(forKey: "RB") as? Int {
                            rbValue = String(rb)
                        }
                        if let qb: Int = rosterDict.value(forKey: "QB") as? Int {
                            qbValue = String(qb)
                        }
                    }
                    self.roasterLbl.text = wrteValue + "WRTE" + " " + "-" + " " + rbValue + "RB" + " " + "-" + " " + qbValue + "QB"
                    
                }else if sportsName == "NBA" {
                    enteredLbl?.backgroundColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
                    entrantsLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
                    entryLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
                    prizeLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
                    gameTypeImage.image = #imageLiteral(resourceName: "Basketball_Logo")
                    
                    var guardValue : String = ""
                    var forwardValue : String = ""
                    var centerValue : String = ""
                    
                    if let rosterDict: NSDictionary = data.value(forKey: "DraftRoaster") as? NSDictionary {
                        if let guards: Int = rosterDict.value(forKey: "Guard") as? Int {
                            guardValue = String(guards)
                        }
                        if let forward: Int = rosterDict.value(forKey: "Forward") as? Int {
                            forwardValue = String(forward)
                        }
                        if let center: Int = rosterDict.value(forKey: "Center") as? Int {
                            centerValue = String(center)
                        }
                    }
                    self.roasterLbl.text = guardValue + "Guard" + " " + "-" + " " + forwardValue + "Forward" + " " + "-" + " " + centerValue + "Center"
                }
            }
        }
    }
    
    func calculateSum(CalculatingValue: NSDictionary) -> Double{
        let allKeyValues: [String] = CalculatingValue.allKeys as! [String]
        var calculatedValue : Double = 0.0
        var valueToAdd : Double = 0.0
        
        for i in 0..<allKeyValues.count {
            let key = allKeyValues[i]
            //Here you received string 'category'
            if let value = CalculatingValue.value(forKey: key) as? Double{
                valueToAdd = value
                calculatedValue = calculatedValue + valueToAdd
            }
        }
        return calculatedValue
    }
    
    // MARK: - IBAction's
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func enterDraftBtn(_ sender: Any) {
        var entryFeeValue:Double = 0
        if let data = draftsData.value(forKey: "data") as? NSDictionary {
            if let entryFee: Int64 = data.value(forKey: "EntryFee") as? Int64 {
                entryFeeValue = Double(entryFee)
            }
        }
        let balance: Double = self.delegate.totalAmount
        
        if Reachability.isConnectedToNetwork() == true {
            
        if balance < entryFeeValue {
            
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
            // Create View Controllers
            self.depositMoneyViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DepositMoney") as! DepositMoneyViewController
            self.present(self.depositMoneyViewController, animated: false, completion: nil)
            
        }else{
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            self.view.isUserInteractionEnabled = false
            var draftIdValue:Int = 0
            var playIdValue:Int64 = 0
            var sportsIdValue:Int64 = 0
            
            if let data = draftsData.value(forKey: "data") as? NSDictionary {
                
                
                if let draftId: Int = data.value(forKey: "DraftId") as? Int {
                    draftIdValue = draftId
                }
                
                if let playId: Int64 = data.value(forKey: "PlayId") as? Int64 {
                    playIdValue = playId
                }
                
                if let sportsId: Int64 = data.value(forKey: "SportsId") as? Int64 {
                    sportsIdValue = sportsId
                }
            }
            
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            
            //Login Api
            enterDraftService.enterDraft(draftId: draftIdValue, userId: userId, playId: playIdValue) {(result, message, status )in
                self.view.isUserInteractionEnabled = true
                
                let playDetails = result as? EnterDraftService
                
                progressHUD.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                
                if let playDict = playDetails?.playData {
                    self.playDictionary = playDict
                }else{
                    let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                      self.fetchDraftFromLobby()
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                var result:String = ""
                var message:String = ""
                
                if let resultValue: String = self.playDictionary.value(forKey: "result") as? String {
                    result = resultValue
                }else{
                    let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                     self.fetchDraftFromLobby()
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                if let messageValue: String = self.playDictionary.value(forKey: "message") as? String{
                    message = messageValue
                }
                
                if result == "1"
                {
                    let remainingBalance:Double = balance - entryFeeValue
                    self.delegate.totalAmount = remainingBalance
            
                    UserDefaults.standard.set(remainingBalance, forKey: "Amount")
                    
                    let playIdValue: Int64 = self.playDictionary.value(forKey: "PlayId") as! Int64
                    self.isFromPlayerDetails = true
                    let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                    
                    self.playDetailPage = mainStoryBoard.instantiateViewController(withIdentifier: "PlayDetails") as! PlayDetailsViewController
                    self.playDetailPage.draftId = draftIdValue
                    self.playDetailPage.playId = playIdValue
                    self.playDetailPage.sportsId = sportsIdValue
                    self.playDetailPage.entryFeesValue = Int(Int64(entryFeeValue))
                    
                    self.present(self.playDetailPage, animated: false, completion: nil)
                    
                }
                else if result == "0"
                {
                    let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                        self.fetchDraftFromLobby()
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
           
        } else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
                self.fetchDraftFromLobby()
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
 }
