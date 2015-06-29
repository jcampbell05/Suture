//
//  SUTSpritesheetLayout.m
//  Suture
//
//  Created by James Campbell on 16/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpritesheetLayout.h"
#import "SUTGeometry.h"

@interface SUTSpriteLayoutAttribute : NSObject

@property (nonatomic, assign) CGRect spriteFrame;

@end

@implementation SUTSpriteLayoutAttribute

@end

@interface SUTSpritesheetLayout ()

@property (nonatomic, strong) NSMutableArray *layoutAttributes;
@property (nonatomic, assign, readwrite) CGSize contentSize;
@property (nonatomic, assign, readwrite) CGSize cellSize;

- (CGPoint)transformMultiplier;

@end

@implementation SUTSpritesheetLayout

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
    return CGPointMake(0, 1);
}

- (void)prepareLayout
{
//    self.contentSize = CGSizeZero;
//    self.cellSize = CGSizeZero;
//    [self.layoutAttributes removeAllObjects];
//    
//    CGPoint spriteOffset = CGPointZero;
//    NSInteger numberOfSprites = [self.delegate numberOfSprites];
//    
//    for (NSInteger spriteIndex = 0; spriteIndex < numberOfSprites; spriteIndex ++)
//    {
//        CGSize spriteSize = [self.delegate sizeForSpriteAtIndex:spriteIndex];
//        self.cellSize = (CGSize)
//        {
//            MAX(self.cellSize.width, spriteSize.width),
//            MAX(self.cellSize.height, spriteSize.height)
//        };
//    }
//    
//    for (NSInteger spriteIndex = 0; spriteIndex < numberOfSprites; spriteIndex ++)
//    {
//        CGSize spriteSize = [self.delegate sizeForSpriteAtIndex:spriteIndex];
//        
//        CGPoint cellPosition = CGPointZero;
//        cellPosition.x = self.cellSize.width * (spriteIndex * self.transformMultiplier.x);
//        cellPosition.y = self.cellSize.height * (spriteIndex * self.transformMultiplier.y);
//        
//        CGPoint spritePosition = cellPosition;
//        spritePosition.x += (self.cellSize.width / 2) - (spriteSize.width / 2);
//        spritePosition.y += (self.cellSize.height / 2) - (spriteSize.height / 2);
//        
//        SUTSpriteLayoutAttribute *attribute = [[SUTSpriteLayoutAttribute alloc] init];
//        attribute.spriteFrame = (CGRect){spritePosition, spriteSize};
//        
//        [self.layoutAttributes addObject:attribute];
//        
//        spriteOffset.x += self.cellSize.width * self.transformMultiplier.x;
//        spriteOffset.y += self.cellSize.height * self.transformMultiplier.y;
//    }
//    
//    CGPoint contentSizeMultiplier = (CGPoint)
//    {
//        MAX(1, numberOfSprites * self.transformMultiplier.x),
//        MAX(1, numberOfSprites * self.transformMultiplier.y)
//    };
//    
//    self.contentSize = CGSizeMake(self.cellSize.width * contentSizeMultiplier.x,
//                                  self.cellSize.height * contentSizeMultiplier.y);
}

- (CGRect)frameForSpriteAtIndex:(NSInteger)index
{
//    SUTSpriteLayoutAttribute *attribute = self.layoutAttributes[index];
//    
//    attribute.spriteFrame = SUTFlipCGRect(attribute.spriteFrame,
//                                          self.contentSize);
//    
//    return attribute.spriteFrame;
    
    return CGRectZero;
}

@end
