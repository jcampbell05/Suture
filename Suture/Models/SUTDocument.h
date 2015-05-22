//
//  SUTDocument.h
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Cocoa;
@class SUTSprite;
@class SUTSpriteLayout;

@interface SUTDocument : NSDocument

@property (nonatomic, strong) SUTSpriteLayout *layout;
@property (nonatomic, strong) NSArray *sprites;

/**
 Gets the size of the largest sprite in this document.
 
 @return CGSize of largest sprite
 */
- (CGSize)largestSpriteSize;
- (NSImage *)imageForURL:(NSURL *)url;

#pragma mark - Sprite

- (void)addSprite:(SUTSprite *)sprite;
- (void)removeSprite:(SUTSprite *)sprite;
- (void)insertObject:(SUTSprite *)sprite inSpritesAtIndex:(NSUInteger)index;
- (void)removeObjectFromSpritesAtIndex:(NSUInteger)index;

@end

