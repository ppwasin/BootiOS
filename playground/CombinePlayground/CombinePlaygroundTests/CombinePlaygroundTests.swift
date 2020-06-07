//
//  CombinePlaygroundTests.swift
//  CombinePlaygroundTests
//
//  Created by Wasin Passornpakorn on 7/6/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import Combine
@testable import CombinePlayground
import XCTest

class CombinePlaygroundTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    func testReigsterSuccessful() {
        let viewModel = RegisterViewModel(
            register: { _, _ in
                Just((Data("true".utf8), URLResponse()))
                    .setFailureType(to: URLError.self)
                    .eraseToAnyPublisher()
        })
        
        var isRegisterd: [Bool] = []
        viewModel.$isRegisterd
            .sink { isRegisterd.append($0) }
            .store(in: &cancellables)
        
        XCTAssertEqual(isRegisterd, [false])
        
        viewModel.email = "blob@pointfree.co"
        XCTAssertEqual(isRegisterd, [false])
        
        viewModel.password = "blob is awesome"
        XCTAssertEqual(isRegisterd, [false])
        
        viewModel.registerButtonTapped()
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
        XCTAssertEqual(isRegisterd, [false, true])
    }
    
    func testReigsterFailure() {
        let viewModel = RegisterViewModel(
            register: { _, _ in
                Just((Data("false".utf8), URLResponse()))
                    .setFailureType(to: URLError.self)
                    .eraseToAnyPublisher()
        })
        
        XCTAssertEqual(viewModel.isRegisterd, false)
        
        viewModel.email = "blob@pointfree.co"
        viewModel.password = "blob is awesome"
        viewModel.registerButtonTapped()
        
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
        XCTAssertEqual(viewModel.isRegisterd, false)
        XCTAssertEqual(viewModel.errorAlert?.title, "Failed to register. Please try again.")
    }
}
