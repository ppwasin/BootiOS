//
//  WhetherClientInterface.swift
//  DesigningDependencies
//
//  Created by Wasin Passornpakorn on 6/8/20.
//

import Combine
import CoreLocation
import Foundation

/// A Client for accessing whether data for locations.
struct WhetherClient {
    var weather: () -> AnyPublisher<WeatherResponse, Error>
    var searchLocations: (CLLocationCoordinate2D) -> AnyPublisher<[Location], Error>
}

struct WeatherResponse: Decodable, Equatable {
    var consolidatedWeather: [ConsolidatedWeather]

    struct ConsolidatedWeather: Decodable, Equatable {
        var applicableDate: Date
        var id: Int
        var maxTemp: Double
        var minTemp: Double
        var theTemp: Double
    }
}

struct Location {}
