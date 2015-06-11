//
//  SUTCheckerboardView.m
//  Suture
//
//  Created by James Campbell on 21/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTCheckerboardView.h"

@implementation SUTCheckerboardView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSInteger cellsPerRow = (self.bounds.size.width / self.cellSize.width);
    NSInteger cellsPerColumn = (self.bounds.size.height / self.cellSize.height);
    NSInteger totalCells = cellsPerRow * cellsPerColumn;
//    
//    for (NSInteger index = 0; index < totalCells; index++)
//    {
//        NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:index % cellsPerRow
//                                                         inSection:index / cellsPerRow];
//        
//        NSRect cellFrame = NSMakeRect(indexPath.jnw_item * self.cellSize.width,
//                                      indexPath.jnw_section * self.cellSize.height,
//                                      self.cellSize.width,
//                                      self.cellSize.height);
//        
//        NSInteger colorIndex = indexPath.jnw_item + indexPath.jnw_section;
//        NSColor *color = self.cellColours[colorIndex % [self.cellColours count]];
//        [color set];
//        
//        
//        
//        NSBezierPath *path = [NSBezierPath bezierPath];
//        [path appendBezierPathWithRect:cellFrame];
//        [path fill];
//    }
}

@end
