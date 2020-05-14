//
//  File.swift
//  
//
//  Created by Wasin Passornpakorn on 27/4/2563 BE.
//
public typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T


public func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {

    return { update in
      { root in
        var copy = root
        copy[keyPath: kp] = update(copy[keyPath: kp])
        return copy
      }
    }
}

public func over<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ set: @escaping (A) -> B
  )
  -> (S) -> T {
    return setter(set)
}

public func set<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ value: B
  )
  -> (S) -> T {
    return over(setter) { _ in value }
}


prefix operator ^
public prefix func ^ <Root, Value>(kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {

    return prop(kp)
}


public typealias MutableSetter<S, A> = (@escaping (inout A) -> Void) -> (inout S) -> Void
public func mver<S, A>(
  _ setter: MutableSetter<S, A>,
  _ set: @escaping (inout A) -> Void
  )
  -> (inout S) -> Void {
    return setter(set)
}

public func mut<S, A>(
  _ setter: MutableSetter<S, A>,
  _ value: A
  ) -> (inout S) -> Void {

  return mver(setter, { $0 = value })
}
public prefix func ^ <Root, Value>(
  _ kp: WritableKeyPath<Root, Value>
  )
  -> (@escaping (inout Value) -> Void)
  -> (inout Root) -> Void {

    return { update in
      { root in
        update(&root[keyPath: kp])
      }
    }
}
