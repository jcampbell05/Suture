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

static CGFloat SUTSpriteSheetTransparentBackgroundCheckerboardSize = 10.0f;
static CGFloat SUTSpriteSheetTransparentBackgroundCheckerboardCount = 2.0f;

void SUTRenderSpriteSheetTransparentBackground(void *info, CGContextRef context)
{
    CGColorRef alternateColor = CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.25);
    CGContextSetFillColorWithColor(context, alternateColor);
    
    for (NSInteger i = 0; i < SUTSpriteSheetTransparentBackgroundCheckerboardCount; i ++)
    {
        CGRect checkerboardFrame = CGRectMake(SUTSpriteSheetTransparentBackgroundCheckerboardSize * i,
                                              SUTSpriteSheetTransparentBackgroundCheckerboardSize * i,
                                              SUTSpriteSheetTransparentBackgroundCheckerboardSize,
                                              SUTSpriteSheetTransparentBackgroundCheckerboardSize);
        CGContextAddRect(context, checkerboardFrame);
        CGContextFillPath(context);
    }
    
    CGColorRelease(alternateColor);
}

void SUTReleaseSpriteSheetTransparentBackground(void *info)
{
}

@interface SUTSpritesheetView ()

@property (nonatomic, strong) NSMutableArray *spriteViewQueue;
@property (nonatomic, strong) SUTSpriteRenderer *renderer;

- (SUTSpriteView *)dequeueSpriteViewForIndex:(NSInteger)index;

@end

@implementation SUTSpritesheetView

#pragma mark - Rendering

- (NSMutableArray *)spriteViewQueue
{
    if (!_spriteViewQueue)
    {
        _spriteViewQueue = [[NSMutableArray alloc] init];
    }
    
    return _spriteViewQueue;
}

- (SUTSpriteRenderer *)renderer
{
    if (!_renderer)
    {
        _renderer = [[SUTSpriteRenderer alloc] init];
    }
    
    return _renderer;
}

- (SUTSpriteView *)dequeueSpriteViewForIndex:(NSInteger)index
{
    SUTSpriteView *spriteView;
    
    if ([self.spriteViewQueue count] < (index + 1))
    {
        SUTSpriteView *newSpriteView = [[SUTSpriteView alloc] initWithRenderer:self.renderer];
        [self.spriteViewQueue addObject:newSpriteView];
        [self addSubview:newSpriteView];
        
        spriteView = newSpriteView;
    }
    else
    {
        spriteView = self.spriteViewQueue[index];
    }
    
    return spriteView;
}

- (void)reloadSprites
{
    [self.document.layout prepareLayout];
    
    NSInteger idx = 0;
    
    for (SUTSprite *sprite in self.document.sprites)
    {
        SUTSpriteView *spriteView = [self dequeueSpriteViewForIndex:idx];
        spriteView.sprite = sprite;
        
        CGRect spriteFrame = [self.document.layout frameForSpriteAtIndex:idx++];
        spriteView.frame = spriteFrame;
        [spriteView setNeedsDisplay:YES];
    }
    
    CGRect spriteSheetFrame = self.frame;
    spriteSheetFrame.size = [self.document.layout contentSize];
    self.frame = spriteSheetFrame;
    
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
            SUTSpriteSheetTransparentBackgroundCheckerboardSize * SUTSpriteSheetTransparentBackgroundCheckerboardCount,
            SUTSpriteSheetTransparentBackgroundCheckerboardSize * SUTSpriteSheetTransparentBackgroundCheckerboardCount
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

- (void)mouseDown:(NSEvent *)event
{
    CGPoint locationInSpriteSheet = [self convertPoint:event.locationInWindow
                                              fromView:nil];
    
    [self.spriteViewQueue enumerateObjectsUsingBlock:^(SUTSpriteView *spriteView, NSUInteger idx, BOOL *stop)
    {
        if (CGRectContainsPoint(spriteView.frame, locationInSpriteSheet))
        {
            spriteView.selected = !spriteView.selected;
        }
    }];
}

@end
