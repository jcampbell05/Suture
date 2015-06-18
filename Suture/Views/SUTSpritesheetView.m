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

static CGFloat SUTSpriteSheetTransparentBackgroundPixelSize = 25.0f;

void SUTRenderSpriteSheetTransparentBackground(void *info, CGContextRef context)
{
    NSInteger numberOfCells = 8;
    NSInteger cellsPerRow = 4;
    
    for (NSInteger cellIndex = 0; cellIndex < numberOfCells; cellIndex ++)
    {
        CGPoint cellLocation = (CGPoint)
        {
            cellIndex,
            cellIndex % cellsPerRow
        };
        
        CGRect cellFrame = (CGRect)
        {
            cellLocation.x * SUTSpriteSheetTransparentBackgroundPixelSize,
            cellLocation.y * SUTSpriteSheetTransparentBackgroundPixelSize,
            SUTSpriteSheetTransparentBackgroundPixelSize,
            SUTSpriteSheetTransparentBackgroundPixelSize
        };
        
        CGContextSetFillColorWithColor(context,
                                       [NSColor gridColor].CGColor);
        
        CGContextFillRect(context,
                          cellFrame);
    }
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
    
    CGPatternRef pattern = CGPatternCreate (NULL,
                                            self.bounds,
                                            CGAffineTransformIdentity,
                                            self.bounds.size.width,
                                            self.bounds.size.height,
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
