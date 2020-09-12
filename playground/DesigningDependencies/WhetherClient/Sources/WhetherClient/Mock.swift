//
//  MockWhetherClient.swift
//  DesigningDependencies
//
//  Created by Wasin Passornpakorn on 6/8/20.
//

import Foundation
import Combine

extension WhetherClient {
    public static let empty = Self(
        weather: { _ in
            Just(WeatherResponse(consolidatedWeather: []))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        },
        searchLocations: { _ in
            Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    )
    public static let happyPath = Self(
        weather: { _ in
            Just(
                WeatherResponse(
                    consolidatedWeather: [
                        .init(applicableDate: Date(), id: 1, maxTemp: 30, minTemp: 10, theTemp: 20),
                        .init(applicableDate: Date().addingTimeInterval(86400), id: 2, maxTemp: -10, minTemp: -30, theTemp: -20)
                    ]
                )
            )
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }, searchLocations: { _ in
            Just([Location(woeid: 1, title: "New York")])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    )

    public static let failed = Self(
        weather: { _ in
            Fail(error: NSError(domain: "", code: 1))
                .eraseToAnyPublisher()
        }, searchLocations: { _ in
            Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    )
}
