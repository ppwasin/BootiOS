import Foundation

public func curry<A, B, C>(
_ f: @escaping (A, B) -> C
) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

public func uncurry<A, B, C>(
    _ f: @escaping (A) -> (B) -> C
) -> (A, B) -> C {
    return { a, b in f(a)(b) } 
}

public func flip<A, B, C>(
    _ f: @escaping (A) -> (B) -> C
) -> (B) -> (A) -> C {
    return { b in { a in f(a)(b) } }
}

public func zurry<A>(_ f: () -> A) -> A {
    return f()
}
public func unzurry<A>(_ a: A) -> () -> A {
    return { a }
}



public func map<A, B>(
    _ f: @escaping (A) -> B
) -> ([A]) -> ([B]) {
    return { $0.map(f) }
}

public func filter<A>(
    _ f: @escaping (A) -> Bool
    ) -> ([A]) -> [A] {
    return { $0.filter(f) }
}


public func unthrow<A, B>(_ f: @escaping (A) throws -> B) -> (A) -> Result<B, Error> {
  return { a in
    do {
      return .success(try f(a))
    } catch {
      return .failure(error)
    }
  }
}
public func throwing<A, B>(_ f: @escaping (A) -> Result<B, Error>) -> (A) throws -> B {
    return { a in
        switch f(a) {
        case let .success(b): return b
        case let .failure(error): throw error
        }
    }
}

//public func absurd<A>(_ never: Never) -> A {
//  switch never {
//    //
//  }
//}
