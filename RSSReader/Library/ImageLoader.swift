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
    
    func getTagImage(tagName: String) -> UIImage {
        let key = "tag" + tagName
        if let image = cache.objectForKey(key) as? UIImage {
            return image
        } else {
            // キャッシュされていなければ作る
            // 文字列の作成
            let tagString = NSAttributedString(
                string: tagName,
                attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7),
                    NSFontAttributeName: UIFont.systemFontOfSize(14)])
            // タグ名の文字列を表示するのに必要な横幅を計算する
            let textSize = tagString.boundingRectWithSize(CGSizeMake(200, 200), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
            // タグ画像を作る
            let imageWidth: CGFloat = textSize.width + 16
            let imageHeight: CGFloat = textSize.height + 2
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), false, 0)
            
            let context = UIGraphicsGetCurrentContext()
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, 10, 0);
            CGContextAddLineToPoint(context, 0, imageHeight/2);
            CGContextAddLineToPoint(context, 10, imageHeight);
            CGContextAddLineToPoint(context, imageWidth, imageHeight);
            CGContextAddLineToPoint(context, imageWidth, 0);
            CGContextClosePath(context);
            CGContextClip(context);
            CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 0.2)
            CGContextAddRect(context, CGRectMake(0, 0, imageWidth, imageHeight))
            CGContextFillPath(context)
            tagString.drawAtPoint(CGPointMake(12, 0))
            
            let tagImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            // キャッシュに入れる
            cache.setObject(tagImage, forKey: key)
            return tagImage
        }
    }
    
    private func resize(image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
}