import CasePaths
import SwiftUI

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

// struct User {
//    var id: Int
//    var name: String
// }
//
// func foo() {
//    let tmp = \User.id
//    var user = User(id: 42, name: "Blob")
//    user[keyPath: \User.id] = 100
//    let id = user[keyPath: \User.id]
//
//    let intStockCasePath: CasePath<Item.Status, Int>
//        = /Item.Status.inStock
////      = .case(Item.Status.inStock)
////      = CasePath<Item.Status, Int>(
////          embed: Item.Status.inStock(quantity:),
////          extract: { status in
////              guard case let .inStock(quantity) = status else { return nil }
////              return quantity
////          }
////        )
//
//    let status = Item.Status.inStock(quantity: 100)
//    let quantity = intStockCasePath.extract(from: status)
//    let newStatus = intStockCasePath.embed(100)
// }
