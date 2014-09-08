//
//  Operators.swift
//  SwiftFunctionalLife
//
//  Created by Colin Eberhardt on 08/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

infix operator !~={}

func !~=<I : IntervalType>(pattern: I, value: I.Bound) -> Bool {
  return !(pattern ~= value)
}