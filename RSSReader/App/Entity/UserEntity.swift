
import Foundation
import SwiftyJSON

class UserEntity: NSObject {
    let id: String
    let profileImageUrl: String?
    
    init(userData: JSON) {
        self.id = userData["id"].string!
        self.profileImageUrl = userData["profile_image_url"].string
    }
}