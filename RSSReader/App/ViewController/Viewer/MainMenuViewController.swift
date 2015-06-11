import Foundation
import UIKit
import PageMenu

class MainMenuViewController: BaseViewController {
    
    var pageMenu: CAPSPageMenu?
    
    @IBOutlet weak var mainscreen: UIView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = "PAGE MENU"
        // 各ページのViewcontrollerを用意する
        let articleListStoryboard = UIStoryboard(name: "ArticleList", bundle: nil)
        let articleListViewController = articleListStoryboard.instantiateInitialViewController() as! UIViewController
        let stockListStoryboard = UIStoryboard(name: "StockList", bundle: nil)
        let stockListViewController = stockListStoryboard.instantiateInitialViewController() as! UIViewController
        let tagListStoryboard = UIStoryboard(name: "TagList", bundle: nil)
        let tagListViewController = tagListStoryboard.instantiateInitialViewController() as! UIViewController
        let controllerArray: [UIViewController] = [articleListViewController, stockListViewController, tagListViewController]
        
        let menuParams: [CAPSPageMenuOption] = [
            .SelectionIndicatorHeight(4),
            .BottomMenuHairlineColor(UIColor.orangeColor()),
            .SelectionIndicatorColor(UIColor.orangeColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectedMenuItemLabelColor(UIColor.orangeColor()),
            .UnselectedMenuItemLabelColor(UIColor.grayColor()),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .MenuItemWidthBasedOnTitleTextWidth(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.mainscreen.frame.width, self.mainscreen.frame.height), pageMenuOptions: menuParams)
        
        self.mainscreen.addSubview(pageMenu!.view)
    }
}