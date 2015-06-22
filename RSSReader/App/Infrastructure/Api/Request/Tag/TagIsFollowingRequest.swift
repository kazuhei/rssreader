import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class TagIsFollowingRequest: BaseRequest {
        var path = "tags"
        let method = Alamofire.Method.GET
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