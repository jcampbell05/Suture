//
//  SUTCollectionViewFlowLayout.m
//  JNWCollectionView
//
//  Created by Jonathan Willing on 16/03/15.
//  Copyright (c) 2015 Unii. All rights reserved.

#import "SUTCollectionViewSpriteLayout.h"


@interface SUTCollectionViewSpriteLayout ()

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation SUTCollectionViewSpriteLayout

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
