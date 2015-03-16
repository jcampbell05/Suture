//
//  SUTSpriteLayout.h
//  Suture
//
//  Created by James Campbell on 16/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    SUTSpriteLayoutOrientationVertical,
    SUTSpriteLayoutOrientationHorizontal,
} SUTSpriteLayoutOrientation;


@interface SUTSpriteLayout : NSObject

@property (nonatomic, assign) SUTSpriteLayoutOrientation orientation;

@end
