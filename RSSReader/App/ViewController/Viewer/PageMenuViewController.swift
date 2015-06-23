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
    override func viewWillAppear(animated: Bool) {
        setNavigationRightBarButtons()
        addObservePushVCFromChildVC()
    }
    
    override func viewWillDisappear(animated: Bool) {
        removeObservePushVCFromChildVC()
    }
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        removeObservePushVCFromChildVC()
        currentIndex = index
        addObservePushVCFromChildVC()
        setNavigationRightBarButtons()
    }
    
    // 子VCの投げてくるpushViewControllerを拾って遷移する
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object as! PageViewController == controllerArray[currentIndex] && keyPath == "pushViewController" {
            let pageViewController = controllerArray[currentIndex] as! PageViewController
            self.navigationController?.pushViewController(pageViewController.pushViewController!, animated: true)
        }
    }
    
    private func setNavigationRightBarButtons() {
        let currentVC = controllerArray[currentIndex] as! PageViewController
        self.navigationItem.setRightBarButtonItems(currentVC.navigationRightBarButtons(), animated: false)
    }
    
    private func addObservePushVCFromChildVC() {
        let currentVC = controllerArray[currentIndex] as! PageViewController
        currentVC.addObserver(self, forKeyPath: "pushViewController", options: .New, context: nil)
    }
    
    private func removeObservePushVCFromChildVC() {
        let currentVC = controllerArray[currentIndex] as! PageViewController
        currentVC.removeObserver(self, forKeyPath: "pushViewController")
    }
}