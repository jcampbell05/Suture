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
    [self.document.layout prepareLayout];
    
    [self.document.sprites enumerateObjectsUsingBlock:^(SUTSprite *sprite, NSUInteger idx, BOOL *stop)
    {
        [self renderSprite:sprite
                   contect:context];
    }];
}

- (void)renderSprite:(SUTSprite *)sprite
             contect:(CGContextRef)context
{
    NSInteger spriteIndex = [self.document.sprites indexOfObject:sprite];
    CGSize contentSize = [self.document.layout contentSize];
    
    CGRect spriteFrame = [self.document.layout frameForSpriteAtIndex:spriteIndex];
    spriteFrame = SUTFlipCGRect(spriteFrame, contentSize);

    CGImageRef image = sprite.image.CGImage;
    
    CGContextDrawImage(context,
                       spriteFrame,
                       image);
    
    CGImageRelease(image);
}

@end
