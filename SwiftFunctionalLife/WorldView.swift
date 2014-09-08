//
//  WorldView.swift
//  SwiftFunctionalLife
//
//  Created by Colin Eberhardt on 08/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit

// A UIView subclass that renders the Game of Life 'World'
class WorldView: UIView {
  let world: World
  
  init(world: World) {
    self.world = world
    super.init(frame: CGRectMake(0,0,0,0))
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    func fillColorForCell (state: State) -> UIColor {
      switch state {
      case .Alive:
        return UIColor.blueColor()
      case .Dead:
        return UIColor.lightGrayColor()
      case .NeverLived:
        return UIColor.whiteColor()
      }
    }
    
    func frameForCell (cell: Cell) -> CGRect {
      let dimensions = CGFloat(self.world.dimensions)
      let cellSize = CGSizeMake(self.bounds.width / dimensions, self.bounds.height / dimensions)
      return CGRectMake(CGFloat(cell.x) * cellSize.width, CGFloat(cell.y) * cellSize.height,
        cellSize.width, cellSize.height)
    }
    
    for cell in world.cells {
      CGContextSetFillColorWithColor(context, fillColorForCell(cell.state).CGColor)
      CGContextAddRect(context, frameForCell(cell))
      CGContextFillPath(context)
    }
  }
}
