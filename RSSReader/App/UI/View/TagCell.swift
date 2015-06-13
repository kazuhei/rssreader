
import UIKit

class TagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagIcon: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    func configure(tag: TagEntity) {
        let mainQueue = dispatch_get_main_queue()
        let subQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        self.tagIcon.image = ImageLoader.sharedInstance.getPlaceHolder(tagIcon.frame.size)
        dispatch_async(subQueue) {
            if let iconUrl = tag.iconUrl {
                if let image = ImageLoader.sharedInstance.get(NSURL(string: iconUrl)!, size: self.tagIcon.frame.size) {
                    dispatch_async(mainQueue) {
                        self.tagIcon.image = image
                        self.setNeedsLayout()
                    }
                }
            }
        }
        tagLabel.text = tag.id
    }
}
