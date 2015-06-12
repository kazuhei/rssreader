import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class ArticleSearchRequest: BaseRequest {
        let path = "items"
        let method = Alamofire.Method.GET
        var params = [String: String]()
        
        init(page: Int, perPage: Int, keyword: String) {
            self.params = ["page": String(page), "per_page": String(perPage), "q": keyword]
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