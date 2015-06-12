import Foundation
import Alamofire

class QiitaApiClient: BaseClient {
    let root = "https://qiita.com/api/v2"
    
    func call<T: BaseRequest>(request: T, callback: (T.BaseResponse) -> Void) {
        var manager = Manager.sharedInstance
        let path = NSBundle.mainBundle().pathForResource("accesstoken", ofType: "txt")!
        let accesstoken = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": accesstoken
        ]
        let url = root + "/" + request.path
        manager.request(request.method, url, parameters: request.params).response {
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
