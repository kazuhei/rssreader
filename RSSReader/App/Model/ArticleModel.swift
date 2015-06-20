import Foundation
import RxSwift

class ArticleModel: BaseModel {
    private static let singleton = ArticleModel()
    private let client = QiitaApiClient()
    
    let perPage: Int = 30
    
    private override init() {}
    
    static func getInstance() -> ArticleModel {
        return singleton
    }
    
    func get(page: Int) -> Observable<[ArticleEntity]> {
        let articles: Variable<[ArticleEntity]> = Variable([])
        client.call(QiitaApiClient.ArticlesRequest(page: page, perPage: perPage),
            callback: {
                data in
                articles.next(data)
                articles.on(Event.Completed)
            }, errorCallback: {
                (error) in
                articles.on(Event.Error(error))
            }
        )
        
        return articles
    }
    
    func get(keyword: String, page: Int) -> Observable<[ArticleEntity]> {
        let articles: Variable<[ArticleEntity]> = Variable([])
        client.call(QiitaApiClient.ArticlesRequest(keyword: keyword, page: page, perPage: perPage),
            callback: {
                data in
                articles.next(data)
                articles.on(Event.Completed)
            }, errorCallback: {
                (error) in
                articles.on(Event.Error(error))
            }
        )
        
        return articles
    }
    
    func getStocks(page: Int) -> Observable<[ArticleEntity]> {
        let stocks: Variable<[ArticleEntity]> = Variable([])
        client.call(QiitaApiClient.ArticleStocksRequest(userId: "kazuhei0108", page: page, perPage: perPage),
            callback: {
                data in
                stocks.next(data)
                stocks.on(Event.Completed)
            }, errorCallback: {
                (error) in
                stocks.on(Event.Error(error))
            }
        )
        
        return stocks
    }
    
    func getDetail(articleId: String) -> Observable<[ArticleEntity]> {
        let articles: Variable<[ArticleEntity]> = Variable([])
        client.call(QiitaApiClient.ArticleDetailRequest(articleId: articleId),
            callback: {
                data in
                articles.next([data])
                articles.on(Event.Completed)
            }, errorCallback: {
                (error) in
                articles.on(Event.Error(error))
            }
        )
        
        return articles
    }
}