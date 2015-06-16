
import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class AuthRequest: BaseRequest {
        var path = "access_tokens"
        let method = Alamofire.Method.POST
        var params = [String: String]()
        
        init(code: String) {
            let idPath = NSBundle.mainBundle().pathForResource("client_id", ofType: "txt")!
            let client_id = String(contentsOfFile: idPath, encoding: NSUTF8StringEncoding, error: nil)!
            params["client_id"] = client_id
            let secretPath = NSBundle.mainBundle().pathForResource("client_secret", ofType: "txt")!
            let client_secret = String(contentsOfFile: secretPath, encoding: NSUTF8StringEncoding, error: nil)!
            params["client_secret"] = client_secret
            params["code"] = code
        }
        
        typealias BaseResponse = TokenEntity
        
        func makeResponse(data: NSData) -> BaseResponse? {
            let json = JSON(data:data)
            
            return TokenEntity(authData: json)
        }
    }
}