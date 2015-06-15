//
//  SUTSpriteView.m
//  Suture
//
//  Created by James Campbell on 15/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteView.h"

@interface SUTSpriteView ()

- (void)spriteDidChange;

@end

@implementation SUTSpriteView

- (void)setSprite:(SUTSprite *)sprite
{
    if (![_sprite isEqual:sprite])
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(sprite))];
        _sprite = sprite;
        [self didChangeValueForKey:NSStringFromSelector(@selector(sprite))];
        
        [self spriteDidChange];
    }
}

- (void)spriteDidChange
{
    [self setNeedsDisplay:YES];
}

@end
