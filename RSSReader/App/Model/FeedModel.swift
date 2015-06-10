
import Foundation

class FeedModel: NSObject {
    static let sharedInstance = FeedModel()
    let xmlParseDelegate: XMLParseDelegate = XMLParseDelegate()

    
    // KVO用のプロパティ
    dynamic var articles: [Article] = []
    
    private override init() {}
    
    func get() {
        let client = QiitaClient()
        xmlParseDelegate.addObserver(self, forKeyPath: "articles", options: .New, context: nil)
        client.call(QiitaClient.FeedRequest(xmlParseDelegate: self.xmlParseDelegate)){
            // KVOで変更を取得するのでcallbackはなし
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        self.articles = self.xmlParseDelegate.articles
        xmlParseDelegate.removeObserver(self, forKeyPath: "articles")
    }
}