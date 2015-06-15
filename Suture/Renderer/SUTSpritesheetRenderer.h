//
//  SUTSpritesheetRenderer.h
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUTDocument;
@class SUTSprite;
@class SUTSpriteLayout;

@interface SUTSpritesheetRenderer : NSObject

@property (nonatomic, strong) SUTDocument *document;

- (void)renderInContext:(CGContextRef)context;

- (void)renderSprite:(SUTSprite *)sprite
             contect:(CGContextRef)context;

@end
