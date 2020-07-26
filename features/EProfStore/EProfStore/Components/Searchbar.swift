//
//  Searchbar.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 18/7/20.
//

import Combine
import SwiftUI

struct Searchbar: View {
    @State var text: String
    @State private var isEditing = false
    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }.overlay(
                    HStack {
                        Image(assets: .Search)
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        if isEditing {
                            Button(action: {
                                print("test")
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }.padding(.horizontal, 8)
                )

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

class SearchTextWrapper: ObservableObject {
    @Published var searchText = ""
}

struct Searchbar_Previews: PreviewProvider {
    static var previews: some View {
        Searchbar(text: "")
    }
}
