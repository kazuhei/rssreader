import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class TagPutFollowingRequest: BaseRequest {
        var path = "tags"
        let method = Alamofire.Method.PUT
        var params = [String: String]()
        
        init(tagId: String) {
            path += "/" + tagId + "/following"
        }
        
        typealias BaseResponse = Bool
        
        func makeResponse(data: NSData) -> BaseResponse? {
            
            return true
        }
    }
}