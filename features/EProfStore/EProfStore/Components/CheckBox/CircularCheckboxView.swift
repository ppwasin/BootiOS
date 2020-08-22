//
//  CircularCheckboxView.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 4/8/20.
//

import SwiftUI

struct CircularCheckboxView: View {
    @Binding var checked: Bool
    @Binding var trimVal: CGFloat
    var animatedData: CGFloat {
        get { trimVal }
        set { trimVal = newValue }
    }

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: trimVal)
                .stroke(style: StrokeStyle(lineWidth: 2))
                .frame(width: 70, height: 70)
                .foregroundColor(checked ? Color.green : Color.gray.opacity(0.2))
                .overlay(
                    Circle()
                        .fill(self.checked ? Color.green : Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                )

            if checked {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.white)
            }
        }
    }
}

struct CircularCheckboxView_Previews: PreviewProvider {
    static var previews: some View {
        CircularCheckboxView(checked: .constant(true), trimVal: .constant(1.0))
    }
}
