import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class TagsRequest: BaseRequest {
        let path = "tags"
        let method = Alamofire.Method.GET
        var params = [String: String]()
        
        init(page: Int, perPage: Int) {
            self.params = ["page": String(page), "per_page": String(perPage)]
        }
        
        typealias BaseResponse = [TagEntity]
        
        func makeResponse(data: NSData) -> BaseResponse? {
            let json = JSON(data:data)
            var tagList: [TagEntity] = []
            for (index: String, tagJson: JSON) in json {
                tagList.append(TagEntity(tagData: tagJson))
            }
            return tagList
        }
    }
}