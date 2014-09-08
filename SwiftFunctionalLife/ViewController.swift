//
//  ViewController.swift
//  SwiftFunctionalLife
//
//  Created by Colin Eberhardt on 30/08/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit

enum State {
  case Alive, Dead
}


class Cell {
  let x: Int, y: Int
  var state: State
 
  init (x: Int, y: Int) {
    self.x = x
    self.y = y
    state = .Dead
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
        print(cell.state == State.Alive ? "#" : ".")
      }
    }
    println()
  }
  
  
  func iterate() {
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
    let dyingCells = liveCells.filter {
      cell in
      2...3 !~= livingNeighboursForCell(cell)
    }
    

    let deadCells = grid.filter { $0.state == .Dead }
    let newLife =  grid.filter { $0.state == .Dead }.filter {
      cell in
      livingNeighboursForCell(cell) == 3
    }

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
    }
    var then = NSDate().timeIntervalSinceDate(now)
    println(then)

  }
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

}

infix operator !~={}

func !~=<I : IntervalType>(pattern: I, value: I.Bound) -> Bool {
  return !(pattern ~= value)
}


