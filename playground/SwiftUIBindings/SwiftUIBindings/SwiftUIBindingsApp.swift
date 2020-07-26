//
//  SwiftUIBindingsApp.swift
//  SwiftUIBindings
//
//  Created by Wasin Passornpakorn on 18/7/20.
//

import SwiftUI

@main
struct SwiftUIBindingsApp: App {
    var body: some Scene {
        WindowGroup {
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
}
