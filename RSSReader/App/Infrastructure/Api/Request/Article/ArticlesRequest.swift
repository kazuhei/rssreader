import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class ArticlesRequest: BaseRequest {
        let path = "items"
        let method = Alamofire.Method.GET
        var params = [String: String]()
        
        init(page: Int, perPage: Int) {
            self.params = ["page": String(page), "per_page": String(perPage)]
        }
        
        init (keyword: String, page: Int, perPage: Int) {
            self.params = ["query": keyword, "page": String(page), "per_page": String(perPage)]
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