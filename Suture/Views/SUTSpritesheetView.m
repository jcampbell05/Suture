//
//  SUTSpritesheetView.m
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpritesheetView.h"

#import "SUTDocument.h"
#import "SUTSpritesheetRenderer.h"
#import "SUTSpritesheetLayout.h"
#import "SUTSpriteView.h"

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

- (void)setNeedsDisplay:(BOOL)needsDisplay
{
    [super setNeedsDisplay:needsDisplay];
    
    [self.document.layout prepareLayout];
    
    CGRect frame = self.frame;
    frame.size = [self.document.layout contentSize];
    self.frame = frame;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSLog(@"RENDER");
    [self.document.sprites enumerateObjectsUsingBlock:^(SUTSprite *sprite, NSUInteger idx, BOOL *stop)
    {
        CGRect frame = [self.document.layout frameForSpriteAtIndex:idx];
        
        SUTSpriteView *spriteView = [[SUTSpriteView alloc] initWithSprite:sprite
                                                                 renderer:self.renderer];
        spriteView.frame = frame;
        
        [self addSubview:spriteView];
    }];
}

@end
