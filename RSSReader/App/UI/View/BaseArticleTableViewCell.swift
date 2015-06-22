import Foundation
import UIKit

protocol BaseArticleTableViewCell {
    
    func configure(article: ArticleEntity) -> Void
    
    func getHeight(article: ArticleEntity, width: CGFloat) -> CGFloat
}
