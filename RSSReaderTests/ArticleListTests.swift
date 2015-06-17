import UIKit
import Quick
import Nimble

class ArticleListTests: QuickSpec {
    override func spec() {
        var articleListViewController: ArticleListViewController!
        
        beforeEach {
            let pageMenuStoryBoard = UIStoryboard(name: "PageMenu", bundle: NSBundle(forClass: self.classForCoder))
            let navigationViewController = pageMenuStoryBoard.instantiateInitialViewController() as! UINavigationController
            let pageMenuViewController = navigationViewController.childViewControllers[0] as! PageMenuViewController
            let pageMenuView = pageMenuViewController.view
            let index = pageMenuViewController.currentIndex
            articleListViewController = pageMenuViewController.controllerArray[index] as! ArticleListViewController
        }
        
        context("表示時に") {
            // viewDidLoadを呼び出すため
            beforeEach {
                let view = articleListViewController.view
            }
            
            describe("新着記事が") {
                it("取得されていること") {
                    articleListViewController.viewWillAppear(false)
                    let articleTableView = articleListViewController.articleTableView

                    expect(articleListViewController.articles).toEventuallyNot(equal([]), timeout: 3)
                    expect(articleListViewController.articles.count).toEventually(equal(30), timeout: 3)
                }
            }
        }
    }
}