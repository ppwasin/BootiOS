import BootiOSFramework
import Foundation


pow(2, 100)

enum Three { case one, two, three }

// Bool^Three
// Bool^(1 + 1 = 1)

let a = 2.0
let b = 3.0
let c = 4.0

//===============================
// (a^b)^c = a^(b*c)
pow(pow(a, b), c) == pow(a, b * c)

// (a^b)^c = a^(b * c)
// (a <- b) <- c = a <- (b * c)
// c -> (b -> a) = b * c -> a
// C -> (B -> A) = (B, C) -> a

String.init(data:encoding:)

curry(String.init(data:encoding:))
uncurry(curry(String.init(data:encoding:)))

//===============================
// a^1 = a
pow(a, 1) == a
pow(b, 1) == b
pow(c, 1) == c

// a^1 = a
// a <- 1 = a
// 1 -> a = a
// Void -> A = A

func to<A>(_ f:() -> A) -> A {
    return f()
}

func from<A>(_ a: A) -> () -> A {
    return { a }
}

//===============================
// a^0 = 1
pow(a, 0) == 1
pow(b, 0) == 1
pow(c, 0) == 1
pow(0, 0) == 1

// a^0 = 1
// a <- 0 = 1
// Never -> A = Void

func to<A>(_ f: (Never) -> A) -> Void {
    return ()
}
//func from<A>(_ void: Void) -> (Never) -> A {
//    return { never in
//        absurd(never)
//    }
//}

//===============================
// (A) -> A
// (inout A) -> Void

func to<A>(
  _ f: @escaping (A) -> A
  ) -> ((inout A) -> Void) {

  return { a in
    a = f(a)
  }
}

func from<A>(
  _ f: @escaping (inout A) -> Void
  ) -> ((A) -> A) {

  return { a in
    var copy = a
    f(&copy)
    return copy
  }
}

// (A, B) -> A
// (inout A, B) -> Void

// (A, inout B) -> C
// (A, B) -> (C, B)

//===============================
Data.init(from:)
// (A) throws -> B == (A) -> Result<B, Error>

Data.init(from:)
unthrow(Data.init(from:))
throwing(unthrow(Data.init(from:)))

//===============================
// a^(b + c) = a^b * a^c
// a <- (b + c) = (a <- b) * (a <- c)
// (b + c) -> a = (b -> a) * (c -> a)

// Either<B, C) -> A = (B -> A, C -> A)

//===============================
// (a * b)^c = a^c * b^c
// C -> (A,B) = ( C -> A, C -> B)

//===============================
// Conclusion
// Operator
// ^: <-
// +: Either
// *: ,
// 1: Void
// 0: Never

// Equation
// (a^b)^c = a^(b*c)        ==> C -> (B -> A) == (B, C) -> a
// a^1 = a                  ==> Void -> A == A
// a^0 = 1                  ==> Never -> A == 1
// (A) -> A                 ==  inout A -> Void
// (A, B) -> A              ==  (inout A, B) -> Void
// (A, inout B) -> C        ==  (A, B) -> (C, B)
// a^(b + c) = a^b * a^c    ==> Either<B,C> -> A == (B -> A, C -> A)
// (a * b)^c = a^c * b^c    ==> C -> (A, B) == (C->A, C->B)

// Not Equation
// a^(b * c) != a^b * a^c
pow(a, b * c) != pow(a, b) * pow(a, c)
// (a + b)^c != a^c + b^c
pow(a + b, c) != pow(a, c) + pow(b, c)
// (a + b)^c != a^c + b^c
// (C) -> Either<A, B> != Either<(C) -> A, (C) -> B>

// d^(a * b * c) =? d^(a + b + c)
