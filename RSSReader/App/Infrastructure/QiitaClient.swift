import Foundation
import Alamofire

class QiitaClient: BaseClient {
    let root = "http://qiita.com"
    
    func call<T: BaseRequest>(request: T, callback: (T.BaseResponse) -> Void) {

        let requestUrl = NSURL(string: root + "/" + request.path)!
        Alamofire.request(request.method, requestUrl, parameters: request.params).response {
            req, res, data, connectionError in
            
            if let error = connectionError {
                println("通信エラーだよ")
            }
            
            let statusCode = res?.statusCode
            if statusCode != 200 {
                println("エラー応答だよ")
                
            }
            
            if let xmlData = data as? NSData {
                if let response = request.makeResponse(xmlData) {
                    callback(response)
                }
            }
        }
    }
}
