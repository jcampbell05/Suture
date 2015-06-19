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

@end

@implementation SUTSpriteView

#pragma mark - Init

- (instancetype)initWithRenderer:(SUTSpriteRenderer *)renderer
{
    self = [super init];
    
    if (self)
    {
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

#pragma mark - Sprite

- (void)setSprite:(SUTSprite *)sprite
{
    if (![self.sprite isEqualTo:sprite])
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(sprite))];
        _sprite = sprite;
        [self didChangeValueForKey:NSStringFromSelector(@selector(sprite))];
        
        [self.layer setNeedsDisplay];
    }
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
