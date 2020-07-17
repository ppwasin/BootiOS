//
//  Example1.swift
//  CasaViewKit
//
//  Created by Wasin Passornpakorn on 11/7/20.
//

import SwiftUI

struct ImplicitEx: View {
    @State private var half = false
    @State private var dim = false

    var body: some View {
        Image(systemName: "paperplane.fill")
            .font(.system(size: 100.0))
            .scaleEffect(half ? 0.5 : 1.0)
            .opacity(dim ? 0.2 : 1.0)
            .animation(.easeInOut(duration: 1.0)) //Try move above
            .onTapGesture {
                self.dim.toggle()
                self.half.toggle()
            }
    }
}

struct ExplicitEx: View {
    @State private var half = false
    @State private var dim = false

    var body: some View {
        Image(systemName: "person")
            .font(.system(size: 100.0))
            .scaleEffect(half ? 0.5 : 1.0)
            .opacity(dim ? 0.2 : 1.0)
            .onTapGesture {
                self.half.toggle()
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.dim.toggle()
                }
            }
    }
}

struct Example1_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Text("Animate Both")
                ImplicitEx()
                Divider().frame(height: 3).background(Color.black)
                Text("Animate only Opacity")
                ExplicitEx()
            }
        }
    }
}
