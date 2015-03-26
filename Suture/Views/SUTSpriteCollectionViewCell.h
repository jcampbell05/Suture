//
//  SUTSpriteCollectionViewCell.h
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <JNWCollectionView/JNWCollectionViewCell.h>
@class SUTSprite;

@interface SUTSpriteCollectionViewCell : JNWCollectionViewCell

@property (nonatomic, weak) SUTSprite *sprite;

+ (NSString *)identifier;

@end
