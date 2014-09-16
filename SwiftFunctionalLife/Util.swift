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

// a faster memoize, cache hits require a single dictionary lookup
func memoize<T:Hashable, U>(fn : T -> U) -> T -> U {
  var cache = [T:U]()
  return {
    (val : T) -> U in
    var value = cache[val]
    if value != nil {
      return value!
    } else {
      let newValue = fn(val)
      cache[val] = newValue
      return newValue
    }
  }
}

// a slow memoize function, where two dictionary look ups are 
// required for each function call
func memoizeSlow<T:Hashable, U>(fn : T -> U) -> T -> U {
  var cache = [T:U]()
  return {
    (val : T) -> U in
    if cache.indexForKey(val) == nil {
      cache[val] = fn(val)
    }
    return cache[val]!
  }
}

struct FunctionParams<T:Hashable, S:Hashable> : Hashable {
  let x: T, y: S
  
  var hashValue: Int {
    var hash = 17;
      hash = hash * 23 + x.hashValue
      hash = hash * 23 + y.hashValue
      return hash;
  }
}

func ==<T:Hashable, S:Hashable> (lhs: FunctionParams<T, S>, rhs: FunctionParams<T, S>) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}

func memoize<S:Hashable, T:Hashable, U>(fn : (S, T) -> U) -> (S, T) -> U {
  var cache = Dictionary<FunctionParams<S,T>, U>()
  func memoized(val1 : S, val2: T) -> U {
    let key = FunctionParams(x: val1, y: val2)
    if cache.indexForKey(key) == nil {
      cache[key] = fn(val1, val2)
    }
    return cache[key]!
  }
  return memoized
}