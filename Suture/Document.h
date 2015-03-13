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

@property (nonatomic, strong) NSMutableArray *sprites;

- (void)addSpriteForFileURL:(NSURL *)fileURL;

@end

