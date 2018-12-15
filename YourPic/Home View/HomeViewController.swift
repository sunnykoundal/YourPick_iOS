
import Foundation
import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // MARK: - Service Objects
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    let fetchLobbiesService = FetchLobbiesService()
    let fetchUserDraftsService = FetchUserDraftsService()
    
    let fetchUpcomingDraftsService = FetchUpcomingDraftsService()
    let fetchUpcomingDraftDetailService = FetchUpcomingDraftDetailServices()
    let fetchDraftResultService = FetchDraftResultService()
    let fetchLiveMatchesService = FetchLiveMatchesService()
    
    
    // MARK: - ViewController Ojects
    var draftDetailPage = DraftDetailViewController()
    var playDetailPage = PlayDetailsViewController()
    var profileDetailPage = ProfileDetailViewController()
    var resultPage = ResultsViewController()
    var depositMoneyViewController = DepositMoneyViewController()
    var upcomingDraftDetailsPage = UpcomingDraftDetailViewController()
    
    // MARK: - Used Objects
    @IBOutlet var logoView: UIView!
    @IBOutlet var btnLobby: UIButton!
    @IBOutlet var btnDrafts: UIButton!
    @IBOutlet var btnUpcoming: UIButton!
    @IBOutlet var btnLive: UIButton!
    @IBOutlet var btnResults: UIButton!
    @IBOutlet var lobbyIndicator: UIImageView!
    @IBOutlet var draftsIndicator: UIImageView!
    @IBOutlet var upcomingIndicator: UIImageView!
    @IBOutlet var liveIndicator: UIImageView!
    @IBOutlet var resultsIndicator: UIImageView!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet weak var amountLbl: UILabel!
    
    @IBOutlet weak var noActiveDraftView: UIView!
    @IBOutlet var filterView: UIView!
    @IBOutlet var lobbyBtnView: UIView!
    @IBOutlet var btnLobbyFilter: UIButton!
    @IBOutlet var basketballBtnView: UIView!
    @IBOutlet var btnBasketballFilter: UIButton!
    @IBOutlet var americanFootballBtnView: UIView!
    @IBOutlet var btnAmericanFootballFilter: UIButton!
    @IBOutlet var footballBtnView: UIView!
    @IBOutlet var btnFootballFilter: UIButton!
    @IBOutlet var lobbiesTableView: UITableView!
    @IBOutlet weak var upcomingTableView: UITableView!
    @IBOutlet weak var liveTableView: UITableView!
    @IBOutlet weak var draftTableView: UITableView!
    
    // MARK: - Arrays Objects
    var HeaderList = NSMutableArray()
    var lobbiesList = NSMutableArray()
    var draftsList = NSMutableArray()
    var upcomingList = NSMutableArray()
    var draftResultsList = NSMutableArray()
    
    // MARK: - Dictionary Objects
    
    var lobbyDictionary = NSDictionary()
    var userDraftsDictionary = NSDictionary()
   
    var userUpcomingDraftDetailsDictionary = NSDictionary()
    var userDraftResultsDictionary = NSDictionary()
    var liveMatchesDictionary = NSDictionary()
    var userDraftResultsDetailDictionary = NSDictionary()
    var liveMatchesDetailDictionary = NSDictionary()
    // MARK: - Bool Objects
    var isUserDraft:Bool = false
    var isFromDraftPlayDetail:Bool = false
    var isLiveData:Bool = false
    var isResultData:Bool = false
    var isDraftRefreshing:Bool = false
    var isLobbyRefreshing:Bool = false
    
    var sportsId:String = "0"
    var timer = Timer()
    var lobbyRefreshTimer = Timer()
    var draftRefreshTimer = Timer()
    // MARK: - UIView Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLobby.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
        btnDrafts.setTitleColor(.white, for: .normal)
        btnUpcoming.setTitleColor(.white, for: .normal)
        btnResults.setTitleColor(.white, for: .normal)
        btnLive.setTitleColor(.white, for: .normal)
        
       
        
        if Reachability.isConnectedToNetwork() == true {
            self.filterBtnRounded()
            
        } else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    @objc func refreshLiveMatches(action: UIAlertAction) {
        self.fetchLiveMatches()
    }
    
    @objc func refreshLobby(action: UIAlertAction) {
        self.isLobbyRefreshing = true
        self.fetchLobbiesList(sportId: sportsId)
    }
    
    @objc func refreshDraft(action: UIAlertAction) {
        self.isDraftRefreshing = true
        self.fetchUserDraftsList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isDraftRefreshing = false
        self.isLobbyRefreshing = false
        lobbyRefreshTimer.invalidate()
        draftRefreshTimer.invalidate()
        timer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(self.refreshLiveMatches), userInfo: nil, repeats: true)
        
        if self.isUserDraft{
            draftRefreshTimer.invalidate()
            draftRefreshTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.refreshDraft), userInfo: nil, repeats: true)
            
            if Reachability.isConnectedToNetwork() == true {
                if !isResultData || !isLiveData{
                self.fetchUserDraftsList()
                }
               
            } else {
                let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }else{
            lobbyRefreshTimer.invalidate()
            lobbyRefreshTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.refreshLobby), userInfo: nil, repeats: true)
            
            if Reachability.isConnectedToNetwork() == true {
                if !isResultData || !isLiveData{
                self.fetchLobbiesList(sportId: sportsId)
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
        
        if isFromDraftPlayDetail {
            if Reachability.isConnectedToNetwork() == true {
                if !isResultData || !isLiveData{
                self.fetchUpcomingDraftsList()
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
        
        let balance: Double = self.delegate.totalAmount
        
        self.amountLbl.text = "€" + String(balance)
        self.amountLbl.layer.cornerRadius = 2
        self.amountLbl.layer.borderWidth = 1
        self.amountLbl.clipsToBounds = true
        
        if let playerImg: String = UserDefaults.standard.string(forKey: "UserImage")
        {
        URLSession.shared.dataTask(with: NSURL(string: playerImg)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "nil")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.btnProfile?.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            })
        }).resume()
    }
        
    }
    
    
    // MARK: - Rounded Buttons
    
    func filterBtnRounded() {
        
        btnProfile?.layer.cornerRadius = btnProfile.frame.size.width/2
        btnProfile?.layer.borderWidth = 1
        btnProfile?.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        btnProfile?.clipsToBounds = true
        
        lobbyBtnView?.layer.cornerRadius = lobbyBtnView.frame.size.width/2
        lobbyBtnView?.layer.borderWidth = 1
        lobbyBtnView?.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        lobbyBtnView.layer.shadowOffset = CGSize(width: -1, height: 1)
        lobbyBtnView.layer.shadowRadius = 1
        lobbyBtnView.layer.shadowOpacity = 0.5
        
        basketballBtnView?.layer.cornerRadius = basketballBtnView.frame.size.width/2
        basketballBtnView?.layer.borderWidth = 1
        basketballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 1.0).cgColor
        basketballBtnView.layer.shadowOffset = CGSize(width: -1, height: 1)
        basketballBtnView.layer.shadowRadius = 1
        basketballBtnView.layer.shadowOpacity = 0.5
        
        americanFootballBtnView?.layer.cornerRadius = americanFootballBtnView.frame.size.width/2
        americanFootballBtnView?.layer.borderWidth = 1
        americanFootballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 1.0).cgColor
        americanFootballBtnView.layer.shadowOffset = CGSize(width: -1, height: 1)
        americanFootballBtnView.layer.shadowRadius = 1
        americanFootballBtnView.layer.shadowOpacity = 0.5
        
        footballBtnView?.layer.cornerRadius = footballBtnView.frame.size.width/2
        footballBtnView?.layer.borderWidth = 1
        footballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 1.0).cgColor
        footballBtnView.layer.shadowOffset = CGSize(width: -1, height: 1)
        footballBtnView.layer.shadowRadius = 1
        footballBtnView.layer.shadowOpacity = 0.5
        
        logoView.layer.shadowOffset = CGSize(width: 1, height: 4)
        logoView.layer.shadowRadius = 5
        logoView.layer.shadowOpacity = 1.0
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Profile Button
    
    @IBAction func profileBtn(_ sender: Any) {
    
        lobbyRefreshTimer.invalidate()
        draftRefreshTimer.invalidate()
        
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
        
        self.profileDetailPage = mainStoryBoard.instantiateViewController(withIdentifier: "ProfileDetail") as! ProfileDetailViewController
        
        self.present(self.profileDetailPage, animated: true, completion: nil)
    }
    
    // MARK: - Lobby Button
    
    @IBAction func allgamesDraftBtn(_ sender: Any) {
        
        draftRefreshTimer.invalidate()
        
        lobbyRefreshTimer.invalidate()
        lobbyRefreshTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.refreshLobby), userInfo: nil, repeats: true)
        
        self.lobbiesList.removeAllObjects()
        self.lobbiesTableView.reloadData()
        
        self.isUserDraft = false
        self.isFromDraftPlayDetail = false
        self.isLiveData = false
        self.isResultData = false
        
        lobbyIndicator.isHidden = false
        draftsIndicator.isHidden = true
        upcomingIndicator.isHidden = true
        resultsIndicator.isHidden = true
        liveIndicator.isHidden = true
        self.noActiveDraftView.isHidden = true
        
        btnLobby.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
        btnDrafts.setTitleColor(.white, for: .normal)
        btnUpcoming.setTitleColor(.white, for: .normal)
        btnResults.setTitleColor(.white, for: .normal)
        btnLive.setTitleColor(.white, for: .normal)
        
        self.upcomingTableView.isHidden = true
        self.lobbiesTableView.isHidden = false
        self.liveTableView.isHidden = true
        self.draftTableView.isHidden = true
        
        self.lobbiesTableView.frame = CGRect(x:self.lobbiesTableView.frame.origin.x, y:self.filterView.frame.size.height, width:self.lobbiesTableView.frame.size.width, height:self.view.frame.size.height - (self.filterView.frame.size.height))
        
        lobbyBtnView?.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        btnLobbyFilter.setImage(#imageLiteral(resourceName: "Lobby_Active"), for: .normal)
        
        basketballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        btnBasketballFilter.setImage(#imageLiteral(resourceName: "Basketball"), for: .normal)
        
        americanFootballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        btnAmericanFootballFilter.setImage(#imageLiteral(resourceName: "American_Football"), for: .normal)
        
        footballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
        btnFootballFilter.setImage(#imageLiteral(resourceName: "Football"), for: .normal)
        if Reachability.isConnectedToNetwork() == true {
            self.fetchLobbiesList(sportId: sportsId)
            
        } else {
            self.noActiveDraftView.isHidden = false
            self.view.bringSubview(toFront: self.noActiveDraftView)
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: - Draft Button
    
    @IBAction func draftBtn(_ sender: Any) {
        self.lobbyRefreshTimer.invalidate()
        
        draftRefreshTimer.invalidate()
        draftRefreshTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.refreshDraft), userInfo: nil, repeats: true)
        
        self.lobbiesList.removeAllObjects()
        self.lobbiesTableView.reloadData()
        
        self.isUserDraft = true
        self.isFromDraftPlayDetail = false
        self.isLiveData = false
        self.isResultData = false
        
        lobbyIndicator.isHidden = true
        draftsIndicator.isHidden = false
        upcomingIndicator.isHidden = true
        resultsIndicator.isHidden = true
        liveIndicator.isHidden = true
        self.noActiveDraftView.isHidden = true
        
        btnDrafts.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
        btnLobby.setTitleColor(.white, for: .normal)
        btnUpcoming.setTitleColor(.white, for: .normal)
        btnResults.setTitleColor(.white, for: .normal)
        btnLive.setTitleColor(.white, for: .normal)
        
        self.upcomingTableView.isHidden = true
        self.lobbiesTableView.isHidden = true
        self.liveTableView.isHidden = true
        self.draftTableView.isHidden = false
        
        self.lobbiesTableView.frame = CGRect(x:self.lobbiesTableView.frame.origin.x, y:self.logoView.frame.size.height + 20, width:self.lobbiesTableView.frame.size.width, height:self.view.frame.size.height - (self.logoView.frame.size.height + 20))
        
        if Reachability.isConnectedToNetwork() == true {
            self.fetchUserDraftsList()
       
        } else {
            self.noActiveDraftView.isHidden = false
            self.view.bringSubview(toFront: self.noActiveDraftView)
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: - Upcoming Button
    
    @IBAction func upcomingBtn(_ sender: Any) {
        
        lobbyRefreshTimer.invalidate()
        draftRefreshTimer.invalidate()
        
        self.upcomingList.removeAllObjects()
        self.upcomingTableView.reloadData()
        
        self.fetchUpcomingDraftsList()
  
    }
    
    @IBAction func resultsBtn(_ sender: Any) {
        lobbyRefreshTimer.invalidate()
        draftRefreshTimer.invalidate()
        
        self.isUserDraft = false
        self.isFromDraftPlayDetail = false
        self.isLiveData = false
        self.isResultData = true
        
        lobbyIndicator.isHidden = true
        draftsIndicator.isHidden = true
        upcomingIndicator.isHidden = true
        resultsIndicator.isHidden = false
        liveIndicator.isHidden = true
        self.noActiveDraftView.isHidden = true
        
        btnResults.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
        btnLobby.setTitleColor(.white, for: .normal)
        btnDrafts.setTitleColor(.white, for: .normal)
        btnUpcoming.setTitleColor(.white, for: .normal)
        btnLive.setTitleColor(.white, for: .normal)
        
        self.upcomingTableView.isHidden = true
        self.lobbiesTableView.isHidden = true
        self.liveTableView.isHidden = false
        self.draftTableView.isHidden = true
        
        if Reachability.isConnectedToNetwork() == true {
            self.fetchDraftResult()
          
        } else {
            self.noActiveDraftView.isHidden = false
            self.view.bringSubview(toFront: self.noActiveDraftView)
            self.view.bringSubview(toFront: self.noActiveDraftView)
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func liveBtn(_ sender: Any) {
        lobbyRefreshTimer.invalidate()
        draftRefreshTimer.invalidate()
        
        self.isUserDraft = false
        self.isFromDraftPlayDetail = false
        self.isLiveData = true
        self.isResultData = false
        
        lobbyIndicator.isHidden = true
        draftsIndicator.isHidden = true
        upcomingIndicator.isHidden = true
        resultsIndicator.isHidden = true
        liveIndicator.isHidden = false
        self.noActiveDraftView.isHidden = true
        
        btnLive.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
        btnLobby.setTitleColor(.white, for: .normal)
        btnDrafts.setTitleColor(.white, for: .normal)
        btnUpcoming.setTitleColor(.white, for: .normal)
        btnResults.setTitleColor(.white, for: .normal)
        
        self.upcomingTableView.isHidden = true
        self.lobbiesTableView.isHidden = true
        self.liveTableView.isHidden = false
        self.draftTableView.isHidden = true
        
        if Reachability.isConnectedToNetwork() == true {
            self.fetchLiveMatches()
           
        } else {
            self.noActiveDraftView.isHidden = false
            self.view.bringSubview(toFront: self.noActiveDraftView)
            self.view.bringSubview(toFront: self.noActiveDraftView)
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    // MARK: - Lobby Button Filters
    
    @IBAction func lobbyBtn(_ sender: Any) {
        self.sportsId = "0"
        
        if Reachability.isConnectedToNetwork() == true {
            self.fetchLobbiesList(sportId: sportsId)
           
        } else {
            self.noActiveDraftView.isHidden = false
            self.view.bringSubview(toFront: self.noActiveDraftView)
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        self.lobbiesTableView.reloadData()
        if self.lobbiesList.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.lobbiesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    @IBAction func basketBallBtn(_ sender: Any) {
        self.sportsId = "2"
        
        if Reachability.isConnectedToNetwork() == true {
            self.fetchLobbiesList(sportId: sportsId)
           
        } else {
            self.noActiveDraftView.isHidden = false
            self.view.bringSubview(toFront: self.noActiveDraftView)
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        self.lobbiesTableView.reloadData()
        if self.lobbiesList.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.lobbiesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    @IBAction func americanFootballBtn(_ sender: Any) {
        self.sportsId = "1"
        
        
        if Reachability.isConnectedToNetwork() == true {
            self.fetchLobbiesList(sportId: sportsId)
           
        } else {
            self.noActiveDraftView.isHidden = false
            self.view.bringSubview(toFront: self.noActiveDraftView)
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        self.lobbiesTableView.reloadData()
        if self.lobbiesList.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.lobbiesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    @IBAction func footballBtn(_ sender: Any) {
        self.sportsId = "3"
        if Reachability.isConnectedToNetwork() == true {
            self.fetchLobbiesList(sportId: sportsId)
          
        } else {
            self.noActiveDraftView.isHidden = false
            self.view.bringSubview(toFront: self.noActiveDraftView)
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        self.lobbiesTableView.reloadData()
        if self.lobbiesList.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.lobbiesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    // MARK: - Fetch Lobbies
    func setFilterIcon() {
        if sportsId == "3"{
            lobbyBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnLobbyFilter.setImage(#imageLiteral(resourceName: "Lobby"), for: .normal)
            
            basketballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnBasketballFilter.setImage(#imageLiteral(resourceName: "Basketball"), for: .normal)
            
            americanFootballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnAmericanFootballFilter.setImage(#imageLiteral(resourceName: "American_Football"), for: .normal)
            
            footballBtnView?.layer.borderColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0).cgColor
            btnFootballFilter.setImage(#imageLiteral(resourceName: "Football_Active"), for: .normal)
        }else if sportsId == "2"{
            lobbyBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnLobbyFilter.setImage(#imageLiteral(resourceName: "Lobby"), for: .normal)
            
            basketballBtnView?.layer.borderColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0).cgColor
            btnBasketballFilter.setImage(#imageLiteral(resourceName: "Baskeball_Active"), for: .normal)
            
            americanFootballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnAmericanFootballFilter.setImage(#imageLiteral(resourceName: "American_Football"), for: .normal)
            
            footballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnFootballFilter.setImage(#imageLiteral(resourceName: "Football"), for: .normal)
        }else if sportsId == "1"{
            lobbyBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnLobbyFilter.setImage(#imageLiteral(resourceName: "Lobby"), for: .normal)
            
            basketballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnBasketballFilter.setImage(#imageLiteral(resourceName: "Basketball"), for: .normal)
            
            americanFootballBtnView?.layer.borderColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0).cgColor
            btnAmericanFootballFilter.setImage(#imageLiteral(resourceName: "American_Football_Active"), for: .normal)
            
            footballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnFootballFilter.setImage(#imageLiteral(resourceName: "Football"), for: .normal)
        }else if sportsId == "0"{
            lobbyBtnView?.layer.borderColor = UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
            btnLobbyFilter.setImage(#imageLiteral(resourceName: "Lobby_Active"), for: .normal)
            
            basketballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnBasketballFilter.setImage(#imageLiteral(resourceName: "Basketball"), for: .normal)
            
            americanFootballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnAmericanFootballFilter.setImage(#imageLiteral(resourceName: "American_Football"), for: .normal)
            
            footballBtnView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
            btnFootballFilter.setImage(#imageLiteral(resourceName: "Football"), for: .normal)
        }
    }
    func fetchLobbiesList(sportId: String) {
        
        self.setFilterIcon()
        //        let storyboard = UIStoryboard(name: "Home", bundle:nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "home") as! HomeViewController
        //        self.present(controller, animated: true, completion: nil
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        
        if !self.isLobbyRefreshing{
            self.view.addSubview(progressHUD)
            self.view.isUserInteractionEnabled = false
        }
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
     if Reachability.isConnectedToNetwork() == true {
        fetchLobbiesService.fetchLobbies(sportId: sportId, userId: userId ) {(result, message, status )in
            if !self.isLobbyRefreshing{
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            }
            let lobbiesDetails = result as? FetchLobbiesService
            
            if let lobbyDict = lobbiesDetails?.lobbiesData {
                self.lobbyDictionary = lobbyDict
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
            
            if let resultValue: String = self.lobbyDictionary.value(forKey: "result") as? String {
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
            if let messageValue: String = self.lobbyDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                self.lobbiesList.removeAllObjects()
                
                let lobbiesListArray: NSArray = (self.lobbyDictionary.value(forKey: "data") as! NSArray)
                
//                let lobbylistArr = lobbiesListArray.mutableCopy() as! NSMutableArray
//                let draftsListArr = lobbiesListArray.mutableCopy() as! NSMutableArray
//
//                let lobbylist = lobbylistArr.value(forKey: "draftList") as! NSArray
//                 let draftsList = draftsListArr.value(forKey: "draftList") as! NSArray
//
                self.lobbiesList =  lobbiesListArray.mutableCopy() as! NSMutableArray
                self.draftsList = lobbiesListArray.mutableCopy() as! NSMutableArray
                
                if sportId != "0"
                {
                    self.HeaderList.removeAllObjects()
                    for dict in self.draftsList
                    {
                        let draftListDict = dict as? NSDictionary
                        let headerText = draftListDict?.value(forKey:"HeaderText") as? String
                        self.HeaderList.add(headerText ?? "")
                    }
                }
                
                self.lobbiesTableView.reloadData()
                if self.lobbiesList.count > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.lobbiesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
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
    
    // MARK: - Fetch User Drafts
    
    func fetchUserDraftsList() {
        self.lobbiesList.removeAllObjects()
        self.lobbiesTableView.reloadData()
        
        self.isUserDraft = true
        self.isFromDraftPlayDetail = false
        self.isLiveData = false
        self.isResultData = false
        
        lobbyIndicator.isHidden = true
        draftsIndicator.isHidden = false
        upcomingIndicator.isHidden = true
        resultsIndicator.isHidden = true
        liveIndicator.isHidden = true
        self.noActiveDraftView.isHidden = true
        
        btnDrafts.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
        btnLobby.setTitleColor(.white, for: .normal)
        btnUpcoming.setTitleColor(.white, for: .normal)
        btnResults.setTitleColor(.white, for: .normal)
        btnLive.setTitleColor(.white, for: .normal)
        
        self.upcomingTableView.isHidden = true
        self.lobbiesTableView.isHidden = true
        self.liveTableView.isHidden = true
        self.draftTableView.isHidden = false
        
        self.draftTableView.frame = CGRect(x:self.draftTableView.frame.origin.x, y:self.logoView.frame.size.height + 20, width:self.draftTableView.frame.size.width, height:self.view.frame.size.height - (self.logoView.frame.size.height + 20))
        
        //Show loading Indicator
         let progressHUD = ProgressHUD(text: "Loading")
        
        if !self.isDraftRefreshing{
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        }
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        fetchUserDraftsService.fetchUserDrafts(userId: userId ) {(result, message, status )in
             if !self.isDraftRefreshing{
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            }
            
            let userDraftsDetails = result as? FetchUserDraftsService
            
            if let userDraftsDict = userDraftsDetails?.userDraftsData {
                self.userDraftsDictionary = userDraftsDict
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
            
            if let resultValue: String = self.userDraftsDictionary.value(forKey: "result") as? String {
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
            if let messageValue: String = self.userDraftsDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                let lobbiesListArray: NSArray = (self.userDraftsDictionary.value(forKey: "data") as! NSArray)
                self.lobbiesList = lobbiesListArray.mutableCopy() as! NSMutableArray
                
                self.draftTableView.reloadData()
                
                if self.lobbiesList.count > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.draftTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
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
    
    // MARK: - Fetch Upcoming Drafts
    
    func fetchUpcomingDraftsList() {
        self.isUserDraft = false
        self.isFromDraftPlayDetail = false
        self.isLiveData = false
        self.isResultData = false
        
        lobbyIndicator.isHidden = true
        draftsIndicator.isHidden = true
        upcomingIndicator.isHidden = false
        resultsIndicator.isHidden = true
        liveIndicator.isHidden = true
        
        btnUpcoming.setTitleColor(UIColor(red: 133.0/255.0, green: 204.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
        btnLobby.setTitleColor(.white, for: .normal)
        btnDrafts.setTitleColor(.white, for: .normal)
        btnResults.setTitleColor(.white, for: .normal)
        btnLive.setTitleColor(.white, for: .normal)
        
        self.upcomingTableView.isHidden = false
        self.lobbiesTableView.isHidden = true
        self.draftTableView.isHidden = true
        self.liveTableView.isHidden = true
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        if Reachability.isConnectedToNetwork() == true {
            fetchUpcomingDraftsService.fetchUpcomingDraftsData(userId: userId ) {(result, message, status )in
                self.view.isUserInteractionEnabled = true
                progressHUD.removeFromSuperview()
                
                let upcomingDraftsDetails = result as? FetchUpcomingDraftsService
                
                if let userDraftsDict = upcomingDraftsDetails?.draftData {
                    self.userDraftsDictionary = userDraftsDict
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
                
                if let resultValue: String = self.userDraftsDictionary.value(forKey: "result") as? String {
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
                if let messageValue: String = self.userDraftsDictionary.value(forKey: "message") as? String{
                    message = messageValue
                }
                
                if result == "1"
                {
                    self.upcomingList.removeAllObjects()
                    let upcomingListArray: NSArray = (self.userDraftsDictionary.value(forKey: "data") as! NSArray)
                    self.upcomingList = upcomingListArray.mutableCopy() as! NSMutableArray
                    self.upcomingTableView.isHidden = false
                    self.view.bringSubview(toFront: self.upcomingTableView)
                    self.upcomingTableView.reloadData()
                }
                else if result == "0"
                {
                    let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                        self.view.isUserInteractionEnabled = true
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
            
        } else {
            self.noActiveDraftView.isHidden = false
            self.upcomingTableView.isHidden = true
            self.view.bringSubview(toFront: self.noActiveDraftView)
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
           
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Fetch  Draft Results
    
    func fetchDraftResult() {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        fetchDraftResultService.fetchDraftResultsData(userId: userId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            
            let draftResults = result as? FetchDraftResultService
            
            if let userDraftsDict = draftResults?.draftResultsData {
                self.userDraftResultsDictionary = userDraftsDict
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
            
            if let resultValue: String = self.userDraftResultsDictionary.value(forKey: "result") as? String {
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
            if let messageValue: String = self.userDraftResultsDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                if let draftResultsList: NSArray = self.userDraftResultsDictionary.value(forKey: "data") as! NSArray{
                    self.draftResultsList = draftResultsList.mutableCopy() as! NSMutableArray
                    self.liveTableView.reloadData()
                }else{
                    let alertController = UIAlertController(title: "Warning", message: "Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action : UIAlertAction!) -> Void in
                        
                    })
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
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
    
    // MARK: - Fetch  Live Matches
    
    func fetchLiveMatches() {
        
        //Show loading Indicator
        
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        fetchLiveMatchesService.fetchLiveMatchesData(userId: userId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            
            
            let liveMatches = result as? FetchLiveMatchesService
            
            if let userDraftsDict = liveMatches?.liveMatchesData {
                self.liveMatchesDictionary = userDraftsDict
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
            
            if let resultValue: String = self.liveMatchesDictionary.value(forKey: "result") as? String {
                result = resultValue
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
            if let messageValue: String = self.liveMatchesDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                let liveMatchList: NSArray = self.liveMatchesDictionary.value(forKey: "data") as! NSArray
                self.draftResultsList = liveMatchList.mutableCopy() as! NSMutableArray
                if self.isLiveData{
                self.liveTableView.reloadData()
                }
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
    
    // MARK: - TableView Data Sources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.lobbiesTableView {
            if sportsId != "0" {
                if HeaderList.count > 0
                {
                    return HeaderList.count
                }
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.upcomingTableView {
            if self.upcomingList.count == 0 {
                self.noActiveDraftView.isHidden = false
                self.view.bringSubview(toFront: self.noActiveDraftView)
            }else{
                self.noActiveDraftView.isHidden = true
                self.view.sendSubview(toBack: self.noActiveDraftView)
            }
            return self.upcomingList.count
        }else if(tableView == self.liveTableView) {
            if self.draftResultsList.count == 0 {
                self.noActiveDraftView.isHidden = false
                self.view.bringSubview(toFront: self.noActiveDraftView)
            }else{
                self.noActiveDraftView.isHidden = true
                self.view.sendSubview(toBack: self.noActiveDraftView)
            }
            return self.draftResultsList.count
        }else if(tableView == self.draftTableView) {
            if self.lobbiesList.count == 0 {
                self.noActiveDraftView.isHidden = false
                self.view.bringSubview(toFront: self.noActiveDraftView)
            }else{
                self.noActiveDraftView.isHidden = true
                self.view.sendSubview(toBack: self.noActiveDraftView)
            }
            return self.lobbiesList.count
        }
        else{
            if self.lobbiesList.count == 0 {
                self.noActiveDraftView.isHidden = false
                self.view.bringSubview(toFront: self.noActiveDraftView)
            }else{
                self.noActiveDraftView.isHidden = true
                self.view.sendSubview(toBack: self.noActiveDraftView)
            }
            
//            if sportsId != "0"
//            {
//                return 1
//            }
            return self.lobbiesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == self.lobbiesTableView {
            if sportsId != "0" {
                print(self.HeaderList)
                
                if self.HeaderList.count > 0{
                    let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
                    
                    let label = UILabel()
                    label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
                    
                    label.text = self.HeaderList.object(at:section) as? String
                    label.font = UIFont.systemFont(ofSize: 18)
                    label.textColor = UIColor.black
                    
                    headerView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
                    headerView.addSubview(label)
                    return headerView
                }
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.lobbiesTableView {
            if sportsId != "0" {
                return 50
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == self.upcomingTableView {
            let upcomingCell = upcomingTableView.dequeueReusableCell(withIdentifier:"Upcoming",for:indexPath) as! UpcomingCell
            let upcomingData:NSDictionary = self.upcomingList[indexPath.row] as! NSDictionary
            
            var sportsNameValue:String = ""
            var draftTypeValue:String = ""
            var opponentValue:String = ""
            var gameStartValue:String = ""
            var draftNameValue:String = ""
            
            if let sportsName: String = upcomingData.value(forKey: "SportsName") as? String {
                sportsNameValue = sportsName
            }
            
            if let draftName: String = upcomingData.value(forKey: "DraftName") as? String {
                draftNameValue = draftName
            }
            
            if let draftType: String = upcomingData.value(forKey: "DraftType") as? String {
                draftTypeValue = draftType
            }
            
            if let opponent: String = upcomingData.value(forKey: "Opponents") as? String {
                opponentValue = opponent
            }
            
            if let gameStart: String = upcomingData.value(forKey: "GameStart") as? String {
                gameStartValue = gameStart
            }
            
            upcomingCell.configureCell(type: sportsNameValue, draftType:draftTypeValue, opponent:draftNameValue, gameStart:gameStartValue)
            
            return upcomingCell as UpcomingCell
        }else if(tableView == self.liveTableView){
            
            let liveCell = self.liveTableView.dequeueReusableCell(withIdentifier:"Live",for:indexPath) as! LiveCell
            let data:NSDictionary = self.draftResultsList[indexPath.row] as! NSDictionary
            
            var draftCountValue:String = "0"
            var sportsIdValue:String = ""
            var winningsValue:String = ""
            var createdDateValue:String = ""
            
            if let draftCount: Int64 = data.value(forKey: "DraftsCount") as? Int64 {
                draftCountValue = String(draftCount)
            }
            
            if let sportsId: Int64 = data.value(forKey: "SportsId") as? Int64 {
                sportsIdValue = String(sportsId)
            }
            
            if let winnings: Double = data.value(forKey: "Winnings") as? Double {
                winningsValue = String(winnings)
            }
            
            if let createdDate: String = data.value(forKey: "CreatedDate") as? String {
                createdDateValue = createdDate
            }
            
            liveCell.configureCell(createdDate: createdDateValue, draftCount: draftCountValue, sportsId: sportsIdValue, winnings: winningsValue)
            
            return liveCell as LiveCell
        }else if tableView == draftTableView{
            
                let draftCell = draftTableView.dequeueReusableCell(withIdentifier:"Drafts",for:indexPath) as! DraftCell
                let lobbyData:NSDictionary = self.lobbiesList[indexPath.row] as! NSDictionary
                var prizesArray = NSDictionary()
                
                if let prizesDict: NSDictionary = lobbyData.value(forKey: "DraftPrizes") as? NSDictionary {
                    prizesArray = prizesDict
                }
                
                let prizesValue: Double = self.calculateSum(CalculatingValue: prizesArray)
                var enteredValue:String = ""
                var entrantsValue:String = ""
                var entryFeeValue:String = ""
                var draftNameValue:String = ""
                var draftTypeValue:String = ""
                var sportsNameValue:String = ""
                
                if let entered: Int = lobbyData.value(forKey: "Entered") as? Int {
                    enteredValue = String(entered)
                }else{
                    enteredValue = "0"
                }
                
                if let entrants: Int = lobbyData.value(forKey: "Entrants") as? Int {
                    entrantsValue = String(entrants)
                }
                
                if let entryFee: Int = lobbyData.value(forKey: "EntryFee") as? Int {
                    entryFeeValue = String(entryFee)
                }
                
                if let draftName: String = lobbyData.value(forKey: "DraftName") as? String {
                    draftNameValue = draftName
                }
                
                if let draftType: String = lobbyData.value(forKey: "DraftType") as? String {
                    draftTypeValue = draftType
                }
                
                if let sportsName: String = lobbyData.value(forKey: "SportsName") as? String {
                    sportsNameValue = sportsName
                }
                
                if self.isUserDraft{
                    draftCell.waitingOpponentLbl.isHidden = false
                }else{
                    draftCell.waitingOpponentLbl.isHidden = true
                }
                
                if enteredValue == entrantsValue{
                    draftCell.waitingOpponentLbl.isHidden = true
                }
                
                draftCell.configureCell(entered: enteredValue , entrants: entrantsValue , entry: entryFeeValue , prizes: String(prizesValue), draftName: draftNameValue , type: sportsNameValue, draftType : draftTypeValue)
                
                return draftCell as DraftCell
            
        }
        else {
            let lobbiesCell = lobbiesTableView.dequeueReusableCell(withIdentifier:"Lobbies",for:indexPath) as! LobbiesCell
           // let lobbyData:NSDictionary = self.lobbiesList.object(at:indexPath.row) as! NSDictionary
            let lobbyData:NSDictionary = self.lobbiesList[indexPath.row] as! NSDictionary
            var prizesArray = NSDictionary()
            
            if let prizesDict: NSArray = lobbyData.value(forKey: "draftList") as? NSArray {
                // prizesArray = prizesDict
                
                if let draftDataDict : NSDictionary = prizesDict.object(at:indexPath.row) as? NSDictionary {
                    prizesArray = draftDataDict
                    
                    let prizesValue: Double = self.calculateSum(CalculatingValue: prizesArray)
                    var enteredValue:String = ""
                    var entrantsValue:String = ""
                    var entryFeeValue:String = ""
                    var draftNameValue:String = ""
                    var draftTypeValue:String = ""
                    var sportsNameValue:String = ""
                    
                    if let entered: Int = draftDataDict.value(forKey: "Entered") as? Int {
                        enteredValue = String(entered)
                    }else{
                        enteredValue = "0"
                    }
                    
                    if let entrants: Int = draftDataDict.value(forKey: "Entrants") as? Int {
                        entrantsValue = String(entrants)
                    }
                    
                    if let entryFee: Int = draftDataDict.value(forKey: "EntryFee") as? Int {
                        entryFeeValue = String(entryFee)
                    }
                    
                    if let draftName: String = draftDataDict.value(forKey: "DraftName") as? String {
                        draftNameValue = draftName
                    }
                    
                    if let draftType: String = draftDataDict.value(forKey: "DraftType") as? String {
                        draftTypeValue = draftType
                    }
                    
                    if let sportsName : String = draftDataDict.value(forKey: "SportsName")as? String {
                        sportsNameValue = sportsName as String
                    }
                    
                    if self.isUserDraft{
                        lobbiesCell.waitingOpponentLbl.isHidden = false
                    }else{
                        lobbiesCell.waitingOpponentLbl.isHidden = true
                    }
                    
                    if enteredValue == entrantsValue{
                        lobbiesCell.waitingOpponentLbl.isHidden = true
                    }
                    
                    lobbiesCell.configureCell(entered: enteredValue , entrants: entrantsValue , entry: entryFeeValue , prizes: String(prizesValue), draftName: draftNameValue , type: sportsNameValue, draftType : draftTypeValue)
                    
                    return lobbiesCell as LobbiesCell
                }
            }
            
            return UITableViewCell()
        }
    }
    
    // MARK: - TableView Deligate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == self.upcomingTableView {
            return 85
        }else if tableView == self.liveTableView {
            return 70
        }
        else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if Reachability.isConnectedToNetwork() == true {
            
            
            if tableView == self.upcomingTableView {
                
                let upcomingData:NSDictionary = self.upcomingList[indexPath.row] as! NSDictionary
                
                var draftIdValue : Int = 0
                var playIdValue : Int64 = 0
                var sportsIdValue:Int64 = 0
                
                if let draftId: Int = upcomingData.value(forKey: "DraftId") as? Int {
                    draftIdValue = draftId
                }
                
                if let playId: Int64 = upcomingData.value(forKey: "PlayId") as? Int64 {
                    playIdValue = playId
                }
                
                if let sportsId: Int64 = upcomingData.value(forKey: "SportsId") as? Int64 {
                    sportsIdValue = sportsId
                }
                
                let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                // Create View Controllers
                
                self.upcomingDraftDetailsPage = mainStoryBoard.instantiateViewController(withIdentifier: "UpcomingDraftDetail") as! UpcomingDraftDetailViewController
                self.upcomingDraftDetailsPage.playId = playIdValue
                self.upcomingDraftDetailsPage.draftId = draftIdValue
                self.upcomingDraftDetailsPage.sportsId = sportsIdValue
                self.upcomingDraftDetailsPage.isLive = isLiveData
                self.present(self.upcomingDraftDetailsPage, animated: false, completion: nil)
                
            }else if(tableView == self.liveTableView) {
                let data:NSDictionary = self.draftResultsList[indexPath.row] as! NSDictionary
                
                var draftCountValue:Int64 = 0
                var sportsIdValue:Int64 = 0
                var winningsValue:Double = 0
                var createdDateValue:String = ""
                
                if let draftCount: Int64 = data.value(forKey: "DraftsCount") as? Int64 {
                    draftCountValue = draftCount
                }
                
                if let sportsId: Int64 = data.value(forKey: "SportsId") as? Int64 {
                    sportsIdValue = sportsId
                }
                
                if let winnings: Double = data.value(forKey: "Winnings") as? Double {
                    winningsValue = winnings
                }
                
                if let createdDate: String = data.value(forKey: "CreatedDate") as? String {
                    createdDateValue = createdDate
                }
                
                let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                // Create View Controllers
                
                self.resultPage = mainStoryBoard.instantiateViewController(withIdentifier: "Results") as! ResultsViewController
                self.resultPage.createdDate = createdDateValue
                self.resultPage.draftCount = draftCountValue
                self.resultPage.winnings = winningsValue
                self.resultPage.sportsId = sportsIdValue
                self.resultPage.isResultData = self.isResultData
                self.resultPage.isLiveData = self.isLiveData
                
                self.present(self.resultPage, animated: false, completion: nil)
               
            }
            else {
                let lobbyData:NSDictionary = self.lobbiesList[indexPath.row] as! NSDictionary
                let draftIdValue : Int
                let playIdValue : Int64
                var draftNameValue : String = ""
                var entryFeeValue:Int = 0
                
                if let draftId: Int = lobbyData.value(forKey: "DraftId") as? Int {
                    draftIdValue = draftId
                }else{
                    draftIdValue = 0
                }
                
                if let playId: Int64 = lobbyData.value(forKey: "PlayId") as? Int64 {
                    playIdValue = playId
                }else{
                    playIdValue = 0
                }
                
                if let draftName: String = lobbyData.value(forKey: "DraftName") as? String {
                    draftNameValue = draftName
                }
                
                if let entryFee: Int = lobbyData.value(forKey: "EntryFee") as? Int {
                    entryFeeValue = entryFee
                }
                
                if isUserDraft{
                    let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                    // Create View Controllers
                    self.playDetailPage = mainStoryBoard.instantiateViewController(withIdentifier: "PlayDetails") as! PlayDetailsViewController
                    self.playDetailPage.draftId = draftIdValue
                    self.playDetailPage.playId = playIdValue
                    self.playDetailPage.entryFeesValue = entryFeeValue
                    
                    self.present(self.playDetailPage, animated: false, completion: nil)
                } else {
                    let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                    // Create View Controllers
                    self.draftDetailPage = mainStoryBoard.instantiateViewController(withIdentifier: "DraftDetails") as! DraftDetailViewController
                    self.draftDetailPage.draftsData = lobbyData
                    self.draftDetailPage.draftId = draftIdValue
                    self.draftDetailPage.draftNameValue = draftNameValue
                    self.present(self.draftDetailPage, animated: false, completion: nil)
                }
            }
        }else {
            let alertController = UIAlertController(title: "Warning", message:"Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Calculated the Sum
    
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
}

