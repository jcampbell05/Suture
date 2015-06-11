//
//  SUTSpritesheetView.m
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpritesheetView.h"

#import "SUTSpritesheetRenderer.h"

@interface SUTSpritesheetView ()

@property (nonatomic, strong) SUTSpritesheetRenderer *renderer;

@end

@implementation SUTSpritesheetView

- (SUTSpritesheetRenderer *)renderer
{
    if (!_renderer)
    {
        _renderer = [[SUTSpritesheetRenderer alloc] init];
    }
    
    return _renderer;
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];
    [self.renderer renderSpriteRange:NSMakeRange(0, 1)
                             context:context];
}

@end
