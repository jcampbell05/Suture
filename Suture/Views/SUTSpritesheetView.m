//
//  SUTSpritesheetView.m
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpritesheetView.h"

#import "SUTDocument.h"
#import "SUTSpriteRenderer.h"
#import "SUTSpritesheetLayout.h"
#import "SUTSpriteView.h"

static CGFloat SUTSpriteSheetTransparentBackgroundCheckerboardSize = 25.0f;

void SUTRenderSpriteSheetTransparentBackground(void *info, CGContextRef context)
{
    CGColorRef alternateColor = CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.25);
    CGContextSetFillColorWithColor(context, alternateColor);
    
    CGContextAddRect(context, CGRectMake(0.0f, 0.0f, SUTSpriteSheetTransparentBackgroundCheckerboardSize, SUTSpriteSheetTransparentBackgroundCheckerboardSize));
    CGContextFillPath(context);
    
    CGContextAddRect(context, CGRectMake(SUTSpriteSheetTransparentBackgroundCheckerboardSize, SUTSpriteSheetTransparentBackgroundCheckerboardSize, SUTSpriteSheetTransparentBackgroundCheckerboardSize, SUTSpriteSheetTransparentBackgroundCheckerboardSize));
    CGContextFillPath(context);
    
    CGColorRelease(alternateColor);
}

void SUTReleaseSpriteSheetTransparentBackground(void *info)
{
}

@interface SUTSpritesheetView ()

@property (nonatomic, strong) NSMutableDictionary *spriteViewTable;
@property (nonatomic, strong) SUTSpriteRenderer *renderer;

@end

@implementation SUTSpritesheetView

#pragma mark - Rendering

- (NSMutableDictionary *)spriteViewTable
{
    if (_spriteViewTable)
    {
        _spriteViewTable = [[NSMutableDictionary alloc] init];
    }
    
    return _spriteViewTable;
}

- (SUTSpriteRenderer *)renderer
{
    if (!_renderer)
    {
        _renderer = [[SUTSpriteRenderer alloc] init];
    }
    
    return _renderer;
}

- (void)reloadSprites
{
    [self.document.layout prepareLayout];
    
    NSInteger idx = 0;
    
    for (NSView *sv in self.subviews)
    {
        [sv removeFromSuperview];
    }
    
    for (SUTSprite *sprite in self.document.sprites)
    {
        SUTSpriteView *spriteView = [[SUTSpriteView alloc] initWithSprite:sprite
                                                                 renderer:self.renderer];
        [self addSubview:spriteView];
        
        CGRect frame = [self.document.layout frameForSpriteAtIndex:idx++];
        spriteView.frame = frame;
        [spriteView setNeedsDisplay:YES];
    }
    
    CGRect frame = self.frame;
    frame.size = [self.document.layout contentSize];
    self.frame = frame;
    
    CGPatternCallbacks transparentBackgroundCallbacks =
    {
        0,
        &SUTRenderSpriteSheetTransparentBackground,
        &SUTReleaseSpriteSheetTransparentBackground
    };
    
    CGRect patternSize =
    {
        CGPointZero,
        (CGSize)
        {
            SUTSpriteSheetTransparentBackgroundCheckerboardSize * 2,
            SUTSpriteSheetTransparentBackgroundCheckerboardSize * 2
        }
    };
    CGPatternRef pattern = CGPatternCreate (NULL,
                                            patternSize,
                                            CGAffineTransformIdentity,
                                            patternSize.size.width,
                                            patternSize.size.height,
                                            kCGPatternTilingConstantSpacing,
                                            true,
                                            &transparentBackgroundCallbacks);
    
    CGColorSpaceRef space = CGColorSpaceCreatePattern(NULL);
    CGFloat components[1] = {1.0};
    CGColorRef color = CGColorCreateWithPattern(space, pattern, components);
    CGColorSpaceRelease(space);
    CGPatternRelease(pattern);
    
    self.layer.backgroundColor = color;
}

@end
