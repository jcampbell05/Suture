//
//  SUTSpritesheetView.m
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpritesheetView.h"

#import <Quartz/Quartz.h>

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

@property (nonatomic, assign) CGPoint dragStartLocation;

@property (nonatomic, assign, getter=isDragging) BOOL dragging;
@property (nonatomic, assign) NSInteger targetDragSpriteIndex;
@property (nonatomic, assign) CGRect targetDragOriginalFrame;
@property (nonatomic, strong) SUTSpriteView *targetDragView;

@property (nonatomic, strong) NSMutableArray *spriteViewQueue;
@property (nonatomic, strong) SUTSpriteRenderer *renderer;

- (SUTSpriteView *)dequeueSpriteViewForIndex:(NSInteger)index;

@end

@implementation SUTSpritesheetView

#pragma mark - SelectedSprites

- (NSArray *)selectedSpriteViews
{
    NSPredicate *selectedViewPredicate = [NSPredicate predicateWithFormat:@"selected = YES"];
    return [self.spriteViewQueue filteredArrayUsingPredicate:selectedViewPredicate];
}

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

- (BOOL)acceptsFirstResponder
{
    return YES;
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
    
    self.dragStartLocation = locationInSpriteSheet;
    self.targetDragView = (SUTSpriteView *)[self hitTest:locationInSpriteSheet];
    self.targetDragSpriteIndex = [self.document indexOfSprite:self.targetDragView.sprite];
    self.targetDragOriginalFrame = self.targetDragView.frame;
}

- (void)mouseDragged:(NSEvent *)event
{
    if (self.targetDragView)
    {
        self.dragging = YES;
        
        CGPoint locationInSpriteSheet = [self convertPoint:event.locationInWindow
                                                  fromView:nil];
        CGPoint mouseDelta =  (CGPoint)
        {
            locationInSpriteSheet.x - self.dragStartLocation.x,
            self.dragStartLocation.y - locationInSpriteSheet.y
        };
        
        self.targetDragView.alphaValue = 0.5;
        self.targetDragView.frame = CGRectOffset(self.targetDragOriginalFrame,
                                                 mouseDelta.x,
                                                 -mouseDelta.y);
        self.targetDragView.layer.zPosition = [self.document.sprites count];
        
        [self.spriteViewQueue enumerateObjectsUsingBlock:^(SUTSpriteView *spriteView, NSUInteger idx, BOOL *stop)
         {
             if (spriteView != self.targetDragView &&
                 CGRectContainsPoint(spriteView.frame, locationInSpriteSheet))
             {
                 NSInteger newTargetDragSpriteIndex = [self.document indexOfSprite:spriteView.sprite];
                 
                 [self.document exchangeSpriteAtIndex:self.targetDragSpriteIndex
                                    withSpriteAtIndex:newTargetDragSpriteIndex];
                 
                 //Animate Sprite Sheet To Current targetDragSpriteIndex
                 CGRect viewFrame = [self.document.layout frameForSpriteAtIndex:self.targetDragSpriteIndex];

                 [[spriteView animator] setFrame:viewFrame];
                 
                 self.targetDragSpriteIndex = newTargetDragSpriteIndex;
                 
                 *stop = YES;
             }
         }];
    }
}

-(void)mouseUp:(NSEvent *)event
{
    if (self.isDragging)
    {
        CGRect viewFrame = [self.document.layout frameForSpriteAtIndex:self.targetDragSpriteIndex];

        [[self.targetDragView animator] setAlphaValue:1.0f];
        [[self.targetDragView animator] setFrame:viewFrame];
        
        self.targetDragView.layer.zPosition = 0;
        self.dragging = NO;
        self.targetDragView = nil;
    }
    else
    {
        CGPoint locationInSpriteSheet = [self convertPoint:event.locationInWindow
                                                  fromView:nil];
        SUTSpriteView *spriteView = (SUTSpriteView *)[self hitTest:locationInSpriteSheet];
        spriteView.selected = YES;
    }
}

@end
