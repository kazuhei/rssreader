import Foundation

protocol BaseRequest {
    var path: String { get }
    
    typealias BaseResponse: Any
    
    func makeResponse(data: NSData) -> BaseResponse?
}