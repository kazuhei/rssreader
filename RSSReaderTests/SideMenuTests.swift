import UIKit
import Quick
import Nimble

class SideMenuTests: QuickSpec {
    override func spec() {
        var sideMenuViewController: SideMenuViewController!
        
        beforeEach {
            let sideMenuStoryBoard = UIStoryboard(name: "SideMenu", bundle: NSBundle(forClass: self.classForCoder))
            let navigationViewController = sideMenuStoryBoard.instantiateInitialViewController() as! UINavigationController
            sideMenuViewController = navigationViewController.childViewControllers[0] as! SideMenuViewController
        }
        
        context("初期化時に") {
            // viewDidLoadを呼び出すため
            beforeEach {
                let view = sideMenuViewController.view
            }
            
            describe("ユーザー名の") {
                it("初期値が設定されていること") {
                    let userName = sideMenuViewController.userNameLabel.text
                    expect(userName).to(equal("dummy"))
                }
            }
            
            describe("プロフィールの") {
                it("初期値が設定されていること") {
                    let description = sideMenuViewController.userDescriptionLabel.text
                    expect(description).to(equal("dummy"))
                }
            }
        }
        
        context("表示時に") {
            beforeEach {
                sideMenuViewController.view
            }
            
            describe("ユーザー名が") {
                it("表示されること") {
                    sideMenuViewController.viewWillAppear(false)
                    expect(sideMenuViewController.userNameLabel.text).toEventuallyNot(equal("dummy"), timeout: 3)
                }
            }
            
            describe("ユーザープロフィールが") {
                it("表示されること") {
                    sideMenuViewController.viewWillAppear(false)
                    expect(sideMenuViewController.userDescriptionLabel.text).toEventuallyNot(equal("dummy"), timeout: 3)
                }
            }
        }
    }
}