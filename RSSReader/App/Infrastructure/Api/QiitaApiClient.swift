import Foundation
import Alamofire
import KeychainAccess

class QiitaApiClient: BaseClient {
    let root = "https://qiita.com/api/v2"
    
    func call<T: BaseRequest>(request: T, callback: (T.BaseResponse) -> Void) {
        var manager = Manager.sharedInstance

        // ログイン済のときはアクセストークンを追加
        let keychain = Keychain(service: "edu.self.rssreader")
        if let accessToken = keychain.get("qiitaAccessToken") {
            manager.session.configuration.HTTPAdditionalHeaders = [
                "Authorization": accessToken
            ]
        }
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
            if let nsdata = data as? NSData {
                if let response = request.makeResponse(nsdata) {
                    callback(response)
                }
            }
        }
    }
}
