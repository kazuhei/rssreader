import Foundation
import UIKit
import PageMenu
import MMDrawerController
import RxSwift

class PageMenuViewController: BaseViewController, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    var controllerArray: [UIViewController] = []
    var currentIndex: Int = 0
    
    @IBOutlet weak var mainscreen: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 各ページのViewcontrollerを用意する
        let articleListStoryboard = UIStoryboard(name: "ArticleList", bundle: NSBundle(forClass: self.classForCoder))
        let articleListViewController = articleListStoryboard.instantiateInitialViewController() as! UIViewController
        let stockListStoryboard = UIStoryboard(name: "StockList", bundle: NSBundle(forClass: self.classForCoder))
        let stockListViewController = stockListStoryboard.instantiateInitialViewController() as! UIViewController
        let tagListStoryboard = UIStoryboard(name: "TagList", bundle: NSBundle(forClass: self.classForCoder))
        let tagListViewController = tagListStoryboard.instantiateInitialViewController() as! UIViewController
        let historyListStoryboard = UIStoryboard(name: "HistoryList", bundle: NSBundle(forClass: self.classForCoder))
        let historyListViewController = historyListStoryboard.instantiateInitialViewController() as! UIViewController
        controllerArray = [articleListViewController, historyListViewController, stockListViewController, tagListViewController]
        
        let baseColor = UIColor(red: 121/255, green: 183/255, blue: 74/255, alpha: 1)
        let menuParams: [CAPSPageMenuOption] = [
            .SelectionIndicatorHeight(4),
            .BottomMenuHairlineColor(baseColor),
            .SelectionIndicatorColor(baseColor),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectedMenuItemLabelColor(baseColor),
            .UnselectedMenuItemLabelColor(UIColor.grayColor()),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .MenuItemWidthBasedOnTitleTextWidth(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.mainscreen.frame.width, self.mainscreen.frame.height), pageMenuOptions: menuParams)
        pageMenu!.delegate = self
        self.mainscreen.addSubview(pageMenu!.view)
    }
    
    @IBAction func onTouchDrawerButton(sender: UIBarButtonItem) {
        navigationController?.mm_drawerController.openDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        currentIndex = index
    }
}