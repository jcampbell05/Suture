//
//  SUTCollectionViewFlowLayout.m
//  JNWCollectionView
//
//  Created by Jonathan Willing on 16/03/15.
//  Copyright (c) 2015 Unii. All rights reserved.

#import "SUTCollectionViewSpriteLayout.h"

@interface SUTCollectionViewSpriteLayoutSection : NSObject

@property (nonatomic, assign) CGRect *rowFrames;

- (instancetype)initWithNumberOfRows:(NSInteger)numberOfRows;

@end

@implementation SUTCollectionViewSpriteLayoutSection

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

@end

@implementation SUTCollectionViewSpriteLayout

- (NSMutableArray *)sections
{
    if (!_sections)
    {
        _sections = [[NSMutableArray alloc] init];
    }
    
    return _sections;
}

- (void)prepareLayout
{
    
}

- (JNWCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGRect)rectForSectionAtIndex:(NSInteger)index
{
    return CGRectZero;
}

- (NSIndexPath *)indexPathForNextItemInDirection:(JNWCollectionViewDirection)direction
                                currentIndexPath:(NSIndexPath *)currentIndexPath
{
    return nil;
}

@end
