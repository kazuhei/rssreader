
import Foundation
import SwiftyJSON

class SimpleTagEntity: NSObject {
    let name: String
    
    init(tagData: JSON) {
        self.name = tagData["name"].string!
    }
}