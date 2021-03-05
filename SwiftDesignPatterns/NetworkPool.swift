//
//  NetworkPool.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/3/5.
//

import Foundation

class NetworkPool {
    static let sharedInstance = NetworkPool()
    
    private let connectionCount = 3
    private var connections = [NetworkConnection]()
    private let semaphore: DispatchSemaphore
    private var queue: DispatchQueue
    
    private init() {
        for _ in 0..<connectionCount {
            connections.append(NetworkConnection())
        }
        semaphore = DispatchSemaphore.init(value: connectionCount)
        queue = DispatchQueue.init(label: "networkPoolQ")
    }
    
    class func getConnection() -> NetworkConnection {
        return sharedInstance.doGetConnection()
    }
    
    class func returnConnection(conn: NetworkConnection) {
        sharedInstance.doReturnConnection(conn: conn)
    }
    
    private func doGetConnection() -> NetworkConnection {
        semaphore.wait()
        var result: NetworkConnection?
        queue.sync {
            result = connections.remove(at: 0)
        }
        return result!
    }
    
    private func doReturnConnection(conn: NetworkConnection) {
        queue.async { [self] in
            connections.append(conn)
            semaphore.signal()
        }
    }
    
}
