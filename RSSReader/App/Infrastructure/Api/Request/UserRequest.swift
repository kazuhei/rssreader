import Foundation
import Alamofire
import SwiftyJSON

extension QiitaApiClient {
    class UserRequest: BaseRequest {
        var path = "users"
        let method = Alamofire.Method.GET
        var params = [String: String]()
        
        init(id: String) {
            path += "/" + id
        }
        
        typealias BaseResponse = UserEntity
        
        func makeResponse(data: NSData) -> BaseResponse? {
            let json = JSON(data:data)
            
            return UserEntity(userData: json)
        }
    }
}