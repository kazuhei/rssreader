
import Foundation
import UIKit

extension UIViewController {
    func getContext() -> Context {
        return Context.sharedInstance
    }
}