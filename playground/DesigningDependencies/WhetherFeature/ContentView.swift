//
//  ContentView.swift
//  DesigningDependencies
//
//  Created by Wasin Passornpakorn on 5/8/20.
//

import Combine
import CoreLocation
import PathMonitorClient
import SwiftUI
import WhetherClient

public struct LocationClient {
    var authorizationStatus: () -> CLAuthorizationStatus
    var requestWhenInUseAuthorization: () -> Void
    var requestLocation: () -> Void
    var delegate: AnyPublisher<DelegateEvent, Never>
    enum DelegateEvent {
        case didChangeAuthorization(CLAuthorizationStatus)
        case didUpdateLocations([CLLocation])
        case didFailWithError(Error)
    }
}

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
            authorizationStatus: manager.authorizationStatus,
            requestWhenInUseAuthorization: manager.requestWhenInUseAuthorization,
            requestLocation: manager.requestLocation,
            delegate: subject
                .handleEvents(receiveCancel: { delegate = nil }) // since manager.delegate is weak ref. So need to have bind the delegate with relay lifetime
                .eraseToAnyPublisher()
        )
    }
}

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

public class AppViewModel: ObservableObject {
    @Published var isConnected = true
    @Published var weatherResults: [WeatherResponse.ConsolidatedWeather] = []
    @Published var currentLocation: Location?

    private var weatherRequestCancellable: AnyCancellable?
    private var pathUpdateCancellable: AnyCancellable?
    private var searchLocationCancellable: AnyCancellable?
    private let weatherClient: WhetherClient
    private let pathMonitorClient: PathMonitorClient
    private let locationClient: LocationClient
    public init(
        pathMonitorClient: PathMonitorClient,
        weatherClient: WhetherClient,
        locationClient: LocationClient
    ) {
        self.pathMonitorClient = pathMonitorClient
        self.weatherClient = weatherClient
        self.locationClient = locationClient
        // 1
//        let pathMonitor = NWPathMonitor()
//        pathMonitor.pathUpdateHandler = { [weak self] path in

        // 2
//        self.pathMonitorClient.setPathUpdateHandler { [weak self] path in
//            guard let self = self else { return }
//            self.isConnected = path.status == .satisfied
//            if self.isConnected {
//                self.refreshWhether()
//            } else {
//                self.weatherResults = []
//            }
//        }
//        self.pathMonitorClient.start(.main)

        self.pathUpdateCancellable = self.pathMonitorClient.networkPathPublisher
            .map { $0.status == .satisfied }
            .removeDuplicates()
            .sink(receiveValue: { [weak self] isConnected in
                guard let self = self else { return }
                self.isConnected = isConnected
                if self.isConnected {
                    self.refreshWeather()
                } else {
                    self.weatherResults = []
                }
            })

        self.searchLocationCancellable = locationClient.delegate
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .didChangeAuthorization(let status):
                    switch status {
                    case .notDetermined:
                        break
                    case .restricted:
                        // TODO: alert, cool that ok
                        break
                    case .denied:
                        // TODO: alert, cool that ok
                        break
                    case .authorizedAlways, .authorizedWhenInUse:
                        self.locationClient.requestLocation()
                    @unknown default:
                        break
                    }
                case .didUpdateLocations(let locations):
                    guard let location = locations.first else { return }

                    self.searchLocationCancellable = self.weatherClient
                        .searchLocations(location.coordinate)
                        .sink(
                            receiveCompletion: { _ in },
                            receiveValue: { [weak self] locations in
                                self?.currentLocation = locations.first
                                self?.refreshWeather()
                            }
                        )
                case .didFailWithError:
                    break
                }
            }
        
        if self.locationClient.authorizationStatus() == .authorizedWhenInUse {
            self.locationClient.requestLocation()
        }
    }

    // cancel happend automatically when viewModel release
    // 2
//    deinit {
//        self.pathMonitorClient.cancel()
//    }

    func refreshWeather() {
        guard let currentLocation = currentLocation else { return }
        self.weatherResults = []
        self.weatherRequestCancellable = self.weatherClient
            .weather(currentLocation.woeid)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] response in
                    self?.weatherResults = response.consolidatedWeather
                }
            )
    }

    func locationButtonTapped() {
        switch self.locationClient.authorizationStatus() {
        case .notDetermined:
            self.locationClient.requestWhenInUseAuthorization()
        case .restricted:
            // TODO: alert
            break
        case .denied:
            // TODO: alert
            break
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationClient.requestLocation()
        @unknown default:
            break
        }
    }
}

public struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    public init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ZStack(alignment: .bottomTrailing) {
                    List {
                        ForEach(self.viewModel.weatherResults, id: \.id) { weather in
                            VStack(alignment: .leading) {
                                Text(dayOfWeekFormatter.string(from: weather.applicableDate).capitalized)
                                    .font(.title)

                                Text("Current temp: \(weather.theTemp, specifier: "%.1f")°C")
                                Text("Max temp: \(weather.maxTemp, specifier: "%.1f")°C")
                                Text("Min temp: \(weather.minTemp, specifier: "%.1f")°C")
                            }
                        }
                    }

                    Button(
                        action: self.viewModel.locationButtonTapped
                    ) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                    }
                    .background(Color.black)
                    .clipShape(Circle())
                    .padding()
                }

                if !self.viewModel.isConnected {
                    HStack {
                        Image(systemName: "exclamationmark.octagon.fill")

                        Text("Not connected to internet")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                }
            }
            .navigationBarTitle(self.viewModel.currentLocation?.title ?? "Weather")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView(
            viewModel: AppViewModel(
                pathMonitorClient: .satisfied,
                weatherClient: .happyPath,
                locationClient: .notDetermined
            )
        )
    }
}

let dayOfWeekFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter
}()
