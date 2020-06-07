//
//  ContentView.swift
//  BootiOS
//
//  Created by Wasin Passornpakorn on 25/4/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import BootiOSFramework


struct Todo: Equatable, Identifiable {
    let id: UUID
    var description = ""
    var isComplete = false
}

enum TodoAction: Equatable {
    case checkboxTapped
    case textFieldChanged(String)
}

struct TodoEnvironment {
    
}

let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment>{
    state, action, environment in
    switch action {
    case .checkboxTapped:
        state.isComplete.toggle()
        return .none
    case .textFieldChanged(let text):
        state.description = text
        return .none
    }
}


struct AppState: Equatable {
    var todos: [Todo] = []
}
enum AppAction: Equatable {
    case addButtonTapped
    case todo(index: Int, action: TodoAction)
    case todoDelayCompleted
}

struct AppEnvironment {
    var uuid: () -> UUID
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    //forEach: make local to global reducer
    //when Global action come from View => convert to Local action and send to this reducer (todoReducer)    
    todoReducer.forEach(
        state: \AppState.todos,
        action: /AppAction.todo(index:action:), //(AppAction) -> TodoAction
        environment: { _ in TodoEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action{
        case .addButtonTapped:
            state.todos.insert(Todo(id: environment.uuid()), at: 0)
            return .none
        case .todo(index: _, action: .checkboxTapped):
//            return .concatenate(
//                Effect.cancel(id: "completion effect"),
//                Effect(value: AppAction.todoDelayCompleted)
//                    .delay(for: 1, scheduler: DispatchQueue.main)
//                    .eraseToEffect()
//                    .cancellable(id: "completion effect")
//            )
            // prevent other reducer to use the the same id
            struct CancelableDelayId: Hashable {}
            return Effect(value: AppAction.todoDelayCompleted)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .eraseToEffect()
                .cancellable(id: CancelableDelayId(), cancelInFlight: true)
               
        case .todo(index: let index, action: let action):
            return .none
        case .todoDelayCompleted:
            state.todos = state.todos
                .enumerated()
                .sorted(by: { lhs, rhs in
                    (rhs.element.isComplete && !lhs.element.isComplete) || lhs.element.description < rhs.element.description
                })
                .map(\.element)
            return .none
        }
    }
)
    .debug()

/*send(LocaAction):
 LocalAction
 => store.scope: make (TodoAction) -> AppAction
 => appReducer: it will extract from case path from (AppAction) to all reducer. if sucecss will pass to that reducer
 In this case, it is todoReducer
 */
struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store){ viewStore in
                List{
                    ForEachStore(
                        self.store.scope(
                            state: \.todos, //app to local state
                            action: AppAction.todo(index:action:) // local to app action
                        ),
                        content: TodoView.init(store:)
                    )
                    //                    ){ todoStore in
                    //                        TodoView(store: todoStore)
                    //                    }
                }
                .navigationBarTitle("Todos")
                .navigationBarItems(trailing: Button("Add") {
                    viewStore.send(.addButtonTapped)
                })
            }
        }
        
    }
}

struct TodoView: View {
    let store: Store<Todo, TodoAction>
    var body: some View {
        WithViewStore(self.store){ todoViewStore in
            HStack {
                Button(action: { todoViewStore.send(.checkboxTapped)}
                ) {
                    Image(systemName: todoViewStore.isComplete ? "checkmark.square" : "square")
                }
                .buttonStyle(PlainButtonStyle())
                TextField(
                    "Untitled todo",
                    text: todoViewStore.binding(
                        get: \.description,
                        send: TodoAction.textFieldChanged
                    )
                )
            }
            .foregroundColor(todoViewStore.isComplete ? .gray : nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: AppState(todos: [
                    Todo(id: UUID(), description: "1 line 1", isComplete: false),
                    Todo(id: UUID(), description: "2 line 2", isComplete: true),
                    Todo(id: UUID(), description: "3 line 3", isComplete: false),
                ]),
                reducer: appReducer,
                environment: AppEnvironment(uuid: UUID.init))
        )
    }
}
