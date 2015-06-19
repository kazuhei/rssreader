
import Foundation
import UIKit
import RxSwift
import SVProgressHUD

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
                    self.configureView(articles[0])
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
        self.createdAtLabel.text = article.createdAt.substringToIndex(advance(article.createdAt.startIndex, 10))
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
        
        let htmlData = article.body.dataUsingEncoding(NSUTF8StringEncoding)
        self.contentsView.loadHTMLString(article.body, baseURL: nil)
    }
}