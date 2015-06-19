//
//  SUTSpriteView.m
//  Suture
//
//  Created by James Campbell on 15/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteView.h"

#import <Quartz/Quartz.h>

@interface SUTSpriteView ()

@property (nonatomic, strong) SUTSpriteRenderer *renderer;
@property (nonatomic, strong) SUTSprite *sprite;

@end

@implementation SUTSpriteView

#pragma mark - Init

- (instancetype)initWithSprite:(SUTSprite *)sprite
                      renderer:(SUTSpriteRenderer *)renderer
{
    self = [super init];
    
    if (self)
    {
        self.sprite = sprite;
        self.renderer = renderer;
        self.wantsLayer = YES;
        
        CATiledLayer *tiledLayer = [CATiledLayer layer];
        tiledLayer.delegate = self;
        tiledLayer.levelsOfDetail = 5;
        
        self.layer = tiledLayer;
        [self.layer setNeedsDisplay];

        if ([[NSProcessInfo processInfo] environment][@"SUTSpriteViewDebugBackground"])
        {
            self.layer.backgroundColor = [NSColor redColor].CGColor;
        }
    }
    
    return self;
}

#pragma mark - Drawing

- (void)drawLayer:(CALayer *)layer
        inContext:(CGContextRef)context
{
    CGContextFlush(context);
    
    [self.renderer renderSprite:self.sprite
                        context:context];
}
@end
