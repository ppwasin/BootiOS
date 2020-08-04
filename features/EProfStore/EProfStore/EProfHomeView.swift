//
//  EProfHomeView.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 4/8/20.
//

import SwiftUI

struct EProfHomeView: View {
    var body: some View {
        ScrollView{
            Searchbar(text: "Test")
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Spacer()
        }
        
    }
}

struct EProfHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EProfHomeView()
    }
}
