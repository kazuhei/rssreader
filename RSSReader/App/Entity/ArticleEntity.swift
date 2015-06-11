
import Foundation
import SwiftyJSON

class ArticleEntity: NSObject {
    let id: String
    let title: String
    let createdAt: String
    let tags: [TagEntity]?
    let user: UserEntity?
    
    init(articleData: JSON) {
        self.id = articleData["id"].string ?? ""
        self.title = articleData["title"].string ?? "無題"
        self.createdAt = articleData["created_at"].string ?? ""
        var tagArray: [TagEntity] = []
        for (index, tagData) in articleData["tags"] {
            tagArray.append(TagEntity(tagData: tagData))
        }
        self.tags = tagArray
        self.user = UserEntity(userData: articleData["user"])
    }
}