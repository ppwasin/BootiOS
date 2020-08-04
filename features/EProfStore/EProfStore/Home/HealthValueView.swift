//
//  HealthValueView.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 4/8/20.
//

import SwiftUI

struct HealthValueView: View {
    var value: String
    var unit: String

    @ScaledMetric var size: CGFloat = 1

    @ViewBuilder var body: some View {
        HStack {
            Text(value).font(.system(size: 24 * size, weight: .bold, design: .rounded)) + Text(" \(unit)").font(.system(size: 14 * size, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct HealthValueView_Previews: PreviewProvider {
    static var previews: some View {
        HealthValueView(value: "Value", unit: "Unit")
    }
}
