// Mark: |>
precedencegroup ForwardApplication {
    higherThan: AssignmentPrecedence
    associativity: left
}
infix operator |>: ForwardApplication

public func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}
public func |> <A>(_ a: A, _ f: (inout A) -> Void) -> A {
  var a = a
  f(&a)
  return a
}

// Mark: >>>
precedencegroup ForwardComposition {
    higherThan: ForwardApplication
    associativity: right
}
infix operator >>>: ForwardComposition

public func >>> <A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in g(f(a)) }
}
// Mark: <<<
precedencegroup BackwardsComposition {
  associativity: left
}
infix operator <<<: BackwardsComposition
public func <<< <A, B, C>(g: @escaping (B) -> C, f: @escaping (A) -> B) -> (A) -> C {
  return { x in
    g(f(x))
  }
}


// Mark: >=>
precedencegroup EffectfulComposition {
  associativity: left
  higherThan: ForwardApplication
}
infix operator >=>: EffectfulComposition

// Mark: <>
precedencegroup SingleTypeComposition {
  associativity: left
  higherThan: ForwardApplication
}
infix operator <>: SingleTypeComposition
public func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
  return f >>> g
}
public func <> <A: AnyObject>(
    f: @escaping (A) -> Void,
    g: @escaping (A) -> Void) ->
(A) -> Void {
  return { a in
    f(a)
    g(a)
  }
}

