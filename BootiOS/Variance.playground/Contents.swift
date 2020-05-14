import Foundation
import BootiOSFramework
import UIKit

// NSObject > UIResponder > UIView > UIControl > UIButton
func wrapView(padding: UIEdgeInsets) -> (UIView) -> UIView {
  return { subview in
    let wrapper = UIView()
    subview.translatesAutoresizingMaskIntoConstraints = false
    wrapper.addSubview(subview)
    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(
        equalTo: wrapper.leadingAnchor, constant: padding.left
      ),
      subview.rightAnchor.constraint(
        equalTo: wrapper.rightAnchor, constant: -padding.right
      ),
      subview.topAnchor.constraint(
        equalTo: wrapper.topAnchor, constant: padding.top
      ),
      subview.bottomAnchor.constraint(
        equalTo: wrapper.bottomAnchor, constant: -padding.bottom
      ),
      ])
    return wrapper
  }
}
let padding = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
// =============================================================
//Functions have subtyping relations just like subclasses

//Contravariant
//we are allowed to substitute in a more specific type (i.e. a subclass)
wrapView(padding: padding) as (UIView) -> UIView
wrapView(padding: padding) as (UIButton) -> UIView
wrapView(padding: padding) as (UIControl) -> UIView
wrapView(padding: padding) as (UISwitch) -> UIView
wrapView(padding: padding) as (UIStackView) -> UIView
//wrapView(padding: padding) as (UIResponder) -> UIView

//Covariant
//But return need to be more broder
//wrapView(padding: padding) as (UIView) -> UIButton
wrapView(padding: padding) as (UIView) -> UIResponder
wrapView(padding: padding) as (UIView) -> NSObject
wrapView(padding: padding) as (UIView) -> AnyObject

//Rule < is sub type of
/*
  If A < B, then

  then (B -> C) < (A -> C)

  then (C -> A) < (C -> B)
*/

/*
 If A < B

 then B -> C
        <              contravariant (in) - reversal of A < B
      A -> C

 then      C -> A
             <         covariant (out) - the same as A < B
           C -> B
*/

//Covariant map
// A -> B ==> [A] -> [B]
func map<A, B>(_ f: (A) -> B) -> ([A]) -> [B] {
  fatalError("Unimplemented")
}
struct Func<A, B> {
  let apply: (A) -> B
}
// B -> C ==> Container B -> Container C
func map<A, B, C>(
    _ f: @escaping (B) -> C
) -> ((Func<A, B>) -> Func<A, C>) {
  return { g in
    Func(apply: g.apply >>> f)
  }
}

func pullback<A, B, C>(
    _ f: @escaping (B) -> A)
-> ((Func<A, C>) -> Func<B, C>) {
  return { g in
     Func(apply: g.apply <<< f)
   }
}

struct F3<A> {
  let run: (@escaping (A) -> Void) -> Void
}

func map<A, B>(_ f: @escaping (A) -> B) -> (F3<A>) -> F3<B> {
    return { f3 in
        return F3<B> { callback in
            f3.run(f >>> callback)
        }
    }
}
