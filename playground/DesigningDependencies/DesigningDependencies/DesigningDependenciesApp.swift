//
//  DesigningDependenciesApp.swift
//  DesigningDependencies
//
//  Created by Wasin Passornpakorn on 5/8/20.
//

import SwiftUI
import WhetherClientLive
import WhetherFeature
import PathMonitorClientLive
import LocationClientLive

@main
struct DesigningDependenciesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: AppViewModel(
                            pathMonitorClient: .live(queue: DispatchQueue.main),
                            weatherClient: .live,
                            locationClient: .live))
        }
    }
}
