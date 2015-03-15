//
//  SUTCollectionViewFlowLayout.h
//  JNWCollectionView
//
//  Created by Jonathan Willing on 4/11/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//
//  Copyright (tweaks for suture) 2015 James Campbell. All rights reserved.

// NB: this was jWilling's initial approach which he decided not to include in the release
// But it might be a useful starting point

#import "JNWCollectionViewLayout.h"

extern NSString * const JNWCollectionViewFlowLayoutFooterKind;
extern NSString * const JNWCollectionViewFlowLayoutHeaderKind;

typedef NS_ENUM(NSInteger, JNWCollectionViewFlowLayoutAlignment)
{
    JNWCollectionViewFlowLayoutAlignmentTop,
    JNWCollectionViewFlowLayoutAlignmentCentre,
    JNWCollectionViewFlowLayoutAlignmentBottom
};

@protocol JNWCollectionViewFlowLayoutDelegate <NSObject>

- (CGSize)collectionView:(JNWCollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)collectionView:(JNWCollectionView *)collectionView heightForHeaderInSection:(NSInteger)index;
- (CGFloat)collectionView:(JNWCollectionView *)collectionView heightForFooterInSection:(NSInteger)index;

@end

@interface SUTCollectionViewFlowLayout : JNWCollectionViewLayout

@property (nonatomic, weak) id<JNWCollectionViewFlowLayoutDelegate> delegate;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInterItemSpacing;
@property (nonatomic, assign) JNWCollectionViewFlowLayoutAlignment alignment;


@end
