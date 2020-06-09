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
        testScheduler.advance()
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
        testScheduler.advance()
        XCTAssertEqual(executionCount, 2)
    }
    
    func testImmedateSchedulerActionWithPublisher() {
        var output: [Int] = []
        
        Just(1)
            .receive(on: testScheduler)
            .sink { output.append($0) }
            .store(in: &cancellables)
        
        XCTAssertEqual(output, [])
        testScheduler.advance()
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
        testScheduler.advance()
        XCTAssertEqual(output, [1, 2])
    }
    
    func testSchedulerdAfterDelay() {
        var isExecuted = false
        testScheduler.schedule(after: testScheduler.now.advanced(by: 1)) {
            isExecuted = true
        }
        
        XCTAssertEqual(isExecuted, false)
        testScheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(isExecuted, false)
        testScheduler.advance(by: .milliseconds(499))
        XCTAssertEqual(isExecuted, false)
        testScheduler.advance(by: .milliseconds(1))
        XCTAssertEqual(isExecuted, true)
    }
    
    func testSchdulerAfterLongDelay() {
        var isExecuted = false
        testScheduler.schedule(after: testScheduler.now.advanced(by: 1)) {
            isExecuted = true
        }
        
        XCTAssertEqual(isExecuted, false)
        testScheduler.advance(by: .seconds(1_000_000))
        XCTAssertEqual(isExecuted, true)
    }
    
    func testSchedulerInterval() {
        var executionCount = 0
        
        testScheduler.schedule(after: testScheduler.now, interval: 1) {
            executionCount += 1
        }.store(in: &cancellables)
        
        XCTAssertEqual(executionCount, 0)
        testScheduler.advance()
        XCTAssertEqual(executionCount, 1)
        testScheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(executionCount, 1)
        testScheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(executionCount, 2)
        testScheduler.advance(by: .seconds(1))
        XCTAssertEqual(executionCount, 3)
        
        testScheduler.advance(by: .seconds(5))
        XCTAssertEqual(executionCount, 8)
    }
    
    func testScheduledTwoInterval_Fail() {
        var values: [String] = []
        testScheduler.schedule(after: testScheduler.now.advanced(by: 1), interval: 1) {
            values.append("Hello")
        }.store(in: &cancellables)
        
        testScheduler.schedule(after: testScheduler.now.advanced(by: 2), interval: 2) {
            values.append("World")
        }.store(in: &cancellables)
        
        XCTAssertEqual(values, [])
        testScheduler.advance(by: 2)
        XCTAssertEqual(values, ["Hello", "Hello", "World"])
    }
    
    func testScheduleNow() {
        var times: [UInt64] = []
        testScheduler.schedule(after: testScheduler.now, interval: 1) {
            times.append(self.testScheduler.now.dispatchTime.uptimeNanoseconds)
        }.store(in: &cancellables)
        
        XCTAssertEqual(times, [])
        testScheduler.advance(by: 3)
        XCTAssertEqual(times, [1, 1_000_000_001, 2_000_000_001, 3_000_000_001])
    }
    
    func testScheduledIntervalCancellation() {
        var executionCount = 0
        
        testScheduler.schedule(after: testScheduler.now, interval: 1) {
            executionCount += 1
        }.store(in: &cancellables)
        
        XCTAssertEqual(executionCount, 0)
        testScheduler.advance()
        XCTAssertEqual(executionCount, 1)
        testScheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(executionCount, 1)
        testScheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(executionCount, 2)
        
        cancellables.removeAll()
        testScheduler.advance(by: .seconds(1))
        XCTAssertEqual(executionCount, 2)
    }
    
    func testFun() {
        var values: [Int] = []
        testScheduler.schedule(after: testScheduler.now, interval: 1){
            values.append(values.count)
        }.store(in: &cancellables)
        
        XCTAssertEqual(values, [])
        testScheduler.advance(by: 1000)
        XCTAssertEqual(values, Array(0...1000))
    }
}
