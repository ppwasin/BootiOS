//
//  File.swift
//
//
//  Created by Wasin Passornpakorn on 22/8/20.
//

import Combine
import CoreLocation
import Foundation
import LocationClient

extension LocationClient {
    public static var live: Self {
        class Delegate: NSObject, CLLocationManagerDelegate {
            let subject: PassthroughSubject<DelegateEvent, Never>

            init(subject: PassthroughSubject<DelegateEvent, Never>) {
                self.subject = subject
            }

            func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                self.subject.send(.didChangeAuthorization(status))
            }

            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                self.subject.send(.didUpdateLocations(locations))
            }

            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                self.subject.send(.didFailWithError(error))
            }
        }
        let manager = CLLocationManager()
        let subject = PassthroughSubject<DelegateEvent, Never>()
        var delegate: Delegate? = Delegate(subject: subject)
        manager.delegate = delegate
        return Self(
            authorizationStatus: {
                if #available(iOS 14.0, *) {
                    return manager.authorizationStatus()
                } else {
                    return CLLocationManager.authorizationStatus()
                }
            },
            requestWhenInUseAuthorization: manager.requestWhenInUseAuthorization,
            requestLocation: manager.requestLocation,
            delegate: subject
                .handleEvents(receiveCancel: {
                                delegate = nil
                    
                }) // since manager.delegate is weak ref. So need to have bind the delegate with relay lifetime
                .eraseToAnyPublisher()
        )
    }
}
