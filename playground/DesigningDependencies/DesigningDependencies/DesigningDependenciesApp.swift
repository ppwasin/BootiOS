//
//  DesigningDependenciesApp.swift
//  DesigningDependencies
//
//  Created by Wasin Passornpakorn on 5/8/20.
//

import LocationClientLive
import PathMonitorClientLive
import SwiftUI
import WhetherClientLive
import WhetherFeature

@main
struct DesigningDependenciesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: AppViewModel(
                locationClient: .live,
                pathMonitorClient: .live(queue: DispatchQueue.main),
                weatherClient: .live
            ))
        }
    }
}
