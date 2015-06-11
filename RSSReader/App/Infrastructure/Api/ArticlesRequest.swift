import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class ArticlesRequest: BaseRequest, URLRequestConvertible {
        let path = "items"
        let method = Alamofire.Method.GET
        var params = [String: String]()
        
        init(page: Int, perPage: Int) {
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
        
        var URLRequest: NSURLRequest {
            let URL = NSURL(string: QiitaApiClient().root + "/" + path)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            mutableURLRequest.addValue("Authorization", forHTTPHeaderField: "Bearer 8256943d75529508c9d922d2da6c790a81d20274")
            
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
        }
    }
}