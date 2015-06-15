//
//  SUTSpriteRenderer.h
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUTSprite;

@interface SUTSpriteRenderer : NSObject

- (void)renderSprite:(SUTSprite *)sprite
             context:(CGContextRef)context;

@end
