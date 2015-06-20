import Foundation
import RxSwift

class UserModel: BaseModel {
    private static let singleton = UserModel()
    let client = QiitaApiClient()
    
    private override init() {}
    
    static func getInstance() -> UserModel {
        return singleton
    }
    
    func get(id: String) -> Observable<[UserEntity]> {
        let user: Variable<[UserEntity]> = Variable([])
        client.call(QiitaApiClient.UserRequest(id: id), callback: {
            data in
            user.next([data])
        }, errorCallback: {(error) in
            user.on(Event.Error(error))
        })
        return user
    }
}