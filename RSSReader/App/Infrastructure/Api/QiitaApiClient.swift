import Foundation
import Alamofire

class QiitaApiClient: BaseClient {
    let root = "http://qiita.com/api/v2"
    
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
            // エラーは全て除外できたものとしてdataを強制開示
            if let jsonData = data as? NSData {
                if let response = request.makeResponse(jsonData) {
                    callback(response)
                }
            }
        }
    }
}
