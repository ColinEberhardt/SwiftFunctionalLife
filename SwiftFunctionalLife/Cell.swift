//
//  Cell.swift
//  SwiftFunctionalLife
//
//  Created by Colin Eberhardt on 08/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

// A single cell within the Game of Life
class Cell: Hashable {
  let x: Int, y: Int
  var state: State
  var neighbours: [Cell]
  
  var hashValue: Int {
    return x + y * 1_000;
  }
  
  init (x: Int, y: Int) {
    self.x = x
    self.y = y
    state = .NeverLived
    neighbours = [Cell]()
  }
}

func == (lhs: Cell, rhs: Cell) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}

enum State {
  case Alive, Dead, NeverLived
}

