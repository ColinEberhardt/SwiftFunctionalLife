//
//  Cell.swift
//  SwiftFunctionalLife
//
//  Created by Colin Eberhardt on 08/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

// A single cell within the Game of Life
class Cell {
  let x: Int, y: Int
  var state: State
  
  init (x: Int, y: Int) {
    self.x = x
    self.y = y
    state = .NeverLived
  }
}

enum State {
  case Alive, Dead, NeverLived
}