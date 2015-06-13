
import Foundation
import SwiftyJSON

class TagEntity: NSObject {
    let id: String
    let iconUrl: String?
    let itemsCount: Int
    let followersCount: Int
    
    init(tagData: JSON) {
        self.id = tagData["id"].string!
        self.iconUrl = tagData["icon_url"].string
        self.itemsCount = tagData["items_count"].int!
        self.followersCount = tagData["followers_count"].int!
    }
}