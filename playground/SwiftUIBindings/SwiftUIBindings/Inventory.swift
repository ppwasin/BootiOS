//
//  InventorListView.swift
//  SwiftUIBindings
//
//  Created by Wasin Passornpakorn on 26/7/20.
//

import Combine
import Foundation
import SwiftUI

class InventoryViewModel: ObservableObject {
    @Published var draft: Item?
    @Published var inventory: [Item]
    init(inventory: [Item] = []) {
        self.inventory = inventory
    }

    func addButtonTapped() {
        self.draft = Item(name: "", color: nil, status: .inStock(quantity: 1))
    }

    func cancelButtonTapped() {
        self.draft = nil
    }

    func saveButtonTapped() {
        if let item = self.draft {
            self.inventory.append(item)
        }
        self.draft = nil
    }

    func duplicate(item: Item) {
        self.draft = Item(name: item.name, color: item.color, status: item.status)
    }
}

struct InventoryView: View {
    @ObservedObject var viewModel: InventoryViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(self.viewModel.inventory, id: \.self) { item in
//                    NavigationLink(destination: ItemView(item: item)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)

                                Group { () -> Text in
                                    switch item.status {
                                    case let .inStock(quantity):
                                        return Text("In stock: \(quantity)")
                                    case let .outOfStock(isOnBackOrder):
                                        return Text("Out of stock" + (isOnBackOrder ? ": on back order" : ""))
                                    }
                                }
                            }

                            Spacer()

                            item.color.map { color in
                                Rectangle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(color.toSwiftUIColor)
                                    .border(Color.black, width: 1)
                            }

                            Button(action: { self.viewModel.duplicate(item: item) }) {
                                Image(systemName: "doc.on.doc.fill")
                            }
                            .padding(.leading)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(item.status.isInStock ? nil : Color.gray)
                    }
//                }
            }
            .navigationBarTitle("Inventory")
            .navigationBarItems(
                trailing: Button("Add") { self.viewModel.addButtonTapped() }
            )
            .sheet(unwrap: self.$viewModel.draft) { item: Binding<Item> in
                NavigationView {
                    ItemView(item: item)
                        .navigationBarItems(
                            leading: Button("Cancel") { self.viewModel.cancelButtonTapped() },
                            trailing: Button("Save") { self.viewModel.saveButtonTapped() }
                        )
                }
            }
        }
    }
}

struct Inventory_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView(
            viewModel: InventoryViewModel(
                inventory: [
                    Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100)),
                    Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20)),
                    Item(name: "Phone", color: .green, status: .outOfStock(isOnBackOrder: true)),
                    Item(name: "Headphones", color: .green, status: .outOfStock(isOnBackOrder: false)),
                ]
            )
        )
    }
}
