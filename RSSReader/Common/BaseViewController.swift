import UIKit
import Foundation
import RxSwift

class BaseViewController: UIViewController {

    var subscriptions: [Disposable] = []
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        for subscription in subscriptions {
            subscription.dispose()
        }
    }
}

