//
//  SUTSprite.h
//  Suture
//
//  Created by James Campbell on 12/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Foundation;
@class SUTDocument;

@interface SUTSprite : NSObject

@property (nonatomic, weak) SUTDocument *document;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, readonly) NSImage *image;

@end
