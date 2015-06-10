
import Foundation

extension QiitaClient {
    class FeedRequest: BaseRequest {
        let path = "tags/Swift/feed.atom"
        let xmlParseDelegate: XMLParseDelegate
        
        init (xmlParseDelegate: XMLParseDelegate) {
            self.xmlParseDelegate = xmlParseDelegate
        }
        
        typealias BaseResponse = Void
        
        func makeResponse(data: NSData) -> BaseResponse? {
            let xmlParser = NSXMLParser(data: data)
            xmlParser.delegate = xmlParseDelegate
            xmlParser.parse()
            return nil
        }
    }
}