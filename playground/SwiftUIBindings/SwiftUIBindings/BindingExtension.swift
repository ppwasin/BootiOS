//
import CasePaths
//  CasePath.swift
//  BootiOSFramework
//
//  Created by Wasin Passornpakorn on 17/7/20.
//  Copyright © 2020 Wasin Passornpakorn. All rights reserved.
//
import SwiftUI

public extension Binding {
    // WritableKeyPath<Value, LocalValue> -> Binding<Value> -> Binding<LocalValue>
    // WritableKeyPath<A, B> -> Binding<A> -> Binding<B>
    // ((A) -> (B)) -> ([A]) -> [B]
    // ((A) -> (B)) -> (A?) -> B?
    // ((A) -> (B)) -> (Result<A, E>) -> Result<B, E>
    // pullback: ((A) -> B) -> (Predicate<B>) -> Predicate<A>
    // pullback: ((A) -> B) -> (Snapshotting<B>) -> Snapshotting<A>
    // pullback: (WritableKeyPath<A,B> -> (Reducer<B>) -> Reducer<A>
    // pullback: (WritableKeyPath<Gloabal,Local> -> (Reducer<Local>) -> Reducer<Gloabal>
    func map<LocalValue>(_ keyPath: WritableKeyPath<Value, LocalValue>) -> Binding<LocalValue> {
        self[dynamicMember: keyPath]
//        Binding<LocalValue>(
//            get: { self.wrappedValue[keyPath: keyPath] },
//            set: { localValue in self.wrappedValue[keyPath: keyPath] = localValue }
//        )
    }
}

public extension Binding {
    func unwrap<Wrapped>() -> Binding<Wrapped>? where Value == Wrapped? {
        guard let value = wrappedValue else { return nil }
        return Binding<Wrapped>(
            get: { value },
            set: { self.wrappedValue = $0 }
        )
    }

    subscript<Case>(
        _ casePath: CasePath<Value, Case>
    ) -> Binding<Case>? {
        self.matching(casePath)
    }

    func matching<Case>(
        _ casePath: CasePath<Value, Case>
//        extract: @escaping (Value) -> Case?,
//        embed: @escaping (Case) -> Value
    ) -> Binding<Case>? {
        guard let `case` = casePath.extract(from: wrappedValue) else { return nil }
        return Binding<Case>(
            get: { `case` },
            set: { `case` in self.wrappedValue = casePath.embed(`case`) }
        )
    }
}
