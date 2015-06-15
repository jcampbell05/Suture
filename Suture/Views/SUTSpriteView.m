//
//  SUTSpriteView.m
//  Suture
//
//  Created by James Campbell on 15/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteView.h"

@interface SUTSpriteView ()

@property (nonatomic, strong) SUTSpritesheetRenderer *renderer;
@property (nonatomic, strong) SUTSprite *sprite;

@end

@implementation SUTSpriteView

#pragma mark - Init

- (instancetype)initWithSprite:(SUTSprite *)sprite
                      renderer:(SUTSpritesheetRenderer *)renderer
{
    self = [super init];
    
    if (self)
    {
        self.sprite = sprite;
        self.renderer = renderer;
    }
    
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];
    [self.renderer renderSprite:self.sprite
                        contect:context];
}

@end
