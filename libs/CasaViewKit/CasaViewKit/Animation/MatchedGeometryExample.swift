//
//  MatchedGeometryExample.swift
//  CasaViewKit
//
//  Created by Wasin Passornpakorn on 11/7/20.
//

import SwiftUI

struct WithoutExample: View {
    @State private var isExpanded = false

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.pink)
            .frame(width: isExpanded ? 100 : 60, height: isExpanded ? 100 : 60)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
    }
}

// iOS 14+
struct CircleTextExample: View {
    @Namespace private var animation
    @State private var isFlipped = false

    var body: some View {
        VStack {
            if isFlipped {
                Circle()
                    .fill(Color.red)
                    .frame(width: 44, height: 44)
                    .matchedGeometryEffect(id: "Shape", in: animation)

                Text("Taylor Swift – 1989")
                    .font(.headline)
                    .matchedGeometryEffect(id: "AlbumTitle", in: animation)

            } else {
                Text("Taylor Swift – 1989")
                    .font(.headline)
                    .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 44, height: 44)
                    .matchedGeometryEffect(id: "Shape", in: animation)
            }
        }
        .onTapGesture {
            withAnimation {
                self.isFlipped.toggle()
            }
        }
    }
}

struct ZoomExample: View {
    @Namespace private var animation
    @State private var isZoomed = false

    var frame: CGFloat {
        isZoomed ? 300 : 44
    }

    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: frame, height: frame)
                    .padding(.top, isZoomed ? 20 : 0)

                if isZoomed == false {
                    Text("Taylor Swift – 1989")
                        .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                        .font(.headline)
                    Spacer()
                }
            }

            if isZoomed == true {
                Text("Taylor Swift – 1989")
                    .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                    .font(.headline)
                    .padding(.bottom, 60)
                Spacer()
            }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                self.isZoomed.toggle()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: isZoomed ? 400 : 60)
        .background(Color(white: 0.9))
    }
}

struct ChangeStack: View {
    @State private var isExpanded = false
    @Namespace private var namespace // <1>

    var body: some View {
        Group {
            if isExpanded {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.pink)
                        .frame(width: 60, height: 60)
                        .matchedGeometryEffect(id: "rect", in: namespace) // <2>
                    Text("Hello SwiftUI!").fontWeight(.semibold)
                        .matchedGeometryEffect(id: "text", in: namespace) // <3>
                }
            } else {
                HStack {
                    Text("Hello SwiftUI!").fontWeight(.semibold)
                        .matchedGeometryEffect(id: "text", in: namespace) // <4>
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.pink)
                        .frame(width: 60, height: 60)
                        .matchedGeometryEffect(id: "rect", in: namespace) // <5>
                }
            }
        }.onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}

struct PassNameSpace: View {
    @State private var isExpanded = false
    @Namespace private var namespace

    var body: some View {
        Group {
            if isExpanded {
                VerticalView(namespace: namespace)
            } else {
                HorizontalView(namespace: namespace)
            }
        }.onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}

struct VerticalView: View {
    var namespace: Namespace.ID

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.pink)
                .frame(width: 60, height: 60)
                .matchedGeometryEffect(id: "rect", in: namespace, properties: .frame)
            Text("Hello SwiftUI!").fontWeight(.semibold)
                .matchedGeometryEffect(id: "text", in: namespace)
        }
    }
}

struct HorizontalView: View {
    var namespace: Namespace.ID

    var body: some View {
        HStack {
            Text("Hello SwiftUI!").fontWeight(.semibold)
                .matchedGeometryEffect(id: "text", in: namespace)
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.pink)
                .frame(width: 60, height: 60)
                .matchedGeometryEffect(id: "rect", in: namespace, properties: .frame)
        }
    }
}

struct MatchedGeometryExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    WithoutExample()
                    Divider().frame(height: 3).background(Color.black)
                    CircleTextExample()
                    Divider().frame(height: 3).background(Color.black)
                    ZoomExample()
                    Divider().frame(height: 3).background(Color.black)
                    ChangeStack()
                    Divider().frame(height: 3).background(Color.black)
                    PassNameSpace()
                }

            }.navigationTitle("Animation Examples")
        }
    }
}
