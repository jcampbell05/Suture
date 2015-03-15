//
//  SUTCollectionViewSpriteLayout.m
//  Suture
//
//  Created by James Campbell on 14/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTCollectionViewSpriteLayout.h"

@interface SUTCollectionViewSpriteLayout ()

@property (nonatomic, strong)  NSMutableArray *attributes;

@end

@implementation SUTCollectionViewSpriteLayout

#pragma mark - Layout

- (void)prepareLayout
{
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger index = 0; index < numberOfItems; index++)
    {
        
    }
}

#pragma mark - Attributes

- (NSMutableArray *)attributes
{
    if (!_attributes)
    {
        _attributes = [[NSMutableArray alloc] init];
    }
    
    return _attributes;
}

@end
