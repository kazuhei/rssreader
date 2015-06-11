import Foundation

class Article: NSObject {
    let title: String
    let url: NSURL
    let authorName: String
    let imgUrl: NSURL?
    
    init (title: String, url: NSURL, authorName: String, imgUrl: NSURL?) {
        self.title = title
        self.url = url
        self.authorName = authorName
        self.imgUrl = imgUrl
    }
}
