
import Foundation
import SwiftyJSON

class TokenEntity: NSObject {
    let token: String
    
    init(authData: JSON) {
        self.token = authData["token"].string!
    }
}