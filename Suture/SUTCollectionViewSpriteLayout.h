//
//  SUTCollectionViewFlowLayout.h
//  JNWCollectionView
//
//  Created by Jonathan Willing on 16/03/15.
//  Copyright (c) 2015 Unii. All rights reserved.

#import "JNWCollectionViewLayout.h"

@protocol SUTCollectionViewSpriteLayoutDelegate <NSObject>

- (CGSize)collectionView:(JNWCollectionView *)collectionView
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface SUTCollectionViewSpriteLayout : JNWCollectionViewLayout

@property (nonatomic, weak) id<SUTCollectionViewSpriteLayoutDelegate> delegate;

@end
