import UIKit
import Quick
import Nimble

class PageMenuTests: QuickSpec {
    override func spec() {
        var pageMenuViewController: PageMenuViewController!
        
        beforeEach {
            let pageMenuStoryBoard = UIStoryboard(name: "PageMenu", bundle: NSBundle(forClass: self.classForCoder))
            let navigationViewController = pageMenuStoryBoard.instantiateInitialViewController() as! UINavigationController
            pageMenuViewController = navigationViewController.childViewControllers[0] as! PageMenuViewController
            // viewDidLoadを呼び出すため
            let view = pageMenuViewController.view
            pageMenuViewController.viewWillAppear(false)
        }
        
        context("初期化時に") {
            describe("新着記事一覧が") {
                it("選択されていること") {
                    let articleListViewController = pageMenuViewController.controllerArray[0]
                    let articleListView = articleListViewController.view
                    expect(articleListViewController.title).to(equal("新着記事一覧"))
                }
            }
            
            describe("更新ボタンが") {
                it("表示されていること") {
                    let articleListViewController = pageMenuViewController.controllerArray[0] as! ArticleListViewController
                    expect(pageMenuViewController.navigationItem.rightBarButtonItem).toNot(equal(nil))
                }
            }
        }
        
        context("viewWillAppear時に") {
            it("ストック記事一覧への移動ができること") {
                let articleListViewController = pageMenuViewController.controllerArray[0]
                let articleListView = articleListViewController.view
                articleListViewController.viewWillAppear(false)
                articleListViewController.viewWillDisappear(false)
                pageMenuViewController.pageMenu!.moveToPage(1)
                let stockListViewController = pageMenuViewController.controllerArray[1]
    
                expect(stockListViewController.title).to(equal("ストック記事一覧"))
            }
        }
    }
}