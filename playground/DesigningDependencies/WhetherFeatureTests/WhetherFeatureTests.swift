//
//  WhetherFeatureTests.swift
//  WhetherFeatureTests
//
//  Created by Wasin Passornpakorn on 6/8/20.
//

import Combine
import CoreLocation
import LocationClient
import PathMonitorClient
@testable import WhetherClient
@testable import WhetherFeature
import XCTest

/*** Tips
 - Testing mock not implementation:
 let locationClient = LocationClient.authorizedWhenInUse
 locationClient: LocationClient(
     authorizationStatus: locationClient.authorizationStatus,
     requestWhenInUseAuthorization: { fatalError() },
     requestLocation: locationClient.requestLocation,
     delegate: Empty(completeImmediately: false).eraseToAnyPublisher() ==> show that it test mock. It show error two location below
 ),

 - Mock data should very lightweight to construct and to customize,
 so maybe we can extract these values out as static members that can be plucked out of air quite easily, and shared over many tests.

 */

extension WeatherResponse {
    static let moderateWeather = WeatherResponse(
        consolidatedWeather: [
            .init(
                applicableDate: Date(timeIntervalSinceReferenceDate: 0),
                id: 1,
                maxTemp: 30,
                minTemp: 20,
                theTemp: 25
            ),
        ]
    )
}

extension Location {
    static let brooklyn = Location(woeid: 1, title: "Brooklyn")
}

extension AnyPublisher {
    init(_ value: Output) {
        self = Just(value).setFailureType(to: Failure.self).eraseToAnyPublisher()
    }
}

extension WhetherClient {
    static let unimplemented = Self(
        weather: { _ in fatalError() },
        searchLocations: { _ in fatalError() }
    )
}

class WhetherFeatureTests: XCTestCase {
    func testBasics() {
        let viewModel = AppViewModel(
            locationClient: .authorizedWhenInUse,
            pathMonitorClient: .satisfied,
            weatherClient: WhetherClient(
                weather: { _ in .init(.moderateWeather) },
                searchLocations: { _ in .init([.brooklyn]) }
            )
        )

        XCTAssertEqual(viewModel.currentLocation, .brooklyn)
        XCTAssertEqual(viewModel.isConnected, true)
        XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
    }

    func testDisconnected() {
        let viewModel = AppViewModel(
            locationClient: .authorizedWhenInUse,
            pathMonitorClient: .unsatisfied,
            weatherClient: .unimplemented
        )
        
        XCTAssertEqual(viewModel.currentLocation, nil)
        XCTAssertEqual(viewModel.isConnected, false)
        XCTAssertEqual(viewModel.weatherResults, [])
    }
    
    func testPathUpdates() {
        let pathUpdateSubject = PassthroughSubject<NetworkPath, Never>()
        let viewModel = AppViewModel(
            locationClient: .authorizedWhenInUse,
            pathMonitorClient: PathMonitorClient(networkPathPublisher: pathUpdateSubject.eraseToAnyPublisher()),
            weatherClient: WhetherClient(
                weather: { _ in .init(.moderateWeather) },
                searchLocations: { _ in .init([.brooklyn]) }
            )
        )
        
        pathUpdateSubject.send(.init(status: .satisfied))
        XCTAssertEqual(viewModel.currentLocation, .brooklyn)
        XCTAssertEqual(viewModel.isConnected, true)
        XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
        
        pathUpdateSubject.send(.init(status: .unsatisfied))
        XCTAssertEqual(viewModel.currentLocation, .brooklyn)
        XCTAssertEqual(viewModel.isConnected, false)
        XCTAssertEqual(viewModel.weatherResults, [])
        
        pathUpdateSubject.send(.init(status: .satisfied))
        XCTAssertEqual(viewModel.currentLocation, .brooklyn)
        XCTAssertEqual(viewModel.isConnected, true)
        XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
    }
    
    func testLocationAuthorization() {
        let locationDelegateSubject = PassthroughSubject<LocationClient.DelegateEvent, Never>()
        var authroizationStatus = CLAuthorizationStatus.notDetermined
        let viewModel = AppViewModel(
            locationClient: LocationClient(
                authorizationStatus: { authroizationStatus },
                requestWhenInUseAuthorization: {
                    authroizationStatus = .authorizedWhenInUse
                    locationDelegateSubject.send(.didChangeAuthorization(authroizationStatus))
                },
                requestLocation: {
                    locationDelegateSubject.send(.didUpdateLocations([CLLocation()]))
                },
                delegate: locationDelegateSubject.eraseToAnyPublisher()),
            pathMonitorClient: .satisfied,
            weatherClient:  WhetherClient(
                weather: { _ in .init(.moderateWeather) },
                searchLocations: { _ in .init([.brooklyn]) }
            )
        )
        XCTAssertEqual(viewModel.currentLocation, nil)
        XCTAssertEqual(viewModel.isConnected, true)
        XCTAssertEqual(viewModel.weatherResults, [])
        
        viewModel.locationButtonTapped()
        XCTAssertEqual(viewModel.currentLocation, .brooklyn)
        XCTAssertEqual(viewModel.isConnected, true)
        XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
    }
    
    func testLocationAuthorizationDenied() {
        let locationDelegateSubject = PassthroughSubject<LocationClient.DelegateEvent, Never>()
        var authroizationStatus = CLAuthorizationStatus.notDetermined
        let viewModel = AppViewModel(
            locationClient: LocationClient(
                authorizationStatus: { authroizationStatus },
                requestWhenInUseAuthorization: {
                    authroizationStatus = .denied
                    locationDelegateSubject.send(.didChangeAuthorization(authroizationStatus))
                },
                requestLocation: { fatalError() },
                delegate: locationDelegateSubject.eraseToAnyPublisher()),
            pathMonitorClient: .satisfied,
            weatherClient:  WhetherClient(
                weather: { _ in .init(.moderateWeather) },
                searchLocations: { _ in .init([.brooklyn]) }
            )
        )
        XCTAssertEqual(viewModel.currentLocation, nil)
        XCTAssertEqual(viewModel.isConnected, true)
        XCTAssertEqual(viewModel.weatherResults, [])
        
        viewModel.locationButtonTapped()
        XCTAssertEqual(viewModel.currentLocation, nil)
        XCTAssertEqual(viewModel.isConnected, true)
        XCTAssertEqual(viewModel.weatherResults, [])
    }
}
