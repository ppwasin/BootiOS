//
//  File.swift
//
//
//  Created by Wasin Passornpakorn on 22/8/20.
//

import Combine
import CoreLocation

extension LocationClient {
    public static var authorizedWhenInUse: Self {
        let subject = PassthroughSubject<DelegateEvent, Never>()
        return Self(
            authorizationStatus: { .authorizedWhenInUse },
            requestWhenInUseAuthorization: {},
            requestLocation: { subject.send(.didUpdateLocations([CLLocation()])) },
            delegate: subject.eraseToAnyPublisher()
        )
    }

    public static var notDetermined: Self {
        var status = CLAuthorizationStatus.notDetermined
        let subject = PassthroughSubject<DelegateEvent, Never>()

        return Self(
            authorizationStatus: { status },
            requestWhenInUseAuthorization: {
                status = .authorizedWhenInUse
                subject.send(.didChangeAuthorization(status))
            },
            requestLocation: {
                subject.send(.didUpdateLocations([CLLocation()]))
            },
            delegate: subject.eraseToAnyPublisher()
        )
    }
}
