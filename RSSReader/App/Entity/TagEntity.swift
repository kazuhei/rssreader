
import Foundation
import SwiftyJSON

class TagEntity: NSObject {
    let name: String
    
    init(tagData: JSON) {
        self.name = tagData["name"].string!
    }
}