//
//  SequenceManager.swift
//

import Foundation

public class SequenceManager: NSObject {
    
    public static let share = SequenceManager()
    public typealias Transaction = () -> Void
    
    private var lock = NSLock()
    private var isGenesis = true
    private var transactionCount = 0
    private lazy var sequenceQueue: DispatchQueue = DispatchQueue(label: "sequence_queue")
    private lazy var sema: DispatchSemaphore = DispatchSemaphore(value: 0)
    
    /// 使用时,每个事务必须对应一个free
    public func commitTransaction(transaction: @escaping Transaction) {
        lock.lock()
        transactionCount += 1
        lock.unlock()
        sequenceQueue.async {
            self.lock.lock()
            if !self.isGenesis {
                self.isGenesis = false
                self.lock.unlock()
                self.sema.wait()
            }
            
            self.isGenesis = false
            if self.transactionCount > 0 {
                self.transactionCount -= 1
                if self.transactionCount == 0 {
                    self.isGenesis = true
                }
            }
            self.lock.unlock()
            
            DispatchQueue.main.async {
                transaction()
            }
        }
    }
    
    public func free() {
        guard transactionCount > 0 else {
            return
        }
        sema.signal()
    }

    public func reset() {
        guard transactionCount > 0 else {
            return
        }
        for _ in 0..<transactionCount {
            sema.signal()
        }
    }
}
