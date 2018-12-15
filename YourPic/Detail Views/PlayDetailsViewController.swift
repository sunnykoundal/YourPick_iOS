
    import Foundation
    import UIKit
    import SwiftR
    import UICircularProgressRing

    class PlayDetailsViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICircularProgressRingDelegate, UISearchBarDelegate, UITextFieldDelegate {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchDraftByIdService = FetchDraftByIdService()
        let leaveDraftService = LeaveDraftService()
        let fetchUserPlayerPicksService = FetchUserPlayerPicksService()
        let fetchPlayerDetailsService = FetchPlayerDetailsService()
        let addPlayerToQueueService = AddPlayerToQueueService()
        let removePlayerFromQueueService = RemovePlayerFromQueueService()
        let moveQueuePLayersService = MoveQueuePLayersService()
        let fetchDraftPlayersService = FetchDraftPlayersService()
        var playerDetailsPage = PlayerDetailsViewController()
        let statusLbl = UIButton()
        var isAutoPickEnable: Bool = false
        var descriptionText: String = ""
        var url : String = ""
        
        @IBOutlet var btnRule: UIButton!
        @IBOutlet weak var searchTxtFld: UITextField!
        @IBOutlet weak var pickBtn: UIButton!
        
        @IBOutlet weak var playlistBtn: UIButton!
        @IBOutlet weak var summaryBtn: UIButton!
        @IBOutlet weak var queueBtn: UIButton!
        @IBOutlet weak var draftTypeLbl: UILabel!
        @IBOutlet weak var draftStartLbl: UILabel!
        @IBOutlet weak var pickClockLbl: UILabel!
        @IBOutlet var gamesLbl: UILabel!
        @IBOutlet weak var prizesLbl: UILabel!
        @IBOutlet weak var firstPrizeLbl: UILabel!
        @IBOutlet weak var detailsView: UIView!
        @IBOutlet var playersTableView: UITableView!
        @IBOutlet var playersScroller: UIScrollView!
        @IBOutlet var pricesTableView: UITableView!
        @IBOutlet weak var queueTableView: UITableView!
        @IBOutlet var userPickPlayerTableView: UITableView!
        @IBOutlet var pricesView: UIView!
        @IBOutlet var summaryBottom: UIView!
        @IBOutlet var queueBottom: UIView!
        @IBOutlet var draftDetailView: UIView!
        @IBOutlet weak var playersInfoView: UIView!
        @IBOutlet weak var searchView: UIView!
        @IBOutlet weak var userImageView: UIImageView!
        @IBOutlet weak var opponentsImageView: UIImageView!
        @IBOutlet weak var userNameLbl: UILabel!
        var currentCell = UserPickPlayerCell()
        @IBOutlet weak var opponentsScroller: UIScrollView!
        @IBOutlet weak var noActiveDraftView: UIView!
        @IBOutlet weak var waitingView: UIView!
        @IBOutlet weak var pickLbl: UILabel!
        
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var centerCountLbl: UILabel!
        @IBOutlet weak var forwardCountLbl: UILabel!
        @IBOutlet weak var guardCountLbl: UILabel!
        @IBOutlet weak var centerLbl: UILabel!
        @IBOutlet weak var forwardLbl: UILabel!
        @IBOutlet weak var guardLbl: UILabel!
        @IBOutlet weak var guardBtn: UIButton!
        @IBOutlet weak var centerBtn: UIButton!
        @IBOutlet weak var forwardBtn: UIButton!
        @IBOutlet weak var leaveDraftBtn: UIButton!
        @IBOutlet weak var leaveDraftBottomBar: UILabel!
        
        @IBOutlet var playlistBottom: UIView!
        var draftId:Int = 0
        var playId:Int64!
        var sportsId:Int64 = 0
        var IsDraftFilled:Bool = false
        var IsOneMinuteTimerPending:Bool = false
        var IsOneMinuteTimerRunning:Bool = false
        var IsPicKEnabled:Bool = false
        var IsPickStarted:Bool = false
        var enteredPickRunning:Bool = false
        var isTimerFinished:Bool = false
        var isSignalRStarted:Bool = false
        var isConnectionLost:Bool = false
        var isInitialTimerCompleted:Bool = false
        var isGuardsFiltered:Bool = false
        var isCenterFiltered:Bool = false
        var isForwardFiltered:Bool = false
        var isPlayerList:Bool = false
        var shouldCallFetchDraft:Bool = true
        
        var draftsData = NSDictionary()
        var leftDraftsData = NSDictionary()
        var draftPlayersDictionary = NSDictionary()
        var draft = NSDictionary()
        var draftPlayers = NSMutableArray()
        var savedDraftPlayers = NSMutableArray()
        var playerPickedValueArray = NSMutableArray()
        var pickedPLayerNames = NSMutableArray()
        var pickedPlayerIds = NSMutableArray()
        var pickedPLayerPositions = NSMutableArray()
        var pickedPLayerImageUrls = NSMutableArray()
        var playerPickedNameValueArray = NSMutableArray()
        var userPickPlayersData = NSDictionary()
        var playerDetailsData = NSDictionary()
        var userPickPlayers = NSMutableArray()
        var selectedQueuePlayers = NSMutableArray()
        var overUserPicks = NSMutableArray()
        var pendingUserPicks = NSMutableArray()
        var timerTick = NSMutableArray()
        var prizesArray = NSDictionary()
        var queuePlayerDetailDict = NSDictionary()
        var playerDetailsDataArray = NSArray()
        
        var pricesKeys = ["FirstPrize","SecondPrize","ThirdPrize","FourthPrize","NextPrize1","NextPrize2","NextPrize3","NextPrize4","NextPrize5","NextPrize6","NextPrize7","NextPrize8","NextPrize9","NextPrize10"]
        var connection: SignalR!
        var selectionHub: Hub!
        var index:Int = 0
        var selectedButtonTag: Int = 0
        var entryFeesValue:Int = 0
        var searchActive : Bool = false
        var filteredArray = NSMutableArray()
        
        var wrteValue : Int = 0
        var rbValue : Int = 0
        var qbValue : Int = 0
        var guardValue : Int = 0
        var forwardValue : Int = 0
        var centerValue : Int = 0
        var attackerValue : Int = 0
        var defenderValue : Int = 0
        var midfielderValue : Int = 0
        
        var selectedQbCount:Int = 0
        var selectedRbCount:Int = 0
        var selectedWrteCount:Int = 0
        var selectedCenterCount:Int = 0
        var selectedForwardCount:Int = 0
        var selectedGaurdCount:Int = 0
        var selectedAttackerCount : Int = 0
        var selectedDefenderCount : Int = 0
        var selectedMidfielderCount : Int = 0
        
        @IBOutlet weak var ring1: UICircularProgressRingView!
        
        // Mark:- Player Details Object
        @IBOutlet weak var switchAutoPick: UISwitch!
        
        @IBOutlet weak var playerDetailBg: UIView!
        @IBOutlet weak var playerDetailMainView: UIView!
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
        @IBOutlet weak var noteTxtView: UITextView!
        @IBOutlet weak var injuryStatus: UILabel!
        
        var timer = Timer()
        let alert = UIAlertController()
        let progressHUD = ProgressHUD(text: "Loading")
        var playerGameId:Int64 = 0
        
        // MARK: - UIViewLifeCycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            searchTxtFld.delegate = self
            UIApplication.shared.isIdleTimerDisabled = true
            
            let leftView = UILabel(frame:CGRect(x: 10, y: 0, width: 7, height: 26))
            leftView.backgroundColor = UIColor.clear
            
            searchTxtFld.leftView = leftView
            searchTxtFld.leftViewMode = .always
            searchTxtFld.contentVerticalAlignment = .center
            searchTxtFld.layer.cornerRadius = 6.0
            searchTxtFld.layer.borderColor = UIColor.black.cgColor
            searchTxtFld.layer.borderWidth = 1.0
            searchTxtFld.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
            
            detailsView?.layer.cornerRadius = 10
            detailsView?.layer.borderWidth = 1
            
            searchView?.layer.cornerRadius = 4
            searchView?.layer.borderWidth = 1
            
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
            self.userImageView.layer.borderWidth = 1
            self.userImageView.layer.borderColor = UIColor(red: 123.0/255.0, green: 188.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
            let playerImg: String = UserDefaults.standard.string(forKey: "UserImage")!
            URLSession.shared.dataTask(with: NSURL(string: playerImg)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error ?? "nil")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    self.userImageView.image = image
                })
            }).resume()
            self.userImageView.clipsToBounds = true
            
            self.opponentsImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
            self.opponentsImageView.layer.borderWidth = 1
            self.opponentsImageView.layer.borderColor = UIColor(red: 123.0/255.0, green: 188.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
            
            self.centerCountLbl.layer.cornerRadius = self.centerCountLbl.frame.size.width/2
            self.centerCountLbl.layer.borderWidth = 1
            self.centerCountLbl.clipsToBounds = true
            
            self.forwardCountLbl.layer.cornerRadius = self.forwardCountLbl.frame.size.width/2
            self.forwardCountLbl.layer.borderWidth = 1
            self.forwardCountLbl.clipsToBounds = true
            
            self.guardCountLbl.layer.cornerRadius = self.guardCountLbl.frame.size.width/2
            self.guardCountLbl.layer.borderWidth = 1
            self.guardCountLbl.clipsToBounds = true
            
            let userName: String = UserDefaults.standard.string(forKey: "UserName")!
            
            self.userNameLbl.text = userName
            
            self.queueTableView.isEditing = true
            self.queueTableView.allowsSelectionDuringEditing = true
            
            self.playersScroller.delegate = self
            self.playersScroller.contentSize = CGSize(width:self.view.bounds.size.width * 3, height:self.playersScroller.frame.height)
            self.playlistBottom.isHidden = true
            self.summaryBottom.isHidden = false
            self.queueBottom.isHidden = true
            
            self.playlistBtn.setTitleColor(UIColor.white, for: .normal)
            self.summaryBtn.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
            self.queueBtn.setTitleColor(UIColor.white, for: .normal)
            
            self.playersScroller.scrollToPage(index: 1, animated: true, after: 0.0)
            
            ring1.animationStyle = kCAMediaTimingFunctionLinear
            ring1.font = UIFont.systemFont(ofSize:20)
            ring1.backgroundColor = UIColor(red: 123.0/255.0, green: 188.0/255.0, blue: 63.0/255.0, alpha: 1.0)
            
            // Set the delegate
            ring1.delegate = self
            self.pickLbl.text = ""
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(cameBackFromSleep),
                name: NSNotification.Name.UIApplicationDidBecomeActive,
                object: nil
            )
            
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reachability), userInfo: nil, repeats: true)
            }
        
        @objc func cameBackFromSleep()
        {
            self.viewWillAppear(true)
        }

        @objc func reachability() {
            
            if Reachability.isConnectedToNetwork() == true {
                
                    if isConnectionLost{
                        self.dismiss(animated: false, completion: nil)
                        var homePage = HomeViewController()
                        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                        // Create View Controllers
                        homePage = mainStoryBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                        homePage.isUserDraft = true
                        
                        self.present(homePage, animated: false, completion: nil)
                        isConnectionLost = false
                        timer.invalidate()
                    }
             
            } else {
        
            
               isConnectionLost = true
                let alert = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                    self.reachability()
                })
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        func recheckReachability() {
            self.reachability()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if !isSignalRStarted{
             self.checkSignalR()
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            timer.invalidate()
            if self.connection != nil{
                self.connection.stop()
                if let hub = self.selectionHub {
                    do {
                        let params = "Group" + String(self.playId)
                        try hub.invoke("leaveRoom",arguments:[params])
                    } catch {
                        print(error)
                    }
                }
            }
            UIApplication.shared.isIdleTimerDisabled = false
        }
        // MARK: - Status Bar
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        // MARK: - Other Methods
        
        func checkSignalR() {
            
            self.view.addSubview(progressHUD)
            self.view.isUserInteractionEnabled = false
            
            self.isSignalRStarted = true
            connection = SignalR("http://200.124.153.227/signalr/hubs")
            connection.signalRVersion = .v2_2_2
            
            selectionHub = Hub("TimeSyncingHub")
            selectionHub.isProxy()
            
            selectionHub.on("getServerTimeDummy") { args in
                if let name = args?[0] as? String, let message = args?[1] as? String {
                  
                    
                    self.UpdateUserIdAndConnectionId()
                }
            }
            
            selectionHub.on("intialTimerElapsed") { args in
                // Change any of the properties you'd like
                if let timerValue = args?[0] as? Int{
                  
                    self.leaveDraftBtn.isHidden = true
                    self.leaveDraftBottomBar.isHidden = true
                    //                let divValue:Float = (Float(100 * timerValue/60))
                    
                    self.ring1.animationStyle = kCAMediaTimingFunctionLinear
                    self.ring1.setProgress(value: CGFloat(timerValue), animationDuration: 1.0) {
                     
                    }
                }
            }
            
            selectionHub.on("initialTimerCompleted") { args in
                if let dataDict = args?[0] as? NSDictionary{
                   
                    
                    self.isInitialTimerCompleted = true
                    self.delegate.intialTimer = true
                    
                    if self.IsDraftFilled{
                        self.playersInfoView.isHidden = true
                        self.draftDetailView.isHidden = true
                        self.userPickPlayerTableView.isHidden = false
                        
                    }else{
                        self.playersInfoView.isHidden = false
                        self.draftDetailView.isHidden = false
                        self.userPickPlayerTableView.isHidden = true
                    }
                    
//                    if self.delegate.intialTimer {
//                        self.userPickPlayerTableView.isHidden = false
//                        self.draftDetailView.isHidden = true
//                    }else{
//                        self.userPickPlayerTableView.isHidden = true
//                        self.draftDetailView.isHidden = false
//                    }
                    
                    self.fetchDraftById()
                }
            }
            
            selectionHub.on("pickRunning") { args in
                if let signalrPlayID = args?[0] as? Int{
                  
                    
                    if self.IsDraftFilled{
                        self.playersInfoView.isHidden = true
                        self.draftDetailView.isHidden = true
                        self.userPickPlayerTableView.isHidden = false
                    }else{
                        self.playersInfoView.isHidden = false
                        self.draftDetailView.isHidden = false
                        self.userPickPlayerTableView.isHidden = true
                    }
                    
//                    if self.delegate.intialTimer {
//                        self.userPickPlayerTableView.isHidden = false
//                        self.draftDetailView.isHidden = true
//                    }else{
//                        self.userPickPlayerTableView.isHidden = true
//                        self.draftDetailView.isHidden = false
//                    }
                    
                    if signalrPlayID == self.playId && !self.enteredPickRunning {
                        
                        if let hub = self.selectionHub {
                            do {
                                let params = "Group" + String(signalrPlayID)
                                try hub.invoke("JoinRoom",arguments:[params])
                            } catch {
                                print(error)
                            }
                        }
                        self.fetchDraftById()
                        self.enteredPickRunning = true
                    }
                }
               
            }
            
            selectionHub.on("getServerTime") { args in
              print("timmer running")
                self.IsPicKEnabled = false
                let indexPath : IndexPath!
                
                if self.shouldCallFetchDraft{
                    self.fetchDraftById()
                    self.shouldCallFetchDraft = false
                }
                
                indexPath = IndexPath(row: self.index, section: 0)
                
//                self.userPickPlayerTableView.scrollToRow(at: indexPath, at: .middle, animated: true)

                self.userPickPlayerTableView.selectRow(at: indexPath, animated: true, scrollPosition:UITableViewScrollPosition.none)
                
                if let timerTickValue = args?[1] as? Int{
                    //                print("name: \(timerValue)\n")
                    if !(self.timerTick.contains(timerTickValue)){
                        self.timerTick.add(timerTickValue)
                        
                    }
                   
                }
                
                if let timerValue = args?[0] as? Int{
                    //                print("name: \(timerValue)\n")
                    self.ring1.animationStyle = kCAMediaTimingFunctionLinear
                    self.ring1.maxValue = 30
                    self.ring1.setProgress(value: CGFloat(timerValue), animationDuration: 0.01) {
                        
                    }
                    
                    if timerValue == 29 {
                        self.setPickingUser()
                    }
                    if timerValue <= 28 {
                        if self.index < self.pickedPLayerNames.count {
                            let userId: Int64 = Int64(UserDefaults.standard.integer(forKey: "UserId"))
                            var pickingUserId: Int64 = 0
                            pickingUserId = self.pickedPlayerIds[self.index] as! Int64
                            let pickPlayerPosition: String = self.pickedPLayerPositions[self.index] as! String
                            self.pickLbl.text = "     Pick: " + pickPlayerPosition
                            
                            if userId == pickingUserId {
                                self.IsPicKEnabled = true
                            }else{
                                self.IsPicKEnabled = false
                            }
                            self.playersTableView.reloadData()
                        }
                    }
                    if timerValue <= 3 {
                        if self.index < self.pickedPLayerNames.count {
                            let userId: Int64 = Int64(UserDefaults.standard.integer(forKey: "UserId"))
                            var pickingUserId: Int64 = 0
                            pickingUserId = self.pickedPlayerIds[self.index] as! Int64
//                            let pickedUsername = pickingUser.components(separatedBy: " ")
                           

                            if userId == pickingUserId{
                                self.IsPicKEnabled = false
                            }else{
                                self.IsPicKEnabled = false
                            }
                            self.playersTableView.reloadData()
                        }
                    }
                    if timerValue == 0{
                        self.userPickPlayerTableView.deselectRow(at: indexPath, animated: true)
                        
                    }
                }
            }
            
            selectionHub.on("playerAddedToDraft") { args in
                if let dataDict = args?[0] as? NSDictionary{
                    print("PLayer Added to Draft and its data is")
                  
                    
                    self.timerTick.removeAllObjects()
                    let data :NSDictionary = dataDict.value(forKey: "data") as! NSDictionary
                    
                    let playerDetail : NSDictionary = data.value(forKey: "Player") as! NSDictionary
                    
                    var pickedPlayerNameValue : String = ""
                    var roarsterPositionValue : String = ""
                    var pickedPlayerIdValue : String = ""
                    
                    if let playerName = playerDetail.value(forKey: "Name") as? String {
                        pickedPlayerNameValue = playerName
                    }
                    
                    if let roarsterPosition = playerDetail.value(forKey: "RoastersPosition") as? String {
                        roarsterPositionValue = roarsterPosition
                    }
                    
                    if let playerGameId = playerDetail.value(forKey: "PlayerGamesId") as? Int {
                        pickedPlayerIdValue = String(playerGameId)
                    }
                    
                    let userId: Int64 = Int64(UserDefaults.standard.integer(forKey: "UserId"))
                    let pickerId: Int64 = data.value(forKey: "UserId") as! Int64
                    
                    if roarsterPositionValue == "QB" && userId == pickerId{
                        if self.selectedQbCount < self.qbValue{
                        self.selectedQbCount = self.selectedQbCount + 1
                            if self.selectedQbCount == self.qbValue && userId == pickerId{
                                self.centerBtn.backgroundColor = UIColor.white
                                self.centerBtn.alpha = 0.7
                                self.centerBtn.isUserInteractionEnabled = false
                                if self.selectedRbCount != self.rbValue {
                                    self.guardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.guardBtn.backgroundColor = UIColor.white
                                    self.guardBtn.alpha = 0.7
                                    self.guardBtn.isUserInteractionEnabled = false
                                }
                                
                                if self.selectedWrteCount != self.wrteValue {
                                    self.forwardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.forwardBtn.backgroundColor = UIColor.white
                                    self.forwardBtn.alpha = 0.7
                                    self.forwardBtn.isUserInteractionEnabled = false
                                }
                                
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "RB" && userId == pickerId{
                        if self.selectedRbCount < self.rbValue{
                            self.selectedRbCount = self.selectedRbCount + 1
                            if self.selectedRbCount == self.rbValue && userId == pickerId{
                                self.guardBtn.backgroundColor = UIColor.white
                                self.guardBtn.alpha = 0.7
                                self.guardBtn.isUserInteractionEnabled = false
                                
                                if self.selectedQbCount != self.qbValue {
                                    self.centerBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.centerBtn.backgroundColor = UIColor.white
                                    self.centerBtn.alpha = 0.7
                                    self.centerBtn.isUserInteractionEnabled = false
                                }
                                
                                if self.selectedWrteCount != self.wrteValue {
                                    self.forwardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.forwardBtn.backgroundColor = UIColor.white
                                    self.forwardBtn.alpha = 0.7
                                    self.forwardBtn.isUserInteractionEnabled = false
                                }
                                
                                
                              
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "WRTE" && userId == pickerId{
                        if self.selectedWrteCount < self.wrteValue{
                            self.selectedWrteCount = self.selectedWrteCount + 1
                            if self.selectedWrteCount == self.wrteValue && userId == pickerId{
                                self.forwardBtn.backgroundColor = UIColor.white
                                self.forwardBtn.alpha = 0.7
                                self.forwardBtn.isUserInteractionEnabled = false
                                
                                if self.selectedQbCount != self.qbValue {
                                    self.centerBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.centerBtn.backgroundColor = UIColor.white
                                    self.centerBtn.alpha = 0.7
                                    self.centerBtn.isUserInteractionEnabled = false
                                }
                                
                                if self.selectedRbCount != self.rbValue {
                                    self.guardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.guardBtn.backgroundColor = UIColor.white
                                    self.guardBtn.alpha = 0.7
                                    self.guardBtn.isUserInteractionEnabled = false
                                }
                                
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Guard" && userId == pickerId{
                        if self.selectedGaurdCount < self.guardValue{
                            self.selectedGaurdCount = self.selectedGaurdCount + 1
                            if self.selectedGaurdCount == self.guardValue && userId == pickerId{
                                self.guardBtn.backgroundColor = UIColor.white
                                self.guardBtn.alpha = 0.7
                                self.guardBtn.isUserInteractionEnabled = false
                               
                                if self.selectedForwardCount != self.forwardValue {
                                    self.forwardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.forwardBtn.backgroundColor = UIColor.white
                                    self.forwardBtn.alpha = 0.7
                                    self.forwardBtn.isUserInteractionEnabled = false
                                }
                                
                                if self.selectedCenterCount != self.centerValue {
                                    self.centerBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.centerBtn.backgroundColor = UIColor.white
                                    self.centerBtn.alpha = 0.7
                                    self.centerBtn.isUserInteractionEnabled = false
                                }
                                
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Forward" && userId == pickerId{
                        if self.selectedForwardCount < self.forwardValue{
                            self.selectedForwardCount = self.selectedForwardCount + 1
                            if self.selectedForwardCount == self.forwardValue && userId == pickerId{
                                self.forwardBtn.backgroundColor = UIColor.white
                                self.forwardBtn.alpha = 0.7
                                self.forwardBtn.isUserInteractionEnabled = false
                                
                                if self.selectedGaurdCount != self.guardValue {
                                    self.guardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.guardBtn.backgroundColor = UIColor.white
                                    self.guardBtn.alpha = 0.7
                                    self.guardBtn.isUserInteractionEnabled = false
                                }
                                
                                if self.selectedCenterCount != self.centerValue {
                                    self.centerBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.centerBtn.backgroundColor = UIColor.white
                                    self.centerBtn.alpha = 0.7
                                    self.centerBtn.isUserInteractionEnabled = false
                                }
                                
                            self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Center" && userId == pickerId{
                        if self.selectedCenterCount < self.centerValue{
                            self.selectedCenterCount = self.selectedCenterCount + 1
                            if self.selectedCenterCount == self.centerValue && userId == pickerId{
                                self.centerBtn.backgroundColor = UIColor.white
                                self.centerBtn.alpha = 0.7
                                self.centerBtn.isUserInteractionEnabled = false
                                
                                if self.selectedForwardCount != self.forwardValue {
                                    self.forwardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.forwardBtn.backgroundColor = UIColor.white
                                    self.forwardBtn.alpha = 0.7
                                    self.forwardBtn.isUserInteractionEnabled = false
                                }
                                
                                if self.selectedGaurdCount != self.guardValue {
                                    self.guardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.guardBtn.backgroundColor = UIColor.white
                                    self.guardBtn.alpha = 0.7
                                    self.guardBtn.isUserInteractionEnabled = false
                                }
                                
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Attacker" && userId == pickerId{
                        if self.selectedAttackerCount < self.attackerValue{
                            self.selectedAttackerCount = self.selectedAttackerCount + 1
                            if self.selectedAttackerCount == self.attackerValue && userId == pickerId{
                                self.guardBtn.backgroundColor = UIColor.white
                                self.guardBtn.alpha = 0.7
                                self.guardBtn.isUserInteractionEnabled = false
                                
                                if self.selectedDefenderCount != self.defenderValue {
                                    self.centerBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.centerBtn.backgroundColor = UIColor.white
                                    self.centerBtn.alpha = 0.7
                                    self.centerBtn.isUserInteractionEnabled = false
                                }
                                
                                if self.selectedMidfielderCount != self.midfielderValue {
                                    self.forwardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.forwardBtn.backgroundColor = UIColor.white
                                    self.forwardBtn.alpha = 0.7
                                    self.forwardBtn.isUserInteractionEnabled = false
                                }
                                
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Defender" && userId == pickerId{
                        if self.selectedDefenderCount < self.defenderValue{
                            self.selectedDefenderCount = self.selectedDefenderCount + 1
                            if self.selectedDefenderCount == self.defenderValue && userId == pickerId{
                                self.centerBtn.backgroundColor = UIColor.white
                                self.centerBtn.alpha = 0.7
                                self.centerBtn.isUserInteractionEnabled = false
                                
                                if self.selectedMidfielderCount != self.midfielderValue {
                                    self.forwardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.forwardBtn.backgroundColor = UIColor.white
                                    self.forwardBtn.alpha = 0.7
                                    self.forwardBtn.isUserInteractionEnabled = false
                                }
                                
                                if self.selectedAttackerCount != self.attackerValue{
                                    self.guardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.guardBtn.backgroundColor = UIColor.white
                                    self.guardBtn.alpha = 0.7
                                    self.guardBtn.isUserInteractionEnabled = false
                                }
                                
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Midfielder" && userId == pickerId{
                        if self.selectedMidfielderCount < self.midfielderValue{
                            self.selectedMidfielderCount = self.selectedMidfielderCount + 1
                            if self.selectedMidfielderCount == self.midfielderValue && userId == pickerId{
                                self.forwardBtn.backgroundColor = UIColor.white
                                self.forwardBtn.alpha = 0.7
                                self.forwardBtn.isUserInteractionEnabled = false
                                
                                if self.selectedDefenderCount != self.defenderValue {
                                    self.centerBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.centerBtn.backgroundColor = UIColor.white
                                    self.centerBtn.alpha = 0.7
                                    self.centerBtn.isUserInteractionEnabled = false
                                }
                                
                                if self.selectedAttackerCount != self.attackerValue{
                                    self.guardBtn.backgroundColor = UIColor.clear
                                }else{
                                    self.guardBtn.backgroundColor = UIColor.white
                                    self.guardBtn.alpha = 0.7
                                    self.guardBtn.isUserInteractionEnabled = false
                                }
                                
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    self.setCounterValues()
                    
                    if self.index < self.pickedPLayerNames.count {
                    let userPickName : String = self.pickedPLayerNames[self.index] as! String
                    
                    self.pickedPLayerNames[self.index] = pickedPlayerNameValue + " " + userPickName
                   
                    self.index = self.index + 1
                        
                    self.userPickPlayerTableView.reloadData()
                
                    self.view.isUserInteractionEnabled = true
                        self.playerDetailMainView.isHidden = true
                        self.playerDetailBg.isHidden = true
                        self.view.sendSubview(toBack: self.playerDetailBg)
                        self.view.sendSubview(toBack: self.playerDetailMainView)
                    self.removePlayerFromPlayerList(playerGameId:pickedPlayerIdValue)
                    }
                }
            }
            
            selectionHub.on("playerSelectionDone") { args in
                
                if let playIdArg = args?[0] as? Int64{
                    if playIdArg == self.playId {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                            
                            self.isTimerFinished = true
                            self.delegate.intialTimer = false
                            
                            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                            // Create View Controllers
                            var upcomingDraftDetailsPage = UpcomingDraftDetailViewController()
                            upcomingDraftDetailsPage = mainStoryBoard.instantiateViewController(withIdentifier: "UpcomingDraftDetail") as! UpcomingDraftDetailViewController
                            upcomingDraftDetailsPage.playId = Int64(self.playId)
                            upcomingDraftDetailsPage.draftId = self.draftId
                            upcomingDraftDetailsPage.isLive = false
                            upcomingDraftDetailsPage.isFromGame = true
                            self.present(upcomingDraftDetailsPage, animated: false, completion: nil)
                            return
                        }
                    }
                }
            }
            connection.addHub(selectionHub)
            
            connection.starting = { [weak self] in
                print("Starting...")
            }
            
            connection.reconnecting = { [weak self] in
                print("Reconnecting...")
            }
            
            connection.connected = { [weak self] in
                print("Connected")
                DispatchQueue.main.async {
                    self?.fetchDraftById()
                }
                
            }
            
            connection.reconnected = { [weak self] in
                print("Reconnected. Connection ID:")
                
            }
            
            connection.disconnected = { [weak self] in
                print("Disconnected")
            }
            
            connection.connectionSlow = { print("Connection slow...") }
            
            connection.error = { [weak self] error in
                print("Error: \(String(describing: error))")
                
                if let source = error?["source"] as? String, source == "TimeoutException" {
                    print("Connection timed out. Restarting...")
                    self?.connection.start()
                }
            }
            
            connection.start()
        }
        
        func setCounterValues(){
            if let sportsName:NSString = self.draft.value(forKey: "SportsName") as? NSString {
                if sportsName == "NFL" {
                    guardCountLbl.text = String(selectedRbCount) + "/" + String(rbValue)
                    centerCountLbl.text = String(selectedQbCount) + "/" + String(qbValue)
                    forwardCountLbl.text = String(selectedWrteCount) + "/" + String(wrteValue)
                    
                }else if sportsName == "NBA" {
                    
                    guardCountLbl.text = String(selectedGaurdCount) + "/" + String(guardValue)
                    centerCountLbl.text = String(selectedCenterCount) + "/" + String(centerValue)
                    forwardCountLbl.text = String(selectedForwardCount) + "/" + String(forwardValue)
                }else if sportsName == "SOCCER" {
                    
                    guardCountLbl.text = String(selectedAttackerCount) + "/" + String(attackerValue)
                    centerCountLbl.text = String(selectedDefenderCount) + "/" + String(defenderValue)
                    forwardCountLbl.text = String(selectedMidfielderCount) + "/" + String(midfielderValue)
                }
            }
        }
        
        func removePlayerFromPlayerList(playerGameId:String) {
      
            if self.draftPlayers.count > 0{
                for i in 0..<self.draftPlayers.count-1{
                  
                    let draftPlayer:NSDictionary = self.draftPlayers[i] as! NSDictionary
                    let draftPlayerGameId:Int64 = draftPlayer.value(forKey: "PlayerGamesId") as! Int64
                    
                    if String(draftPlayerGameId) == playerGameId{
                        self.draftPlayers.remove(draftPlayer)
                    }
                }
                
                if self.draftPlayers.count == 1{
                    
                    let draftPlayer:NSDictionary = self.draftPlayers[0] as! NSDictionary
                    let draftPlayerGameId:Int64 = draftPlayer.value(forKey: "PlayerGamesId") as! Int64
                    
                    if String(draftPlayerGameId) == playerGameId{
                        self.draftPlayers.remove(draftPlayer)
                        
                    }
                }
                
                if self.draftPlayers.count != 0 {
                let draftPlayer:NSDictionary = self.draftPlayers.lastObject as! NSDictionary
                let draftPlayerGameId:Int64 = draftPlayer.value(forKey: "PlayerGamesId") as! Int64
                
                if String(draftPlayerGameId) == playerGameId{
                    self.draftPlayers.remove(draftPlayer)
                    
                }
                }
            }
            
            if self.filteredArray.count > 0{
                for i in 0..<self.filteredArray.count-1{
                    
                    let draftPlayer:NSDictionary = self.filteredArray[i] as! NSDictionary
                    let draftPlayerGameId:Int64 = draftPlayer.value(forKey: "PlayerGamesId") as! Int64
                    
                    if String(draftPlayerGameId) == playerGameId{
                        self.filteredArray.remove(draftPlayer)
                    }
                }
                
                if self.filteredArray.count == 1{
                    
                    let draftPlayer:NSDictionary = self.filteredArray[0] as! NSDictionary
                    let draftPlayerGameId:Int64 = draftPlayer.value(forKey: "PlayerGamesId") as! Int64
                    
                    if String(draftPlayerGameId) == playerGameId{
                        self.filteredArray.remove(draftPlayer)
                        
                    }
                }
                
                if self.filteredArray.count != 0{
                let draftPlayer:NSDictionary = self.filteredArray.lastObject as! NSDictionary
                let draftPlayerGameId:Int64 = draftPlayer.value(forKey: "PlayerGamesId") as! Int64
                
                if String(draftPlayerGameId) == playerGameId{
                    self.filteredArray.remove(draftPlayer)
                }
            }
            }
//            removePlayerFromSelectedQueueList(playerGameId: playerGameId)
            if !self.isPlayerList{
             self.fetchDraftPlayers()
            }
            self.IsPicKEnabled = false
            self.searchTxtFld.text = ""
            self.filteredArray.removeAllObjects()
            self.setFilterPresentation()
            self.playersTableView.reloadData()
        }
        
        func removePlayerFromSelectedQueueList(playerGameId:String) {
            
            if self.selectedQueuePlayers.count > 0{
                for i in 0..<self.selectedQueuePlayers.count-1{
                   
                    let draftPlayer:NSDictionary = self.selectedQueuePlayers[i] as! NSDictionary
                    let draftPlayerGameId:Int64 = draftPlayer.value(forKey: "PlayerGamesId") as! Int64
                    
                    if String(draftPlayerGameId) == playerGameId{
                        self.selectedQueuePlayers.remove(draftPlayer)
                       
                    }
                }
                if self.selectedQueuePlayers.count == 1 {
                    let draftPlayer:NSDictionary = self.selectedQueuePlayers[0] as! NSDictionary
                    let draftPlayerGameId:Int64 = draftPlayer.value(forKey: "PlayerGamesId") as! Int64
                    
                    if String(draftPlayerGameId) == playerGameId{
                        self.selectedQueuePlayers.remove(draftPlayer)
                        
                    }
                }
                
                if self.selectedQueuePlayers.count > 0 {
                let draftPlayer:NSDictionary = self.selectedQueuePlayers.lastObject as! NSDictionary
                let draftPlayerGameId:Int64 = draftPlayer.value(forKey: "PlayerGamesId") as! Int64
                
                if String(draftPlayerGameId) == playerGameId{
                    self.selectedQueuePlayers.remove(draftPlayer)
                    
                }
                }
                self.IsPicKEnabled = false
                self.queueTableView.reloadData()
            }
        }
        
        func removeRoasterPLayers(playerRoaster:String) {
            let tempArr = NSMutableArray()
            if self.draftPlayers.count > 0{
            for i in 0..<self.draftPlayers.count{
                
                let draftPlayer:NSDictionary = self.draftPlayers[i] as! NSDictionary
                let draftPLayerRoaster:String = draftPlayer.value(forKey: "RoastersPosition") as! String
               
                if draftPLayerRoaster.lowercased() == playerRoaster.lowercased(){
                    tempArr.add(draftPlayer)
                    
                }
            }
            
            for j in 0..<tempArr.count{
                let draftPlayer:NSDictionary = tempArr[j] as! NSDictionary
                self.draftPlayers.remove(draftPlayer)
            }
//            removeRoasterPLayersFromSelectedQueue(playerRoaster: playerRoaster)
                if !self.isPlayerList{
                    self.fetchDraftPlayers()
                }
            self.IsPicKEnabled = false
                self.searchTxtFld.text = ""
                self.filteredArray.removeAllObjects()
                self.setFilterPresentation()
            self.playersTableView.reloadData()
            }
        }
        
        func removeRoasterPLayersFromSelectedQueue(playerRoaster:String) {
            let tempArr = NSMutableArray()
            if self.selectedQueuePlayers.count > 0{
                for i in 0..<self.selectedQueuePlayers.count{
                    
                    let draftPlayer:NSDictionary = self.selectedQueuePlayers[i] as! NSDictionary
                    let draftPLayerRoaster:String = draftPlayer.value(forKey: "RoastersPosition") as! String
               
                    if draftPLayerRoaster.lowercased() == playerRoaster.lowercased(){
                        tempArr.add(draftPlayer)
                        
                    }
                }
                
                for j in 0..<tempArr.count{
                    let draftPlayer:NSDictionary = tempArr[j] as! NSDictionary
                    self.selectedQueuePlayers.remove(draftPlayer)
                }
                
                self.IsPicKEnabled = false
                self.queueTableView.reloadData()
            }
        }
        
        func setFilterPresentation(){
            self.guardBtn.backgroundColor = UIColor.clear
            self.centerBtn.backgroundColor = UIColor.clear
            self.forwardBtn.backgroundColor = UIColor.clear
             self.isGuardsFiltered = false
             self.isCenterFiltered = false
            self.isForwardFiltered = false
            
            if filteredArray.count == 0 {
                
                if self.selectedRbCount == self.rbValue && self.rbValue != 0{
                    self.guardBtn.backgroundColor = UIColor.white
                    self.guardBtn.alpha = 0.7
                    self.guardBtn.isUserInteractionEnabled = false
                    
                }
                
                if self.selectedQbCount == self.qbValue && self.qbValue != 0{
                    self.centerBtn.backgroundColor = UIColor.white
                    self.centerBtn.alpha = 0.7
                    self.centerBtn.isUserInteractionEnabled = false
                }
                
                if self.selectedWrteCount == self.wrteValue && self.wrteValue != 0{
                    self.forwardBtn.backgroundColor = UIColor.white
                    self.forwardBtn.alpha = 0.7
                    self.forwardBtn.isUserInteractionEnabled = false
                    
                }
                
                if self.selectedForwardCount == self.forwardValue && self.forwardValue != 0{
                    self.forwardBtn.backgroundColor = UIColor.white
                    self.forwardBtn.alpha = 0.7
                    self.forwardBtn.isUserInteractionEnabled = false
                }
                
                
                if self.selectedCenterCount == self.centerValue && self.centerValue != 0{
                    self.centerBtn.backgroundColor = UIColor.white
                    self.centerBtn.alpha = 0.7
                    self.centerBtn.isUserInteractionEnabled = false
                    
                }
                
                if self.selectedGaurdCount == self.guardValue && self.guardValue != 0 {
                    self.guardBtn.backgroundColor = UIColor.white
                    self.guardBtn.alpha = 0.7
                    self.guardBtn.isUserInteractionEnabled = false
                }
                
                if self.selectedAttackerCount == self.attackerValue && self.attackerValue != 0{
                    self.guardBtn.backgroundColor = UIColor.white
                    self.guardBtn.alpha = 0.7
                    self.guardBtn.isUserInteractionEnabled = false
                }
                
                if self.selectedDefenderCount == self.defenderValue && self.defenderValue != 0{
                    self.centerBtn.backgroundColor = UIColor.white
                    self.centerBtn.alpha = 0.7
                    self.centerBtn.isUserInteractionEnabled = false
                }
                
                if self.selectedMidfielderCount == self.midfielderValue && self.midfielderValue != 0{
                    self.forwardBtn.backgroundColor = UIColor.white
                    self.forwardBtn.alpha = 0.7
                    self.forwardBtn.isUserInteractionEnabled = false
                    
                }
            }
        }
        func UpdateUserIdAndConnectionId() {
            
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            let connectionId:String = self.connection.connectionID!
            
            if let hub = self.selectionHub {
                do {
                    try hub.invoke("updateSignalRConnectionUserId", arguments:[connectionId,userId])
                } catch {
                    print(error)
                }
                
                hub.on("updateSignalRConnectionUserIdSuccess") { args in
                    if let name = args?[0] as? String, let message = args?[1] as? String {
                        
                    }
                }
                
                connection.addHub(hub)
                
            }
        }
        
        func fetchDraftById() {
            print("Fetch draft by id called")
            //Show loading Indicator
            
            
            self.view.addSubview( self.progressHUD)
            self.view.isUserInteractionEnabled = false
            
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            
            //Login Api
            fetchDraftByIdService.fetchDraftById(draftId:draftId , userId: userId, playId: Int64(playId)) {(result, message, status )in
                self.view.isUserInteractionEnabled = true
                
                let draftDetails = result as? FetchDraftByIdService
         
                self.progressHUD.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                //
                if let draftsDataDict = draftDetails?.draftData {
                    self.draftsData = draftsDataDict
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
                
                if let resultValue: String = self.draftsData.value(forKey: "result") as? String {
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
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }
        
        func fetchDraftPlayers() {
            
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            self.view.isUserInteractionEnabled = false
            
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            
            fetchDraftPlayersService.fetchDraftPlayersData(playId: self.playId, sportsId: self.sportsId, userId: Int64(userId)) {(result, message, status )in
                self.view.isUserInteractionEnabled = true
                let draftDetails = result as? FetchDraftPlayersService
     
                progressHUD.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                //
                if let userPickPlayersDataDict = draftDetails?.draftPlayersData {
                    self.userPickPlayersData = userPickPlayersDataDict
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
                
                if let resultValue: String = self.userPickPlayersData.value(forKey: "result") as? String {
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
                if let messageValue: String = self.userPickPlayersData.value(forKey: "message") as? String{
                    message = messageValue
                }
                
                if result == "1"
                {
                    self.selectedQueuePlayers.removeAllObjects()
                    self.queueTableView.reloadData()
                    
                    self.draftPlayersDictionary = (self.userPickPlayersData.value(forKey: "data") as! NSDictionary)
//                    self.draft = self.draftPlayersDictionary.value(forKey: "draft") as! NSDictionary
                   
                    let selectedPlayersArray: NSArray = self.draftPlayersDictionary.value(forKey: "selectedPlayersQueue") as! NSArray
                    self.selectedQueuePlayers = selectedPlayersArray.mutableCopy() as! NSMutableArray
                    self.queueTableView.reloadData()
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
        
        func moveQueuePlayer(playerRowPosition: NSArray) {
            
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            self.view.isUserInteractionEnabled = false
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            //Login Api
            moveQueuePLayersService.moveQueuePLayers(userId: userId, playId: Int64(self.playId), playerRowPOsition: playerRowPosition){(result, message, status )in
                self.view.isUserInteractionEnabled = true
                
                let queuePlayerDetail = result as? MoveQueuePLayersService
                
                progressHUD.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                //
                if let queuePlayerDetailDataDict = queuePlayerDetail?.queuePlayerData {
                    self.queuePlayerDetailDict = queuePlayerDetailDataDict
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
                
                if let resultValue: String = self.queuePlayerDetailDict.value(forKey: "result") as? String {
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
                if let messageValue: String = self.queuePlayerDetailDict.value(forKey: "message") as? String{
                    message = messageValue
                }
                
                if result == "1"
                {
                    
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
        
        
        func addPLayerToQueue( playerId: Int64){
            
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            self.view.isUserInteractionEnabled = false
            
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            //Login Api
            addPlayerToQueueService.addPlayerToQueue(userId: userId, playId: Int64(self.playId), playerId:playerId ) {(result, message, status )in
                self.view.isUserInteractionEnabled = true
                
                let playerDetails = result as? AddPlayerToQueueService
                var playerDetailsData = NSDictionary()
                
                progressHUD.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                //
                if let playerDetailsDataDict = playerDetails?.playerData {
                    playerDetailsData = playerDetailsDataDict
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
                
                if let resultValue: String = playerDetailsData.value(forKey: "result") as? String {
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
                if let messageValue: String = playerDetailsData.value(forKey: "message") as? String{
                    message = messageValue
                }
                
                
                if result == "1"
                {
                    self.fetchDraftPlayers()
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
        
        func removePLayerFromQueue( playerId: Int64){
            
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            self.view.isUserInteractionEnabled = false
            
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            //Login Api
            removePlayerFromQueueService.removePlayerFromQueue(userId: userId, playId: Int64(self.playId), playerId:playerId ) {(result, message, status )in
                self.view.isUserInteractionEnabled = true
                
                let playerDetails = result as? RemovePlayerFromQueueService
                var playerDetailsData = NSDictionary()
                
                progressHUD.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                //
                if let playerDetailsDataDict = playerDetails?.playerData {
                    playerDetailsData = playerDetailsDataDict
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
                
                if let resultValue: String = playerDetailsData.value(forKey: "result") as? String {
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
                if let messageValue: String = playerDetailsData.value(forKey: "message") as? String{
                    message = messageValue
                }
                
                if result == "1"
                {
                    self.fetchDraftPlayers()
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
        
        func addPlayerButtons() {
            var xAxis: Int = 50
            
            let players:NSMutableArray = []
            let playerDict:NSMutableArray = []
            
            for i in 0..<self.userPickPlayers.count{
                let dict : NSDictionary = self.userPickPlayers[i] as! NSDictionary
                let playerName: NSString = dict.value(forKey: "UserName") as! NSString
                
                
                if !(players.contains(playerName)){
                    players.add(playerName)
                    playerDict.add(dict)
                }
            }
            for i in 0..<playerDict.count {
                
                let playerDetail:NSDictionary = playerDict[i] as! NSDictionary
                let userName: String = playerDetail.value(forKey: "UserName") as! String
                let playerImage: NSString = playerDetail.value(forKey: "UserImage") as! NSString
                
                let playerBtn = UIButton()
                playerBtn.frame = CGRect(x: xAxis, y: 15, width: 60, height: 60)
                playerBtn.backgroundColor = UIColor.clear
                playerBtn.tag = i
                playerBtn.layer.cornerRadius = playerBtn.frame.size.width/2
                
                let intialTimer:Bool = UserDefaults.standard.bool(forKey: "Initial Timer Completed")
                
                if self.delegate.selectedUserTag == i{
                    playerBtn.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
                   playerBtn.layer.borderWidth = 3
                }else{
                    playerBtn.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
                playerBtn.layer.borderWidth = 1
                }
                playerBtn.clipsToBounds = true;
                
                playerBtn.sd_setImage(with: URL(string: playerImage as String), for: .normal)
                
                //            playerBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                let nameLbl = UILabel(frame: CGRect(x: playerBtn.frame.origin.x, y: playerBtn.frame.size.height  , width: 70, height: 60))
                nameLbl.textAlignment = .center
                nameLbl.text = userName
                nameLbl.font = nameLbl.font.withSize(12)
                nameLbl.numberOfLines = 5
                
                self.opponentsScroller.addSubview(nameLbl)
                self.opponentsScroller.addSubview(playerBtn)
                
                self.opponentsScroller.contentSize = CGSize(width: xAxis + 150, height: Int(self.opponentsScroller.frame.size.height))
                
                xAxis = xAxis + 95
                
            }
        }
        
        func setPickingUser(){
        
            let players:NSMutableArray = []
            let playerDict:NSMutableArray = []
            
            for i in 0..<self.userPickPlayers.count{
                let dict : NSDictionary = self.userPickPlayers[i] as! NSDictionary
                let playerName: NSString = dict.value(forKey: "UserName") as! NSString
                
                
                if !(players.contains(playerName)){
                    players.add(playerName)
                    playerDict.add(dict)
                }
            }
            for j in 0..<playerDict.count {
                
                let playerDetail:NSDictionary = playerDict[j] as! NSDictionary
                let userId: Int64 = playerDetail.value(forKey: "UserId") as! Int64
                var pickingUserId: Int64 = 0
                if self.pickedPLayerNames.count > 0{
                    if self.index > self.pickedPLayerNames.count - 1 {
                        self.index = self.index - 1
                    }
                }
                pickingUserId = self.pickedPlayerIds[self.index] as! Int64
//                let pickedUsername = pickingUser.components(separatedBy: " ")
               
                
                if pickingUserId == userId{
                    self.delegate.selectedUserTag = j
                    self.addPlayerButtons()
                }
            }
        }
        
        func setValuesToFields() {
            self.pickedPLayerNames.removeAllObjects()
            self.pickedPlayerIds.removeAllObjects()
            self.pickedPLayerPositions.removeAllObjects()
            self.pickedPLayerImageUrls.removeAllObjects()
            self.userPickPlayers.removeAllObjects()
            self.selectedQueuePlayers.removeAllObjects()
            self.filteredArray.removeAllObjects()
            self.searchActive = false
            self.searchTxtFld.text = ""
            
            self.draftPlayersDictionary = (self.draftsData.value(forKey: "data") as! NSDictionary)
            self.draft = self.draftPlayersDictionary.value(forKey: "draft") as! NSDictionary
            
            if let sportId:Int64 = self.draft.value(forKey: "SportsId") as! Int64 {
                self.sportsId = sportId
            }
            
            let draftPlayersArray: NSArray = self.draftPlayersDictionary.value(forKey: "draftPlayer") as! NSArray
            self.draftPlayers = draftPlayersArray.mutableCopy() as! NSMutableArray
            
            let userPickPlayersArray: NSArray = self.draftPlayersDictionary.value(forKey: "userPlayerPicks") as! NSArray
            self.userPickPlayers = userPickPlayersArray.mutableCopy() as! NSMutableArray
            
            let selectedPlayersArray: NSArray = self.draftPlayersDictionary.value(forKey: "selectedPlayersQueue") as! NSArray
            self.selectedQueuePlayers = selectedPlayersArray.mutableCopy() as! NSMutableArray
    
            if let rosterDict: NSDictionary = self.draft.value(forKey: "DraftRoaster") as? NSDictionary {
                if let wrte: Int = rosterDict.value(forKey: "WRTE") as? Int {
                    wrteValue = wrte
                }
                
                if let rb: Int = rosterDict.value(forKey: "RB") as? Int {
                    rbValue = rb
                }
                
                if let qb: Int = rosterDict.value(forKey: "QB") as? Int {
                    qbValue = qb
                }
                
                if let guards: Int = rosterDict.value(forKey: "Guard") as? Int {
                    guardValue = guards
                }
                if let forward: Int = rosterDict.value(forKey: "Forward") as? Int {
                    forwardValue = forward
                }
                if let center: Int = rosterDict.value(forKey: "Center") as? Int {
                    centerValue = center
                }
                if let attacker: Int = rosterDict.value(forKey: "Attacker") as? Int {
                    attackerValue = attacker
                }
                if let defender: Int = rosterDict.value(forKey: "Defender") as? Int {
                    defenderValue = defender
                }
                if let midfielder: Int = rosterDict.value(forKey: "Midfielder") as? Int {
                    midfielderValue = midfielder
                }
                
            }
            
            if self.draft.value(forKey: "AutoPick") != nil && (self.draft.value(forKey: "AutoPick")) as! Bool
            {
                self.switchAutoPick.setOn(true, animated: true)
                self.isAutoPickEnable = true
            }
            else
            {
                self.switchAutoPick.setOn(false, animated: true)
                self.isAutoPickEnable = false
            }
            
            if let sportsName:NSString = self.draft.value(forKey: "SportsName") as? NSString {
                if sportsName == "NFL" {
                    guardLbl.text = "RB"
                    centerLbl.text = "QB"
                    forwardLbl.text = "WRTE"
                   
                    guardCountLbl.text = String(selectedRbCount) + "/" + String(rbValue)
                    centerCountLbl.text = String(selectedQbCount) + "/" + String(qbValue)
                    forwardCountLbl.text = String(selectedWrteCount) + "/" + String(wrteValue)
                    
                    //self.btnRule.setTitle("NFL Rules", for: UIControlState.normal)
                    
                    
                }else if sportsName == "NBA" {
                    guardLbl.text = "Guard"
                    centerLbl.text = "Center"
                    forwardLbl.text = "Forward"
                   
                    guardCountLbl.text = String(selectedGaurdCount) + "/" + String(guardValue)
                    centerCountLbl.text = String(selectedCenterCount) + "/" + String(centerValue)
                    forwardCountLbl.text = String(selectedForwardCount) + "/" + String(forwardValue)
                    
                    //self.btnRule.setTitle("NBA Rules", for: UIControlState.normal)
                    
                }else if sportsName == "SOCCER"{
                    guardLbl.text = "Attacker"
                    centerLbl.text = "Defender"
                    forwardLbl.text = "Midfielder"
                    
                    guardCountLbl.text = String(selectedAttackerCount) + "/" + String(attackerValue)
                    centerCountLbl.text = String(selectedDefenderCount) + "/" + String(defenderValue)
                    forwardCountLbl.text = String(selectedMidfielderCount) + "/" + String(midfielderValue)
                    
                    //self.btnRule.setTitle("SOCCER Rules", for: UIControlState.normal)
                    
                }
            }
            
            for i in 0..<self.draftPlayers.count {
                let playerData:NSDictionary = self.draftPlayers[i] as! NSDictionary
                
                if let playerId: Int = playerData.value(forKey: "PlayerGamesId") as? Int {
                    
                  
                }
            }
            
            self.guardBtn.backgroundColor = UIColor.clear
            self.centerBtn.backgroundColor = UIColor.clear
            self.forwardBtn.backgroundColor = UIColor.clear
            
            self.index = 0
            self.selectedQbCount = 0
            self.selectedRbCount = 0
            self.selectedWrteCount = 0
            self.selectedCenterCount = 0
            self.selectedForwardCount = 0
            self.selectedGaurdCount = 0
            self.selectedAttackerCount = 0
            self.selectedDefenderCount = 0
            self.selectedMidfielderCount = 0
            
            for i in 0..<self.userPickPlayers.count {
                
                let userPickPlayer:NSDictionary = self.userPickPlayers[i] as! NSDictionary
                
                var playerNameValues: String = ""
                var playerIdValues:Int64 = 0
                var playerTypeValues: String = ""
                var playerImageValues: String = ""
                
                
                if let playerName: String = userPickPlayer.value(forKey: "UserName") as? String {
                    playerNameValues = playerName
                     playerNameValues = playerNameValues.trimmingCharacters(in: .whitespaces)
                }
                
                if let playerId: Int64 = userPickPlayer.value(forKey: "UserId") as? Int64 {
                    playerIdValues = playerId
                }
                
                if let playerType: String = userPickPlayer.value(forKey: "Pick") as? String {
                    playerTypeValues = playerType
                }
                
                if let playerImage: String = userPickPlayer.value(forKey: "UserImage") as? String {
                    playerImageValues = playerImage
                }
                
                
                if let playerData: NSDictionary = userPickPlayer.value(forKey: "Player") as? NSDictionary {
                   
                    var playerIdValueForRoaster:Int64 = 0
                    var pickedPlayerNameValue : String = ""
                    var roarsterPositionValue : String = ""
                    var pickedPlayerIdValue : String = ""
                    
                    if let playerId: Int64 = userPickPlayer.value(forKey: "UserId") as? Int64 {
                        playerIdValueForRoaster = playerId
                    }
                    
                    if let playerName = playerData.value(forKey: "Name") as? String {
                        pickedPlayerNameValue = playerName
                        if self.index <= self.pickedPLayerNames.count {
                            self.index = self.index + 1
                        }
                       
                    }
                    
                     let userId: Int64 = Int64(UserDefaults.standard.integer(forKey: "UserId"))
                    
                    if let roarsterPosition = playerData.value(forKey: "RoastersPosition") as? String {
                        roarsterPositionValue = roarsterPosition
                    }
                    
                    if let playerGameId = playerData.value(forKey: "PlayerGamesId") as? Int {
                        pickedPlayerIdValue = String(playerGameId)
                    }
                    
                    if roarsterPositionValue == "QB" && userId == playerIdValueForRoaster{
                        if self.selectedQbCount < self.qbValue{
                            self.selectedQbCount = self.selectedQbCount + 1
                            if self.selectedQbCount == self.qbValue && userId == playerIdValueForRoaster{
                                self.centerBtn.backgroundColor = UIColor.white
                                self.centerBtn.alpha = 0.7
                                self.centerBtn.isUserInteractionEnabled = false
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "RB" && userId == playerIdValueForRoaster{
                        if self.selectedRbCount < self.rbValue{
                            self.selectedRbCount = self.selectedRbCount + 1
                            if self.selectedRbCount == self.rbValue && userId == playerIdValueForRoaster{
                                self.guardBtn.backgroundColor = UIColor.white
                                self.guardBtn.alpha = 0.7
                                self.guardBtn.isUserInteractionEnabled = false
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "WRTE" && userId == playerIdValueForRoaster{
                        if self.selectedWrteCount < self.wrteValue{
                            self.selectedWrteCount = self.selectedWrteCount + 1
                            if self.selectedWrteCount == self.wrteValue && userId == playerIdValueForRoaster{
                                self.forwardBtn.backgroundColor = UIColor.white
                                self.forwardBtn.alpha = 0.7
                                self.forwardBtn.isUserInteractionEnabled = false
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Guard" && userId == playerIdValueForRoaster{
                        if self.selectedGaurdCount < self.guardValue{
                            self.selectedGaurdCount = self.selectedGaurdCount + 1
                            if self.selectedGaurdCount == self.guardValue && userId == playerIdValueForRoaster{
                                self.guardBtn.backgroundColor = UIColor.white
                                self.guardBtn.alpha = 0.7
                                self.guardBtn.isUserInteractionEnabled = false
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Forward" && userId == playerIdValueForRoaster{
                        if self.selectedForwardCount < self.forwardValue{
                            self.selectedForwardCount = self.selectedForwardCount + 1
                            if self.selectedForwardCount == self.forwardValue && userId == playerIdValueForRoaster{
                                self.forwardBtn.backgroundColor = UIColor.white
                                self.forwardBtn.alpha = 0.7
                                self.forwardBtn.isUserInteractionEnabled = false
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Center" && userId == playerIdValueForRoaster{
                        if self.selectedCenterCount < self.centerValue{
                            self.selectedCenterCount = self.selectedCenterCount + 1
                            if self.selectedCenterCount == self.centerValue && userId == playerIdValueForRoaster{
                                self.centerBtn.backgroundColor = UIColor.white
                                self.centerBtn.alpha = 0.7
                                self.centerBtn.isUserInteractionEnabled = false
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Attacker" && userId == playerIdValueForRoaster{
                        if self.selectedAttackerCount < self.attackerValue{
                            self.selectedAttackerCount = self.selectedAttackerCount + 1
                            if self.selectedAttackerCount == self.attackerValue && userId == playerIdValueForRoaster{
                                self.guardBtn.backgroundColor = UIColor.white
                                self.guardBtn.alpha = 0.7
                                self.guardBtn.isUserInteractionEnabled = false
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Defender" && userId == playerIdValueForRoaster{
                        if self.selectedDefenderCount < self.defenderValue{
                            self.selectedDefenderCount = self.selectedDefenderCount + 1
                            if self.selectedDefenderCount == self.defenderValue && userId == playerIdValueForRoaster{
                                self.centerBtn.backgroundColor = UIColor.white
                                self.centerBtn.alpha = 0.7
                                self.centerBtn.isUserInteractionEnabled = false
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    if roarsterPositionValue == "Midfielder" && userId == playerIdValueForRoaster{
                        if self.selectedMidfielderCount < self.midfielderValue{
                            self.selectedMidfielderCount = self.selectedMidfielderCount + 1
                            if self.selectedMidfielderCount == self.midfielderValue && userId == playerIdValueForRoaster{
                                self.forwardBtn.backgroundColor = UIColor.white
                                self.forwardBtn.alpha = 0.7
                                self.forwardBtn.isUserInteractionEnabled = false
                                self.removeRoasterPLayers(playerRoaster: roarsterPositionValue)
                            }
                        }
                    }
                    
                    self.setCounterValues()
                    
                    self.removePlayerFromPlayerList(playerGameId:pickedPlayerIdValue)
                    playerNameValues = pickedPlayerNameValue + " " + playerNameValues
                }
                
                self.pickedPLayerNames.add(playerNameValues)
                self.pickedPlayerIds.add(playerIdValues)
                self.pickedPLayerPositions.add(playerTypeValues)
                self.pickedPLayerImageUrls.add(playerImageValues)
                
                
                
//                var playerPickValue: Bool = false
//
//                if let playerPick: Bool = userPickPlayer.value(forKey: "Picked") as? Bool {
//                    playerPickValue = playerPick
//                }
//
//                if playerPickValue{
//                    self.overUserPicks.add(userPickPlayer)
//                }else{
//                    self.pendingUserPicks.add(userPickPlayer)
//                }
            }
            
//            let userPickPlayersArr:NSMutableArray = self.userPickPlayers.mutableCopy() as! NSMutableArray
//
//            for i in 0..<self.overUserPicks.count {
//                let overUserPickPlayer:NSDictionary = self.overUserPicks[i] as! NSDictionary
//
//                userPickPlayersArr[i] = overUserPickPlayer
//            }
            
//            self.userPickPlayers = userPickPlayersArr
            
            self.prizesArray = self.draft.value(forKey: "DraftPrizes") as! NSDictionary
        
            let prizesValue: Double = self.calculateSum(CalculatingValue: prizesArray)
            
            if let draftType: String = self.draft.value(forKey: "DraftType") as? String {
                self.draftTypeLbl.text = draftType
            }
            
            if let draftStart: String = self.draft.value(forKey: "DraftStart") as? String {
                self.draftStartLbl.text = draftStart
            }
            
            if let gameStart: String = self.draft.value(forKey: "GameStart") as? String {
                self.gamesLbl.text = gameStart
            }
            
            if let pickClock: String = self.draft.value(forKey: "PickClock") as? String {
                self.pickClockLbl.text = pickClock
            }
            
            self.prizesLbl.text = "(" + "€" + String(prizesValue) + ")"
            
            if let firstPrize: Double = prizesArray.value(forKey: "FirstPrize") as? Double {
                self.firstPrizeLbl.text = "(" + "€" + String(firstPrize) + ")"
            }
            
            if let IsDraftFilled: Bool = self.draft.value(forKey: "IsDraftFilled") as? Bool {
                if IsDraftFilled{
                    self.IsDraftFilled = IsDraftFilled
                    self.playersInfoView.isHidden = true
                    self.draftDetailView.isHidden = true
                    self.userPickPlayerTableView.isHidden = false
                    
                }else{
                    self.playersInfoView.isHidden = false
                    self.draftDetailView.isHidden = false
                    self.userPickPlayerTableView.isHidden = true
                }
            }
            
//            if self.delegate.intialTimer {
//                self.userPickPlayerTableView.isHidden = false
//                self.draftDetailView.isHidden = true
//            }else{
//                self.userPickPlayerTableView.isHidden = true
//                self.draftDetailView.isHidden = false
//            }
            
            let playArray: NSDictionary = self.draft.value(forKey: "Play") as! NSDictionary
            if let IsOneMinuteTimerPending: Bool = playArray.value(forKey: "IsOneMinuteTimerPending") as? Bool {
                self.IsOneMinuteTimerPending = IsOneMinuteTimerPending
            }
            
            if let IsOneMinuteTimerRunning: Bool = playArray.value(forKey: "IsOneMinuteTimerRunning") as? Bool {
                self.IsOneMinuteTimerRunning = IsOneMinuteTimerRunning
            }
            
            if let IsPlayerSelectionDone: Bool = playArray.value(forKey: "PlayerSelectionCompleted") as? Bool {
                if IsPlayerSelectionDone{
                let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                // Create View Controllers
                var upcomingDraftDetailsPage = UpcomingDraftDetailViewController()
                upcomingDraftDetailsPage = mainStoryBoard.instantiateViewController(withIdentifier: "UpcomingDraftDetail") as! UpcomingDraftDetailViewController
                upcomingDraftDetailsPage.playId = Int64(self.playId)
                upcomingDraftDetailsPage.draftId = self.draftId
                upcomingDraftDetailsPage.isLive = false
                upcomingDraftDetailsPage.isFromGame = true
                self.present(upcomingDraftDetailsPage, animated: false, completion: nil)
                }
            }
            
            self.playersTableView.reloadData()
            self.userPickPlayerTableView.reloadData()
            self.queueTableView.reloadData()
            self.setPickingUser()
            self.startInitialTimer()
        }
        
        
        @IBAction func switchStateChange(switchState: UISwitch)
        {
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to enable/disable this functionality", preferredStyle: UIAlertControllerStyle.alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.view.addSubview( self.progressHUD)
                
                if switchState.isOn
                {
                    self.autoPickOnOff(switchValue: true)
                }
                else
                {
                    self.autoPickOnOff(switchValue: false)
                }
            })
            
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: {
                (action : UIAlertAction!) -> Void in
                
                if self.isAutoPickEnable
                {
                    self.switchAutoPick.setOn(true, animated: true)
                    self.isAutoPickEnable = true
                }
                else
                {
                    self.switchAutoPick.setOn(false, animated: true)
                    self.isAutoPickEnable = false
                }
            })
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        func autoPickOnOff(switchValue: Bool) {
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            
            fetchPlayerDetailsService.fetchAutoPickData(playId: Int64(self.playId), userID: userId, boolValue: switchValue) { (result, message, status) in
                self.progressHUD.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                //let draftDetails = result as? FetchDraftPlayersService

                if message == "Success"
                {
                    print("Success")
                    
                    if self.isAutoPickEnable
                    {
                        self.switchAutoPick.setOn(false, animated: true)
                        self.isAutoPickEnable = false
                    }
                    else
                    {
                        self.switchAutoPick.setOn(true, animated: true)
                        self.isAutoPickEnable = true
                    }
                    
                }
                else
                {
                    if self.isAutoPickEnable
                    {
                        self.switchAutoPick.setOn(true, animated: true)
                        self.isAutoPickEnable = true
                    }
                    else
                    {
                        self.switchAutoPick.setOn(false, animated: true)
                        self.isAutoPickEnable = false
                    }
                    
                    let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
        }
        
        func startInitialTimer(){
            if self.IsDraftFilled {
                if let hub = self.selectionHub {
                    do {
                        let params = "Group" + String(self.playId)
                        try hub.invoke("JoinRoom",arguments:[params])
                    } catch {
                        print(error)
                    }
                }
                if self.IsOneMinuteTimerPending {
                    let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
                    let params = ["draftId": self.draftId,"playId":self.playId, "userId":userId] as [String : Any]
                    
                    if let hub = self.selectionHub {
                        do {
                            try hub.invoke("StartInitialTimer",arguments:[params])
                        } catch {
                            print(error)
                        }
                    }
                } else if (!self.IsOneMinuteTimerRunning && !self.IsOneMinuteTimerPending) {
                    for i in 0..<self.userPickPlayers.count {
                        
                        let userPickPlayer:NSDictionary = self.userPickPlayers[i] as! NSDictionary
                        
                        var playerPickValue: Bool = false
                        
                        if let playerPick: Bool = userPickPlayer.value(forKey: "Picked") as? Bool {
                            playerPickValue = playerPick
                        }
                        
//                        if playerPickValue{
//                            self.overUserPicks.add(userPickPlayer)
//                        }else{
//                            self.pendingUserPicks.add(userPickPlayer)
//                        }
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
        
        func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
            NSLog("Place holder")
            return descriptionText as AnyObject;
        }
        
        func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
            NSLog("Place holder itemForActivity")
            if(activityType == UIActivityType.mail.rawValue){
                return descriptionText as AnyObject
            } else if(activityType == UIActivityType.postToTwitter.rawValue){
                return descriptionText + " via @iOSgetstarted " + url as AnyObject
            } else {
                return descriptionText + " url" as AnyObject
            }
        }
        
        func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
            NSLog("Place holder subjectForActivity")
            if(activityType == UIActivityType.mail.rawValue){
                return "Hey check this out!!"
            } else if(activityType == UIActivityType.postToTwitter.rawValue){
                return descriptionText + " via @iOSgetstarted " + url
            } else {
                return descriptionText + " via @iOSgetstarted " + url
            }
        }
        
        // MARK: - IBAction's
        
        @IBAction func pickBtn(_ sender: Any) {
            
        }
        
        @IBAction func backBtn(_ sender: Any) {
            self.dismiss(animated: false, completion: nil)
        }
        
        @IBAction func shareBtn(_ sender: Any) {
            
            let myWebsite = NSURL(string: "https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
            
            let img: UIImage = UIImage(named:"Dhoni")!
            
            guard let url = myWebsite else {
                print("nothing found")
                return
            }
            
            let shareItems:Array = [img,url]
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        @IBAction func pickPlayerBtn(_ sender: UIButton) {
            print("Manual Picked")
            print(sender.tag)
            self.view.isUserInteractionEnabled = false
            
            var playerDetail = NSDictionary()
            
            if(self.filteredArray.count != 0){
                playerDetail = self.filteredArray[sender.tag] as! NSDictionary
            }else{
                playerDetail = self.draftPlayers[sender.tag] as! NSDictionary
            }
            
            let playerGameId = playerDetail.value(forKey: "PlayerGamesId") as! Int64
            
            let pickPlayerDict:NSDictionary = self.userPickPlayers[self.index] as! NSDictionary
            let pickPlayerMutableDict:NSMutableDictionary = pickPlayerDict.mutableCopy() as! NSMutableDictionary
            
//            print("Pick player dict ==>\(pickPlayerMutableDict)")
            let userId: Int32 = Int32(UserDefaults.standard.integer(forKey: "UserId"))
            pickPlayerMutableDict.setValue(playerGameId, forKey: "PlayerId")
            pickPlayerMutableDict["PlayId"] = Int64(self.playId)
            pickPlayerMutableDict["UserId"] = userId
            
            
//            let sportsId: Int = pickPlayerMutableDict.value(forKey: "SportsId") as! Int
//            let userDraftId: Int64 = pickPlayerMutableDict.value(forKey: "UserDraftId") as! Int64
//            let userPlayerPickId : Int64 = pickPlayerMutableDict.value(forKey: "UserPlayerPickId") as! Int64
//            let userName : String = pickPlayerMutableDict.value(forKey: "UserName") as! String
//            let pick : String = pickPlayerMutableDict.value(forKey: "Pick") as! String
//            
//            if let player : NSDictionary = pickPlayerMutableDict.value(forKey: "Player") as! NSDictionary {
//                
//            }
            
            print("Pick player dict ==>\(String(describing: pickPlayerMutableDict.value(forKey: "UserDraftId")))")
            
            print("Current Index =====> \(self.index)")
            
            print("Params =====> \(pickPlayerMutableDict)")
            
            if let hub = self.selectionHub {
                do {
                    print("Add Player to draft called")
                    try hub.invoke("addPlayerToDarft",arguments:[pickPlayerMutableDict,self.timerTick])
                } catch {
                    print(error)
                }
            }
            
            self.timerTick.removeAllObjects()
            self.filteredArray.removeAllObjects()
            self.searchActive = false
            self.searchTxtFld.text = ""
            self.searchTxtFld.resignFirstResponder()
        }
        
        @IBAction func playlistBtn(_ sender: Any) {
            self.isPlayerList = true
            self.playlistBottom.isHidden = false
            self.summaryBottom.isHidden = true
            self.queueBottom.isHidden = true
            self.noActiveDraftView.isHidden = true
            self.playlistBtn.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
            self.summaryBtn.setTitleColor(UIColor.white, for: .normal)
            self.queueBtn.setTitleColor(UIColor.white, for: .normal)
            self.playersScroller.scrollToPage(index: 0, animated: true, after: 0.0)
        }
        
        @IBAction func summaryBtn(_ sender: Any) {
            self.isPlayerList = false
            self.searchTxtFld.text = ""
            self.searchTxtFld.resignFirstResponder()
            
            self.playlistBottom.isHidden = true
            self.summaryBottom.isHidden = false
            self.queueBottom.isHidden = true
            self.noActiveDraftView.isHidden = true
            self.playlistBtn.setTitleColor(UIColor.white, for: .normal)
            self.summaryBtn.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
            self.queueBtn.setTitleColor(UIColor.white, for: .normal)
            self.playersScroller.scrollToPage(index: 1, animated: true, after: 0.0)
        }
        
        @IBAction func queueBtn(_ sender: Any) {
            self.isPlayerList = false
            self.searchTxtFld.text = ""
            self.searchTxtFld.resignFirstResponder()
            
            self.fetchDraftPlayers()
            if self.selectedQueuePlayers.count == 0 {
                self.noActiveDraftView.isHidden = false
            }else{
                self.noActiveDraftView.isHidden = true
            }
            self.playlistBottom.isHidden = true
            self.summaryBottom.isHidden = true
            self.queueBottom.isHidden = false
            self.playlistBtn.setTitleColor(UIColor.white, for: .normal)
            self.summaryBtn.setTitleColor(UIColor.white, for: .normal)
            self.queueBtn.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
            self.playersScroller.scrollToPage(index: 2, animated: true, after: 0.0)
        }
        
        @IBAction func playerDetailFavBtn(_ sender: Any) {
            if favouriteBtn.currentImage == #imageLiteral(resourceName: "Favorite") {
                draftPlayerBtn.setTitle("Remove player from Queue", for: .normal)
                draftPlayerBtn.backgroundColor = UIColor.gray
                favouriteBtn.setImage(#imageLiteral(resourceName: "Favorite_red"), for: .normal)
                self.addPLayerToQueue(playerId: self.playerGameId)
                
            }else if favouriteBtn.currentImage == #imageLiteral(resourceName: "Favorite_red") {
                draftPlayerBtn.setTitle("Add player to Queue", for: .normal)
                draftPlayerBtn.backgroundColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                favouriteBtn.setImage(#imageLiteral(resourceName: "Favorite"), for: .normal)
                self.removePLayerFromQueue(playerId: self.playerGameId)
                
            }
        }
        
        @IBAction func favrioteBtn(_ sender: UIButton) {
            let tag : Int = sender.tag
        
            if sender.currentImage == #imageLiteral(resourceName: "Favorite") {
                var draftPlayer = NSDictionary()
                if(self.filteredArray.count != 0){
                    draftPlayer = self.filteredArray[sender.tag] as! NSDictionary
                }else{
                    draftPlayer = self.draftPlayers[tag] as! NSDictionary
                }
                var playerIdValue: Int = 0
                
                if let playerId: Int = draftPlayer.value(forKey: "PlayerGamesId") as? Int {
                    playerIdValue = playerId
                }
                
                self.addPLayerToQueue(playerId: Int64(playerIdValue))
            }else if sender.currentImage == #imageLiteral(resourceName: "Favorite_red") {
                var draftPlayerId: Int = 0
                var queueDraftPlayerId: Int = 0
                
                var draftPlayer = NSDictionary()
                
                if self.isPlayerList{
                    if(self.filteredArray.count != 0){
                        draftPlayer = self.filteredArray[sender.tag] as! NSDictionary
                    }else{
                        draftPlayer = self.draftPlayers[tag] as! NSDictionary
                    }
                }else{
                    draftPlayer = self.selectedQueuePlayers[tag] as! NSDictionary
                }
                
                if let playerId: Int = draftPlayer.value(forKey: "PlayerGamesId") as? Int {
                    draftPlayerId = playerId
                }
                
                for i in 0..<self.selectedQueuePlayers.count{
                    let queueDraftPlayer:NSDictionary = self.selectedQueuePlayers[i] as! NSDictionary
                    
                    if let playerId: Int = queueDraftPlayer.value(forKey: "PlayerGamesId") as? Int {
                        if draftPlayerId == playerId{
                        queueDraftPlayerId = playerId
                        }
                    }
                    
                }
        
                self.removePLayerFromQueue(playerId: Int64(queueDraftPlayerId))
            }
            
            self.searchTxtFld.resignFirstResponder()
        }
        
        @IBAction func viewAllPricesBtn(_ sender: Any) {
            self.pricesView.isHidden = false
            self.pricesTableView.reloadData()
        }
        
        @IBAction func leaveDraftBtn(_ sender: Any) {
            
            if Reachability.isConnectedToNetwork() == true {
                
            //Show loading Indicator
            let progressHUD = ProgressHUD(text: "Loading")
            self.view.addSubview(progressHUD)
            self.view.isUserInteractionEnabled = false
            
            let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
            //Login Api
                leaveDraftService.leaveDraft(userId: userId, playId: Int64(playId)) {(result, message, status )in
                self.view.isUserInteractionEnabled = true
                
                let leftDraftDetails = result as? LeaveDraftService
          
                progressHUD.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                //
                if let leftDraftsDataDict = leftDraftDetails?.leftDraftData {
                    self.leftDraftsData = leftDraftsDataDict
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
                
                if let resultValue: String = self.leftDraftsData.value(forKey: "result") as? String {
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
                if let messageValue: String = self.leftDraftsData.value(forKey: "message") as? String{
                    message = messageValue
                }
                if result == "1"
                {
                    let balance: Double = self.delegate.totalAmount
                   
                    let remainingBalance:Int64 = Int64(balance + Double(self.entryFeesValue))
                    
                    self.delegate.totalAmount = Double(remainingBalance)
                    
                    UserDefaults.standard.set(remainingBalance, forKey: "Amount")
                    //                self.setValuesToFields()
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
                
            } else {
                let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
        @IBAction func searchPlayersBtn(_ sender: Any) {
            searchTxtFld.resignFirstResponder()
           
        }
        
        @IBAction func NBARulesBtn(_ sender: Any)
        {
        }
        
        @IBAction func closePriceListBtn(_ sender: Any) {
            self.pricesView.isHidden = true
        }
        
        // Mark:- Roaster Buttons
        
        @IBAction func gaurdBtn(_ sender: Any) {
            
            self.guardBtn.backgroundColor = UIColor.clear
         
            self.centerBtn.backgroundColor = UIColor.white
            self.centerBtn.alpha = 0.7
            
            self.forwardBtn.backgroundColor = UIColor.white
            self.forwardBtn.alpha = 0.7
            
             self.isForwardFiltered = false
            self.isCenterFiltered = false
            
            self.filteredArray.removeAllObjects()
            
            for i in 0..<self.draftPlayers.count {
                let draftPlayer:NSDictionary = self.draftPlayers[i] as! NSDictionary
                var roastersPositionValue:String = ""
                
                if let roastersPosition: String = draftPlayer.value(forKey: "RoastersPosition") as? String {
                    roastersPositionValue = roastersPosition
                }
                
                if roastersPositionValue == "Guard" || roastersPositionValue == "RB" || roastersPositionValue == "Attacker"{
                    self.filteredArray.add(draftPlayer)
                }
            }
            
            if self.isGuardsFiltered{
                self.isGuardsFiltered = false
                self.guardBtn.backgroundColor = UIColor.clear
                self.centerBtn.backgroundColor = UIColor.clear
                self.forwardBtn.backgroundColor = UIColor.clear
                self.filteredArray.removeAllObjects()

            }else{
                self.isGuardsFiltered = true
            }
            
            if self.selectedQbCount == self.qbValue && self.qbValue != 0{
                self.centerBtn.backgroundColor = UIColor.white
                self.centerBtn.alpha = 0.7
                self.centerBtn.isUserInteractionEnabled = false
            }
            
            if self.selectedWrteCount == self.wrteValue && self.wrteValue != 0{
                self.forwardBtn.backgroundColor = UIColor.white
                self.forwardBtn.alpha = 0.7
                self.forwardBtn.isUserInteractionEnabled = false
                
            }
            
            if self.selectedForwardCount == self.forwardValue && self.forwardValue != 0{
                self.forwardBtn.backgroundColor = UIColor.white
                self.forwardBtn.alpha = 0.7
                self.forwardBtn.isUserInteractionEnabled = false
            }
            
            
            if self.selectedCenterCount == self.centerValue && self.centerValue != 0{
                self.centerBtn.backgroundColor = UIColor.white
                self.centerBtn.alpha = 0.7
                self.centerBtn.isUserInteractionEnabled = false
                
            }
            
            if self.selectedDefenderCount == self.defenderValue && self.defenderValue != 0{
                self.centerBtn.backgroundColor = UIColor.white
                self.centerBtn.alpha = 0.7
                self.centerBtn.isUserInteractionEnabled = false
            }
            
            if self.selectedMidfielderCount == self.midfielderValue && self.midfielderValue != 0{
                self.forwardBtn.backgroundColor = UIColor.white
                self.forwardBtn.alpha = 0.7
                self.forwardBtn.isUserInteractionEnabled = false
                
            }
            
            self.playersTableView.reloadData()
        
        }
        @IBAction func centerBtn(_ sender: Any) {
           
            self.guardBtn.backgroundColor = UIColor.white
            self.guardBtn.alpha = 0.7
            
            self.centerBtn.backgroundColor = UIColor.clear
           
            self.forwardBtn.backgroundColor = UIColor.white
            self.forwardBtn.alpha = 0.7
            
             self.isForwardFiltered = false
            self.isGuardsFiltered = false
            
            self.filteredArray.removeAllObjects()
            
            for i in 0..<self.draftPlayers.count {
                let draftPlayer:NSDictionary = self.draftPlayers[i] as! NSDictionary
                var roastersPositionValue:String = ""
                
                if let roastersPosition: String = draftPlayer.value(forKey: "RoastersPosition") as? String {
                    roastersPositionValue = roastersPosition
                }
                
                if roastersPositionValue == "Center" || roastersPositionValue == "QB" || roastersPositionValue == "Defender"{
                    self.filteredArray.add(draftPlayer)
                }
            }
            
            if self.isCenterFiltered{
                self.isCenterFiltered = false
                
                self.guardBtn.backgroundColor = UIColor.clear
                self.centerBtn.backgroundColor = UIColor.clear
                self.forwardBtn.backgroundColor = UIColor.clear
                self.filteredArray.removeAllObjects()

            }else{
                self.isCenterFiltered = true
            }
            
            if self.selectedRbCount == self.rbValue && self.rbValue != 0{
                self.guardBtn.backgroundColor = UIColor.white
                self.guardBtn.alpha = 0.7
                self.guardBtn.isUserInteractionEnabled = false
                
            }
            
            if self.selectedWrteCount == self.wrteValue && self.wrteValue != 0{
                self.forwardBtn.backgroundColor = UIColor.white
                self.forwardBtn.alpha = 0.7
                self.forwardBtn.isUserInteractionEnabled = false
                
            }
            
            if self.selectedGaurdCount == self.guardValue && self.guardValue != 0 {
                self.guardBtn.backgroundColor = UIColor.white
                self.guardBtn.alpha = 0.7
                self.guardBtn.isUserInteractionEnabled = false
            }
            
            if self.selectedForwardCount == self.forwardValue && self.forwardValue != 0{
                self.forwardBtn.backgroundColor = UIColor.white
                self.forwardBtn.alpha = 0.7
                self.forwardBtn.isUserInteractionEnabled = false
            }
            
            if self.selectedAttackerCount == self.attackerValue && self.attackerValue != 0{
                self.guardBtn.backgroundColor = UIColor.white
                self.guardBtn.alpha = 0.7
                self.guardBtn.isUserInteractionEnabled = false
            }
            
            if self.selectedMidfielderCount == self.midfielderValue && self.midfielderValue != 0{
                self.forwardBtn.backgroundColor = UIColor.white
                self.forwardBtn.alpha = 0.7
                self.forwardBtn.isUserInteractionEnabled = false
                
            }
            
            self.playersTableView.reloadData()

        }
        @IBAction func forwardBtn(_ sender: Any) {
            
            self.guardBtn.backgroundColor = UIColor.white
            self.guardBtn.alpha = 0.7
            self.centerBtn.backgroundColor = UIColor.white
            self.centerBtn.alpha = 0.7
            self.forwardBtn.backgroundColor = UIColor.clear
            
            self.isGuardsFiltered = false
            self.isCenterFiltered = false
            
            self.filteredArray.removeAllObjects()
            
            for i in 0..<self.draftPlayers.count {
                let draftPlayer:NSDictionary = self.draftPlayers[i] as! NSDictionary
                var roastersPositionValue:String = ""
                
                if let roastersPosition: String = draftPlayer.value(forKey: "RoastersPosition") as? String {
                    roastersPositionValue = roastersPosition
                }
                
                if roastersPositionValue == "Forward" || roastersPositionValue == "WRTE" || roastersPositionValue == "Midfielder"{
                    self.filteredArray.add(draftPlayer)
                }
            }
            
            if self.isForwardFiltered{
                self.isForwardFiltered = false
                
                self.guardBtn.backgroundColor = UIColor.clear
                self.centerBtn.backgroundColor = UIColor.clear
                self.forwardBtn.backgroundColor = UIColor.clear
                self.filteredArray.removeAllObjects()

            }else{
                self.isForwardFiltered = true
            }
            
            if self.selectedQbCount == self.qbValue && self.qbValue != 0{
                self.centerBtn.backgroundColor = UIColor.white
                self.centerBtn.alpha = 0.7
                self.centerBtn.isUserInteractionEnabled = false
            }
            
            if self.selectedRbCount == self.rbValue && self.rbValue != 0{
                self.guardBtn.backgroundColor = UIColor.white
                self.guardBtn.alpha = 0.7
                self.guardBtn.isUserInteractionEnabled = false
                
            }
            
            if self.selectedGaurdCount == self.guardValue && self.guardValue != 0{
                self.guardBtn.backgroundColor = UIColor.white
                self.guardBtn.alpha = 0.7
                self.guardBtn.isUserInteractionEnabled = false
            }
            
            if self.selectedCenterCount == self.centerValue && self.centerValue != 0{
                self.centerBtn.backgroundColor = UIColor.white
                self.centerBtn.alpha = 0.7
                self.centerBtn.isUserInteractionEnabled = false
                
            }
            
            if self.selectedAttackerCount == self.attackerValue && self.attackerValue != 0{
                self.guardBtn.backgroundColor = UIColor.white
                self.guardBtn.alpha = 0.7
                self.guardBtn.isUserInteractionEnabled = false
            }
            
            if self.selectedDefenderCount == self.defenderValue && self.defenderValue != 0{
                self.centerBtn.backgroundColor = UIColor.white
                self.centerBtn.alpha = 0.7
                self.centerBtn.isUserInteractionEnabled = false
            }
            
            self.playersTableView.reloadData()
            
        }
        // MARK: - UITableview delegate
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int
        {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            //make sure you use the relevant array sizes
            if tableView == self.playersTableView {
//                if self.draftPlayers.count == 0{
//                    self.waitingView.isHidden = false
//                }else{
//                    self.waitingView.isHidden = true
//                }
                
                if (self.filteredArray.count != 0) {
                    return filteredArray.count
                }
                else {
                    return self.draftPlayers.count
                }
                //            return self.draftPlayers.count
                
            }else if tableView == self.queueTableView {
                
                if self.selectedQueuePlayers.count == 0 {
                    self.noActiveDraftView.isHidden = false
                }else{
                    self.noActiveDraftView.isHidden = true
                }
                return self.selectedQueuePlayers.count
            }else if tableView == self.userPickPlayerTableView {
                return self.pickedPLayerNames.count
            } else {
                return self.prizesArray.count
            }
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if tableView == self.playersTableView {
                return 50
            }else{
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if tableView == self.playersTableView || tableView == self.userPickPlayerTableView || tableView == self.queueTableView{
                return 90
            }else {
                return 50
            }
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
             if tableView == queueTableView{
                return true
             }else{
                return false
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            if tableView == self.playersTableView {
                let playerCell = self.playersTableView.dequeueReusableCell(withIdentifier:"PlayerCell",for:indexPath) as! PlayerCell
                playerCell.favrioteBtn.tag = indexPath.row
                playerCell.pickBtn.tag = indexPath.row
                playerCell.favrioteBtn.setImage(#imageLiteral(resourceName: "Favorite"), for: .normal)
                playerCell.injuryTag.isHidden = true
                
                if IsPicKEnabled{
                    playerCell.pickBtn.isHidden = false
                }else{
                    playerCell.pickBtn.isHidden = true
                }
                
                if(self.filteredArray.count != 0){
                    let filteredData:NSDictionary = self.filteredArray[indexPath.row] as! NSDictionary
                    
                    var queuedPlayerIdValue: String = ""
                    
                    var playerIdValue: String = ""
                    
                    for i in 0..<self.selectedQueuePlayers.count {
                        let queuePlayerData:NSDictionary = self.selectedQueuePlayers[i] as! NSDictionary
                        
                        if let queuedPlayerId: Int = queuePlayerData.value(forKey: "PlayerGamesId") as? Int {
                            queuedPlayerIdValue = String(queuedPlayerId)
                        }
                        
                        if let playerId: Int = filteredData.value(forKey: "PlayerGamesId") as? Int {
                            playerIdValue = String(playerId)
//                            print("Player Game Id \(playerIdValue)")
                        }
                        
                        if playerIdValue == queuedPlayerIdValue {
                            playerCell.favrioteBtn.setImage(#imageLiteral(resourceName: "Favorite_red"), for: .normal)
                        }
                    }
                    
                    var playerNameValue: String = ""
                    var playerTypeValue: String = ""
                    var playerRatingValue: String = ""
                    var playerImageValue: String = ""
                    var roastersPositionValue:String = ""
                    var teamNameValue:String = ""
                    var opponentsNameValue:String = ""
                    
                    if let playerName: String = filteredData.value(forKey: "Name") as? String {
                        playerNameValue = playerName
                    }
                    
                    if let playerType: String = filteredData.value(forKey: "Position") as? String {
                        playerTypeValue = playerType
                    }
                    
                    if let playerRating: Double = filteredData.value(forKey: "FantasyPointsFanDuel") as? Double {
                        playerRatingValue = String(playerRating)
                    }
                    
                    if let playerImage: String = filteredData.value(forKey: "PhotoUrl") as? String {
                        playerImageValue = playerImage
                    }
                    
                    if let roastersPosition: String = filteredData.value(forKey: "RoastersPosition") as? String {
                        roastersPositionValue = roastersPosition
                    }
                    
                    if let teamName: String = filteredData.value(forKey: "Team") as? String {
                        teamNameValue = teamName
                    }
                    
                    if let opponentsName: String = filteredData.value(forKey: "Opponent") as? String {
                        opponentsNameValue = opponentsName
                    }
                    
                    playerCell.configureCell(playerName: playerNameValue, playerType: playerTypeValue, rating: playerRatingValue, playerImg: playerImageValue, roastersPosition:roastersPositionValue, teamName:teamNameValue, opponentsName:opponentsNameValue)
                    
                } else {
                    
                    let draftPlayer:NSDictionary = self.draftPlayers[indexPath.row] as! NSDictionary
                    
                    var queuedPlayerIdValue: String = ""
                    
                    var playerIdValue: String = ""
                    
                    for i in 0..<self.selectedQueuePlayers.count {
                        let queuePlayerData:NSDictionary = self.selectedQueuePlayers[i] as! NSDictionary
                        
                        if let queuedPlayerId: Int = queuePlayerData.value(forKey: "PlayerGamesId") as? Int {
                            queuedPlayerIdValue = String(queuedPlayerId)
                        }
                        
                        if let playerId: Int = draftPlayer.value(forKey: "PlayerGamesId") as? Int {
                            playerIdValue = String(playerId)
                        }
                        
//                        print("Player Game Id \(playerIdValue) == Queued Player Game Id \(queuedPlayerIdValue)and index value is \(indexPath.row)")
                        
                        if playerIdValue.lowercased() == queuedPlayerIdValue.lowercased() {
//                            print("Player fav selected")
                            playerCell.favrioteBtn.setImage(#imageLiteral(resourceName: "Favorite_red"), for: .normal)
                        }
                    }
                    
                    var playerNameValue: String = ""
                    var playerTypeValue: String = ""
                    var playerRatingValue: String = ""
                    var playerImageValue: String = ""
                    var roastersPositionValue:String = ""
                    var teamNameValue:String = ""
                    var opponentsNameValue:String = ""
                    var playerInjuryStatusValue:String = ""
                    
                    if let playerName: String = draftPlayer.value(forKey: "Name") as? String {
                        playerNameValue = playerName
                    }
                    
                    if let playerType: String = draftPlayer.value(forKey: "Position") as? String {
                        playerTypeValue = playerType
                    }
                    
                    if let playerRating: Double = draftPlayer.value(forKey: "FantasyPointsFanDuel") as? Double {
                        playerRatingValue = String(playerRating)
                    }
                    
                    if let playerImage: String = draftPlayer.value(forKey: "PhotoUrl") as? String {
                        playerImageValue = playerImage
                    }
                    
                    if let roastersPosition: String = draftPlayer.value(forKey: "RoastersPosition") as? String {
                        roastersPositionValue = roastersPosition
                    }
                    
                    if let teamName: String = draftPlayer.value(forKey: "Team") as? String {
                        teamNameValue = teamName
                    }
                    
                    if let opponentsName: String = draftPlayer.value(forKey: "Opponent") as? String {
                        opponentsNameValue = opponentsName
                    }
                    
                    if let playerInjuryStatus: String = draftPlayer.value(forKey: "InjuryStatus") as? String {
                        playerInjuryStatusValue = playerInjuryStatus
                    }
                    
                    if playerInjuryStatusValue == "Out"{
                        playerCell.injuryTag.isHidden = false
                        playerCell.injuryTag.backgroundColor = UIColor(red: 233.0/255.0, green: 43.0/255.0, blue: 60.0/255.0, alpha: 1.0)
                    }else if playerInjuryStatusValue == "Questionable"{
                        playerCell.injuryTag.isHidden = false
                        playerCell.injuryTag.backgroundColor = UIColor(red: 225.0/255.0, green: 187.0/255.0, blue: 13.0/255.0, alpha: 1.0)
                   }
            
                    playerCell.configureCell(playerName: playerNameValue, playerType: playerTypeValue, rating: playerRatingValue, playerImg: playerImageValue, roastersPosition:roastersPositionValue, teamName:teamNameValue, opponentsName:opponentsNameValue)
                    
                }
                
                playerCell.selectionStyle = UITableViewCellSelectionStyle.none
                
                return playerCell as PlayerCell
                
            }else if tableView == self.queueTableView {
                let queueCell = self.queueTableView.dequeueReusableCell(withIdentifier:"QueueCell",for:indexPath) as! QueueCell
                queueCell.favrioteBtn.tag = indexPath.row
                
                let draftPlayer:NSDictionary = self.selectedQueuePlayers[indexPath.row] as! NSDictionary
                
                var playerNameValue: String = ""
                var playerTypeValue: String = ""
                var playerRatingValue: String = ""
                var playerImageValue: String = ""
                var roastersPositionValue:String = ""
                var teamNameValue:String = ""
                var opponentsNameValue:String = ""
                
                if let playerName: String = draftPlayer.value(forKey: "Name") as? String {
                    playerNameValue = playerName
                }
                
                if let playerType: String = draftPlayer.value(forKey: "Position") as? String {
                    playerTypeValue = playerType
                }
                
                if let playerRating: Double = draftPlayer.value(forKey: "FantasyPointsFanDuel") as? Double {
                    playerRatingValue = String(playerRating)
                }
                
                if let playerImage: String = draftPlayer.value(forKey: "PhotoUrl") as? String {
                    playerImageValue = playerImage
                }
                
                if let roastersPosition: String = draftPlayer.value(forKey: "RoastersPosition") as? String {
                    roastersPositionValue = roastersPosition
                }
                
                if let teamName: String = draftPlayer.value(forKey: "Team") as? String {
                    teamNameValue = teamName
                }
                
                if let opponentsName: String = draftPlayer.value(forKey: "Opponent") as? String {
                    opponentsNameValue = opponentsName
                }
                
                queueCell.configureCell(playerName: playerNameValue, playerType: playerTypeValue, rating: playerRatingValue, playerImg: playerImageValue,roastersPosition: roastersPositionValue, teamName:teamNameValue, opponentsName:opponentsNameValue)
                
                queueCell.selectionStyle = UITableViewCellSelectionStyle.none
                
                return queueCell as QueueCell
            }else if tableView == self.userPickPlayerTableView {
                let userPickPlayerCell = self.userPickPlayerTableView.dequeueReusableCell(withIdentifier:"UserPickPlayerCell",for:indexPath) as! UserPickPlayerCell
//                print("Index to set =====> \(self.index)")
                
                userPickPlayerCell.pickedName.text = ""
                
                var playerNameValue:String = ""
                var playerIdValue:Int64 = 0
                var playerPositionValue:String = ""
                var playerImageValue:String = ""
                
                if let playername:String = self.pickedPLayerNames[indexPath.row] as? String{
                    playerNameValue = playername
                }
                
                if let playerId:Int64 = self.pickedPlayerIds[indexPath.row] as? Int64{
                    playerIdValue = playerId
                }
                
                if let playerPosition:String = self.pickedPLayerPositions[indexPath.row] as? String{
                    playerPositionValue = playerPosition
                }
                
                if let playerImage:String = self.pickedPLayerImageUrls[indexPath.row] as? String{
                    playerImageValue = playerImage
                }
                
                userPickPlayerCell.configureCell(playerName: playerNameValue, playerId: playerIdValue, playerPickPosition:playerPositionValue, playerImg: playerImageValue)
                
                
                
                
                
                return userPickPlayerCell as UserPickPlayerCell
            }else{
                let pricesCell = self.pricesTableView.dequeueReusableCell(withIdentifier:"PricesCell",for:indexPath) as! PricesCell
                
                var pricesName: String = ""
                var pricesValue: String = ""
                
                if let priceName: String = self.pricesKeys[indexPath.row] as? String {
                    pricesName = priceName
                }
                
                if let priceValue: Double = prizesArray.value(forKey: pricesName) as? Double {
                    pricesValue = "€" + String(priceValue)
                }else{
                    pricesValue = "€0.0"
                }
                
                pricesCell.configureCell(pricesName: pricesName, pricesValue: pricesValue)
                
                pricesCell.selectionStyle = UITableViewCellSelectionStyle.none
                return pricesCell as PricesCell
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            
            
            if tableView == self.playersTableView {
                
                var draftPlayer = NSDictionary()
                
                if(self.filteredArray.count != 0){
                    draftPlayer = self.filteredArray[indexPath.row] as! NSDictionary
                }else{
                    draftPlayer = self.draftPlayers[indexPath.row] as! NSDictionary
                }
                
                var sportsIdValue: Int = 0
                var playerIdValue: Int64 = 0
                
                if let sportsId: Int = draftPlayer.value(forKey: "SportsId") as? Int {
                    sportsIdValue = sportsId
                }
                
                if let playerGamesIdValue = draftPlayer.value(forKey: "PlayerGamesId") as? Int64 {
                    self.playerGameId = playerGamesIdValue
                }
                
                if let playerId: Int64 = draftPlayer.value(forKey: "PlayerID") as? Int64 {
                    playerIdValue = playerId
                }
                
                if let playerRating: Double = draftPlayer.value(forKey: "FantasyPointsFanDuel") as? Double {
                    self.projectionLbl.text = String(playerRating)
                }
                
                if Reachability.isConnectedToNetwork() == true {
                    self.fetchPlayerDetails(playerId:playerIdValue ,sportsId: sportsIdValue)
                   
                } else {
                    let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }else if tableView == queueTableView{
                    
                   let draftPlayer:NSDictionary = self.selectedQueuePlayers[indexPath.row] as! NSDictionary
                
                    
                    var sportsIdValue: Int = 0
                    var playerIdValue: Int64 = 0
                    
                    if let sportsId: Int = draftPlayer.value(forKey: "SportsId") as? Int {
                        sportsIdValue = sportsId
                    }
                    
                    if let playerGamesIdValue = draftPlayer.value(forKey: "PlayerGamesId") as? Int64 {
                        self.playerGameId = playerGamesIdValue
                    }
                    
                    if let playerId: Int64 = draftPlayer.value(forKey: "PlayerID") as? Int64 {
                        playerIdValue = playerId
                    }
                    
                    if let playerRating: Double = draftPlayer.value(forKey: "FantasyPointsFanDuel") as? Double {
                        self.projectionLbl.text = String(playerRating)
                    }
                    
                    if Reachability.isConnectedToNetwork() == true {
                        self.fetchPlayerDetails(playerId:playerIdValue ,sportsId: sportsIdValue)
                        
                    } else {
                        let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                            (action : UIAlertAction!) -> Void in
                        })
                        
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
            }
    
            self.searchTxtFld.resignFirstResponder()
        }
        
        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
            return .none
        }
        
        func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
        }
        
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         
            let movedObject = self.selectedQueuePlayers[sourceIndexPath.row]

            self.selectedQueuePlayers.removeObject(at: sourceIndexPath.row)
            self.selectedQueuePlayers.insert(movedObject, at: destinationIndexPath.row)
           
            let playerDetail : NSDictionary = self.selectedQueuePlayers[destinationIndexPath.row] as! NSDictionary
            
            let playerPosition :NSArray = self.selectedQueuePlayers.value(forKey: "PlayerGamesId") as! NSArray
            
            
            self.moveQueuePlayer(playerRowPosition: playerPosition)
            // To check for correctness enable: self.tableView.reloadData()
        }
        
        // MARK: - UITextField Delegate Methods
        
        func textFieldDidBeginEditing(textField: UITextField) {
            self.searchActive = true;
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            //        txtFldSearchBar
//            searchTxtFld.rchesignFirstResponder()
//            searchActive = false;
        }
        
        @objc func searchRecordsAsPerText(_ textfield:UITextField) {
            filteredArray.removeAllObjects()
            for dictData in draftPlayers {

                if let receivedDict = dictData as? NSDictionary{
                    if let nameStr = receivedDict["Name"]{



                        if (nameStr as AnyObject).lowercased.range(of: textfield.text!) != nil {
                             if !(filteredArray.contains(dictData)){
                            filteredArray.add(dictData)
                            }
                        }
                    }
                    if let teamStr = receivedDict["Team"]{

                        if (teamStr as AnyObject).lowercased.range(of: textfield.text!) != nil {
                            if !(filteredArray.contains(dictData)){
                            filteredArray.add(dictData)
                            }
                        }
                    }

                    if let teamStr = receivedDict["Opponent"]{

                        if (teamStr as AnyObject).lowercased.range(of: textfield.text!) != nil {
                            if !(filteredArray.contains(dictData)){
                                filteredArray.add(dictData)
                            }
                        }
                    }

                }
            }

            if(filteredArray.count == 0){
                self.searchActive = false;
            } else {
                self.searchActive = true;
            }
            
            self.playersTableView.reloadData()
        }
        
        
        
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
//            filteredArray.removeAllObjects()
//            for dictData in draftPlayers {
//
//                if let receivedDict = dictData as? NSDictionary{
//                    if let nameStr = receivedDict["Name"]{
//
//
//
//                        if (nameStr as AnyObject).lowercased.range(of: string) != nil {
//                             if !(filteredArray.contains(dictData)){
//                            filteredArray.add(dictData)
//                            }
//                        }
//                    }
//                    if let teamStr = receivedDict["Team"]{
//
//                        if (teamStr as AnyObject).lowercased.range(of: string) != nil {
//                            if !(filteredArray.contains(dictData)){
//                                filteredArray.add(dictData)
//                            }
//                        }
//                    }
//
//                    if let teamStr = receivedDict["Opponent"]{
//
//                        if (teamStr as AnyObject).lowercased.range(of:string) != nil {
//                            if !(filteredArray.contains(dictData)){
//                                filteredArray.add(dictData)
//                            }
//                        }
//                    }
//
//                }
//            }
//
//
//            self.playersTableView.reloadData()
            return true
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            self.searchTxtFld.text = ""
            self.searchTxtFld.resignFirstResponder()
            
            return true
        }
        
        func setplayerDetailsfieldValue(sportsId: Int){
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Favorite"), for: .normal)
            self.injuryStatus.isHidden = true
            self.draftPlayerBtn.setTitle("Add player to Queue", for: .normal)
            self.draftPlayerBtn.backgroundColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0)

            var latestNewsDate: String = ""
            
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
                
                    var playerInjuryStatusValue:String = ""
                    
                    if let playerInjuryStatus: String = detail.value(forKey: "InjuryStatus") as? String {
                        playerInjuryStatusValue = playerInjuryStatus
                    }
                    
                    if playerInjuryStatusValue == "Out"{
                        self.injuryStatus.isHidden = false
                        self.injuryStatus.text = "Out"
                        self.injuryStatus.backgroundColor = UIColor(red: 233.0/255.0, green: 43.0/255.0, blue: 60.0/255.0, alpha: 1.0)
                    }else if playerInjuryStatusValue == "Questionable"{
                        self.injuryStatus.isHidden = false
                         self.injuryStatus.text = "Quest"
                        self.injuryStatus.backgroundColor = UIColor(red: 225.0/255.0, green: 187.0/255.0, blue: 13.0/255.0, alpha: 1.0)
                    }
                    
                if let note = detail.value(forKey: "InjuryNotes") as? String {
                    self.noteTxtView.text = note
                }else{
                    self.noteTxtView.text = "No news found!"
                    }
                
                var queuedPlayerIdValue: Int64 = 0
           
                
                
                for i in 0..<self.selectedQueuePlayers.count {
                    let queuePlayerData:NSDictionary = self.selectedQueuePlayers[i] as! NSDictionary
                    
                    if let queuedPlayerId: Int64 = queuePlayerData.value(forKey: "PlayerGamesId") as? Int64 {
                        queuedPlayerIdValue = queuedPlayerId
                    }
                
                    if self.playerGameId == queuedPlayerIdValue {
                        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Favorite_red"), for: .normal)
                        self.draftPlayerBtn.setTitle("Remove player from Queue", for: .normal)
                        self.draftPlayerBtn.backgroundColor = UIColor.gray
                    }
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
                            
                        }else if i == 3 {
                            if let pointsInt = playerGame.value(forKey: "Score") as? Double {
                                self.points4Lbl.text = String(pointsInt)
                            }
                            
                            if let assistsInt = playerGame.value(forKey: "Assists") as? Double {
                                self.assists4Lbl.text = String(assistsInt)
                            }
                            
                            if let blockedShotsInt = playerGame.value(forKey: "Fouled") as? Double {
                                self.blockedShots4Lbl.text = String(blockedShotsInt)
                            }
                            
                            if let stealsInt = playerGame.value(forKey: "TacklesWon") as? Double {
                                self.steals4Lbl.text = String(stealsInt)
                            }
                            
                            if let fantasyPointsInt = playerGame.value(forKey: "FantasyPoints") as? Double {
                                self.fantasyPoints4Lbl.text = String(fantasyPointsInt)
                            }
                            
                            if let reboundsInt = playerGame.value(forKey: "Goals") as? Double {
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
            self.playerDetailMainView.isHidden = true
            self.playerDetailBg.isHidden = true
            self.view.sendSubview(toBack: self.playerDetailBg)
            self.view.sendSubview(toBack: self.playerDetailMainView)
        }
    }

    private typealias ScrollView = PlayDetailsViewController
    extension ScrollView
    {
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
            // Test the offset and calculate the current page after scrolling ends
            let pageWidth:CGFloat = self.playersScroller.frame.width
            let currentPage:CGFloat = floor((self.playersScroller.contentOffset.x-pageWidth/2)/pageWidth)+1
            
            // Change the text accordingly
            if Int(currentPage) == 0{
                self.isPlayerList = true
                self.playlistBottom.isHidden = false
                self.summaryBottom.isHidden = true
                self.queueBottom.isHidden = true
                self.noActiveDraftView.isHidden = true
                self.playlistBtn.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
                self.summaryBtn.setTitleColor(UIColor.white, for: .normal)
                self.queueBtn.setTitleColor(UIColor.white, for: .normal)
            }else if Int(currentPage) == 1{
                self.isPlayerList = false
                self.playlistBottom.isHidden = true
                self.summaryBottom.isHidden = false
                self.queueBottom.isHidden = true
                self.noActiveDraftView.isHidden = true
                self.playlistBtn.setTitleColor(UIColor.white, for: .normal)
                self.summaryBtn.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
                self.queueBtn.setTitleColor(UIColor.white, for: .normal)
            }else if Int(currentPage) == 2{
                self.isPlayerList = false
                self.fetchDraftPlayers()
                self.playlistBottom.isHidden = true
                self.summaryBottom.isHidden = true
                self.queueBottom.isHidden = false
                self.playlistBtn.setTitleColor(UIColor.white, for: .normal)
                self.summaryBtn.setTitleColor(UIColor.white, for: .normal)
                self.queueBtn.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
                if self.selectedQueuePlayers.count == 0 {
                    self.noActiveDraftView.isHidden = false
                }else{
                    self.noActiveDraftView.isHidden = true
                }
            }
        }
    }

    // MARK: - UIScrollView Methods

    extension UIScrollView {
        func scrollToPage(index: UInt8, animated: Bool, after delay: TimeInterval) {
            let offset: CGPoint = CGPoint(x: CGFloat(index) * frame.size.width, y: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.setContentOffset(offset, animated: animated)
            })
        }
    }
