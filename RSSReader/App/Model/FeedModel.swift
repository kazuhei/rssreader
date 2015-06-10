
import Foundation

class FeedModel: BaseModel {
    private let xmlParseDelegate: XMLParseDelegate = XMLParseDelegate()
    private static let singleton = FeedModel()
    
    // KVO用のプロパティ
    dynamic var articles: [Article] = []
    
    private override init() {}

    static func getInstance() -> FeedModel {
         return singleton
    }
    
    func get() {
        let client = QiitaClient()
        xmlParseDelegate.addObserver(self, forKeyPath: "articles", options: .New, context: nil)
        client.call(QiitaClient.FeedRequest(xmlParseDelegate: self.xmlParseDelegate)){
            // KVOで変更を取得するのでcallbackはなし
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        // VCにイベント通知
        if xmlParseDelegate.articles.count != 0 {
            self.articles = xmlParseDelegate.articles
            self.articles.removeAll(keepCapacity: false)
        }
        xmlParseDelegate.removeObserver(self, forKeyPath: "articles")
    }
}