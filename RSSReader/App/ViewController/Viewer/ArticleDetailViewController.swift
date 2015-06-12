
import Foundation
import UIKit

class ArticleDetailViewController: BaseViewController {
    
    var articleId: String = ""
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainView: UIView!
    convenience init(articleId: String) {
        self.init()
    }
    
    override func viewDidLoad() {
        self.addModelObserve(ArticleModel.getInstance(), forKeyPath: "singleArticle", options: .New, context: nil){
            let header = self.headerView as! HeaderView
            header.configure(ArticleModel.getInstance().singleArticle!)
            header.setNeedsLayout()
            header.layoutIfNeeded()
        }
        ArticleModel.getInstance().getDetail(articleId)
    }
}