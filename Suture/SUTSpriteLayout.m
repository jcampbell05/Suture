//
//  SUTSpriteLayout.m
//  Suture
//
//  Created by James Campbell on 16/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteLayout.h"

@interface SUTSpriteLayoutAttribute : NSObject

@property (nonatomic, assign) CGRect frame;

@end

@implementation SUTSpriteLayoutAttribute

@end

@interface SUTSpriteLayout ()

@property (nonatomic, strong) NSMutableArray *layoutAttributes;
@property (nonatomic, assign, readwrite) CGSize contentSize;
@property (nonatomic, assign, readwrite) CGSize cellSize;

- (CGPoint)transformMultiplier;

@end

@implementation SUTSpriteLayout

#pragma makk - Attributes

- (NSMutableArray *)layoutAttributes
{
    if (!_layoutAttributes)
    {
        _layoutAttributes = [[NSMutableArray alloc] init];
    }
    
    return _layoutAttributes;
}

#pragma mark - Layout

- (CGPoint)transformMultiplier
{
    return CGPointMake((self.orientation == SUTSpriteLayoutOrientationHorizontal),
                       (self.orientation == SUTSpriteLayoutOrientationVertical));
}

- (void)prepareLayout
{
    self.contentSize = CGSizeZero;
    self.cellSize = CGSizeZero;
    [self.layoutAttributes removeAllObjects];
    
    CGPoint spriteOffset = CGPointZero;
    NSInteger numberOfSprites = [self.delegate numberOfSprites];
    
    for (NSInteger spriteIndex = 0; spriteIndex < numberOfSprites; spriteIndex ++)
    {
        CGSize spriteSize = [self.delegate sizeForSpriteAtIndex:spriteIndex];
        self.cellSize = (CGSize)
        {
            MAX(self.cellSize.width, spriteSize.width),
            MAX(self.cellSize.height, spriteSize.height)
        };
    }
    
    for (NSInteger spriteIndex = 0; spriteIndex < numberOfSprites; spriteIndex ++)
    {
    
        CGPoint spritePositon = spriteOffset;
//        
//        spritePositon.x += ((spriteSize.width / 2)) * !self.transformMultiplier.x;
//        spritePositon.y += ((spriteSize.height / 2)) * !self.transformMultiplier.y;
        
        SUTSpriteLayoutAttribute *attribute = [[SUTSpriteLayoutAttribute alloc] init];
        attribute.frame = (CGRect){spritePositon, self.cellSize};
        
        [self.layoutAttributes addObject:attribute];
        
        spriteOffset.x += self.cellSize.width * self.transformMultiplier.x;
        spriteOffset.y += self.cellSize.height * self.transformMultiplier.y;
    }
    
    CGPoint contentSizeMultiplier = (CGPoint)
    {
        MAX(1, numberOfSprites * self.transformMultiplier.x),
        MAX(1, numberOfSprites * self.transformMultiplier.y)
    };
    self.contentSize = CGSizeMake(self.cellSize.width * contentSizeMultiplier.x,
                                  self.cellSize.height * contentSizeMultiplier.y);
}

- (CGRect)frameForSpriteAtIndex:(NSInteger)index
{
    SUTSpriteLayoutAttribute *attribute = self.layoutAttributes[index];
    return attribute.frame;
}

@end
