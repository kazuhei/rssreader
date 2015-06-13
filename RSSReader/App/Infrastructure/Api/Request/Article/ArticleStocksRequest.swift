import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class ArticleStocksRequest: BaseRequest {
        let path: String
        let method = Alamofire.Method.GET
        var params = [String: String]()
        
        
        init(userId: String, page: Int, perPage: Int) {
            self.path = "users/" + userId + "/stocks"
            self.params = ["page": String(page), "per_page": String(perPage)]
        }
        
        typealias BaseResponse = [ArticleEntity]
        
        func makeResponse(data: NSData) -> BaseResponse? {
            let json = JSON(data:data)
            var articleList: [ArticleEntity] = []
            for (index: String, articleJson: JSON) in json {
                articleList.append(ArticleEntity(articleData: articleJson))
            }
            return articleList
        }
    }
}