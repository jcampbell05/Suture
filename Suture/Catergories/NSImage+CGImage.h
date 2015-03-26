//
//  NSImage+CGImage.h
//  Suture
//
//  Created by James Campbell on 26/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Cocoa;
@import ImageIO;

@interface NSImage (CGImage)

@property (nonatomic, readonly) CGImageRef CGImage;

@end
