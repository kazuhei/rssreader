import Foundation

class ArticleModel: BaseModel {
    private static let singleton = ArticleModel()
    
    // KVO用のプロパティ
    dynamic var articles: [ArticleEntity] = []
    
    private override init() {}
    
    static func getInstance() -> ArticleModel {
        return singleton
    }
    
    func get() {
        let client = QiitaApiClient()
        client.call(QiitaApiClient.ArticlesRequest(page: 1, perPage: 30)){
            data in
            self.articles = data
        }
    }
}