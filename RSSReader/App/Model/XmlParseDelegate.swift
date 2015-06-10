import Foundation

class XMLParseDelegate: NSObject, NSXMLParserDelegate {
    
    // 結果をViewControllerに通知するKVO用
    dynamic var articles: [Article] = []
    var _articles: [Article] = []
    
    /*
    * パース実処理
    */
    var elementKey = ""
    var entryTitle = ""
    var entryUrl = ""
    var entryAuthorName = ""
    var entryImgUrl = ""
    
    // parse開始時にarticlesを空にする
    func parserDidStartDocument(parser: NSXMLParser) {
        _articles = []
    }
    
    // elementの始めでどのelementか記憶しておく
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        if elementName == "title" || elementName == "url" || elementName == "name" || elementName == "content" {
            elementKey = elementName
        }
    }
    
    // titleかurlの時はデータを保存
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if let string = string {
            if elementKey == "title" {
                entryTitle += string
            }
            if elementKey == "url" {
                entryUrl += string
            }
            if elementKey == "name" {
                entryAuthorName += string
            }
            if elementKey == "content" {
                // 画像が確保できていればスキップ
                if entryImgUrl != "" {
                    return
                }
                
                // contentから1つ画像URLを取得する
                let contentString = NSString(string: string)
                let pattern = "https?:\\/\\/[-_.!~*\\'()a-zA-Z0-9\\/?]+(\\.jpeg|\\.png|\\.gif)"
                let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
                regex?.enumerateMatchesInString(contentString as String, options: nil, range: NSMakeRange(0, contentString.length)){(result: NSTextCheckingResult!, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    let range = result.rangeAtIndex(0)
                    self.entryImgUrl = contentString.substringWithRange(range)
                }
            }
        }
    }
    
    // urlの時はtitleとurlの両方のデータが取得済みのはずなのでArticleを作って一時データをリフレッシュ
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "name" {
            _articles.append(Article(title: entryTitle, url: NSURL(string: entryUrl)!, authorName: entryAuthorName, imgUrl: NSURL(string: entryImgUrl)))
            entryTitle = ""
            entryUrl = ""
            entryAuthorName = ""
            entryImgUrl = ""
        }
        elementKey = ""
    }
    
    // xmlのパースが終わったらテーブルを再読み込み
    func parserDidEndDocument(parser: NSXMLParser) {
        // 1件目は新着投稿一覧なので除去
        _articles.removeAtIndex(0)
        // 通知発行
        articles = _articles
    }
}