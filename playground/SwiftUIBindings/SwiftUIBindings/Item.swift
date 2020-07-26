//
//  Item.swift
//  SwiftUIBindings
//
//  Created by Wasin Passornpakorn on 26/7/20.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    var name: String
    var color: Color?
    var status: Status

    enum Status: Hashable {
        case inStock(quantity: Int)
        case outOfStock(isOnBackOrder: Bool)
        var isInStock: Bool {
            guard case .inStock = self else { return false }
            return true
        }
    }

    enum Color: String, CaseIterable {
        case blue
        case green
        case black
        case red
        case yellow
        case white
        var toSwiftUIColor: SwiftUI.Color {
            switch self {
            case .blue:
                return .blue
            case .green:
                return .green
            case .black:
                return .black
            case .red:
                return .red
            case .yellow:
                return .yellow
            case .white:
                return .white
            }
        }
    }
}
