import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class ArticleDetailRequest: BaseRequest {
        let path: String
        let method = Alamofire.Method.GET
        var params = [String: String]()
        
        init(articleId: String) {
            self.path = "items/" + articleId
        }
        
        typealias BaseResponse = ArticleEntity
        
        func makeResponse(data: NSData) -> BaseResponse? {
            let json = JSON(data:data)
            return ArticleEntity(articleData: json)
        }
    }
}