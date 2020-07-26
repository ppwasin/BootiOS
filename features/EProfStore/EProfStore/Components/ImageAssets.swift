//
//  SearchImage.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 19/7/20.
//

import SwiftUI

extension Image {
    enum Assets {
        case Search
    }

    init(assets: Assets) {
        switch assets {
        case .Search:
            self.init(systemName: "magnifyingglass")
        }
    }
}
