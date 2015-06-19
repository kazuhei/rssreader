import Foundation
import RxSwift

class AuthModel: BaseModel {
    private static let singleton = AuthModel()
    let client = QiitaApiClient()
    
    private override init() {}
    
    static func getInstance() -> AuthModel {
        return singleton
    }
    
    func getAccessToken(code: String, callback: (QiitaApiClient.AuthRequest.BaseResponse) -> ()) {
        client.call(QiitaApiClient.AuthRequest(code: code), callback: {
            data in
            println(data)
            callback(data)
        }, errorCallback: {(error) in
        })
    }
}