import Foundation
import Alamofire

extension QiitaClient {
    class FeedRequest: BaseRequest {
        let path = "tags/Swift/feed.atom"
        let method = Alamofire.Method.GET
        let params = [String: String]()
        
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