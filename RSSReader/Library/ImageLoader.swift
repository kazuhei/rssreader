import Foundation
import UIKit

class ImageLoader {
    
    // singletonパターン
    static let sharedInstance = ImageLoader()
    
    let cache: NSCache = NSCache()
    
    private init () {
        cache.name = "ImageLoader"
        cache.countLimit = 200
    }
    
    func get(url: NSURL, size: CGSize?) -> UIImage? {
        // NSStringをハッシュ化...したいがとりあえずurlをkeyにする
        var key = url.absoluteString!
        if let size = size {
            key = key + String(stringInterpolationSegment: size.width)
        }
        
        // キャッシュされているか確認する
        if let image = cache.objectForKey(key) as? UIImage {
            return image
        } else {
            // キャッシュされていなければリクエストして取る
            var image: UIImage? = nil
            if let imageData = NSData(contentsOfURL: url) {
                if var image = UIImage(data: imageData) {
                    // サイズの指定がある場合はリサイズ
                    if let size = size {
                        image = resize(image, size: size)
                    }
                    
                    // キャッシュに入れる
                    cache.setObject(image, forKey: key)
                    
                    // 画像を返す
                    return image
                }
            }
        }
        
        return nil
    }
    
    func getPlaceHolder(size: CGSize) -> UIImage? {
        let key = "placeholder"
            + String(stringInterpolationSegment: size.width)
            + "x"
            + String(stringInterpolationSegment: size.height)
        // キャッシュされているか確認する
        if let image = cache.objectForKey(key) as? UIImage {
            return image
        } else {
            // キャッシュされていなければリクエストして取る
            var image: UIImage? = nil
            if let image = UIImage(named: "placeholder.png") {
                
                // リサイズ
                let resizeImage = resize(image, size: size)
                
                // キャッシュに入れる
                cache.setObject(resizeImage, forKey: key)
                
                // 画像を返す
                return resizeImage
            }
        }
        return nil
    }
    
    private func resize(image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
}