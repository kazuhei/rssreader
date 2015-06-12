
import UIKit

// PageMenuの子ViewControllerにするためのViewControllerの親クラス
class PageViewController: BaseViewController {
    
    dynamic var pushViewController: UIViewController? = nil
    
    // 子クラスでオーバーライドするとそれが呼ばれてnavigationbarに設定される
    func navigationRightBarButtons() ->  [UIBarButtonItem] {
        return []
    }
}
