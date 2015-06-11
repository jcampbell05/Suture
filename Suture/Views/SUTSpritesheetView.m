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

#pragma mark - Document

- (void)setDocument:(SUTDocument *)document
{
    self.renderer.document = document;
    
    [self setNeedsDisplay:YES];
}

- (SUTDocument *)document
{
    return self.renderer.document;
}

#pragma mark - Rendering

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
