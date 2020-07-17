import CasePaths
import SwiftUI

struct Item {
    var name: String
    var color: Color?
    //  var quantity = 1
    //  var isInStock = true
    //  var isOnBackOrder = false
    var status: Status

    enum Status {
        case inStock(quantity: Int)
        case outOfStock(isOnBackOrder: Bool)

//        var isInStock: Bool {
//            guard case .inStock = self else { return false }
//            return true
//        }
//
//        var quantity: Int? {
//            get {
//                switch self {
//                case let .inStock(quantity: quantity):
//                    return quantity
//                case .outOfStock:
//                    return nil
//                }
//            }
//            set {
        ////        switch self {
        ////        case .inStock:
        ////          self = .inStock(quantity: newValue)
        ////        case .outOfStock:
        ////          break
        ////        }
//                guard let quantity = newValue else { return }
//                self = .inStock(quantity: quantity)
//            }
//        }
//
//        var isOnBackOrder: Bool? {
//            get {
//                guard case let .outOfStock(isOnBackOrder) = self else {
        ////                    return false
        ////          return true
//                    return nil
//                }
//                return isOnBackOrder
//            }
//            set {
        ////        switch self {
        ////        case .inStock:
        ////          break
        ////        case .outOfStock:
//                guard let newValue = newValue else { return }
//                self = .outOfStock(isOnBackOrder: newValue)
        ////        }
//            }
//        }
    }

    enum Color: String, CaseIterable {
        case blue
        case green
        case black
        case red
        case yellow
        case white
    }

    //  static func inStock(
//    name: String,
//    color: Color?,
//    quantity: Int
    //  ) -> Self {
//    Item(name: name, color: color, quantity: quantity, isInStock: true, isOnBackOrder: false)
    //  }
//
    //  static func outOfStock(
//    name: String,
//    color: Color?,
//    isOnBackOrder: Bool
    //  ) -> Self {
//    Item(name: name, color: color, quantity: 0, isInStock: false, isOnBackOrder: isOnBackOrder)
    //  }
}

struct ItemView: View {
    @Binding var item: Item

    var body: some View {
        Form {
            TextField("Name", text: self.$item.name)

            Picker(selection: self.$item.color, label: Text("Color")) {
                Text("None")
                    .tag(Item.Color?.none)

                ForEach(Item.Color.allCases, id: \.rawValue) { color in
                    Text(color.rawValue)
                        .tag(Optional(color))
                }
            }

            // (Binding<Int?>) -> Binding<Int>?
            // unwrap: (Binding<A?>) -> Binding<A>?
//          self.$item.status.quantity.unwrap()
//            self.$item.status.matching(/Item.Status.inStock)
//            self.$item.status[/Item.Status.inStock]
//                .map { (quantity: Binding<Int>) in
            if let quantity = self.$item.status[/Item.Status.inStock] {
                    Section(header: Text("In stock")) {
                        Stepper("Quantity: \(quantity.wrappedValue)", value: quantity)
                        Button("Mark as sold out") {
                            self.item.status = .outOfStock(isOnBackOrder: false)
                        }
                    }
                }

//          self.$item.status.isOnBackOrder.unwrap()
//            self.$item.status.matching(/Item.Status.outOfStock)
//            self.$item.status[/Item.Status.outOfStock]
//                .map { isOnBackOrder in
            if let isOnBackOrder = self.$item.status[/Item.Status.outOfStock] {
                Section(header: Text("Out of stock")) {
                    Toggle(
                        "Is on back order?",
                        isOn: isOnBackOrder
                    )
                    Button("Is back in stock!") {
                        self.item.status = .inStock(quantity: 1)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        struct Wrapper: View {
            @State var item = Item(name: "Keyboard", color: .green, status: .inStock(quantity: 1))

            var body: some View {
                ItemView(item: self.$item)
            }
        }

        return NavigationView {
            Wrapper()
        }
    }
}

struct User {
    var id: Int
    var name: String
}

func foo() {
    let tmp = \User.id
    var user = User(id: 42, name: "Blob")
    user[keyPath: \User.id] = 100
    let id = user[keyPath: \User.id]

    let intStockCasePath: CasePath<Item.Status, Int>
        = /Item.Status.inStock
//      = .case(Item.Status.inStock)
//      = CasePath<Item.Status, Int>(
//          embed: Item.Status.inStock(quantity:),
//          extract: { status in
//              guard case let .inStock(quantity) = status else { return nil }
//              return quantity
//          }
//        )

    let status = Item.Status.inStock(quantity: 100)
    let quantity = intStockCasePath.extract(from: status)
    let newStatus = intStockCasePath.embed(100)
}
