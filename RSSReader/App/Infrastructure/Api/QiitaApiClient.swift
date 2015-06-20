import Foundation
import Alamofire
import KeychainAccess

class QiitaApiClient: BaseClient {
    let root = "https://qiita.com/api/v2"
    
    func call<T: BaseRequest>(request: T, callback: (T.BaseResponse) -> Void, errorCallback: (error: NSError) -> ()) {
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
                errorCallback(error: NSError(domain: "connection error", code: 0, userInfo: nil))
                return
            }
            
            if let httpResponse = res {
                if httpResponse.statusCode != 200 {
                    errorCallback(error: NSError(domain: "error response", code: httpResponse.statusCode, userInfo: nil))
                    return
                }
            } else {
                errorCallback(error: NSError(domain: "unexpected error", code: 0, userInfo: nil))
                return
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
