import Foundation
import RxSwift

class UserModel: BaseModel {
    private static let singleton = UserModel()
    
    var observableUser: Variable<UserEntity> = Variable(UserEntity())
    
    private override init() {}
    
    static func getInstance() -> UserModel {
        return singleton
    }
    
    func get(id: String) {
        let client = QiitaApiClient()
        client.call(QiitaApiClient.UserRequest(id: id)){
            data in
            self.observableUser.next(data)
        }
    }
}