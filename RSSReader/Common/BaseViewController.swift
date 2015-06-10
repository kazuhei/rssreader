import UIKit
import Foundation

// 監視中のmodel.keyを保持する
struct ObserveKey: Equatable {
    let model: BaseModel
    let key:   String
}

func == (lhs: ObserveKey, rhs: ObserveKey) -> Bool {
    if lhs.model == rhs.model && lhs.key == rhs.key {
        return true
    }
    return false
}

class BaseViewController: UIViewController {
    
    private var observeKeys: [ObserveKey] = []
    
    func addModelObserve(model: BaseModel, forKeyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutablePointer<Void>) {
        model.addObserver(self, forKeyPath: forKeyPath, options: options, context: context)
        observeKeys.append(ObserveKey(model: model, key: forKeyPath))
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
}

