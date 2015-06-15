//
//  SUTSpritesheetRenderer.m
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteSheetRenderer.h"

#import "NSImage+CGImage.h"
#import "SUTDocument.h"
#import "SUTGeometry.h"
#import "SUTSprite.h"
#import "SUTSpritesheetLayout.h"

@implementation SUTSpritesheetRenderer

- (void)renderInContext:(CGContextRef)context
{
    [self.document.sprites enumerateObjectsUsingBlock:^(SUTSprite *sprite, NSUInteger idx, BOOL *stop)
    {
        [self renderSprite:sprite
                   context:context];
    }];
}

- (void)renderSprite:(SUTSprite *)sprite
             context:(CGContextRef)context
{
    CGRect spriteFrame = CGRectZero;
    spriteFrame.size = sprite.size;

    CGImageRef image = sprite.image.CGImage;
    
    CGContextDrawImage(context,
                       spriteFrame,
                       image);
    
    CGImageRelease(image);
}

@end
