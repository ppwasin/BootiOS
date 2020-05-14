//
//  Tagged.swift
//  BootiOSFramework
//
//  Created by Wasin Passornpakorn on 4/5/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import Foundation

public struct Tagged<Tag, RawValue> {
  let rawValue: RawValue
}

extension Tagged: Decodable where RawValue: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.init(rawValue: try container.decode(RawValue.self))
  }
}

extension Tagged: Equatable where RawValue: Equatable {
  public static func == (lhs: Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }

}
