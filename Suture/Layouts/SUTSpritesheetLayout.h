//
//  SUTSpritesheetLayout.h
//  Suture
//
//  Created by James Campbell on 16/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SUTSpritesheetLayoutDelegate <NSObject>

- (NSInteger)numberOfSprites;
- (CGSize)sizeForSpriteAtIndex:(NSInteger)index;

@end

typedef enum : NSUInteger
{
    SUTSpriteLayoutOrientationVertical,
    SUTSpriteLayoutOrientationHorizontal,
} SUTSpriteLayoutOrientation;

@interface SUTSpritesheetLayout : NSObject

@property (nonatomic, weak) id<SUTSpritesheetLayoutDelegate> delegate;
@property (nonatomic, assign) SUTSpriteLayoutOrientation orientation;
@property (nonatomic, assign, readonly) CGSize contentSize;

- (void)prepareLayout;
- (CGRect)frameForSpriteAtIndex:(NSInteger)index;
- (CGRect)frameForCellAtIndex:(NSInteger)index;

@end
