import Foundation

class BaseModel: NSObject {
    static func getInstance<T: BaseModel>() -> T {
        fatalError("This method must be overridden")
    }
}