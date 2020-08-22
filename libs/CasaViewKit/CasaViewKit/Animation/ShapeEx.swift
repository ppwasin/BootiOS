//
//  ShapeEx.swift
//  CasaViewKit
//
//  Created by Wasin Passornpakorn on 12/7/20.
//

import SwiftUI

struct ShapeEx: View {
    @State private var insetAmount: CGFloat = 50

    var body: some View {
        VStack {
            Text("\(insetAmount)")
            Trapezoid(insetAmount: insetAmount)
                .frame(width: 200, height: 100)
                .onTapGesture {
                    // when we use withAnimation(), SwiftUI immediately changes our state property to its new value, but behind the scenes it’s also keeping track of the changing value over time as part of the animation.
                    //As the animation progresses, SwiftUI will set the animatableData property of our shape to the latest value
                    withAnimation {
                        self.insetAmount = CGFloat.random(in: 10...90)
                    }
                }
        }
    }
}

struct Trapezoid: Shape {
    var insetAmount: CGFloat
    var animatableData: CGFloat {
        get { insetAmount }
        set { insetAmount = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        return path
    }
}

struct ShapeEx_Previews: PreviewProvider {
    static var previews: some View {
        ShapeEx()
    }
}
