//
//  SwiftFunctionalLifeTests.swift
//  SwiftFunctionalLifeTests
//
//  Created by Colin Eberhardt on 30/08/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest

class SwiftFunctionalLifeTests: XCTestCase {
  
  let world = World()
    
  override func setUp() {
    super.setUp()
    
    // a random initial state
    func randLocation () -> Int {
      return Int(arc4random()) % world.dimensions
    }
    for _ in 0...100 {
      let x = randLocation(), y = randLocation()
      world[x, y]!.state = .Alive
    }
  }
  
  /*func testPerformanceNonOptimised() {
    measureBlock {
      for _ in 0...20 {
        self.world.iterateNonOptimised()
      }
    }
  }*/
  
  func testPerformanceMemoised() {
    self.measureBlock() {
      for _ in 0...20 {
        self.world.iterateMemoised()
      }
    }
  }
  
  func testPerformancePreComputed() {
    self.measureBlock() {
      for _ in 0...20 {
        self.world.iteratePreComputed()
      }
    }
  }
    
}
