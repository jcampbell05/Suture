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

#pragma mark - Image

@property (nonatomic, readonly) CGImageRef CGImage;
@property (nonatomic, readonly) CGSize size;

@end
