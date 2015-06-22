import Foundation
import UIKit

class ArticleTableViewFirstCell: UITableViewCell, BaseArticleTableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tagListView: UIView!
    @IBOutlet weak var stockIcon: UIImageView!
    @IBOutlet weak var stockCountLabel: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    func getHeight(article: ArticleEntity, width: CGFloat) -> CGFloat {
        self.bounds.size.width = width
        setNeedsLayout()
        layoutIfNeeded()
        
        // 高さを取得
        let text = article.title
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = titleLabel.lineBreakMode
        let attributeDict = [
            NSFontAttributeName: titleLabel.font,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        let textSize = NSString(string: text).boundingRectWithSize(CGSizeMake(titleLabel.frame.width, 600), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributeDict, context: nil)
        
        // 100文字で切る
        let summary = article.body.substringToIndex(advance(article.body.startIndex, 100))
        let summaryParagraphStyle = NSMutableParagraphStyle()
        summaryParagraphStyle.lineBreakMode = summaryLabel.lineBreakMode
        let summaryAttributeDict = [
            NSFontAttributeName: summaryLabel.font,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        let summayTextSize = NSString(string: summary).boundingRectWithSize(CGSizeMake(summaryLabel.frame.width, 600), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: summaryAttributeDict, context: nil)
        
        return max(textSize.height + summayTextSize.height + 64, 110)
    }
    
    func configure(article: ArticleEntity) {
        // Cellに値を設定する.
        titleLabel.text = article.title
        summaryLabel.text = article.body.substringToIndex(advance(article.body.startIndex, 100))
        
        profileImage.image = ImageLoader.sharedInstance.getPlaceHolder(profileImage.frame.size)
        
        // ユーザー情報
        if let user = article.user {
            userNameLabel.text = user.id
            // サムネイルがある場合はサムネイルを表示
            let imageUrl = user.profileImageUrl
            let mainQueue = dispatch_get_main_queue()
            let subQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            
            // 画像の読み込みはサブのスレッドで非同期に行う
            dispatch_async(subQueue) {
                if let image = ImageLoader.sharedInstance.get(NSURL(string: imageUrl)!, size: self.profileImage.frame.size) {
                    dispatch_async(mainQueue) {
                        self.profileImage.image = image
                        self.setNeedsLayout()
                    }
                }
            }
            
        }
        
        // タグ情報
        // セルの使い回しによる重複を防ぐため、一回すべて削除
        for tagView in tagListView.subviews {
            tagView.removeFromSuperview()
        }
        if let tags = article.tags {
            var leftPosition: CGFloat = 0
            for tag in tags {
                let tagView = UIImageView(image: ImageLoader.sharedInstance.getTagImage(tag.name))
                // はみ出さない範囲でタグを貼り続ける
                if tagListView.frame.width > leftPosition + tagView.frame.width {
                    tagView.frame = CGRectOffset(tagView.frame, leftPosition, 0)
                    tagListView.addSubview(tagView)
                    leftPosition += tagView.frame.width + 4
                } else {
                    break
                }
            }
        }
        
        // stock数、コメント数
        stockIcon.image = ImageLoader.sharedInstance.stockIcon(stockIcon.frame.size)
        stockCountLabel.text = String(arc4random() % 1000)
        commentIcon.image = ImageLoader.sharedInstance.commentIcon(commentIcon.frame.size)
        commentCountLabel.text = String(arc4random() % 1000)
        
    }
}