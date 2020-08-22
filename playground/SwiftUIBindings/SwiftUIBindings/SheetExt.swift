//
//  SheetExt.swift
//  SwiftUIBindings
//
//  Created by Wasin Passornpakorn on 26/7/20.
//

import SwiftUI

extension View {
    func sheet<Content, Item>(
        unwrap item: Binding<Item?>,
        content: @escaping (Binding<Item>) -> Content
    ) -> some View where Content: View, Item: Identifiable {
        self.sheet(item: item) { _ in
            item.unwrap().map { item in
                content(item)
            }
        }
    }
}
