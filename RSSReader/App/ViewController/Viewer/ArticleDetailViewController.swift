
import Foundation
import UIKit
import RxSwift
import SVProgressHUD
import MagicalRecord

class ArticleDetailViewController: BaseViewController, UIWebViewDelegate {
    
    var articleId: String = ""
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tagListView: UIView!
    @IBOutlet weak var stockButtonView: UIView!
    @IBOutlet weak var stockIcon: UIImageView!
    @IBAction func onTouchStockButton(sender: UIButton) {
    }
    
    @IBOutlet weak var contentsView: UIWebView!
    
    convenience init(articleId: String) {
        self.init()
    }
    
    override func viewDidLoad() {
        contentsView.delegate = self
        
        SVProgressHUD.show()
        subscriptions.append(ArticleModel.getInstance().getDetail(self.articleId) >- filter { articleArray in articleArray.count == 1 }
            >- subscribe(next:
                {
                    articles in
                    let article = articles[0]
                    self.configureView(article)
                    self.saveHistor(article)
                }, error: {
                    error in
                    println(error)
                    SVProgressHUD.showErrorWithStatus("ロード失敗")
                }, completed: {
                    SVProgressHUD.dismiss()
                }
            ))
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        if let heightString = contentsView.stringByEvaluatingJavaScriptFromString("document.documentElement.scrollHeight") {
            let height = CGFloat(NSString(string: heightString).floatValue)
            println(height)
            contentsView.addConstraint(
                NSLayoutConstraint(
                    item: contentsView,
                    attribute: NSLayoutAttribute.Height,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.Height,
                    multiplier: 1.0,
                    constant: height
                )
            )
        }
    }
    
    func configureView(article: ArticleEntity) {
        self.titleLabel.text = article.title
        self.stockIcon.image = ImageLoader.sharedInstance.stockIcon(self.stockIcon.frame.size)
        if let user = article.user {
            self.userProfileImage.image = ImageLoader.sharedInstance.get(NSURL(string: user.profileImageUrl)!, size: self.userProfileImage.frame.size)
            self.userNameLabel.text = user.id
        }
        
        if let createdAt = article.createdAt {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yy年MM月dd日 H時mm分"
            self.createdAtLabel.text  = formatter.stringFromDate(createdAt)
        }
        
        if let tags = article.tags {

            var leftPosition: CGFloat = 0
            for tag in tags {
                let tagView = UIImageView(image: ImageLoader.sharedInstance.getTagImage(tag.name))
                // はみ出さない範囲でタグを貼り続ける
                if self.tagListView.frame.width > leftPosition + tagView.frame.width {
                    tagView.frame = CGRectOffset(tagView.frame, leftPosition, 0)
                    self.tagListView.addSubview(tagView)
                    leftPosition += tagView.frame.width + 4
                } else {
                    break
                }
            }
        }
        self.headerView.setNeedsLayout()
        self.headerView.layoutIfNeeded()
        
        self.contentsView.loadHTMLString(article.renderdBody, baseURL: nil)
    }
    
    // 履歴データを保存する
    private func saveHistor(article: ArticleEntity) {
        // 記事が登録済の場合はupdated_atだけ更新する
        if let record = History.MR_findFirstByAttribute("id", withValue: article.id) {
            record.updated_at = NSDate()
            record.managedObjectContext?.MR_saveToPersistentStoreAndWait()
        } else {
            // 無いときは新規で追加
            let history: History = History.MR_createEntity()
            history.id = article.id
            history.title = article.title
            if let user = article.user {
                history.userId = user.id
                history.userProfileImageUrl = user.profileImageUrl
            }
            history.created_at = NSDate()
            history.updated_at = NSDate()
            history.managedObjectContext?.MR_saveToPersistentStoreAndWait()
        }
    }
}