import Foundation
import UIKit
import PageMenu

class MainMenuViewController: BaseViewController, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    var controllerArray: [UIViewController] = []
    
    @IBOutlet weak var mainscreen: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PAGE MENU"
        // 各ページのViewcontrollerを用意する
        let articleListStoryboard = UIStoryboard(name: "ArticleList", bundle: nil)
        let articleListViewController = articleListStoryboard.instantiateInitialViewController() as! UIViewController
        let stockListStoryboard = UIStoryboard(name: "StockList", bundle: nil)
        let stockListViewController = stockListStoryboard.instantiateInitialViewController() as! UIViewController
        let tagListStoryboard = UIStoryboard(name: "TagList", bundle: nil)
        let tagListViewController = tagListStoryboard.instantiateInitialViewController() as! UIViewController
        controllerArray = [articleListViewController, stockListViewController, tagListViewController]
        
        let menuParams: [CAPSPageMenuOption] = [
            .SelectionIndicatorHeight(4),
            .BottomMenuHairlineColor(UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 0.8)),
            .SelectionIndicatorColor(UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 0.8)),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectedMenuItemLabelColor(UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 0.8)),
            .UnselectedMenuItemLabelColor(UIColor.grayColor()),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .MenuItemWidthBasedOnTitleTextWidth(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.mainscreen.frame.width, self.mainscreen.frame.height), pageMenuOptions: menuParams)
        
        pageMenu!.delegate = self
        self.mainscreen.addSubview(pageMenu!.view)
        
        // navigationBarの初期化
        let firstPageViewController = articleListViewController as! PageViewController
        self.navigationItem.setRightBarButtonItems(firstPageViewController.navigationRightBarButtons(), animated: false)
    }
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        if let nextVC = controllerArray[index] as? PageViewController {
            self.navigationItem.setRightBarButtonItems(nextVC.navigationRightBarButtons(), animated: false)
        }
    }
}