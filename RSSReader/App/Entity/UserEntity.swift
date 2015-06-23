
import Foundation
import SwiftyJSON

class UserEntity: NSObject {
    let id: String
    let profileImageUrl: String
    let userDescription: String
    
    init(userData: JSON) {
        self.id = userData["id"].string!
        self.profileImageUrl = userData["profile_image_url"].string!
        self.userDescription = userData["description"].string ?? ""
    }
    
    init (history: History) {
        self.id = history.userId
        self.profileImageUrl = history.userProfileImageUrl
        self.userDescription = ""
    }
}