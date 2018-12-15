
import UIKit
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var totalAmount:Double = 0.0
    var intialTimer:Bool = false
    var playSound:Bool = false
    var isLogedIn:Bool = false
    var selectedUserTag:Int = 0
    
    let payPalSandBox = "AZNUetmv73dFNgfDEhT_xU7ongAjM-i40HE2gEYr26Jf1VZLyvNupp7kUJtlKinSwnKBFnFYRUMHXCP0"
    let payPalLive = "AUjz_Xvrre4GGyB4aXb661K74fTqa2LQ22CARQlbXlktiB41zdDywroXIeJUUpaYYCxtyk9JNnEsmn89"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        self.isLogedIn = (UserDefaults.standard.value(forKey: "Loged In") != nil)
        
        if UserDefaults.standard.value(forKey: "Amount") != nil{
        self.totalAmount = UserDefaults.standard.value(forKey: "Amount")  as! Double
        }
        // Initialize PayPal
        Fabric.with([Crashlytics.self])
        PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: payPalLive,
                                                                PayPalEnvironmentSandbox: payPalSandBox])

        UIApplication.shared.applicationIconBadgeNumber = 0
        registerForPushNotifications()
        
        var mainStoryBoard = UIStoryboard()
        // Instantiate Main.storyboard
        if self.isLogedIn{
            mainStoryBoard = UIStoryboard(name:"Home", bundle:nil)
            // Create View Controllers
            let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
            
           self.window?.rootViewController = homePage
        }else{
        mainStoryBoard = UIStoryboard(name:"Main", bundle:nil)
        let joinNowViewController = mainStoryBoard.instantiateViewController(withIdentifier: "JoinNow") as! JoinNowViewController
        self.window?.rootViewController = joinNowViewController
        }
        
        return true
    }

    func registerForPushNotifications() {
        if UserDefaults.standard.value(forKey: "Sound") != nil{
            self.playSound = (UserDefaults.standard.value(forKey: "Sound") != nil) 
        }
        if  self.playSound {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                self.getNotificationSettings()
            }
        }else{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                self.getNotificationSettings()
            }
        }
       
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        UserDefaults.standard.set(token, forKey: "DeviceToken")
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

