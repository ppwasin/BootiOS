//
//  CapsuleCheckboxView.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 4/8/20.
//

import SwiftUI

struct CapsuleCheckboxView: View {
    @Binding var checked: Bool
    @Binding var trimVal: CGFloat
    @Binding var width: CGFloat
    @Binding var removeText: Bool
    var animatedData: CGFloat {
        get { trimVal }
        set { trimVal = newValue }
    }

    var body: some View {
        ZStack {
            Capsule()
                .trim(from: 0, to: trimVal)
                .stroke(style: StrokeStyle(lineWidth: 2))
                .frame(width: width, height: 70)
                .foregroundColor(checked ? Color.green : Color.gray.opacity(0.2))
                .overlay(
                    Capsule()
                        .fill(self.checked ? Color.green : Color.gray.opacity(0.2))
                        .frame(width: width - 10, height: 60)
                )

            if checked {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.white)
                    .opacity(Double(trimVal))
            }

            if !removeText {
                Text("Check Mark")
            }
        }
    }
}

struct CapsuleCheckboxView_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleCheckboxView(
            checked: .constant(false),
            trimVal: .constant(0),
            width: .constant(200),
            removeText: .constant(true)
        )
    }
}
