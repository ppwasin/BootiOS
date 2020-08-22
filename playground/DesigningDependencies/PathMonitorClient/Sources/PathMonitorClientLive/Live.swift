//
//  File.swift
//
//
//  Created by Wasin Passornpakorn on 15/8/20.
//

import Combine
import Foundation
import Network
import PathMonitorClient

extension PathMonitorClient {
//    static var live: Self {
//        let monitor = NWPathMonitor()
//
//        return Self(
//            setPathUpdateHandler: { callback in
//                monitor.pathUpdateHandler = { path in
//                    callback(NetworkPath(rawValue: path))
//                }
//            },
//            start: monitor.start(queue:),
//            cancel: monitor.cancel
//        )
//    }

    public static func live(queue: DispatchQueue) -> Self {
        let monitor = NWPathMonitor()
        let subject = PassthroughSubject<NWPath, Never>()

        monitor.pathUpdateHandler = subject.send

        return Self(
            networkPathPublisher: subject
                .handleEvents(
                    receiveSubscription: { _ in monitor.start(queue: queue) },
                    receiveCancel: monitor.cancel
                )
                .map(NetworkPath.init(rawValue:))
                .eraseToAnyPublisher()
        )
    }
}
