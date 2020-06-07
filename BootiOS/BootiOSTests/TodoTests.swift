//
//  TodoTests.swift
//  BootiOSTests
//
//  Created by Wasin Passornpakorn on 19/5/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import ComposableArchitecture
import XCTest
@testable import BootiOS

class TodoTests: XCTestCase {
    func testCompletingTodo(){
        let store = TestStore(
            initialState: AppState(
                todos: [
                    Todo(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        description: "Milk",
                        isComplete: false
                        
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment(uuid: {
                fatalError()
            }))
        
        store.assert(
            .send(.todo(index: 0, action: .checkboxTapped)){
                $0.todos[0].isComplete = true
            }
        )
    }
    
    func testAddTodo() {
        let mockUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        
        let store = TestStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(uuid: { mockUUID } ))
        
        store.assert(
            .send(.addButtonTapped){
                $0.todos = [
                    Todo(
                        id: mockUUID,
                        description: "",
                        isComplete: false
                    )
                ]
            }
        )
    }
    
    func testTodoSorting(){
        let store = TestStore(
            initialState: AppState(
                todos: [
                    Todo(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        description: "Milk",
                        isComplete: false
                        
                    ),
                    Todo(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        description: "Eggs",
                        isComplete: false
                        
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment(uuid: {
                fatalError()
            }))
        
        store.assert(
            .send(.todo(index: 0, action: .checkboxTapped)){
                $0.todos[0].isComplete = true
//                $0.todos = [
//                    $0.todos[1],
//                    $0.todos[0]
//                ]
                $0.todos.swapAt(0, 1)
            }
        )
    }

}
