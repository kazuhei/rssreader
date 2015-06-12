import Foundation

class ArticleModel: BaseModel {
    private static let singleton = ArticleModel()
    
    // KVO用のプロパティ
    dynamic var articles: [ArticleEntity] = []
    dynamic var stocks: [ArticleEntity] = []
    dynamic var singleArticle: ArticleEntity? = nil
    
    let perPage: Int = 30
    
    private override init() {}
    
    static func getInstance() -> ArticleModel {
        return singleton
    }
    
    func get(page: Int) {
        let client = QiitaApiClient()
        client.call(QiitaApiClient.ArticlesRequest(page: 1, perPage: perPage)){
            data in
            self.articles = data
        }
    }
    
    func get(keyword: String, page: Int) {
        let client = QiitaApiClient()
        client.call(QiitaApiClient.ArticlesRequest(page: 1, perPage: perPage)){
            data in
            self.articles = data
        }
    }
    
    func getStocks(page: Int) {
        let client = QiitaApiClient()
        client.call(QiitaApiClient.ArticleStocksRequest(userId: "kazuhei0108", page: 1, perPage: perPage)){
            data in
            self.stocks = data
        }
    }
    
    func getDetail(articleId: String) {
        let client = QiitaApiClient()
        client.call(QiitaApiClient.ArticleDetailRequest(articleId: articleId)) {
            article in
            self.singleArticle = article
        }
    }
}