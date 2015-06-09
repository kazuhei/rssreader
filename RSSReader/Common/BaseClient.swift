import Foundation

protocol BaseClient{
    var root: String { get }
    
    func call<T: BaseRequest>(request: T, callback: (T.BaseResponse) -> Void)
}
