
import Foundation
import UIKit
import KeychainAccess

class Context {
    
    static let sharedInstance = Context()
    
    private init() {
        
    }
    
    // ユーザー設定
    private let accessTokenKey = "qiitaAccessToken"
    var user: UserEntity?
    var accesstoken: String? {
        get {
            // Keychainからログイン状態を取得する
            let keychain = Keychain(service: "edu.self.rssreader")
            return keychain.get(accessTokenKey)
        }
        
        set (accessToken) {
            let keychain = Keychain(service: "edu.self.rssreader")
            // アクセストークンを保存
            keychain.set(accessToken!, key: accessTokenKey)
        }
    }
    
    var navigationController: UINavigationController?
}