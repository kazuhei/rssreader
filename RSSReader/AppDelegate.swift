import UIKit
import CoreData
import MMDrawerController
import KeychainAccess
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // MagicalRecordの初期設定
        MagicalRecord.setupCoreDataStackWithStoreNamed("db.sqlite")
        // History.MR_truncateAll() // データの初期化をしたい場合はコメントを外す
        
        // Keychainからログイン状態を取得する
        let keychain = Keychain(service: "edu.self.rssreader")
        // アクセストークンを保存
        let path = NSBundle.mainBundle().pathForResource("accesstoken", ofType: "txt")!
        let localAccessToken = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
        keychain.set(localAccessToken, key: "qiitaAccessToken")
        // アクセストークンを削除
        // keychain.remove("qiitaAccessToken")
        if let accessToken = keychain.get("qiitaAccessToken") {
            println(accessToken)
            println("ログイン済です")
            startAppToFirstController()
        } else {
            println("ログインできていません")
            toLoginViewController()
        }
        
        return true
    }

    // カスタムスキームで起動した場合
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        // codeが付与されているのを確認する
        let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)!
        let queryDict = urlComponentsToDict(urlComponents)
        
        // 付与されたcodeを付けてpostしqiitaからaccesstokenを得り保存してリスタート
        AuthModel.getInstance().getAccessToken(queryDict["code"]!){
            authEntity in
            let keychain = Keychain(service: "edu.self.rssreader")
            keychain.set(authEntity.token, key: "qiitaAccessToken")
            self.startAppToFirstController()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        MagicalRecord.cleanUp()
    }
    
    private func toLoginViewController() {
        let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = loginStoryBoard.instantiateInitialViewController() as! UIViewController
        
        window!.rootViewController = loginViewController
        window!.makeKeyAndVisible()
    }
    
    private func startAppToFirstController() {
        let pageMenuStoryBoard = UIStoryboard(name: "PageMenu", bundle: nil)
        let pageMenuViewController = pageMenuStoryBoard.instantiateInitialViewController() as! UIViewController
        let sideMenuStoryBoard = UIStoryboard(name: "SideMenu", bundle: nil)
        let sideMenuViewController = sideMenuStoryBoard.instantiateInitialViewController() as! UIViewController
        
        let drawerController = MMDrawerController(centerViewController: pageMenuViewController, leftDrawerViewController: sideMenuViewController)
        drawerController.openDrawerGestureModeMask = .Custom
        drawerController.closeDrawerGestureModeMask = .TapCenterView | .TapNavigationBar
        
        window!.rootViewController = drawerController
        window!.makeKeyAndVisible()
    }
    
    private func urlComponentsToDict(comp: NSURLComponents) -> Dictionary<String, String> {
        var dict: Dictionary<String, String> = Dictionary<String, String>()
        
        for (var i = 0; i < comp.queryItems?.count; i++) {
            let item = comp.queryItems?[i] as! NSURLQueryItem
            dict[item.name] = item.value
        }
        
        return dict
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.self.RSSReader" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("RSSReader", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("RSSReader.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

