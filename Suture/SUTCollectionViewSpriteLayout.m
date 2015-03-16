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
    [self.sections removeAllObjects];
    
    CGFloat globalOffset = 0.0f;
    
    for (NSInteger sectionIndex = 0; sectionIndex < [self.collectionView numberOfSections]; sectionIndex ++)
    {
        NSInteger numberOfRowInSection = [self.collectionView numberOfItemsInSection:sectionIndex];
        
        SUTCollectionViewSpriteLayoutSection *section = [[SUTCollectionViewSpriteLayoutSection alloc] init];
        
        for (NSInteger rowIndex = 0; rowIndex < numberOfRowInSection; rowIndex++)
        {
            JNWCollectionViewLayoutAttributes *attributes = [[JNWCollectionViewLayoutAttributes alloc] init];
            
            attributes.frame = [self rectForItemAtIndexPath:indexPath];
            attributes.alpha = 1.0f;
            
            
            NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:rowIndex
                                                             inSection:sectionIndex];
            CGSize rowSize = CGSizeZero;
            
            if ([self.delegate respondsToSelector:@selector(collectionView:sizeForItemAtIndexPath:)])
            {
                rowSize = [self.delegate collectionView:self.collectionView
                                 sizeForItemAtIndexPath:indexPath];
            }
            
            CGPoint rowPosition = CGPointMake(globalOffset * (self.orientation == SUTCollectionViewSpriteLayoutOrientationHorizontal),
                                              globalOffset * (self.orientation == SUTCollectionViewSpriteLayoutOrientationVertical));
            
            if (self.orientation == SUTCollectionViewSpriteLayoutOrientationVertical)
            {
                rowPosition.x += (self.collectionView.frame.size.width / 2) - (rowSize.width / 2);
            }
            else
            {
                rowPosition.y += (self.collectionView.frame.size.height / 2) - (rowSize.height / 2);
            }
            
            globalOffset += (self.orientation == SUTCollectionViewSpriteLayoutOrientationVertical) ? rowSize.height : rowSize.width;
            
            SUTCollectionViewSpriteLayoutRow *row = [[SUTCollectionViewSpriteLayoutRow alloc] init];
            row.frame = (CGRect){rowPosition, rowSize};
            [section.rows addObject:row];
        }
        
        [self.sections addObject:section];
    }
}

- (NSArray *)indexPathsForItemsInRect:(CGRect)rect
{
    NSMutableArray *indexPathsInRect = [[NSMutableArray alloc] init];
    
    [self.sections enumerateObjectsUsingBlock:^(SUTCollectionViewSpriteLayoutSection *section, NSUInteger sectionIndex, BOOL *stop)
    {
        [section.rows enumerateObjectsUsingBlock:^(SUTCollectionViewSpriteLayoutRow *row, NSUInteger rowIndex, BOOL *stop)
        {
            if (CGRectIntersectsRect(rect, row.frame))
            {
                NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:rowIndex
                                                                 inSection:sectionIndex];
                [indexPathsInRect addObject:indexPath];
            }
        }];
    }];
    
    return indexPathsInRect;
}

- (JNWCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return layoutAttributes[indexPath.jnw_item];
}

- (CGSize)contentSize
{
    __block CGSize contentSize = CGSizeZero;
    
    [self.sections enumerateObjectsUsingBlock:^(SUTCollectionViewSpriteLayoutSection *section, NSUInteger sectionIndex, BOOL *stop)
     {
         [section.rows enumerateObjectsUsingBlock:^(SUTCollectionViewSpriteLayoutRow *row, NSUInteger rowIndex, BOOL *stop)
          {
              if (self.orientation == SUTCollectionViewSpriteLayoutOrientationVertical)
              {
                  contentSize.height += row.frame.size.height;
              }
              else
              {
                  contentSize.width += row.frame.size.width;
              }
          }];
     }];
    
    return contentSize;
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
