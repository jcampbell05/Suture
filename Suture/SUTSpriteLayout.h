//
//  SUTSpriteLayout.h
//  Suture
//
//  Created by James Campbell on 16/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SUTSpriteLayoutDelegate <NSObject>

- (CGSize)sizeForSpriteAtIndex:(NSInteger)index;

@end

typedef enum : NSUInteger
{
    SUTSpriteLayoutOrientationVertical,
    SUTSpriteLayoutOrientationHorizontal,
} SUTSpriteLayoutOrientation;

@interface SUTSpriteLayout : NSObject

@property (nonatomic, weak) id<SUTSpriteLayoutDelegate> delegate;
@property (nonatomic, assign) SUTSpriteLayoutOrientation orientation;

- (void)prepareLayout;
- (CGRect)frameForSpriteAtIndex:(NSInteger)index;
- (CGSize)contentSize;

@end
