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

- (void)renderSpriteRange:(NSRange)range
                  context:(CGContextRef)context
{
    [self.document.layout prepareLayout];
    CGSize contentSize = [self.document.layout contentSize];
    
    for (NSInteger spriteIndex = range.location; spriteIndex < range.length; spriteIndex ++)
    {
        CGRect spriteFrame = [self.document.layout frameForSpriteAtIndex:spriteIndex];
        spriteFrame = SUTFlipCGRect(spriteFrame, contentSize);
        
        SUTSprite *sprite = self.document.sprites[spriteIndex];
        CGImageRef image = sprite.image.CGImage;
        
        CGContextDrawImage(context,
                           spriteFrame,
                           image);
        
        CGImageRelease(image);
    }
}

@end
