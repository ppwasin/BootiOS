//: A UIKit based Playground for presenting user interface
  
import CasePaths

struct User {
    var id: Int
    var name: String
}

func foo() {
    let tmp = \User.id
    var user = User(id: 42, name: "Blob")
    user[keyPath: \User.id] = 100
    let id = user[keyPath: \User.id]
}
