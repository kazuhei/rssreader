import UIKit
import Foundation

// 監視中のmodel.keyを保持する
struct ObserveKey: Equatable {
    let model: BaseModel
    let key:   String
    let handler: (() -> Void)?
    
    init(model: BaseModel, key: String) {
        self.model = model
        self.key = key
        self.handler = nil
    }
    
    init(model: BaseModel, key: String, handler: () -> Void) {
        self.model = model
        self.key = key
        self.handler = handler
    }
}

func == (lhs: ObserveKey, rhs: ObserveKey) -> Bool {
    if lhs.model == rhs.model && lhs.key == rhs.key {
        return true
    }
    return false
}

class BaseViewController: UIViewController {
    
    private var observeKeys: [ObserveKey] = []
    
    // kvoとそのhandlerを一緒に登録できるように独自定義
    func addModelObserve(model: BaseModel, forKeyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutablePointer<Void>, handler: () -> Void) {
        model.addObserver(self, forKeyPath: forKeyPath, options: options, context: context)
        observeKeys.append(ObserveKey(model: model, key: forKeyPath, handler: handler))
    }
    
    func removeModelObserve(model: BaseModel, forKeyPath: String) {
        for observeKey in observeKeys {
            if observeKey.model == model && observeKey.key == forKeyPath {
                model.removeObserver(self, forKeyPath: forKeyPath)
                if let index = find(observeKeys, ObserveKey(model: model, key: forKeyPath)) {
                    observeKeys.removeAtIndex(index)
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // modelの監視を全て外す
        for observeKey in observeKeys {
            observeKey.model.removeObserver(self, forKeyPath: observeKey.key)
        }
        observeKeys.removeAll(keepCapacity: false)
    }
    
    // 登録されていたらhandlerを実行
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if let index = find(observeKeys, ObserveKey(model: object as! BaseModel, key: keyPath)) {
            if let handler = observeKeys[index].handler {
                handler()
            }
        }
    }
}

