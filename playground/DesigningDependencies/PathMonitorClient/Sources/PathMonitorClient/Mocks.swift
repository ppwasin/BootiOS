//
//  File.swift
//
//
//  Created by Wasin Passornpakorn on 15/8/20.
//
import Combine
import Foundation
import Network

extension PathMonitorClient {
//    static let satisfied = Self(
//        setPathUpdateHandler: { callback in
//            callback(NetworkPath(status: .satisfied))
//        },
//        start: { _ in },
//        cancel: {}
//    )
//    static let unsatisfied = Self(
//        setPathUpdateHandler: { callback in
//            callback(NetworkPath(status: .unsatisfied))
//        },
//        start: { _ in },
//        cancel: {}
//    )
//
//    static let flakey = Self(
//        setPathUpdateHandler: { callback in
//            var status = NWPath.Status.satisfied
//            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
//                callback(.init(status: status))
//                status = status == .satisfied ? .unsatisfied : .satisfied
//            }
//        },
//        start: { _ in },
//        cancel: {}
//    )

    public static let satisfied = Self(
        networkPathPublisher: Just(NetworkPath(status: .satisfied))
            .eraseToAnyPublisher()
    )
    public static let unsatisfied = Self(
        networkPathPublisher: Just(NetworkPath(status: .unsatisfied))
            .eraseToAnyPublisher()
    )
    public static let flakey = Self(
        networkPathPublisher: Timer.publish(every: 2, on: .main, in: .default)
            .autoconnect()
            .scan(.satisfied) { status, _ in
                status == .satisfied ? .unsatisfied : .satisfied
            }
            .map { NetworkPath(status: $0) }
            .eraseToAnyPublisher()
    )
}
