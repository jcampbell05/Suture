//
//  Document.h
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Cocoa;
@class SUTSprite;

@interface Document : NSDocument

@property (nonatomic, strong, readonly) NSArray *sprites;

- (void)addSprite:(SUTSprite *)sprite;
- (void)insertObject:(SUTSprite *)sprite inSpritesAtIndex:(NSUInteger)index;
- (void)removeObjectFromSpritesAtIndex:(NSUInteger)index;

@end

