import Foundation
import RxSwift

class TagModel: BaseModel {
    private static let singleton = TagModel()
    private let client = QiitaApiClient()
    
    let perPage: Int = 100
    
    private override init() {}
    
    static func getInstance() -> TagModel {
        return singleton
    }
    
    func get(page: Int) -> Observable<[TagEntity]> {
        let tags: Variable<[TagEntity]> = Variable([])
        client.call(QiitaApiClient.TagsRequest(page: page, perPage: perPage),
            callback: {
                data in
                tags.next(data)
                tags.on(Event.Completed)
            }, errorCallback: {
                (error) in
                tags.on(Event.Error(error))
            }
        )
        
        return tags
    }
    
    func isFollowing(tagId: String) -> Observable<Bool> {
        let isFollowing: Variable<Bool> = Variable(false)
        
        client.call(QiitaApiClient.TagIsFollowingRequest(tagId: tagId),
            callback: {
                data in
                isFollowing.next(true)
                isFollowing.on(Event.Completed)
            }, errorCallback: {
                (error) in
                isFollowing.next(false)
            }
        )
        
        return isFollowing
    }
    
    func follow(tagId: String) -> Observable<Bool> {
        let isFollowing: Variable<Bool> = Variable(false)
        
        client.call(QiitaApiClient.TagPutFollowingRequest(tagId: tagId),
            callback: {
                data in
                isFollowing.next(true)
                isFollowing.on(Event.Completed)
            }, errorCallback: {
                (error) in
                isFollowing.on(Event.Error(error))
            }
        )
        
        return isFollowing
    }
    
    func unFollow(tagId: String) -> Observable<Bool> {
        let isFollowing: Variable<Bool> = Variable(false)
        
        client.call(QiitaApiClient.TagDeleteFollowingRequest(tagId: tagId),
            callback: {
                data in
                isFollowing.next(true)
                isFollowing.on(Event.Completed)
            }, errorCallback: {
                (error) in
                isFollowing.on(Event.Error(error))
            }
        )
        
        return isFollowing
    }
}