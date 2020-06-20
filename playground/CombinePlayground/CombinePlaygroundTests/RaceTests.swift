//
//  RaceTests.swift
//  CombinePlaygroundTests
//
//  Created by Wasin Passornpakorn on 20/6/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import Combine
@testable import CombinePlayground
import XCTest

// Run two at the same time
// if cache come first, fresh still run and publish the result after finish
// if fresh come frist, need to cancel the cache one
func race<Output, Failure: Error>(
    cache: Future<Output, Failure>,
    fresh: Future<Output, Failure>
) -> AnyPublisher<Output, Failure> {
    Publishers.Merge(
        cache.map { (model: $0, isCached: true) },
        fresh.map { (model: $0, isCached: false) }
    )
    .scan((nil, nil)) { accum, output in (accum.1, output) }
    .prefix(while: { lhs, rhs in
        !(rhs?.isCached ?? true) // isFresh
            || (lhs?.isCached ?? true) // isCache
        })
    .compactMap(\.1?.model)
    .eraseToAnyPublisher()
}

class RaceTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    let testScheduler = DispatchQueue.testScheduler

    func testRace_CacheEmitsFirst() {
        var output: [Int] = []

        race(
            cache: Future<Int, Never> { callback in
                self.testScheduler.schedule(after: self.testScheduler.now.advanced(by: 1)) {
                    callback(.success(2))
                }
            },
            fresh: Future<Int, Never> { callback in
                self.testScheduler.schedule(after: self.testScheduler.now.advanced(by: 2)) {
                    callback(.success(42))
                }
            }
        )
        .sink { output.append($0) }
        .store(in: &cancellables)

        XCTAssertEqual(output, [])
        testScheduler.advance(by: 2)
        XCTAssertEqual(output, [2, 42])
    }

    func testRace_FreshEmitsFirst() {
        var output: [Int] = []

        race(
            cache: Future<Int, Never> { callback in
                self.testScheduler.schedule(after: self.testScheduler.now.advanced(by: 2)) {
                    callback(.success(2))
                }
            },
            fresh: Future<Int, Never> { callback in
                self.testScheduler.schedule(after: self.testScheduler.now.advanced(by: 1)) {
                    callback(.success(42))
                }
            }
        )
        .sink { output.append($0) }
        .store(in: &cancellables)

        XCTAssertEqual(output, [])
        testScheduler.advance(by: 2)
        XCTAssertEqual(output, [42])
    }
}

