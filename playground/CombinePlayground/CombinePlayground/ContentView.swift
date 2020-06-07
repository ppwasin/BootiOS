//
//  ContentView.swift
//  CombinePlayground
//
//  Created by Wasin Passornpakorn on 7/6/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import Combine
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var isRegisterd = false
    @Published var password = ""

    let register: (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>

    var cancellables: Set<AnyCancellable> = []

    init(
        register: @escaping (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    ) {
        self.register = register
    }

    func registerButtonTapped() {
        self.register(self.email, self.password)
            .map { data, _ in
                Bool(String(decoding: data, as: UTF8.self)) ?? false
            }
            .replaceError(with: false)
            .sink {
                self.isRegisterd = $0
            }
            .store(in: &self.cancellables)
//            .eraseToAnyPublisher()
    }
}

func registerRequest(
    email: String,
    password: String
) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
    var components = URLComponents(string: "https://www.pointfree.co/registersss")
    components?.queryItems = [
        URLQueryItem(name: "email", value: email),
        URLQueryItem(name: "password", value: password)
    ]

    return URLSession.shared
        .dataTaskPublisher(for: components!.url!)
        .eraseToAnyPublisher()
}

struct ContentView: View {
    @ObservedObject var viewModel: RegisterViewModel
    var body: some View {
        NavigationView {
            if self.viewModel.isRegisterd {
                Text("Welcome!")
            }
            else {
                Form {
                    Section(header: Text("Email")) {
                        TextField(
                            "blob@pointfree.co",
                            text: self.$viewModel.email
                        )
                    }

                    Section(header: Text("Password")) {
                        TextField(
                            "Password",
                            text: self.$viewModel.password
                        )
                    }
                    Button("Register") {
                        self.viewModel.registerButtonTapped()
                    }
                }
                .navigationBarTitle("Register")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: RegisterViewModel(
                register: { _, _ in
                    Just((Data("true".utf8), URLResponse()))
                    .setFailureType(to: URLError.self)
                    .eraseToAnyPublisher()
            })
        )
    }
}
