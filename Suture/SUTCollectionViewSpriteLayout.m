//
//  SUTCollectionViewFlowLayout.m
//  JNWCollectionView
//
//  Created by Jonathan Willing on 16/03/15.
//  Copyright (c) 2015 Unii. All rights reserved.

#import "SUTCollectionViewSpriteLayout.h"

@interface SUTCollectionViewSpriteLayout ()

@property (nonatomic, strong) NSMutableArray *layoutAttributes;

@end

@implementation SUTCollectionViewSpriteLayout

#pragma mark - Layout

- (void)setLayout:(SUTSpriteLayout *)layout
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(layout))];
    _layout = layout;
    [self didChangeValueForKey:NSStringFromSelector(@selector(layout))];
    
    [self invalidateLayout];
}

#pragma mark - Layout Attributes

- (NSMutableArray *)layoutAttributes
{
    if (!_layoutAttributes)
    {
        _layoutAttributes = [[NSMutableArray alloc] init];
    }
    
    return _layoutAttributes;
}

#pragma mark - Layout

- (void)prepareLayout
{
    [self.layoutAttributes removeAllObjects];
    [self.layout prepareLayout];
    
    NSInteger numberOfSprites = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger spriteIndex = 0; spriteIndex < numberOfSprites; spriteIndex ++)
    {
        JNWCollectionViewLayoutAttributes *attribute = [[JNWCollectionViewLayoutAttributes alloc] init];
        attribute.frame = [self.layout frameForCellAtIndex:spriteIndex];
        attribute.alpha = 1.0f;
        
        [self.layoutAttributes addObject:attribute];
    }
}

- (NSArray *)indexPathsForItemsInRect:(CGRect)rect
{
    NSMutableArray *indexPathsInRect = [[NSMutableArray alloc] init];
    
    [self.layoutAttributes enumerateObjectsUsingBlock:^(JNWCollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop)
    {
        if (CGRectIntersectsRect(rect, attribute.frame))
        {
            NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:idx
                                                             inSection:0];
            [indexPathsInRect addObject:indexPath];
        }
    }];
    
    return indexPathsInRect;
}

- (JNWCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutAttributes[indexPath.jnw_item];
}

- (CGSize)contentSize
{
    return self.layout.contentSize;
}

- (NSIndexPath *)indexPathForNextItemInDirection:(JNWCollectionViewDirection)direction
                                currentIndexPath:(NSIndexPath *)currentIndexPath
{
    NSIndexPath *newIndexPath = currentIndexPath;
    
    if (direction == JNWCollectionViewDirectionUp ||
        direction == JNWCollectionViewDirectionLeft)
    {
        newIndexPath  = [self.collectionView indexPathForNextSelectableItemBeforeIndexPath:currentIndexPath];
    }
    else if (direction == JNWCollectionViewDirectionDown ||
             direction == JNWCollectionViewDirectionRight)
    {
        newIndexPath = [self.collectionView indexPathForNextSelectableItemAfterIndexPath:currentIndexPath];
    }
    
    return newIndexPath;
}

@end
