import Foundation
import RxSwift

class AuthModel: BaseModel {
    private static let singleton = AuthModel()
    
    private override init() {}
    
    static func getInstance() -> AuthModel {
        return singleton
    }
    
    func getAccessToken(code: String, callback: (QiitaApiClient.AuthRequest.BaseResponse) -> ()) {
        let client = QiitaApiClient()
        client.call(QiitaApiClient.AuthRequest(code: code)){
            data in
            println(data)
            callback(data)
        }
    }
}