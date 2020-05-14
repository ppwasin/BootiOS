import Foundation
import BootiOSFramework

struct Food {
  var name: String
}

struct Location {
  var name: String
}

struct User {
  var favoriteFoods: [Food]
  var location: Location
  var name: String
}

var user = User(
  favoriteFoods: [Food(name: "Tacos"), Food(name: "Nachos")],
  location: Location(name: "Brooklyn"),
  name: "Blob"
)
//user
//|> (prop(\.name)) { $0.uppercased() }
//<> (prop(\.location.name)) { _ in "Los Angeles" }


let addCourtesyTitle = { $0 + ", Esq." }
//user
//  |> prop(\.name, addCourtesyTitle)
//  |> prop(\.name) { $0.uppercased() }
//  <> prop(\.location.name, "Los Angele")

let healthierOption = { $0 + " & Salad" }
user
|> over(^\.name, addCourtesyTitle)
<> over(^\.name) { $0.uppercased() }
<> set(^\.location.name, "Los Angeles")
<> over(^\.favoriteFoods <<< map <<< prop(\.name), healthierOption)
