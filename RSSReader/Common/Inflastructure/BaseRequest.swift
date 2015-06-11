import Foundation
import Alamofire

protocol BaseRequest {
    var path: String { get }
    var method: Alamofire.Method { get }
    var params: Dictionary<String, String> { get }
    
    typealias BaseResponse: Any
    
    func makeResponse(data: NSData) -> BaseResponse?
}