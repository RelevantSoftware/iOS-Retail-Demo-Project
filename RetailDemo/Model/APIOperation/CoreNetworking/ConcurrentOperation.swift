//
//  ConcurrentOperation.swift
//

import Foundation

class ConcurrentOperation: Operation {
    
    let executingKey = "isExecuting"
    let finishedKey = "isFinished"
    
    internal var privateExecuting: Bool = false
    internal var privateFinished: Bool = false
    
    override var isExecuting: Bool {
        return privateExecuting
    }
    
    override var isFinished: Bool {
        return privateFinished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        let boolValue = (value as? Bool) ?? false
        switch key {
            case executingKey:
                self.willChangeValue(forKey: executingKey)
                privateExecuting = boolValue
                self.didChangeValue(forKey: executingKey)
            case finishedKey:
                self.willChangeValue(forKey: finishedKey)
                privateFinished = boolValue
                self.didChangeValue(forKey: finishedKey)
            default:
                super.setValue(value, forKey: key)
        }
    }
}
