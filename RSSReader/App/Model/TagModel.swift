import Foundation

class TagModel: BaseModel {
    private static let singleton = TagModel()
    
    // KVO用のプロパティ
    dynamic var tags: [TagEntity] = []
    
    let perPage: Int = 100
    
    private override init() {}
    
    static func getInstance() -> TagModel {
        return singleton
    }
    
    func get(page: Int) {
        let client = QiitaApiClient()
        client.call(QiitaApiClient.TagsRequest(page: page, perPage: perPage)){
            data in
            self.tags = data
        }
    }
}