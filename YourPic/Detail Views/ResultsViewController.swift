
import Foundation
import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // MARK: - Service Objects
    
    let delegate = UIApplication.shared.delegate as! AppDelegate

    let fetchResultsService = FetchResultsService()
    let fetchLiveService = FetchLiveService()
    
    
    // MARK: - ViewController Ojects
     var upcomingDraftDetailsPage = UpcomingDraftDetailViewController()
    
    @IBOutlet weak var gameTypeImage: UIImageView!
    @IBOutlet weak var winningLbl: UILabel!
    @IBOutlet weak var draftCountLbl: UILabel!
    @IBOutlet weak var gameNameDateLbl: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var noActiveDraftView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Used Objects
    var createdDate:String = ""
    var sportsId: Int64 = 0
    var isLiveData:Bool = false
    var isResultData:Bool = false
    var draftCount:Int64=0
    var winnings:Double=0.0
    
    // MARK: - Arrays Objects
   
    var resultsList = NSMutableArray()
    
    // MARK: - Dictionary Objects

    var resultsDictionary = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        self.setGameDetailView()
      
            if Reachability.isConnectedToNetwork() == true {
                if isLiveData{
                    self.titleLbl.text = "Live"
                    self.fetchLive()
                }else if isResultData{
                    self.titleLbl.text = "Result"
                    self.fetchResults()
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
    
    func setGameDetailView() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        
        dateFormatter.dateFormat = "yyyy/MM/dd";
        let dateValue = dateFormatter.date(from: createdDate)
        
        dateFormatter.dateFormat = "MMM d";
        let dateStr = dateFormatter.string(from: dateValue!)
        
        draftCountLbl?.text = String(draftCount)
        winningLbl?.text = String(winnings)
        
        if sportsId == 3 {
           
            winningLbl?.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            draftCountLbl?.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            gameNameDateLbl?.text = String(dateStr) + ", " + "Soccer Draft"
        }else if sportsId == 1 {
            winningLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            draftCountLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            gameNameDateLbl?.text = String(dateStr) + ", " + "NFL Draft"
        }else if sportsId == 2{
            winningLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            draftCountLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            gameNameDateLbl?.text = String(dateStr) + ", " + "NBA Draft"
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - Profile Button
    
    func fetchResults() {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        fetchResultsService.fetchResultsData(userId: userId,createdDate: self.createdDate,SportsId:self.sportsId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            
            let draftResults = result as? FetchResultsService
            
            if let userDraftsDict = draftResults?.resultsData {
                self.resultsDictionary = userDraftsDict
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
            
            if let resultValue: String = self.resultsDictionary.value(forKey: "result") as? String {
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
            if let messageValue: String = self.resultsDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                if let draftResultsList: NSArray = self.resultsDictionary.value(forKey: "data") as? NSArray{
                    self.resultsList = draftResultsList.mutableCopy() as! NSMutableArray
                    self.resultsTableView.reloadData()
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
    
    func fetchLive() {
        
        //Show loading Indicator
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        //Login Api
        fetchLiveService.fetchLiveData(userId: userId,createdDate: self.createdDate,SportsId:self.sportsId) {(result, message, status )in
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            
            let draftResults = result as? FetchLiveService
            
            if let userDraftsDict = draftResults?.liveData {
                self.resultsDictionary = userDraftsDict
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
            
            if let resultValue: String = self.resultsDictionary.value(forKey: "result") as? String {
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
            if let messageValue: String = self.resultsDictionary.value(forKey: "message") as? String{
                message = messageValue
            }
            
            if result == "1"
            {
                if let draftResultsList: NSArray = self.resultsDictionary.value(forKey: "data") as? NSArray{
                    self.resultsList = draftResultsList.mutableCopy() as! NSMutableArray
                    self.resultsTableView.reloadData()
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
    
    // MARK: - TableView Data Sources
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
            if self.resultsList.count == 0 {
                self.noActiveDraftView.isHidden = false
                self.view.bringSubview(toFront: self.noActiveDraftView)
            }else{
                self.noActiveDraftView.isHidden = true
                self.view.sendSubview(toBack: self.noActiveDraftView)
            }
            return self.resultsList.count
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
            
            let resultsCell = self.resultsTableView.dequeueReusableCell(withIdentifier:"Results",for:indexPath) as! ResultsCell
            let data:NSDictionary = self.resultsList[indexPath.row] as! NSDictionary
            var prizesArray = NSDictionary()
            
            if let prizesDict: NSDictionary = data.value(forKey: "DraftPrizes") as? NSDictionary {
                prizesArray = prizesDict
            }
            
            let prizesValue: Double = self.calculateSum(CalculatingValue: prizesArray)
            var enteredValue:String = ""
            var draftNumbersValue:String = ""
            var draftNameValue:String = ""
            var sportsNameValue:String = ""
            var WinningPositionValue:String=""
        
            if let entered: Int = data.value(forKey: "Entered") as? Int {
                enteredValue = String(entered)
            }else{
                enteredValue = "0"
            }
            
            if let entrants: Int = data.value(forKey: "Entrants") as? Int {
                draftNumbersValue = String(entrants)
            }
            
            if let draftName: String = data.value(forKey: "DraftName") as? String {
                draftNameValue = draftName
            }
            
            if let sportsName: String = data.value(forKey: "SportsName") as? String {
                sportsNameValue = sportsName
            }
        
        if let winningPosition:Int64 = data.value(forKey: "WinningPosition") as? Int64 {
            WinningPositionValue = String(winningPosition)
        }
            
            resultsCell.configureCell(entered: enteredValue ,draft: draftNumbersValue, won: WinningPositionValue, draftName: draftNameValue, type: sportsNameValue)
            
            return resultsCell as ResultsCell
        
    }
    
    // MARK: - TableView Deligate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if Reachability.isConnectedToNetwork() == true {
            
            
            
                let data:NSDictionary = self.resultsList[indexPath.row] as! NSDictionary
                
                
                var draftIdValue : Int = 0
                var playIdValue : Int64 = 0
                
                if let draftId: Int = data.value(forKey: "DraftId") as? Int {
                    draftIdValue = draftId
                }
                
                if let playId: Int64 = data.value(forKey: "PlayId") as? Int64 {
                    playIdValue = playId
                }
            
                let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
                // Create View Controllers
                
                self.upcomingDraftDetailsPage = mainStoryBoard.instantiateViewController(withIdentifier: "UpcomingDraftDetail") as! UpcomingDraftDetailViewController
                self.upcomingDraftDetailsPage.playId = playIdValue
                self.upcomingDraftDetailsPage.draftId = draftIdValue
                self.upcomingDraftDetailsPage.sportsId = self.sportsId
                self.upcomingDraftDetailsPage.isLive = isLiveData
                self.upcomingDraftDetailsPage.isResult = isResultData
                self.present(self.upcomingDraftDetailsPage, animated: false, completion: nil)
                
           
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

