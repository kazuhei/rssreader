
import UIKit

// PageMenuの子ViewControllerにするためのViewControllerの親クラス
class PageViewController: BaseViewController {
    
    // 子クラスでオーバーライドするとそれが呼ばれてnavigationbarに設定される
    func navigationRightBarButtons() ->  [UIBarButtonItem] {
        return []
    }
}
