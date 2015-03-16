//
//  SUTCollectionViewFlowLayout.m
//  JNWCollectionView
//
//  Created by Jonathan Willing on 16/03/15.
//  Copyright (c) 2015 Unii. All rights reserved.

#import "SUTCollectionViewSpriteLayout.h"

@interface SUTCollectionViewSpriteLayoutSection : NSObject

@property (nonatomic, assign) CGRect *rowFrames;
@property (nonatomic, assign) CGRect frame;

- (instancetype)initWithNumberOfRows:(NSInteger)numberOfRows;

@end

@implementation SUTCollectionViewSpriteLayoutSection

#pragma mark - Section Rows

- (instancetype)initWithNumberOfRows:(NSInteger)numberOfRows
{
    if (self)
    {
        self.rowFrames = calloc(numberOfRows, sizeof(numberOfRows));
    }
    
    return self;
}

- (void)dealloc
{
    if (self.rowFrames != nil)
    {
        free(self.rowFrames);
    }
}

@end

@interface SUTCollectionViewSpriteLayout ()

@property (nonatomic, strong) NSMutableArray *sections;

- (CGRect)rectForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation SUTCollectionViewSpriteLayout

#pragma mark - Sections

- (NSMutableArray *)sections
{
    if (!_sections)
    {
        _sections = [[NSMutableArray alloc] init];
    }
    
    return _sections;
}

#pragma mark - Frame

- (CGRect)rectForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SUTCollectionViewSpriteLayoutSection *section = self.sections[indexPath.jnw_section];
    return section.rowFrames[indexPath.jnw_item];
}

#pragma mark - Layout

- (void)prepareLayout
{
    [self.sections removeAllObjects];
    
    CGFloat globalOffset = 0.0f;
    
    for (NSInteger sectionIndex = 0; sectionIndex < [self.collectionView numberOfSections]; sectionIndex ++)
    {
        NSInteger numberOfRowInSection = [self.collectionView numberOfItemsInSection:sectionIndex];
        
        SUTCollectionViewSpriteLayoutSection *section = [[SUTCollectionViewSpriteLayoutSection alloc] initWithNumberOfRows:numberOfRowInSection];
        
        CGRect sectionFrame = self.collectionView.bounds;
        
        if (self.orientation == SUTCollectionViewSpriteLayoutOrientationVertical)
        {
            sectionFrame.origin.y = globalOffset;
        }
        else
        {
            sectionFrame.origin.y = globalOffset;
        }
        
        for (NSInteger rowIndex = 0; rowIndex < numberOfRowInSection; rowIndex++)
        {
            NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:rowIndex
                                                             inSection:sectionIndex];
            CGSize rowSize = CGSizeZero;
            
            if ([self.delegate respondsToSelector:@selector(collectionView:sizeForItemAtIndexPath:)])
            {
                rowSize = [self.delegate collectionView:self.collectionView
                                 sizeForItemAtIndexPath:indexPath];
            }
            
            globalOffset += (self.orientation == SUTCollectionViewSpriteLayoutOrientationVertical) ? rowSize.height : rowSize.width;
            
            CGPoint rowPosition = CGPointMake(globalOffset * (self.orientation == SUTCollectionViewSpriteLayoutOrientationHorizontal),
                                              globalOffset * (self.orientation == SUTCollectionViewSpriteLayoutOrientationVertical));
            CGRect rowFrame = (CGRect){rowPosition, rowSize};
            section.rowFrames[rowIndex] = rowFrame;

            if (self.orientation == SUTCollectionViewSpriteLayoutOrientationVertical)
            {
                sectionFrame.size.width += rowSize.width;
            }
            else
            {
                sectionFrame.size.height += rowSize.height;
            }
        }
        
        section.frame = sectionFrame;
        
        [self.sections addObject:section];
    }
}

- (JNWCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JNWCollectionViewLayoutAttributes *attributes = [[JNWCollectionViewLayoutAttributes alloc] init];
    
    attributes.frame = [self rectForItemAtIndexPath:indexPath];
    attributes.alpha = 1.f;
    
    return attributes;
}

- (CGRect)rectForSectionAtIndex:(NSInteger)index
{
    SUTCollectionViewSpriteLayoutSection *section = self.sections[index];
    return section.frame;
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
