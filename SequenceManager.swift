//
//  SequenceManager.swift
//

import Foundation

public class SequenceManager: NSObject {
    public typealias Transaction = () -> Void

    private var isGenesis = true
    private lazy var sequenceQueue: DispatchQueue = {
        DispatchQueue(label: "sequence_queue")
    }()

    private lazy var sema: DispatchSemaphore = {
        DispatchSemaphore(value: 0)
    }()

    public static let share = SequenceManager()

    public func commitTransaction(transaction: @escaping Transaction) {
        sequenceQueue.async {
            if !self.isGenesis {
                self.sema.wait()
            }
            self.isGenesis = false
            DispatchQueue.main.async {
                transaction()
            }
        }
    }

    public func free() {
        sema.signal()
    }
}
