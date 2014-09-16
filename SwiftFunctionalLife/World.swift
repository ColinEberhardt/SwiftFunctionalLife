//
//  World.swift
//  SwiftFunctionalLife
//
//  Created by Colin Eberhardt on 08/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// the Game of Life 'World', contains an array of cells
class World {
  let cells: [Cell]
  let dimensions: Int = 20
  
  lazy var neighboursForCell: (cell: Cell) -> [Cell] = memoize {
    (cell: Cell) -> [Cell] in
    
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
    
    return self.cells.filter { cellsAreNeighbours(cell, $0)}
  }
  
  init() {
    cells = [Cell]()
    
    // create the cells
    for x in 0..<dimensions {
      for y in 0..<dimensions {
        cells.append(Cell(x: x, y: y))
      }
    }
    
    // find their neighbours
    for cell in cells {
      cell.neighbours = self.neighboursForCell(cell: cell)
    }
  }
  
  subscript (x: Int, y: Int) -> Cell? {
    return cells.filter { $0.x == x && $0.y == y }.first
  }
  
  // applies the rules of the Game of Life to the current state
  func iterateMemoised() {
    
    let livingNeighboursForCell = {
      (cell: Cell) -> Int in
      self.neighboursForCell(cell: cell).filter{ $0.state == State.Alive }.count
    }
    
    // rules of life
    let liveCells = cells.filter { $0.state == .Alive }
    let deadCells = cells.filter { $0.state != .Alive }
    
    let dyingCells = liveCells.filter { livingNeighboursForCell($0) !~= 2...3 }
    let newLife =  deadCells.filter { livingNeighboursForCell($0) == 3 }
    
    // updating the world state
    newLife.each { (cell: Cell) in cell.state = .Alive }
    dyingCells.each { (cell: Cell) in cell.state = .Dead }
    
  }
  
  // applies the rules of the Game of Life to the current state
  func iteratePreComputed() {
    
    let livingNeighboursForCell = {
      (cell: Cell) -> Int in
      cell.neighbours.filter{ $0.state == State.Alive }.count
    }
    
    // rules of life
    let liveCells = cells.filter { $0.state == .Alive }
    let deadCells = cells.filter { $0.state != .Alive }
    
    let dyingCells = liveCells.filter { livingNeighboursForCell($0) !~= 2...3 }
    let newLife =  deadCells.filter { livingNeighboursForCell($0) == 3 }
    
    // updating the world state
    newLife.each { (cell: Cell) in cell.state = .Alive }
    dyingCells.each { (cell: Cell) in cell.state = .Dead }
    
  }
  
  // applies the rules of the Game of Life to the current state. This
  // implementation is non-optimised in that it repeatedly computes the 
  // neighbours for each cell
  func iterateNonOptimised() {
    
    // utility functions
    // local function, hence defined as constant closures
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
      return self.cells.filter { cellsAreNeighbours(cell, $0)}
    }
    
    let livingNeighboursForCell = {
      (cell: Cell) -> Int in
      neighboursForCell(cell).filter{ $0.state == State.Alive }.count
    }
    
    // rules of life
    let liveCells = cells.filter { $0.state == .Alive }
    let deadCells = cells.filter { $0.state != .Alive }
    
    let dyingCells = liveCells.filter { livingNeighboursForCell($0) !~= 2...3 }
    let newLife =  deadCells.filter { livingNeighboursForCell($0) == 3 }
    
    // updating the world state
    newLife.each { (cell: Cell) in cell.state = .Alive }
    dyingCells.each { (cell: Cell) in cell.state = .Dead }
  }
}






