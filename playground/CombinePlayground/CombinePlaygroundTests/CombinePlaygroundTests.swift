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
            },
            validatePassword: { _ in
                Empty(completeImmediately: true)
                    .eraseToAnyPublisher()
            }
        )
        
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
            },
            validatePassword: { _ in Empty(completeImmediately: true).eraseToAnyPublisher() }
        )
        
        XCTAssertEqual(viewModel.isRegisterd, false)
        
        viewModel.email = "blob@pointfree.co"
        viewModel.password = "blob is awesome"
        viewModel.registerButtonTapped()
        
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
        XCTAssertEqual(viewModel.isRegisterd, false)
        XCTAssertEqual(viewModel.errorAlert?.title, "Failed to register. Please try again.")
    }
    
    func testValidatePassword() {
        let viewModel = RegisterViewModel(
            register: { _, _ in fatalError() },
            validatePassword: mockValidate(password:)
        )
        
        var passwordValidationMessage: [String] = []
        viewModel.$passwordValidationMesaaage
            .sink { passwordValidationMessage.append($0) }
            .store(in: &cancellables)
        
        XCTAssertEqual(passwordValidationMessage, [""])
        
        viewModel.password = "blob"
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.31)
        XCTAssertEqual(passwordValidationMessage, ["", "Password is too short"])
        
        viewModel.password = "blob is awesome"
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.21)
        XCTAssertEqual(passwordValidationMessage, ["", "Password is too short"])
        
        viewModel.password = "012456789-012456789-012456789"
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.31)
        XCTAssertEqual(passwordValidationMessage, ["", "Password is too short", "Password is too long"])
    }
    
    let testScheduler = DispatchQueue.testScheduler
    func testImmediatedSchedulerdAction() {
//        let testScheduler = TestScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>(now: DispatchQueue.SchedulerTimeType.init(DispatchTime.init(uptimeNanoseconds: 0)))
        
//        let testScheduler = TestScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>(now: .init(.init(uptimeNanoseconds: 0)))
        
        var isExecuted = false
        testScheduler.schedule {
            isExecuted = true
        }
        
        XCTAssertEqual(isExecuted, false)
        testScheduler.advanced()
        XCTAssertEqual(isExecuted, true)
    }
    
    func testMultipleImmediateSchdulerActions() {
        var executionCount = 0
        
        testScheduler.schedule {
            executionCount += 1
        }
        testScheduler.schedule {
            executionCount += 1
        }
        
        XCTAssertEqual(executionCount, 0)
        testScheduler.advanced()
        XCTAssertEqual(executionCount, 2)
    }
    
    func testImmedateSchedulerActionWithPublisher() {
        var output: [Int] = []
        
        Just(1)
            .receive(on: testScheduler)
            .sink { output.append($0) }
            .store(in: &cancellables)
                
        XCTAssertEqual(output, [])
        testScheduler.advanced()
        XCTAssertEqual(output, [1])
    }
    
    func testImmedateSchedulerActionWithMultiplePublisher() {
        var output: [Int] = []
        
        Just(1)
            .receive(on: testScheduler)
            .merge(with: Just(2).receive(on: testScheduler))
            .sink { output.append($0) }
            .store(in: &cancellables)
                
        XCTAssertEqual(output, [])
        testScheduler.advanced()
        XCTAssertEqual(output, [1, 2])
    }
}
