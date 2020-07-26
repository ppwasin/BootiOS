//
//  HeaderView.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 19/7/20.
//

import Combine
import SwiftUI

class OrientationModel: ObservableObject {
    @Published var isLandscape: Bool = false
}

struct HeaderView: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    var bgColor: Color
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Ellipse()
                    .fill(self.bgColor)
                    .frame(width: geometry.size.width * 1.4,
                           height: geometry.size.height * 0.33)
                    .position(x: geometry.size.width / 2.35,
                              y: geometry.size.height * 0.1)
                    .shadow(radius: 3)
                    .edgesIgnoringSafeArea(.all)

                HStack {
                    VStack(alignment: .leading) {
                        Text("\(geometry.size.width), \(geometry.size.height)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)

                        Text(self.subtitle)
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding(.leading, 25)
                    .padding(.top, 30)
                    Spacer()
                }
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Groups", subtitle: "Choose a group to connect", bgColor: Color.blue)
    }
}
