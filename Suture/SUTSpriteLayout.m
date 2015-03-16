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
    [self.layoutAttributes removeAllObjects];
    
    CGSize sheetSize = [self.delegate sheetSize];
    CGPoint spriteOffset = CGPointZero;
    
    for (NSInteger spriteIndex = 0; spriteIndex < [self.delegate numberOfSprites]; spriteIndex ++)
    {
        CGSize spriteSize = [self.delegate sizeForSpriteAtIndex:spriteIndex];
        CGPoint spritePositon = spriteOffset;
        
        spritePositon.x += ((sheetSize.width / 2) - (spriteSize.width / 2)) * !self.transformMultiplier.x;
        spritePositon.y += ((sheetSize.height / 2) - (spriteSize.height / 2)) * !self.transformMultiplier.y;
        
        SUTSpriteLayoutAttribute *attribute = [[SUTSpriteLayoutAttribute alloc] init];
        attribute.frame = (CGRect){spritePositon, spriteSize};
        
        [self.layoutAttributes addObject:attribute];
        
        spriteOffset.x += spriteSize.width * self.transformMultiplier.x;
        spriteOffset.y += spriteSize.height * self.transformMultiplier.y;
    }
}

- (CGRect)frameForSpriteAtIndex:(NSInteger)index
{
    SUTSpriteLayoutAttribute *attribute = self.layoutAttributes[index];
    return attribute.frame;
}

- (CGSize)contentSize
{
    return CGSizeZero;
}

@end
