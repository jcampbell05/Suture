//
//  SUTSpriteRenderer.m
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteRenderer.h"

#import "SUTSprite.h"

@implementation SUTSpriteRenderer

- (void)renderSprite:(SUTSprite *)sprite
             context:(CGContextRef)context
{
    CGRect spriteFrame = CGRectZero;
    spriteFrame.size = sprite.size;

    CGImageRef image = sprite.CGImage;
    
    CGContextDrawImage(context,
                       spriteFrame,
                       image);
    
    CGImageRelease(image);
}

@end
