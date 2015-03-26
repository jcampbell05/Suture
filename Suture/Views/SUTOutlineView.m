//
//  SUTOutlineView.m
//  Suture
//
//  Created by James Campbell on 12/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTOutlineView.h"

@implementation SUTOutlineView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSRect outlineRect = NSInsetRect(self.bounds,
                                     10,
                                     10);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:outlineRect
                                                         xRadius:15
                                                         yRadius:15];

    [[NSColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1] set];
    [path setLineWidth:5.0];
    
    CGFloat pat[2] = {20.0, 10.0};
    [path setLineDash:pat
                count:1
                phase:0];
    
    [path stroke];
}

@end
