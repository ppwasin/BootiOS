//
//  File.swift
//
//
//  Created by Wasin Passornpakorn on 15/8/20.
//

import Network
import Combine

public struct NetworkPath {
    public var status: NWPath.Status
    public init(status: NWPath.Status) {
        self.status = status
    }
}

extension NetworkPath {
    public init(rawValue: NWPath) {
        self.status = rawValue.status
    }
}

public struct PathMonitorClient {
//    public var setPathUpdateHandler: (@escaping (NetworkPath) -> Void) -> Void
//    public var start: (DispatchQueue) -> Void
//    public var cancel: () -> Void
//
//    public init(
//        setPathUpdateHandler: @escaping (@escaping (NetworkPath) -> Void) -> Void,
//        start: @escaping (DispatchQueue) -> Void,
//        cancel: @escaping () -> Void
//    ) {
//        self.setPathUpdateHandler = setPathUpdateHandler
//        self.start = start
//        self.cancel = cancel
//    }
    
    public var networkPathPublisher: AnyPublisher<NetworkPath, Never>
    public init(networkPathPublisher: AnyPublisher<NetworkPath, Never>){
        self.networkPathPublisher = networkPathPublisher
    }
}
