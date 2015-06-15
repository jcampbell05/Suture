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
    CGSize contentSize = [self.document.layout contentSize];
    
    for (NSInteger spriteIndex = 0; spriteIndex < [self.document.sprites count]; spriteIndex ++)
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
