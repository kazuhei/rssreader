
import UIKit

class HeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagListView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var stockButtonView: UIView!
    @IBOutlet weak var stockButton: UIButton!
    @IBOutlet weak var stockIcon: UIImageView!
    
    var headerView: HeaderView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 無限ループしないように
        if self.subviews.count == 0 {
            headerView = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil).first as? HeaderView
            headerView.frame = self.bounds
            self.addSubview(headerView)
        }
    }
    
    func configure(article: ArticleEntity) {
        headerView.titleLabel.text = article.title
        headerView.createdAtLabel.text = article.createdAt.substringToIndex(advance(article.createdAt.startIndex, 10))
        
        // タグ情報
        // セルの使い回しによる重複を防ぐため、一回すべて削除
        if let tags = article.tags {
            var leftPosition: CGFloat = 0
            for tag in tags {
                let tagView = UIImageView(image: ImageLoader.sharedInstance.getTagImage(tag.name))
                // はみ出さない範囲でタグを貼り続ける
                if headerView.tagListView.frame.width > leftPosition + tagView.frame.width {
                    tagView.frame = CGRectOffset(tagView.frame, leftPosition, 0)
                    headerView.tagListView.addSubview(tagView)
                    leftPosition += tagView.frame.width + 4
                } else {
                    break
                }
            }
        }
        
        // ユーザー情報
        if let user = article.user {
            headerView.userNameLabel.text = user.id
            // サムネイルがある場合はサムネイルを表示
            if let imageUrl = user.profileImageUrl {
                let mainQueue = dispatch_get_main_queue()
                let subQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                
                // 画像の読み込みはサブのスレッドで非同期に行う
                dispatch_async(subQueue) {
                    if let image = ImageLoader.sharedInstance.get(NSURL(string: imageUrl)!, size: self.headerView.userProfileImage.frame.size) {
                        dispatch_async(mainQueue) {
                            self.headerView.userProfileImage.image = image
                            self.setNeedsLayout()
                        }
                    }
                }
            }
        }
        
        headerView.stockIcon.image = ImageLoader.sharedInstance.stockIcon(headerView.stockIcon.frame.size)
    }
}