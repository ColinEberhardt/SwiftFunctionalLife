//
//  ViewController.swift
//  SwiftFunctionalLife
//
//  Created by Colin Eberhardt on 30/08/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit

enum State {
  case Alive, Dead, NeverLived
}

infix operator !~={}

func !~=<I : IntervalType>(pattern: I, value: I.Bound) -> Bool {
  return !(pattern ~= value)
}

class Cell {
  let x: Int, y: Int
  var state: State
 
  init (x: Int, y: Int) {
    self.x = x
    self.y = y
    state = .NeverLived
  }
}


class World {
  let grid: [Cell];
  let dimensions: Int = 8
  
  init() {
    grid = [Cell]()
    
    // create the cells
    for x in 0..<dimensions {
      for y in 0..<dimensions {
        grid.append(Cell(x: x, y: y))
      }
    }
  }
  
  subscript (x: Int, y: Int) -> Cell? {
    return grid.filter { $0.x == x && $0.y == y }.first
  }

  func dump() {
    for x in 0..<dimensions {
      println()
      for y in 0..<dimensions {
        let cell = self[x, y]!
        switch cell.state {
        case .Alive:
          print("#")
        case .Dead:
          print("-")
        case .NeverLived:
          print(".")
        }
      }
    }
    println()
  }
  
  
  func iterate() {

    // utility functions

    let cellsAreNeighbours = {
      (op1: Cell, op2: Cell) -> Bool in
      let delta = (abs(op1.x - op2.x), abs(op1.y - op2.y))
      switch (delta) {
      case (1,1), (1,0), (0,1):
        return true
      default:
        return false
      }
    }
    
    let neighboursForCell = {
      (cell: Cell) -> [Cell] in
      return self.grid.filter { cellsAreNeighbours(cell, $0)}
    }
    
    let livingNeighboursForCell = {
      (cell: Cell) -> Int in
      neighboursForCell(cell).filter{ $0.state == State.Alive }.count
    }

    // rules of life

    let liveCells = grid.filter { $0.state == .Alive }
    let deadCells = grid.filter { $0.state != .Alive }

    let dyingCells = liveCells.filter { 2...3 !~= livingNeighboursForCell($0) }
    let newLife =  deadCells.filter { livingNeighboursForCell($0) == 3 }

    // updating the world state

    for cell in newLife {
      cell.state = .Alive
    }

    for cell in dyingCells {
      cell.state = .Dead
    }
  }
}

class ViewController: UIViewController {
  
  let world = World()
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // initial state
    world[3,4]!.state = .Alive
    world[3,5]!.state = .Alive
    world[3,6]!.state = .Alive
    
    let now = NSDate()
    for _ in 0...100 {
      world.iterate()
      world.dump()
    }
    var then = NSDate().timeIntervalSinceDate(now)
    println(then)

  }
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

}




