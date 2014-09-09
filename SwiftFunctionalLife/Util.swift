//
//  Operators.swift
//  SwiftFunctionalLife
//
//  Created by Colin Eberhardt on 08/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

infix operator !~= {}

func !~= <I : IntervalType>(value: I.Bound, pattern: I) -> Bool {
  return !(pattern ~= value)
}

extension Array {
  func each<T>(fn: (T) -> ()) {
    for item in self {
      let itemAsT = item as T
      fn(itemAsT)
    }
  }

}