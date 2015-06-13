
import Foundation
import SwiftyJSON

class ArticleEntity: NSObject {
    let id: String
    let title: String
    let body: String
    let createdAt: String
    let tags: [SimpleTagEntity]?
    let user: UserEntity?
    
    init(articleData: JSON) {
        self.id = articleData["id"].string!
        self.title = articleData["title"].string ?? "無題"
        self.body = articleData["rendered_body"].string ?? ""
        self.createdAt = articleData["created_at"].string!
        var tagArray: [SimpleTagEntity] = []
        for (index, tagData) in articleData["tags"] {
            tagArray.append(SimpleTagEntity(tagData: tagData))
        }
        self.tags = tagArray
        self.user = UserEntity(userData: articleData["user"])
    }
}