//
//  CheckboxButton.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 4/8/20.
//

import SwiftUI

enum CheckboxType {
    case rectangle
    case circular
    case capsule(maxWidth: CGFloat = 200)
}

struct CheckboxButton: View {
    @State var trimVal: CGFloat = 0
    @State var checked = false
    let type: CheckboxType
    
    @State var removeText: Bool = false
    @State var width: CGFloat = 200
    var body: some View {
        switch type {
        case .rectangle:
            CheckboxView(checked: self.$checked, trimVal: self.$trimVal)
                .onTapGesture { self.onTapped() }
        case .circular:
            CircularCheckboxView(checked: self.$checked, trimVal: self.$trimVal)
                .onTapGesture { self.onTapped() }
        case .capsule(let maxWidth):
            CapsuleCheckboxView(checked: self.$checked, trimVal: self.$trimVal, width: self.$width, removeText: self.$removeText)
                .onTapGesture { self.onCapsuleTapped(maxWidth: maxWidth) }
        }
    }

    private func onTapped() {
        if checked {
            withAnimation(Animation.easeIn(duration: 0.7)) {
                self.trimVal = 0
                self.checked.toggle()
            }
        } else {
            withAnimation(Animation.easeIn(duration: 0.7)) {
                self.trimVal = 1
                self.checked.toggle()
            }
        }
    }
    private func onCapsuleTapped(maxWidth: CGFloat) {
        if !checked {
            self.removeText.toggle()
            withAnimation{
                self.width = 70
            }
            withAnimation(Animation.easeIn(duration: 0.7)) {
                self.trimVal = 1
                self.checked.toggle()
            }
        } else {
            withAnimation {
                self.trimVal = 0
                self.width = maxWidth
                self.checked.toggle()
                self.removeText.toggle()
            }
        }
    }
}

struct CheckboxButton_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CheckboxButton(type: .rectangle)
            CheckboxButton(type: .circular)
            CheckboxButton(type: .capsule())
        }
    }
}
