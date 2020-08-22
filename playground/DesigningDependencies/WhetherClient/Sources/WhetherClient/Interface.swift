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
public struct WhetherClient {
    public init(weather: @escaping (Int) -> AnyPublisher<WeatherResponse, Error>, searchLocations: @escaping (CLLocationCoordinate2D) -> AnyPublisher<[Location], Error>) {
        self.weather = weather
        self.searchLocations = searchLocations
    }
    
    public var weather: (Int) -> AnyPublisher<WeatherResponse, Error>
    public var searchLocations: (CLLocationCoordinate2D) -> AnyPublisher<[Location], Error>
    
}

public struct WeatherResponse: Decodable, Equatable {
    public var consolidatedWeather: [ConsolidatedWeather]

    public struct ConsolidatedWeather: Decodable, Equatable {
        public var applicableDate: Date
        public var id: Int
        public var maxTemp: Double
        public var minTemp: Double
        public var theTemp: Double
    }
}

public struct Location: Decodable {
    public var title: String
    public var woeid: Int
}
